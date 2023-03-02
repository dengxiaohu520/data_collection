# python链接mysql方式
1. 第一种方式：
```
import pymysql

def context(is_dict_cursor=True):
    try:
        config = {
            'host': MYSQL_HOST,
            'port': MYSQL_PORT,
            'user': MYSQL_USER,
            'password': MYSQL_PASSWORD,
            'database': MYSQL_DATABASE,
            'charset': MYSQL_CHARSET,
        }

        conn = pymysql.connect(**config)
        if is_dict_cursor:
            cursor = conn.cursor(cursor=pymysql.cursors.DictCursor)
        else:
            cursor = conn.cursor()
        return conn, cursor
    except Exception as ex:
        print("connect database failed, {},{}".format(200, ex))
        raise Exception({'code': 200, 'msg': ex})

def get_factry_id():
    """
    获取厂牌id
    """
    tb_name_1 = 'db_infinitech_website.tp_part'
    try:
        conn, cursor = context()
        sql = """select factory from {tb_name_1} group by factory""".format(tb_name_1=tb_name_1)
        cursor.execute(sql)
        res = cursor.fetchall()
    except Exception as e:
        print("获取厂牌id出错，原因是： %s" % e)
```

2. 第二种方式：
```

```