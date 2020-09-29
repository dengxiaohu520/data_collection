# mysql脚本创建库表.md

-- ===========================================================================================
-- 创建得捷爬虫库
-- ===========================================================================================
create database if not exists db_crawler_digikey DEFAULT CHARACTER SET utf8mb4;

use db_crawler_digikey;

-- 创建得捷分类表(中文)
CREATE TABLE IF NOT EXISTS `tb_electron_category_zh` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mongo_relate_id` varchar(50) NOT NULL COMMENT '关联mongo _id',
  `first_zh_name` varchar(256) NOT NULL DEFAULT '' COMMENT '一级分类中文名',
  `first_zh_url` varchar(256) not null DEFAULT '' COMMENT '一级分类中文地址',
  `second_category_id` varchar(256) NOT NULL DEFAULT '0' COMMENT '得捷二级分类id',
  `second_zh_name` varchar(256) NOT NULL DEFAULT '' COMMENT '二级分类中文名',
  `second_zh_url` varchar(256) not null DEFAULT '' COMMENT '二级分类中文地址',
  `third_category_id` varchar(256) NOT NULL DEFAULT '0' COMMENT '得捷三级分类id',
  `third_zh_name` varchar(256) NOT NULL DEFAULT '' COMMENT '三级分类中文名',
  `third_zh_url` varchar(256) not null DEFAULT '' COMMENT '三级分类中文地址',
  `data_version` varchar(32) not null DEFAULT '' COMMENT '采集日期版本号，如：20190103',
  `state` tinyint(4) NOT NULL DEFAULT '0' COMMENT '状态',
  `create_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `extra` varchar(400) DEFAULT NULL COMMENT '额外字段',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_zh_name` (`first_zh_name`, `second_zh_name`, `third_zh_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- 创建得捷分类表(英文)
CREATE TABLE IF NOT EXISTS `tb_electron_category_en` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mongo_relate_id` varchar(50) NOT NULL COMMENT '关联mongo _id',
  `first_en_name` varchar(256) NOT NULL DEFAULT '' COMMENT '一级分类英文名',
  `first_en_url` varchar(256) not null DEFAULT '' COMMENT '一级分类英文地址',
  `second_category_id` varchar(256) NOT NULL DEFAULT '0' COMMENT '得捷二级分类id',
  `second_en_name` varchar(256) NOT NULL DEFAULT '' COMMENT '二级分类英文名',
  `second_en_url` varchar(256) not null DEFAULT '' COMMENT '二级分类英文地址',
  `third_category_id` varchar(256) NOT NULL DEFAULT '0' COMMENT '得捷三级分类id',
  `third_en_name` varchar(256) NOT NULL DEFAULT '' COMMENT '三级分类英文名',
  `third_en_url` varchar(256) not null DEFAULT '' COMMENT '三级分类英文地址',
  `data_version` varchar(32) not null DEFAULT '' COMMENT '采集日期版本号，如：20190103',
  `state` tinyint(4) NOT NULL DEFAULT '0' COMMENT '状态',
  `create_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `extra` varchar(400) DEFAULT NULL COMMENT '额外字段',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_en_name` (`first_en_name`, `second_en_name`, `third_en_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- 创建得捷分类参数表(中文)
CREATE TABLE IF NOT EXISTS `tb_electron_category_kwargs_zh` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mongo_relate_id` varchar(50) NOT NULL COMMENT '关联mongo _id',
  `category_id` varchar(256) NOT NULL DEFAULT '0' COMMENT '得捷分类id',
  `zh_name` varchar(256) NOT NULL DEFAULT '' COMMENT '分类中文名',
  `kwargs_zh_name` varchar(100) NOT NULL DEFAULT '' COMMENT '分类中文参数名',
  `kwargs_zh_value` varchar(100) NOT NULL DEFAULT '' COMMENT '分类中文参数值',
  `kwargs_zh_url` varchar(100) NOT NULL DEFAULT '' COMMENT '分类参数中文地址',
  `level` tinyint(4) NOT NULL DEFAULT '0' COMMENT '级别',
  `data_version` varchar(32) not null DEFAULT '' COMMENT '采集日期版本号，如：20190103',
  `state` tinyint(4) NOT NULL DEFAULT '0' COMMENT '状态',
  `create_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `extra` varchar(400) DEFAULT NULL COMMENT '额外字段',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 创建得捷分类参数表(英文)
CREATE TABLE IF NOT EXISTS `tb_electron_category_kwargs_en` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mongo_relate_id` varchar(50) NOT NULL COMMENT '关联mongo _id',
  `category_id` varchar(256) NOT NULL DEFAULT '0' COMMENT '得捷分类id',
  `en_name` varchar(256) NOT NULL DEFAULT '' COMMENT '分类英文名',
  `kwargs_en_name` varchar(100) NOT NULL DEFAULT '' COMMENT '分类英文参数名',
  `kwargs_en_value` varchar(100) NOT NULL DEFAULT '' COMMENT '分类英文参数值',
  `kwargs_en_url` varchar(100) NOT NULL DEFAULT '' COMMENT '分类参数英文地址',
  `level` tinyint(4) NOT NULL DEFAULT '0' COMMENT '级别',
  `data_version` varchar(32) not null DEFAULT '' COMMENT '采集日期版本号，如：20190103',
  `state` tinyint(4) NOT NULL DEFAULT '0' COMMENT '状态',
  `create_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `extra` varchar(400) DEFAULT NULL COMMENT '额外字段',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- 创建得捷制造商信息列表（中文）
CREATE TABLE IF NOT EXISTS `tb_manufacturer_zh` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `zh_name` varchar(128) NOT NULL DEFAULT '' COMMENT '制造商中文名',
  `zh_detail_url` varchar(256) NOT NULL DEFAULT '' COMMENT '制造商详情页地址',
  `homepage` varchar(256) NOT NULL DEFAULT '' COMMENT '制造商主页',
  `logo` varchar(256) NOT NULL DEFAULT '' COMMENT '制造商商标logo链接', 
  `zh_about` varchar(3000) NOT NULL DEFAULT '' COMMENT '制造商中文简介',
  `data_version` varchar(32) not null DEFAULT '' COMMENT '采集日期版本号，如：20190103',
  `state` tinyint(4) NOT NULL DEFAULT '0' COMMENT '状态',
  `create_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_zh_name` (`zh_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 创建得捷制造商信息列表（英文）
CREATE TABLE IF NOT EXISTS `tb_manufacturer_en` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `eh_name` varchar(128) NOT NULL DEFAULT '' COMMENT '制造商英文名',
  `en_detail_url` varchar(256) NOT NULL DEFAULT '' COMMENT '制造商详情页地址',
  `homepage` varchar(256) NOT NULL DEFAULT '' COMMENT '制造商主页',
  `logo` varchar(256) NOT NULL DEFAULT '' COMMENT '制造商商标logo链接', 
  `en_about` varchar(3000) NOT NULL DEFAULT '' COMMENT '制造商英文简介',
  `data_version` varchar(32) not null DEFAULT '' COMMENT '采集日期版本号，如：20190103',
  `state` tinyint(4) NOT NULL DEFAULT '0' COMMENT '状态',
  `create_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_en_name` (`eh_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- 创建得捷元器件表(英文)
CREATE TABLE IF NOT EXISTS `tb_electron_en_685` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `digikey_part_number` varchar(128) NOT NULL DEFAULT '' COMMENT '得捷型号',
  `manufacturer_part_number` varchar(128) NOT NULL DEFAULT '' COMMENT '原厂型号',
  `manufacturer` varchar(128) NOT NULL DEFAULT '' COMMENT '制造商名称',
  `category_id` varchar(10) NOT NULL DEFAULT '' COMMENT '得捷分类id',
  `datasheets` varchar(256) NOT NULL DEFAULT '' COMMENT 'pdf连接',
  `image` varchar(256) NOT NULL DEFAULT '' COMMENT 'logo链接',
  `description` text NOT NULL DEFAULT '' COMMENT '描述',
  `quantity_available` int(11) DEFAULT 0 COMMENT '可用库存数量',
  `factory_stock` int(11) DEFAULT 0 COMMENT '原厂库存数量',
  `unit_price` decimal(10,2) DEFAULT 0.00 COMMENT '价格(USD)',
  `qty` int(11) DEFAULT 0 COMMENT '数量',
  `minimum_quantity` int(11) DEFAULT 0 COMMENT '最小数量',
  `packaging` varchar(100) DEFAULT '' COMMENT '包装',
  `series` varchar(100) DEFAULT '' COMMENT '系列',
  `part_status` varchar(100) DEFAULT '' COMMENT '零件状态',
  `package_case` varchar(64) DEFAULT '' COMMENT '封装',
  `mounting_type` varchar(32) DEFAULT '' COMMENT '安装类型',
  `field01` varchar(256) DEFAULT '',
  `field02` varchar(256) DEFAULT '',
  `field03` varchar(256) DEFAULT '',
  `field04` varchar(256) DEFAULT '',
  `field05` varchar(256) DEFAULT '',
  `field06` varchar(256) DEFAULT '',
  `field07` varchar(256) DEFAULT '',
  `field08` varchar(256) DEFAULT '',
  `field09` varchar(256) DEFAULT '',
  `field10` varchar(256) DEFAULT '',
  `field11` varchar(256) DEFAULT '',
  `field12` varchar(256) DEFAULT '',
  `field13` varchar(256) DEFAULT '',
  `field14` varchar(256) DEFAULT '',
  `field15` varchar(256) DEFAULT '',
  `field16` varchar(256) DEFAULT '',
  `field17` varchar(256) DEFAULT '',
  `field18` varchar(256) DEFAULT '',
  `field19` varchar(256) DEFAULT '',
  `field20` varchar(256) DEFAULT '',
  `field21` varchar(256) DEFAULT '',
  `field22` varchar(256) DEFAULT '',
  `field23` varchar(256) DEFAULT '',
  `field24` varchar(256) DEFAULT '',
  `field25` varchar(256) DEFAULT '',
  `field26` varchar(256) DEFAULT '',
  `field27` varchar(256) DEFAULT '',
  `field28` varchar(256) DEFAULT '',
  `field29` varchar(256) DEFAULT '',
  `field30` varchar(256) DEFAULT '',
  `field31` varchar(256) DEFAULT '',
  `field32` varchar(256) DEFAULT '',
  `field33` varchar(256) DEFAULT '',
  `field34` varchar(256) DEFAULT '',
  `field35` varchar(256) DEFAULT '',
  `field36` varchar(256) DEFAULT '',
  `field37` varchar(256) DEFAULT '',
  `field38` varchar(256) DEFAULT '',
  `field39` varchar(256) DEFAULT '',
  `field40` varchar(256) DEFAULT '',
  `field41` varchar(256) DEFAULT '',
  `field42` varchar(256) DEFAULT '',
  `field43` varchar(256) DEFAULT '',
  `field44` varchar(256) DEFAULT '',
  `field45` varchar(256) DEFAULT '',
  `field46` varchar(256) DEFAULT '',
  `field47` varchar(256) DEFAULT '',
  `field48` varchar(256) DEFAULT '',
  `field49` varchar(256) DEFAULT '',
  `field50` varchar(256) DEFAULT '',
  `data_version` varchar(32) not null DEFAULT '' COMMENT '采集日期版本号，如：20190103', 
  `state` tinyint(4) NOT NULL DEFAULT '0' COMMENT '状态',
  `create_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `filename` varchar(100) DEFAULT '' COMMENT '来源文件名',
  `args_state` int(10) DEFAULT 0 COMMENT '参数缺失状态值',
  PRIMARY KEY (`id`),
  key idx_digikey_part_number (digikey_part_number) USING BTREE,
  key idx_manufacturer_part_number (manufacturer_part_number) USING BTREE,
  key idx_manufacturer (manufacturer) USING BTREE,
  key idx_series (series) USING BTREE,
  key idx_package_case (package_case) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



-- 创建得捷元器件表(中文)
CREATE TABLE IF NOT EXISTS `tb_electron_zh_685` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `digikey_part_number` varchar(128) NOT NULL DEFAULT '' COMMENT '得捷型号',
  `manufacturer_part_number` varchar(128) NOT NULL DEFAULT '' COMMENT '原厂型号',
  `manufacturer` varchar(128) NOT NULL DEFAULT '' COMMENT '制造商名称',
  `category_id` varchar(10) NOT NULL DEFAULT '' COMMENT '得捷分类id',
  `datasheets` varchar(256) NOT NULL DEFAULT '' COMMENT 'pdf连接',
  `image` varchar(256) NOT NULL DEFAULT '' COMMENT 'logo链接',
  `description` text NOT NULL DEFAULT '' COMMENT '描述',
  `quantity_available` int(11) DEFAULT 0 COMMENT '可用库存数量',
  `factory_stock` int(11) DEFAULT 0 COMMENT '原厂库存数量',
  `unit_price` decimal(10,2) DEFAULT 0.00 COMMENT '价格(USD)',
  `qty` int(11) DEFAULT 0 COMMENT '数量',
  `minimum_quantity` int(11) DEFAULT 0 COMMENT '最小数量',
  `packaging` varchar(100) DEFAULT '' COMMENT '包装',
  `series` varchar(100) DEFAULT '' COMMENT '系列',
  `part_status` varchar(100) DEFAULT '' COMMENT '零件状态',
  `package_case` varchar(64) DEFAULT '' COMMENT '封装',
  `mounting_type` varchar(32) DEFAULT '' COMMENT '安装类型',
  `field01` varchar(256) DEFAULT '',
  `field02` varchar(256) DEFAULT '',
  `field03` varchar(256) DEFAULT '',
  `field04` varchar(256) DEFAULT '',
  `field05` varchar(256) DEFAULT '',
  `field06` varchar(256) DEFAULT '',
  `field07` varchar(256) DEFAULT '',
  `field08` varchar(256) DEFAULT '',
  `field09` varchar(256) DEFAULT '',
  `field10` varchar(256) DEFAULT '',
  `field11` varchar(256) DEFAULT '',
  `field12` varchar(256) DEFAULT '',
  `field13` varchar(256) DEFAULT '',
  `field14` varchar(256) DEFAULT '',
  `field15` varchar(256) DEFAULT '',
  `field16` varchar(256) DEFAULT '',
  `field17` varchar(256) DEFAULT '',
  `field18` varchar(256) DEFAULT '',
  `field19` varchar(256) DEFAULT '',
  `field20` varchar(256) DEFAULT '',
  `field21` varchar(256) DEFAULT '',
  `field22` varchar(256) DEFAULT '',
  `field23` varchar(256) DEFAULT '',
  `field24` varchar(256) DEFAULT '',
  `field25` varchar(256) DEFAULT '',
  `field26` varchar(256) DEFAULT '',
  `field27` varchar(256) DEFAULT '',
  `field28` varchar(256) DEFAULT '',
  `field29` varchar(256) DEFAULT '',
  `field30` varchar(256) DEFAULT '',
  `field31` varchar(256) DEFAULT '',
  `field32` varchar(256) DEFAULT '',
  `field33` varchar(256) DEFAULT '',
  `field34` varchar(256) DEFAULT '',
  `field35` varchar(256) DEFAULT '',
  `field36` varchar(256) DEFAULT '',
  `field37` varchar(256) DEFAULT '',
  `field38` varchar(256) DEFAULT '',
  `field39` varchar(256) DEFAULT '',
  `field40` varchar(256) DEFAULT '',
  `field41` varchar(256) DEFAULT '',
  `field42` varchar(256) DEFAULT '',
  `field43` varchar(256) DEFAULT '',
  `field44` varchar(256) DEFAULT '',
  `field45` varchar(256) DEFAULT '',
  `field46` varchar(256) DEFAULT '',
  `field47` varchar(256) DEFAULT '',
  `field48` varchar(256) DEFAULT '',
  `field49` varchar(256) DEFAULT '',
  `field50` varchar(256) DEFAULT '',
  `data_version` varchar(32) not null DEFAULT '' COMMENT '采集日期版本号，如：20190103', 
  `state` tinyint(4) NOT NULL DEFAULT '0' COMMENT '状态',
  `create_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `filename` varchar(100) DEFAULT '' COMMENT '来源文件名',
  `args_state` int(10) DEFAULT 0 COMMENT '参数缺失状态值',
  PRIMARY KEY (`id`),
  key idx_digikey_part_number (digikey_part_number) USING BTREE,
  key idx_manufacturer_part_number (manufacturer_part_number) USING BTREE,
  key idx_manufacturer (manufacturer) USING BTREE,
  key idx_series (series) USING BTREE,
  key idx_package_case (package_case) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


/*
alter table tb_electron_en_685 add `category_id` varchar(10) not null DEFAULT '' comment '得捷分类id';
alter table tb_electron_zh_685 add `category_id` varchar(10) not null DEFAULT '' comment '得捷分类id';


alter table tb_electron_en_685 add column(
`category_id` varchar(10) not null DEFAULT '' comment '得捷分类id',
`filename` varchar(100) DEFAULT '' COMMENT '来源文件名',
`args_state` int(10) DEFAULT 0 comment '参数缺失状态值'
);

alter table tb_electron_zh_685 add column(
`category_id` varchar(10) not null DEFAULT '' comment '得捷分类id',
`filename` varchar(100) DEFAULT '' COMMENT '来源文件名',
`args_state` int(10) DEFAULT 0 comment '参数缺失状态值'
);
*/



-- ===========================================================================================
-- 创建校对库
-- ===========================================================================================
create database if not exists db_proofread_digikey DEFAULT CHARACTER SET utf8mb4;

use db_proofread_digikey;

-- 创建分类索引表
CREATE TABLE IF NOT EXISTS `tb_category_index` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `first_zh_name` varchar(128) NOT NULL DEFAULT '' COMMENT '一级分类中文',
  `first_en_name` varchar(256) NOT NULL DEFAULT '' COMMENT '一级分类英文',
  `first_category_id` varchar(10) NOT NULL DEFAULT '' COMMENT '一级分类id',
  `second_zh_name` varchar(128) NOT NULL DEFAULT '' COMMENT '二级分类中文',
  `second_en_name` varchar(256) NOT NULL DEFAULT '' COMMENT '二级分类英文',
  `second_category_id` varchar(10) NOT NULL DEFAULT '' COMMENT '二级分类id',
  `third_zh_name` varchar(128) NOT NULL DEFAULT '' COMMENT '三级分类中文',
  `third_en_name` varchar(256) NOT NULL DEFAULT '' COMMENT '三级分类英文',
  `third_category_id` varchar(10) NOT NULL DEFAULT '' COMMENT '三级分类id',
  `org_source_web` varchar(64) DEFAULT '' COMMENT '原始来源',
  `amend_source_web` varchar(64) DEFAULT '' COMMENT '修正后来源',
  `data_version` varchar(32) not null DEFAULT '' COMMENT '采集日期版本号，如：20200103', 
  `state` tinyint(4) NOT NULL DEFAULT '0' COMMENT '状态',
  `create_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `create_uid` varchar(16) NOT NULL DEFAULT '' ,
  `update_uid` varchar(16) NOT NULL DEFAULT '' ,
  PRIMARY KEY (`id`),
  key idx_first_zh_name (first_zh_name) USING BTREE,
  key idx_first_en_name (first_en_name) USING BTREE,
  key idx_second_zh_name (second_zh_name) USING BTREE,
  key idx_second_en_name (second_en_name) USING BTREE,
  key idx_third_zh_name (third_zh_name) USING BTREE,
  key idx_third_en_name (third_en_name) USING BTREE,
  UNIQUE KEY `uk_zh_name` (`first_zh_name`, `second_zh_name`, `third_zh_name`),
  UNIQUE KEY `uk_en_name` (`first_en_name`, `second_en_name`, `third_en_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- 创建分类参数表
CREATE TABLE IF NOT EXISTS `tb_category_kwargs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `category_index_id` int(11) NOT NULL DEFAULT 0 COMMENT '分类索引id',
  `zh_parameter` json DEFAULT '' COMMENT '中文参数',
  `en_parameter` json DEFAULT '' COMMENT '中文参数',
  `data_version` varchar(32) not null DEFAULT '' COMMENT '采集日期版本号，如：20200103', 
  `state` tinyint(4) NOT NULL DEFAULT '0' COMMENT '状态',
  `create_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `create_uid` varchar(16) NOT NULL DEFAULT '' ,
  `update_uid` varchar(16) NOT NULL DEFAULT '' ,
  PRIMARY KEY (`id`),
  key idx_category_index_id (category_index_id) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



-- 创建厂牌（制造商）索引表
CREATE TABLE IF NOT EXISTS `tb_factory_index` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `zh_name` varchar(128) NOT NULL DEFAULT '' COMMENT '中文全称',
  `en_name` varchar(256) NOT NULL DEFAULT '' COMMENT '英文全称',
  `zh_url` varchar(256) NOT NULL DEFAULT '' COMMENT '官网地址',
  `en_url` varchar(256) NOT NULL DEFAULT '' COMMENT '官网地址',
  `org_source_web` varchar(64) DEFAULT '' COMMENT '原始来源',
  `amend_source_web` varchar(64) DEFAULT '' COMMENT '修正后来源',
  `data_version` varchar(32) not null DEFAULT '' COMMENT '采集日期版本号，如：20200103', 
  `state` tinyint(4) NOT NULL DEFAULT '0' COMMENT '状态',
  `create_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `create_uid` varchar(16) NOT NULL DEFAULT '' ,
  `update_uid` varchar(16) NOT NULL DEFAULT '' ,
  PRIMARY KEY (`id`),
  key idx_zh_name (zh_name) USING BTREE,
  key idx_en_name (en_name) USING BTREE,
  UNIQUE KEY `uk_zh_en_name` (`zh_name`, `en_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 创建厂牌（制造商）表
CREATE TABLE IF NOT EXISTS `tb_factory` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `factory_index_id` int(11) NOT NULL DEFAULT 0 COMMENT '厂牌索引id',
  `zh_name` varchar(128) NOT NULL DEFAULT '' COMMENT '中文简称',
  `en_name` varchar(256) NOT NULL DEFAULT '' COMMENT '英文简称',
  `description` varchar(500) NOT NULL DEFAULT '' COMMENT '描述',
  `link` varchar(256) NOT NULL DEFAULT '' COMMENT '网址',
  `image` varchar(256) NOT NULL DEFAULT '' COMMENT 'image',
  `banner` varchar(256) NOT NULL DEFAULT '' COMMENT 'banner',
  `views` int(10) NOT NULL DEFAULT 0 COMMENT '浏览量',
  `country_id` int(11)  NOT NULL DEFAULT -1 COMMENT '国别id',
  `source_type` tinyint(1) DEFAULT '0' COMMENT '0:后台维护，1:商家',
  `contacts`  varchar(160) NOT NULL DEFAULT '' COMMENT '联系人',
  `telephone`  varchar(16) NOT NULL DEFAULT '' COMMENT '联系电话',
  `address` varchar(128) NOT NULL DEFAULT '' COMMENT '联系地址',
  `email` varchar(64) NOT NULL DEFAULT '' COMMENT '联系邮箱',
  `area_code` varchar(10) NOT NULL DEFAULT '' COMMENT '联系人手机所在国家代码',
  `extra_data` json DEFAULT NULL COMMENT '额外附属字段',
  `data_version` varchar(32) not null DEFAULT '' COMMENT '采集日期版本号，如：20200103',
  `state` tinyint(4) NOT NULL DEFAULT '0' COMMENT '状态',
  `create_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `create_uid` varchar(16) NOT NULL DEFAULT '' ,
  `update_uid` varchar(16) NOT NULL DEFAULT '' ,
  PRIMARY KEY (`id`),
  key idx_zh_name (zh_name) USING BTREE,
  key idx_en_name (en_name) USING BTREE,
  UNIQUE KEY `uk_zh_en_name` (`zh_name`, `en_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- 创建元器件索引表
CREATE TABLE IF NOT EXISTS `tb_electron_index_685` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `part_number` varchar(128) NOT NULL DEFAULT '' COMMENT '型号',
  `manufacturer` varchar(128) NOT NULL DEFAULT '' COMMENT '制造商名称',
  `org_source_web` varchar(64) DEFAULT '' COMMENT '原始来源',
  `amend_source_web` varchar(64) DEFAULT '' COMMENT '修正后来源',
  `data_version` varchar(32) not null DEFAULT '' COMMENT '采集日期版本号，如：20200103', 
  `state` tinyint(4) NOT NULL DEFAULT '0' COMMENT '状态',
  `create_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `create_uid` varchar(16) NOT NULL DEFAULT '' ,
  `update_uid` varchar(16) NOT NULL DEFAULT '' ,
  PRIMARY KEY (`id`),
  key idx_part_number (part_number) USING BTREE,
  key idx_manufacturer (manufacturer) USING BTREE,
  UNIQUE KEY `uk_part_num_manufacturer` (`part_number`, `manufacturer`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- 创建元器件表
CREATE TABLE IF NOT EXISTS `tb_electron_685` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `electron_index_id` int(11) NOT NULL DEFAULT 0 COMMENT '元器件索引id',
  `part_number` varchar(128) NOT NULL DEFAULT '' COMMENT '型号',
  `category_id` int(11) NOT NULL DEFAULT 0 COMMENT '分类id',
  `factory_id` int(11) NOT NULL DEFAULT 0 COMMENT '厂牌id',
  `data_sheet` varchar(256) NOT NULL DEFAULT '' COMMENT 'pdf下载地址',
  `image` varchar(256) NOT NULL DEFAULT '' COMMENT '图片地址',
  `views` int(11) NOT NULL DEFAULT 0 COMMENT '浏览量',
  `description` varchar(3000) NOT NULL DEFAULT '' COMMENT '描述',
  `unit_price` decimal(10,2) DEFAULT 0.00 COMMENT '价格',
  `qty` int(11) DEFAULT 0 COMMENT '库存数量',
  `minimum_quantity` int(11) DEFAULT 0 COMMENT '最小数量',
  `packaging` varchar(100) DEFAULT '' COMMENT '包装',
  `series` varchar(100) DEFAULT '' COMMENT '系列',
  `part_status` varchar(100) DEFAULT '' COMMENT '零件状态',
  `package_case` varchar(64) DEFAULT '' COMMENT '封装',
  `mounting_type` varchar(32) DEFAULT '' COMMENT '安装类型',
  `summary` text DEFAULT '' COMMENT '摘要',
  `pdf_path` varchar(256) DEFAULT '' COMMENT 'pdf存放地址',
  `txt_path` varchar(256) DEFAULT '' COMMENT 'txt存放路径',
  `zh_parameter` json DEFAULT '' COMMENT '中文参数',
  `en_parameter` json DEFAULT '' COMMENT '英文参数',
  `data_version` varchar(32) not null DEFAULT '' COMMENT '采集日期版本号，如：20200103', 
  `state` tinyint(4) NOT NULL DEFAULT '0' COMMENT '状态',
  `create_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `create_uid` varchar(16) NOT NULL DEFAULT '' ,
  `update_uid` varchar(16) NOT NULL DEFAULT '' ,
  PRIMARY KEY (`id`),
  key idx_part_number (part_number) USING BTREE,
  key idx_category_id (category_id) USING BTREE,
  key idx_factory_id (factory_id) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;




ALTER TABLE tb_user_extra add logins int(11) DEFAULT 0 COMMENT '登录次数'; --添加用户登录次数字段

alter table tb_feedback add (
`audit_status` int(10) DEFAULT NULL COMMENT '受理状态：0：待受理，1：受理中， 2：已解决， 3：未解决',
      `process_time` datetime DEFAULT NULL COMMENT '受理时间',
      `question_category` int(10) DEFAULT NULL COMMENT '反馈问题分类：0：建议或意见，1：业务问题，2：产品问题',
      `user_evaluate` int(10) DEFAULT 0 COMMENT '用户评价：0：未评价，1：非常满意，2：满意， 3：不满意',
      `receiver` VARCHAR(128) DEFAULT '' COMMENT '受理人'
    
)



SELECT * from tb_user_extra where uid='32'


select a.id,a.username,a.area_code,a.phone,a.email,a.real_name,a.icon,a.company,a.position,a.address,
    a.create_at,b.is_lock,b.last_login_time,b.last_login_time,b.logins,b.is_merchant,b.last_login_ip from db_user.tb_user a, db_user.tb_user_extra b where  a.id = b.uid;


SELECT count(*) from db_user.tb_user a, db_user.tb_user_extra b where  a.id = b.uid;