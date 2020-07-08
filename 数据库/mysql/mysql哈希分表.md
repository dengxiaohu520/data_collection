# mysql哈希分表
```
"""
1. 对已有参数的数据进行筛选出满足替换条件的拟推送数据
2. 从拟推送数据中放入到元器件总表， 形成总表数据
3. 按三种维度拆分表
4. 推送es(仅创建好索引结果即可)
"""
import logging
from logging.handlers import RotatingFileHandler, TimedRotatingFileHandler
import pymysql
import json, time
import re
import os
import sys
import platform
import gevent
from gevent import monkey
from gevent.pool import Pool
from concurrent.futures import ProcessPoolExecutor, ThreadPoolExecutor
from datetime import datetime
from collections import defaultdict
from copy import deepcopy
import hashlib

monkey.patch_all()

BASE_DIR = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
sys.path.append(BASE_DIR)

DEBUG = True
# DEBUG = False
if DEBUG:
    MYSQL_HOST = '127.0.0.1'
    MYSQL_PORT = 3306
    MYSQL_USER = 'root'
    MYSQL_PASSWORD = 'vichen'
    MYSQL_REVISE_DATABASE = 'db_revise'
    MYSQL_MAGIC_DATABASE = 'magic_online'
    MYSQL_ELECTRON_DATABASE = 'db_electron'
    MYSQL_ELECTRON_TOTAL_DATABASE = 'db_business_electron_test'
    TOTAL_ELECTRON_TABLE_SUFFIX = 'total'
    MYSQL_CHARSET = 'utf8'
    ADD_PARAMETERS = 'RoHS, pb, MSL, lifecycle, ECCN, AEC, Automotive, HTSUSA, Schedule, UNSPSC'
    ADD_PARAMETERS_LIST = ['RoHS', 'pb', 'MSL', 'lifecycle', 'ECCN', 'AEC', 'Automotive', 'HTSUSA', 'Schedule',
                           'UNSPSC']
    LINES_LIMIT = 10000
else:
    MYSQL_HOST = '192.168.1.100'
    MYSQL_PORT = 3306
    MYSQL_USER = 'mofang'
    MYSQL_PASSWORD = 'Mofredkg!@#mdfG01062'
    MYSQL_REVISE_DATABASE = 'db_revise'
    MYSQL_MAGIC_DATABASE = 'magic_online'
    MYSQL_ELECTRON_DATABASE = 'db_electron'
    MYSQL_ELECTRON_TOTAL_DATABASE = 'db_business_electron'
    TOTAL_ELECTRON_TABLE_SUFFIX = 'total'
    MYSQL_CHARSET = 'utf8'
    ADD_PARAMETERS = 'RoHS, pb, MSL, lifecycle, ECCN, AEC, Automotive, HTSUSA, Schedule, UNSPSC'
    ADD_PARAMETERS_LIST = ['RoHS', 'pb', 'MSL', 'lifecycle', 'ECCN', 'AEC', 'Automotive', 'HTSUSA', 'Schedule',
                           'UNSPSC']
    LINES_LIMIT = 10000

LOG_PATH = '/data/logs/icmofang/moli_restapi/electron/'
if platform.system().lower() == 'windows':
    LOG_PATH = 'E:/log/electron/'
    if not os.path.exists(LOG_PATH):
        os.mkdir(LOG_PATH)
elif platform.system().lower() == 'linux':
    if not os.path.exists(LOG_PATH):
        os.mkdir(LOG_PATH)
else:
    if not os.path.exists(LOG_PATH):
        os.mkdir(LOG_PATH)
# 获取logger实例
logger = logging.getLogger(__name__)
formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)-8s: %(message)s')

# 每天生成一个日志文件，保留最近30天的日志文件
# log_file_name = datetime.now().strftime('%Y-%m-%d_%H-%M')
log_file_name = 'calculate-contrast-pintopin-' + datetime.now().strftime('%Y-%m-%d_%H-%M')
timeRotateHandler = TimedRotatingFileHandler(filename=LOG_PATH.rstrip('/').rstrip('\\') + "/{}_".format(log_file_name),
                                             when="D", interval=1, backupCount=30, encoding='utf-8')
timeRotateHandler.setFormatter(formatter)
# timeRotateHandler.setLevel(logging.INFO)
# 删除日志文件设置
timeRotateHandler.suffix = '%Y-%m-%d_%H-%M.log'
timeRotateHandler.extMatch = re.compile(r"^\d{4}-\d{2}-\d{2}_\d{2}-\d{2}.log$")

# 控制台日志
console_handler = logging.StreamHandler(sys.stdout)
console_handler.setFormatter(formatter)
logger.addHandler(timeRotateHandler)
logger.addHandler(console_handler)

logger.setLevel(logging.INFO)


def context(is_dict_cursor=True, database=MYSQL_REVISE_DATABASE):
    try:
        config = {
            'host': MYSQL_HOST,
            'port': MYSQL_PORT,
            'user': MYSQL_USER,
            'password': MYSQL_PASSWORD,
            'database': database,
            'charset': MYSQL_CHARSET,
        }

        conn = pymysql.connect(**config)
        if is_dict_cursor:
            cursor = conn.cursor(cursor=pymysql.cursors.DictCursor)
        else:
            cursor = conn.cursor()
        return conn, cursor
    except Exception as ex:
        logger.error("connect database failed, {},{}".format(200, ex))
        print("connect database failed, {},{}".format(200, ex))
        raise Exception({'code': 200, 'msg': ex})


def get_category_old_new_mapping():
    column = "mc.id id, dc.category_id"

    sql = """select {} from magic_online.m_electron_category mc inner join db_electron_property.tb_electron_category dc on mc.id= dc.org_category_id""".format(
        column)
    result = {}
    conn, cursor = context()
    try:
        cursor.execute(sql)
        results = cursor.fetchall()
        for r in results:
            result[r['id']] = r['category_id']
    except Exception as ex:
        logger.error(
            "get_category_old_new_mapping Exception : {},{},{}".format(sql,
                                                                       ex,
                                                                       ex))
        print("get_category_old_new_mapping Exception: {},{}".format(sql, ex))
        conn.close()
        raise Exception
    conn.close()
    return result


def generate_category_substitute_pintopin_kwargs_mapping():
    category_old_new_mapping = get_category_old_new_mapping()
    column = "electron_id category_fid, ename, is_contrast, is_pintopin"

    sql = """select {} from magic_online.m_category_kwargs""".format(
        column)
    mapping = defaultdict(dict)
    conn, cursor = context()
    try:
        cursor.execute(sql)
        results = cursor.fetchall()
        for r in results:
            try:
                category_fid = r['category_fid']
                ename = r['ename']
                # is_contrast： 替换  is_substitute： 对比
                is_contrast = r['is_contrast']
                is_pintopin = r['is_pintopin']
                # 忽略旧分类在新的分类表里不存在的旧分类数据
                if category_old_new_mapping.get(category_fid):
                    category_code = category_old_new_mapping.get(category_fid)
                    # 创建普通替换/piptopin/其他 参数列表
                    if 'contrast' not in mapping[category_code].keys():
                        mapping[category_code]['contrast'] = []
                    if 'pintopin' not in mapping[category_code].keys():
                        mapping[category_code]['pintopin'] = []
                    if 'others' not in mapping[category_code].keys():
                        mapping[category_code]['others'] = []
                    if 'category_fid' not in mapping[category_code].keys():
                        mapping[category_code]['category_fid'] = category_fid
                    # 保存参数到对应的参数列表
                    if is_contrast:
                        mapping[category_code]['contrast'].append(ename)
                    if is_pintopin:
                        mapping[category_code]['pintopin'].append(ename)
                    if not is_contrast and not is_pintopin:
                        mapping[category_code]['others'].append(ename)
            except Exception:
                pass
        # 因为业务上勾选可替换参数时并没有勾选pintopin，需要把可替换参数的值加入到pintopin里面
        for category_code in mapping.keys():
            contrasts = mapping[category_code]['contrast']
            if contrasts:
                pintopins = mapping[category_code]['pintopin']
                pintopins.extend(contrasts)
                pintopins = list(set(pintopins))
                mapping[category_code]['pintopin'] = pintopins
    except Exception as ex:
        logger.error(
            "generate_category_substitute_pintopin_kwargs_mapping Exception : {},{}".format(sql, ex))
        print("generate_category_substitute_pintopin_kwargs_mapping Exception: {},{}".format(sql, ex))
        conn.close()
        raise Exception
    conn.close()
    return dict(mapping)


CATEGORY_MAPPING = generate_category_substitute_pintopin_kwargs_mapping()
import pprint
pprint.pprint(CATEGORY_MAPPING)

# 存在pin to pin 参数的类别, 以统计需要pin to pin 的元器件总数
# 存在普通替换的类别，以统计需要普通替换的元器件总数
need_pin_to_pin_parameter_electron = None  # 1692224
need_contrast_parameter_electron = None  # 4093823
neither_pintopin_electrons = []
contrast_categories = []
pin_to_pin_categories = []
for category, category_parameters in CATEGORY_MAPPING.items():
    if category_parameters['contrast']:
        contrast_categories.append(category)
    if category_parameters['pintopin']:
        pin_to_pin_categories.append(category)
        # print(pin_to_pin_categories)


def count_pin_to_pin_electrons(pin_to_pin_categories):
    column = "count(*)"

    sql = """select {} from db_electron_to_es.tb_electron_parameter where category_id in ({})""".format(
        column, ','.join(pin_to_pin_categories))
    print("*" * 100)
    print(sql)
    print("*" * 100)
    conn, cursor = context()
    try:
        cursor.execute(sql)
        results = cursor.fetchall()
        print(results)

    except Exception as ex:
        logger.error(
            "generate_category_substitute_pintopin_kwargs_mapping Exception : {},{}".format(sql, ex))
        print("generate_category_substitute_pintopin_kwargs_mapping Exception: {},{}".format(sql, ex))
        conn.close()
        raise Exception
    conn.close()
    return results[0]['count(*)'] if results else 0


def count_contrast_electrons(contrast_categories):
    column = "count(*)"

    sql = """select {} from db_electron_to_es.tb_electron_parameter where category_id in ({})""".format(
        column, ','.join(contrast_categories))
    print("*" * 100)
    print(sql)
    print("*" * 100)
    conn, cursor = context()
    try:
        cursor.execute(sql)
        results = cursor.fetchall()
        print(results)

    except Exception as ex:
        logger.error(
            "generate_category_substitute_pintopin_kwargs_mapping Exception : {},{}".format(sql, ex))
        print("generate_category_substitute_pintopin_kwargs_mapping Exception: {},{}".format(sql, ex))
        conn.close()
        raise Exception
    conn.close()
    return results[0]['count(*)'] if results else 0


def sum_tb_lines(db=MYSQL_REVISE_DATABASE, tb=None, where_clause=''):
    column = "count(*) as amount"
    sql = """SELECT {} FROM {}.{}""".format(column, db, tb)
    # 统计连接器的
    if where_clause:
        sql = sql + ' ' + where_clause
    result = [{'amount': 0}]
    conn, cursor = context()
    try:
        cursor.execute(sql)
        result = cursor.fetchall()
    except Exception as ex:
        logger.error(
            "sum_tb_lines : {},{},{}".format(sql,
                                             ex,
                                             ex))
        print("sum_tb_lines: {},{}".format(sql, ex))
        conn.close()
        raise Exception
    conn.close()
    return result[0]['amount'] if result else 0


CONSTRAST = 0
PINTOPIN = 0
missing_parameters = {
    "contrast": [],
    "pintopin": [],
    "others": []
}


def handle_electron_parameter_status():
    # 获取行数
    tb_lines = sum_tb_lines(db='db_electron_to_es', tb='tb_electron_parameter')
    limit = 50
    offset = 0

    conn, cursor = context()
    while tb_lines > offset:
        # 循环执行
        column = 'id, model_name, model_id, category_id, en_parameter'
        # sql = """select {} from db_electron_to_es.tb_electron_parameter order by id limit {} offset {}""".format(
        #     column,
        #     limit,
        #     offset)
        sql = """select {} from db_electron_to_es.tb_electron_parameter order by id limit {} offset {}""".format(
            column,
            limit,
            offset)
        try:
            print("*" * 100)
            print(sql)
            print("*" * 100)
            cursor.execute(sql)
            results = cursor.fetchall()
            log_sqls = []
            log_column = 'category_id, lack_contrast_parameter, lack_pintopin_parameter, tb_electron_parameter_fid, model_name, model_id, is_satisfied_contrast, is_satisfied_pintopin, missing_parameter'
            log_sql = """insert into db_electron_to_es.tb_electron_parameter_contrast_pintopin_cal({}) values(%s, %r, %r, %r, %s, %s, %r, %r, %s)""".format(
                log_column)
            for electron in results:
                try:
                    # 检查参数状态
                    tb_electron_parameter_fid = electron['id']
                    model_name = electron['model_name']
                    model_id = electron['model_id']
                    category_id = electron['category_id']
                    en_parameter = electron['en_parameter']
                    is_satisfied_contrast = 0
                    is_satisfied_pintopin = 0
                    contrast_parameter = CATEGORY_MAPPING[category_id].get('contrast')
                    lack_contrast_parameter = False if contrast_parameter else True
                    pintopin_parameter = CATEGORY_MAPPING[category_id].get('pintopin')
                    lack_pintopin_parameter = False if pintopin_parameter else True
                    _missing_parameters = deepcopy(missing_parameters)
                    if en_parameter:
                        en_parameter = json.loads(en_parameter)
                        # 参数列有值，则进行检查普通替换和pintopin参数情况
                        # 是否有缺失普通替换需要的参数值
                        for key in contrast_parameter:
                            if not en_parameter.get(key):
                                _missing_parameters['contrast'].append(key)
                        # 是否有缺失pintopin需要的参数值
                        for key in pintopin_parameter:
                            if not en_parameter.get(key):
                                _missing_parameters['pintopin'].append(key)
                        # 判断是否缺少其他参数
                        for key in CATEGORY_MAPPING[category_id].get('others'):
                            if not en_parameter.get(key):
                                _missing_parameters['others'].append(key)
                        # 判断普通替换的参数是否都具备
                        if not lack_contrast_parameter and not _missing_parameters['contrast']:
                            is_satisfied_contrast = 1
                            global CONSTRAST
                            CONSTRAST += 1
                        # 判断pintopin的参数是否都具备
                        if not lack_pintopin_parameter and not _missing_parameters['pintopin']:
                            is_satisfied_pintopin = 1
                            global PINTOPIN
                            PINTOPIN += 1
                        if _missing_parameters == missing_parameters:
                            _missing_parameters = 'NULL'
                    else:
                        # 缺少参数列，不能进行判断， 直接把此类别所有三类参数名写入缺乏参数列
                        _missing_parameters = CATEGORY_MAPPING.get(category_id)

                    if _missing_parameters != 'NULL':
                        _missing_parameters = json.dumps(_missing_parameters, ensure_ascii=False)

                    log_sqls.append((category_id, lack_contrast_parameter, lack_pintopin_parameter,
                        tb_electron_parameter_fid, model_name, model_id, is_satisfied_contrast, is_satisfied_pintopin,
                                     _missing_parameters))
                    print(log_sql)
                except Exception:
                    pass
            cursor.executemany(log_sql, log_sqls)
            conn.commit()
        except Exception as ex:
            logger.error(
                "generate_category_substitute_pintopin_kwargs_mapping Exception : {},{}".format(sql, ex))
            print("generate_category_substitute_pintopin_kwargs_mapping Exception: {},{}".format(sql, ex))
        offset += limit
    conn.close()
    return True


def calculate_electron_contrast_pintopin_status():
    need_pin_to_pin_parameter_electron = count_pin_to_pin_electrons(pin_to_pin_categories)
    need_contrast_parameter_electron = count_contrast_electrons(contrast_categories)
    start_time = datetime.now()
    handle_electron_parameter_status()
    end_time = datetime.now()
    with open('result_contrast_pintopin.txt', 'w+', encoding='utf8') as f:
        f.write(
            'total: {}\n need_pin_to_pin_parameter_electron: {}\n need_contrast_parameter_electron: {}\n satisfied_contrast: {}\n satisfied_piptopin: {}\n'.format(
                sum_tb_lines(db='db_electron_to_es', tb='tb_electron_parameter'), need_pin_to_pin_parameter_electron,
                need_contrast_parameter_electron, CONSTRAST, PINTOPIN))
        f.write('start_time: {}\n'.format(start_time))
        f.write('end_time: {}\n'.format(end_time))
        f.write('run time: {}\n'.format(end_time - start_time))


# 获取哈希列表
def get_hash_256():
    """
    得到256个两位数字符串
    :return:
    """
    results_set = set()
    for i in range(0, 256):
        k = hex(i)[-2:]
        if k[0] == 'x':
            k = k.replace('x', '0')
        results_set.add('{}'.format(k))

    results_set = sorted(results_set)
    # print('数量：', len(results_set))
    return results_set


def get_hash_id(address, max_num):
    """
    根据 address 确定唯一 hash 值（确定分表）
    """
    hash_str = hashlib.md5(address.encode(encoding='UTF-8')).hexdigest()  # 16进制 -- 900150983cd24fb0d6963f7d28e17f72
    num = int(hash_str[:2] + hash_str[-2:], 16)  # 16进制 --> 10进制
    print(hash_str, hash_str[:2], hash_str[-2:], num)
    hash_id = num % max_num  # 8
    print('HashID:', hash_id)
    return hash_id


# 创建hash 表
def create_hash_table(db_name=MYSQL_ELECTRON_TOTAL_DATABASE, table_name_prefix=None, sql=None, comment=None, create_total_table=False):
    """
    创建hash表
    :param db_name:数据库名
    :param table_name_prefix:hash表前缀
    :param create_sql: 创建表sql
    :return:
    """
    if create_total_table:
        hash_suffix_tables = [TOTAL_ELECTRON_TABLE_SUFFIX]
    else:
        hash_suffix_tables = get_hash_256()
    mysql_conn, mysql_cursor = context()

    print('创建hash表')
    mysql_conn.begin()
    for item in hash_suffix_tables:
        table_name = table_name_prefix + item
        delete_sql = 'drop table if exists {}.`{}`'.format(db_name, table_name)
        mysql_cursor.execute(delete_sql)
        print('{} 表删除完成 {}'.format(table_name, delete_sql))
        mysql_conn.commit()
        create_sql = sql.format(db_name, table_name, comment)
        mysql_cursor.execute(create_sql)
        print('{} 表创建完成 {}'.format(table_name, create_sql))

    mysql_conn.commit()
    print('所有hash表创建完成')
    mysql_cursor.close()
    mysql_conn.close()


def create_electron_hash_table(db_name='db_business_electron', table_prefix='', comment='', create_total_table=False):
    create_sql = """
create table if not exists {}.{}
(
	id int unsigned auto_increment comment '主键id' primary key,
	name varchar(128) default '' not null comment '内部型号',
	part_number varchar(128) not null comment '型号',
	category_id varchar(9) default '0' not null comment '分类id',
	factory_id int unsigned default 0 not null comment '厂牌id',
	country_id int signed default -1 not null comment '国别/地区id',
	is_cn tinyint default -1 not null comment '-1: 未知；0：非国产；1：国产',
	is_hot tinyint default 0 not null comment '0：非热门；1：热门',
	supplier_id int unsigned default 0 not null comment '供应商id',
	producer_id int unsigned default 0 not null comment '产地id',
	source_web varchar(255) default '' not null comment '来源站点',
	data_sheet varchar(512) default '' not null comment 'pdf下载地址',
	icons json comment '图片',
	description varchar(3000) default '' not null comment '描述',
	price decimal(10,2) unsigned default 0.00 not null comment '价格',
	qty int unsigned default 0 not null comment '库存数量',
	minimum_quantity int unsigned default 0 not null comment '最小数量',
	series varchar(100) default '' not null comment '系列',
	packaging varchar(200) default '' not null comment '封装',
	summary text comment '摘要',
	pdf_path varchar(512) default '' not null comment 'pdf存放路径',
	txt_path varchar(512) default '' not null comment 'txt存放路径',
	zh_parameter json comment '中文参数',
	en_parameter json comment '英文参数',
	args_state int unsigned default 0 not null comment '参数缺失状态值',
	src_id int unsigned default 0 not null comment '数据来源id',
	src_tb_name varchar(128) default '' not null comment '数据来源库名.表名',
	market_date_at datetime(6) null comment '上市时间',
	lifecycle tinyint unsigned default 0 not null comment '生命周期',
	extra_parameter json null comment '额外参数',
	data_version varchar(8) default '' not null comment '采集日期版本号',
	state tinyint unsigned default 0 not null comment '状态',
	create_at datetime(3) default CURRENT_TIMESTAMP(3) not null comment '创建时间',
	update_at datetime(3) default CURRENT_TIMESTAMP(3) not null on update CURRENT_TIMESTAMP(3) comment '更新时间',
	create_uid varchar(16) default '' not null comment '创建人id',
	update_uid varchar(16) default '' not null comment '更新人id',
	field1 varchar(200) default '' not null,
	field2 varchar(200) default '' not null,
	field3 varchar(200) default '' not null,
	field4 varchar(200) default '' not null,
	field5 varchar(200) default '' not null,
	field6 varchar(200) default '' not null,
	field7 varchar(200) default '' not null,
	field8 varchar(200) default '' not null,
	field9 varchar(200) default '' not null,
	field10 varchar(200) default '' not null,
	field11 varchar(200) default '' not null,
	field12 varchar(200) default '' not null,
	field13 varchar(200) default '' not null,
	field14 varchar(200) default '' not null,
	field15 varchar(200) default '' not null,
	field16 varchar(200) default '' not null,
	field17 varchar(200) default '' not null,
	field18 varchar(200) default '' not null,
	field19 varchar(200) default '' not null,
	field20 varchar(200) default '' not null,
	field21 varchar(200) default '' not null,
	field22 varchar(200) default '' not null,
	field23 varchar(200) default '' not null,
	field24 varchar(200) default '' not null,
	field25 varchar(200) default '' not null,
	field26 varchar(200) default '' not null,
	field27 varchar(200) default '' not null,
	field28 varchar(200) default '' not null,
	field29 varchar(200) default '' not null,
	field30 varchar(200) default '' not null,
	field31 varchar(200) default '' not null,
	field32 varchar(200) default '' not null,
	field33 varchar(200) default '' not null,
	field34 varchar(200) default '' not null,
	field35 varchar(200) default '' not null,
	field36 varchar(200) default '' not null,
	field37 varchar(200) default '' not null,
	field38 varchar(200) default '' not null,
	field39 varchar(200) default '' not null,
	field40 varchar(200) default '' not null,
	field41 varchar(200) default '' not null,
	field42 varchar(200) default '' not null,
	field43 varchar(200) default '' not null,
	field44 varchar(200) default '' not null,
	field45 varchar(200) default '' not null,
	field46 varchar(200) default '' not null,
	field47 varchar(200) default '' not null,
	field48 varchar(200) default '' not null,
	field49 varchar(200) default '' not null,
	field50 varchar(200) default '' not null,
  INDEX `idx_id`(`id`) USING BTREE,
  INDEX `idx_part_number`(`part_number`) USING BTREE,
  INDEX `idx_factory_id`(`factory_id`) USING BTREE,
  INDEX `idx_category_id`(`category_id`) USING BTREE,
  INDEX `idx_supplier_id`(`supplier_id`) USING BTREE,
  INDEX `idx_producer_id`(`producer_id`) USING BTREE,
  INDEX `idx_is_cn`(`is_cn`) USING BTREE,
  INDEX `idx_is_hot`(`is_hot`) USING BTREE,
  INDEX `idx_state`(`state`) USING BTREE
)ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '{}' ROW_FORMAT = Dynamic;
"""
    create_hash_table(db_name, table_prefix, create_sql, comment, create_total_table)


def move_ok_electron_to_total_table():
    # 获取所有的满足推送条件的元器件基本数据放到总表中
    src_table = 'db_electron_to_es.tb_electron_parameter_contrast_pintopin_cal'
    src_column = 'model_name, category_id'
    dst_table = '{}.tb_electron_total'.format(MYSQL_ELECTRON_TOTAL_DATABASE)
    dst_column = 'part_number, category_id'
    conn, cursor = context()
    # 插入满足要求的part_number和category_id
    insert_base_field_sql = """insert into {}({}) select {} from {} where is_satisfied_contrast=1 or is_satisfied_pintopin=1""".format(dst_table, dst_column, src_column, src_table)
    cursor.execute(insert_base_field_sql)
    conn.commit()
    # 更新国别字段
    update_country_field_sql = """update {} e, db_electron_to_es.tb_electron_parameter p set e.price=p.price, e.factory_id=p.factory_id, e.country_id=p.country_id, e.is_cn=case when p.country_id=1 then 1 else 0 end where e.part_number=p.model_name and e.category_id=p.category_id""".format(dst_table)
    cursor.execute(update_country_field_sql)
    conn.commit()


def update_electron_total_value_from_old_table():
    conn, cursor = context()
    src_table = '{}.{}'.format(MYSQL_ELECTRON_TOTAL_DATABASE, 'tb_electron_total_vichen_20200510')
    dst_table = '{}.tb_electron_total'.format(MYSQL_ELECTRON_TOTAL_DATABASE)
    update_sql = """update {} e, {} o set e.supplier_id=o.supplier_id, e.producer_id=o.producer_id, e.source_web=o.source_web, e.data_sheet=o.data_sheet, e.icons=o.icons, e.description=o.description, e.qty=o.qty, e.minimum_quantity=o.minimum_quantity, e.series=o.series, e.packaging=coalesce(o.en_parameter->>'$.Packaging', ''), e.summary=o.summary, e.pdf_path=o.pdf_path, e.txt_path=o.txt_path, e.zh_parameter=o.zh_parameter, e.en_parameter=o.en_parameter, e.args_state=o.args_state, e.src_id=o.src_id, e.src_tb_name=o.src_tb_name, e.market_date_at=o.market_date_at, e.lifecycle=o.lifecycle, e.extra_parameter=o.extra_parameter, e.data_version=o.data_version, e.state=o.state where e.part_number=o.part_number and e.category_id=o.category_id""".format(dst_table, src_table)
    cursor.execute(update_sql)
    conn.commit()


def generate_category_kwargs_to_field_name_dict():
    """
    :return:
    {"01001001": {"zh_name": {'EEPROM容量': 'field15'}, "en_name": {'EEPROM Size': 'field15'}}}
    """
    column = "category_id, field_name, zh_name, en_name"
    sql = """select {} from db_revise.tb_electron_kwargs_mapping order by category_id""".format(column)
    result = []
    conn, cursor = context()
    try:
        cursor.execute(sql)
        result = cursor.fetchall()
    except Exception as ex:
        logger.error(
            "get_all_category_id Exception : {},{},{}".format(sql,
                                                              ex,
                                                              ex))
        print("get_all_category_id Exception: {},{}".format(sql, ex))
        conn.close()
        raise Exception
    conn.close()

    category_field_name_dict = defaultdict(dict)
    # 循环处理， 形成字典
    for kwargs_field_name in result:
        category_id = kwargs_field_name['category_id']
        field_name = kwargs_field_name['field_name']
        zh_name = kwargs_field_name['zh_name']
        en_name = kwargs_field_name['en_name']
        if category_id not in category_field_name_dict.keys():
            category_field_name_dict[category_id] = {'zh_name': {}, 'en_name': {}}
        # 插入值
        category_field_name_dict[category_id]['zh_name'][zh_name] = field_name
        category_field_name_dict[category_id]['en_name'][en_name] = field_name

    import pprint
    pprint.pprint(dict(category_field_name_dict))

    return dict(category_field_name_dict)


CATEGORY_KWARGS_FIELD_NAME_DICT = generate_category_kwargs_to_field_name_dict()


def get_field_name_dict_by_kwargs_dict(category_id: str, kwargs_dict: dict, is_zh_parameter=False):
    """
    根据分类id和zh_parameter/en_parameter， 返回field1-field50的字典
    :param category_id: 分类id
    :param kwargs_dict: 字典类型的参数名和值的数据  {"电压"： "5v"}
    :param is_zh_parameter: 传递进来的kwargs_dict是否是中文参数
    :return: {"field1": "5v"}
    """
    result = {}
    language_type = 'zh_name' if is_zh_parameter else 'en_name'
    if category_id not in CATEGORY_KWARGS_FIELD_NAME_DICT.keys():
        return result
    for key, value in kwargs_dict.items():
        field_name = CATEGORY_KWARGS_FIELD_NAME_DICT[category_id][language_type][key]
        result[field_name] = value

    return result


def split_json_key_to_field():
    # 每次从总表读取一定量的数据，根据映射表拆分en_parameter的key， value到对应的field中
    # 获取mapping： {"010010001": {"en_name": {"vcc/vdd":"field1"}}}
    select_column = 'id, category_id, en_parameter'
    conn, cursor = context()
    tb_lines = sum_tb_lines(db=MYSQL_ELECTRON_TOTAL_DATABASE, tb='tb_electron_total')
    offset = 0
    while tb_lines >= offset:
        # 拆分json放入field中
        select_sql = """select {} from {}.tb_electron_total order by id limit {} offset {}""".format(select_column, MYSQL_ELECTRON_TOTAL_DATABASE, LINES_LIMIT, offset)
        update_sql = """update {}.tb_electron_total set {} where id={}"""
        cursor.execute(select_sql)
        results = cursor.fetchall()
        for e_data in results:
            id = e_data['id']
            category_id = e_data['category_id']
            en_paremeter = e_data['en_parameter']
            if en_paremeter:
                en_paremeter = json.loads(en_paremeter, encoding='utf8')
            else:
                continue
            field_dict = get_field_name_dict_by_kwargs_dict(category_id=category_id, kwargs_dict=en_paremeter)
            set_values = []
            for key, value in field_dict.items():
                sigle_v = key + '=' + repr(value)
                set_values.append(sigle_v)
            cursor.execute(update_sql.format(MYSQL_ELECTRON_TOTAL_DATABASE, ','.join(set_values), id))
        conn.commit()
        offset += LINES_LIMIT


def generate_electron_total_data():
    # 1. 生成总表结构
    create_electron_hash_table(db_name=MYSQL_ELECTRON_TOTAL_DATABASE, table_prefix='tb_electron_', comment='业务库-元器件信息总表', create_total_table=True)
    # 2. 从满足推送要求的表里提取字段填充到总表
    move_ok_electron_to_total_table()
    # 3. 从旧总表里提取数据完整的字段更新到新总表
    update_electron_total_value_from_old_table()
    # 4. 根据规则拆分json到各field字段
    split_json_key_to_field()


def insert_data_sql(db_name, table, part_number_data, mysql_cursor):
    insert_sql = """
    insert into {}.`{}` (
  `id`, 
  `name`,
  `part_number`,
  `category_id`,
  `factory_id`,
  `country_id`,
  `supplier_id`,
  `producer_id`,
  `source_web`,
  `data_sheet`,
  `icons`,
  `description`,
  `price`,
  `qty`,
  `minimum_quantity`,
  `series`,
  `packaging`,
  `summary`,
  `pdf_path`,
  `txt_path`,
  `zh_parameter`,
  `en_parameter`,
  `args_state`,
  `src_id`,
  `src_tb_name`,
  `market_date_at`,
  `lifecycle`,
  `extra_parameter`,
  `is_cn`,
  `is_hot`,
  `data_version`,
  `state`,
  `field1`,
  `field2`,
  `field3`,
  `field4`,
  `field5`,
  `field6`,
  `field7`,
  `field8`,
  `field9`,
  `field10`,
  `field11`,
  `field12`,
  `field13`,
  `field14`,
  `field15`,
  `field16`,
  `field17`,
  `field18`,
  `field19`,
  `field20`,
  `field21`,
  `field22`,
  `field23`,
  `field24`,
  `field25`,
  `field26`,
  `field27`,
  `field28`,
  `field29`,
  `field30`,
  `field31`,
  `field32`,
  `field33`,
  `field34`,
  `field35`,
  `field36`,
  `field37`,
  `field38`,
  `field39`,
  `field40`,
  `field41`,
  `field42`,
  `field43`,
  `field44`,
  `field45`,
  `field46`,
  `field47`,
  `field48`,
  `field49`,
  `field50`
)values(
{},
{},
{},
{},
{},
{},
{},
{},
{},
{},
{},
{},
{},
{},
{},
{},
{},
{},
{},
{},
{},
{},
{},
{},
{},
{},
{},
{},
{},
{},
{},
{},
{},
{},
{},
{},
{},
{},
{},
{},
{},
{},
{},
{},
{},
{},
{},
{},
{},
{},
{},
{},
{},
{},
{},
{},
{},
{},
{},
{},
{},
{},
{},
{},
{},
{},
{},
{},
{},
{},
{},
{},
{},
{},
{},
{},
{},
{},
{},
{},
{},
{}
)
"""
    if part_number_data['market_date_at']:
        market_date_at = repr(part_number_data['market_date_at'])
    else:
        market_date_at = 'NULL'
    if part_number_data['summary']:
        summary = repr(part_number_data['summary'])
    else:
        summary = 'NULL'
    if part_number_data['zh_parameter']:
        zh_parameter = repr(part_number_data['zh_parameter'])
    else:
        zh_parameter = 'NULL'
    if part_number_data['en_parameter']:
        en_parameter = repr(part_number_data['en_parameter'])
    else:
        en_parameter = 'NULL'
    if part_number_data['extra_parameter']:
        extra_parameter = repr(part_number_data['extra_parameter'])
    else:
        extra_parameter = 'NULL'
    icons = part_number_data['icons']
    if icons:
        icons = json.loads(icons)
        print(icons)
        if icons:
            pass
        else:
            icons = []
    else:
        icons = []
    icons = repr(json.dumps(icons, ensure_ascii=False))
    # print(insert_sql.format(db_name,table,kav[0],kav[1],repr(part_number_data['part_number']),repr(part_number_data['category_id']),repr(part_number_data['factory_id']),repr(part_number_data['supplier_id']),repr(part_number_data['producer_id']),repr(part_number_data['source_web']),repr(part_number_data['data_sheet']),repr(icon),repr(part_number_data['description']),(part_number_data['price']),repr(part_number_data['qty']),repr(part_number_data['minimum_quantity']),repr(part_number_data['series']),repr(part_number_data['summary']),repr(part_number_data['pdf_path']),repr(part_number_data['txt_path']),repr(part_number_data['zh_parameter']),repr(part_number_data['en_parameter']),repr(part_number_data['args_state']),repr(part_number_data['src_id']),repr(part_number_data['src_tb_name']),market_date_at,repr(part_number_data['lifecycle']),extra_parameter,repr(part_number_data['is_cn']),repr(part_number_data['data_version']),repr(part_number_data['state'])))
    mysql_cursor.execute(
        insert_sql.format(db_name, table, part_number_data['id'], repr(part_number_data['name']), repr(part_number_data['part_number']),
                          repr(part_number_data['category_id']), repr(part_number_data['factory_id']), repr(part_number_data['country_id']),
                          repr(part_number_data['supplier_id']), repr(part_number_data['producer_id']),
                          repr(part_number_data['source_web']), repr(part_number_data['data_sheet']), icons,
                          repr(part_number_data['description']), (part_number_data['price']),
                          repr(part_number_data['qty']), repr(part_number_data['minimum_quantity']),
                          repr(part_number_data['series']), repr(part_number_data['packaging']), summary,
                          repr(part_number_data['pdf_path']), repr(part_number_data['txt_path']),
                          zh_parameter, en_parameter,
                          repr(part_number_data['args_state']), repr(part_number_data['src_id']),
                          repr(part_number_data['src_tb_name']), market_date_at, repr(part_number_data['lifecycle']),
                          extra_parameter, repr(part_number_data['is_cn']), repr(part_number_data['is_hot']), repr(part_number_data['data_version']),
                          repr(part_number_data['state']), repr(part_number_data['field1']),
                          repr(part_number_data['field2']), repr(part_number_data['field3']),
                          repr(part_number_data['field4']), repr(part_number_data['field5']),
                          repr(part_number_data['field6']), repr(part_number_data['field7']),
                          repr(part_number_data['field8']), repr(part_number_data['field9']),
                          repr(part_number_data['field10']), repr(part_number_data['field11']),
                          repr(part_number_data['field12']), repr(part_number_data['field13']),
                          repr(part_number_data['field14']), repr(part_number_data['field15']),
                          repr(part_number_data['field16']), repr(part_number_data['field17']),
                          repr(part_number_data['field18']), repr(part_number_data['field19']),
                          repr(part_number_data['field20']), repr(part_number_data['field21']),
                          repr(part_number_data['field22']), repr(part_number_data['field23']),
                          repr(part_number_data['field24']), repr(part_number_data['field25']),
                          repr(part_number_data['field26']), repr(part_number_data['field27']),
                          repr(part_number_data['field28']), repr(part_number_data['field29']),
                          repr(part_number_data['field30']), repr(part_number_data['field31']),
                          repr(part_number_data['field32']), repr(part_number_data['field33']),
                          repr(part_number_data['field34']), repr(part_number_data['field35']),
                          repr(part_number_data['field36']), repr(part_number_data['field37']),
                          repr(part_number_data['field38']), repr(part_number_data['field39']),
                          repr(part_number_data['field40']), repr(part_number_data['field41']),
                          repr(part_number_data['field42']), repr(part_number_data['field43']),
                          repr(part_number_data['field44']), repr(part_number_data['field45']),
                          repr(part_number_data['field46']), repr(part_number_data['field47']),
                          repr(part_number_data['field48']), repr(part_number_data['field49']),
                          repr(part_number_data['field50'])).strip())


def insert_value_into_table(src_table, dst_tb_prefix):
    # 遍历读取记录，判断所在hid，进行插入操作
    tb_lines = sum_tb_lines(db=MYSQL_ELECTRON_TOTAL_DATABASE, tb=src_table)
    offset = 0
    success = False
    conn, cursor = context()
    # 获取固定行数数据进行逐行追加参数名
    while tb_lines >= offset:
        sql = """SELECT * FROM {}.{} order by id limit {} offset {}""".format(MYSQL_ELECTRON_TOTAL_DATABASE, src_table,
                                                                              LINES_LIMIT, offset)
        try:
            cursor.execute(sql)
            result = cursor.fetchall()
            for electron_dict in result:
                # 判断分表的维度
                if dst_tb_prefix in ['tb_electron_', 'tb_category_']:
                    standard = 'part_number' if dst_tb_prefix == 'tb_electron_' else 'category_id'
                    # 根据分表维度计算此条数据该放到哪个hash_id表
                    dst_tb_hid = hashlib.md5(electron_dict[standard].encode('UTF-8')).hexdigest()[-2:]
                    dst_table = dst_tb_prefix + dst_tb_hid
                else:
                    standard = 'factory_id'
                    # 根据分表维度计算此条数据该放到哪个hash_id表
                    dst_tb_hid = hex(int(electron_dict[standard]))[-2:]
                    if dst_tb_hid[0] == 'x':
                        dst_tb_hid = dst_tb_hid.replace('x', '0')
                    dst_table = dst_tb_prefix + dst_tb_hid
                # cursor.execute()
                # 把数据插入到目标表
                insert_data_sql(MYSQL_ELECTRON_TOTAL_DATABASE, dst_table, electron_dict, cursor)
                conn.commit()
                # # 记录数据来源
                # with open('insert_value_tb_{}.txt'.format(dst_table), 'a+', encoding='utf8') as f:
                #     f.write('src_table: {}, part_number: {},  dst_table: {}\n'.format(src_table, electron_dict['part_number'], dst_table))
                # success = True
                # print("offset: ", offset)
        except Exception as ex:
            logger.error(
                "insert_value_into_table Error: {},{},{}".format(sql,
                                                                   ex,
                                                                   ex))
            print("insert_value_into_table Error: {},{}".format(sql, ex))
            # conn.close()
            success = False
            # raise Exception
        offset += LINES_LIMIT
    conn.close()
    return success


def split_electron(dimension=''):
    if dimension == 'category':
        table_prefix = 'tb_category_'
    elif dimension == 'factory':
        table_prefix = 'tb_factory_'
    else:
        table_prefix = 'tb_electron_'
    # 创建256张表
    create_electron_hash_table(db_name=MYSQL_ELECTRON_TOTAL_DATABASE, table_prefix=table_prefix, comment='业务库-元器件信息表(按{}维度分表)'.format(dimension))
    # 从总表读取数据，放入相应的表格中
    insert_value_into_table(src_table='tb_electron_total', dst_tb_prefix=table_prefix)


def create_es_mapping():
    # 1. 创建总表mapping
    # 2. 创建三种维度的mapping
    pass


if __name__ == "__main__":
    # 伪代码
    # TODO 把101的表数据读过来更新100的， 更新分类命名参数和不命名参数的对应表
    # 计算元器件是否满足推送条件
    # calculate_electron_contrast_pintopin_status()
    # 把满足推送条件元器件放到总表中
    generate_electron_total_data()
    # 按不同维度进行分表, 可以通过多进程处理
    split_electron(dimension='category')
    split_electron(dimension='factory')
    split_electron(dimension='part_number')
    # 创建es索引
    create_es_mapping()

```
