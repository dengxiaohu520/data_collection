mysql脚本创建库表.sql

-- ===========================================================================================
-- 创建字典库
-- ===========================================================================================
create database if not exists db_dictionary DEFAULT CHARACTER SET utf8mb4;

use db_dictionary;

-- 创建字典分类表
CREATE TABLE IF NOT EXISTS `tb_category_dict` (
  `id` int(11) NOT NULL AUTO_INCREMENT comment '主键',
  `category_uuid` char(36) not null  COMMENT '分类uuid',
  `org_category_fid` int(11) default 0 comment '原始表中的主键id',
  `category_code` varchar(9) NOT NULL DEFAULT '' COMMENT '分类业务编码CR: level1: [01-99], level2: [001-999], level3: [0001-9999]',
  `zh_name` varchar(128) NOT NULL DEFAULT '' COMMENT '分类中文名',
  `en_name` varchar(128) NOT NULL DEFAULT '' COMMENT '分类英文名',
  `parent_code` varchar(9) default null comment '父级分类业务编码',
  `level`  tinyint(1) default 0 comment '级别',
  `abbreviation` json comment '分类简称',
  `remark` varchar(100) default null comment '备注',
  `sort`  int(11) default 0 comment '排序',
  `state` tinyint(1) NOT NULL DEFAULT '0' COMMENT '状态',
  `create_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
  `update_at` datetime(3) NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3) COMMENT '更新时间',
  `create_uid` varchar(16) NOT NULL DEFAULT '' COMMENT '创建人id',
  `update_uid` varchar(16) NOT NULL DEFAULT '' COMMENT '修改人id',
  `field1` varchar(30) not null default '' comment '备用字段1',
  `field2` varchar(30) not null default '' comment '备用字段2',
  `field3` varchar(30) not null default '' comment '备用字段3',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_zh_name` (`zh_name`, `en_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- 创建分类参数表
CREATE TABLE IF NOT EXISTS `tb_category_kwargs` (
  `id` int(11) NOT NULL AUTO_INCREMENT comment '主键',
  `category_kwargs_uuid` char(36) not null  COMMENT '分类参数uuid',
  `category_id` varchar(9) NOT NULL DEFAULT '0' COMMENT '分类表的业务id',
  `zh_parameter` json DEFAULT NULL COMMENT '中文参数',
  `en_parameter` json DEFAULT NULL COMMENT '英文参数',
  `create_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
  `update_at` datetime(3) NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3) COMMENT '更新时间',
  `is_similar_args` tinyint(1) not null default 0 comment '0: 不是普通替代参数; 1: 是普通替代参数',
  `is_pintopin_args` tinyint(1) not null default 0 comment '0: 不是pintopin参数; 1: 是pintopin参数',
  `create_uid` varchar(16) NOT NULL DEFAULT '' COMMENT '创建人id',
  `update_uid` varchar(16) NOT NULL DEFAULT '' COMMENT '修改人id',
  `state` tinyint(1) NOT NULL DEFAULT '0' COMMENT '状态',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- 创建国家/地区字典表
CREATE TABLE IF NOT EXISTS `tb_area_dict` (
  `id` int(11) NOT NULL AUTO_INCREMENT comment '主键',
  `area_uuid` char(36) not null COMMENT '国家/地区uuid',
  `org_area_fid` int(1) default 0 comment '原始表中的主键id',
  `zh_name` varchar(256) NOT NULL DEFAULT '' COMMENT '国别中文名',
  `en_name` varchar(100) NOT NULL DEFAULT '' COMMENT '国别英文名',
  `create_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `create_uid` varchar(16) NOT NULL DEFAULT '' COMMENT '创建人id',
  `update_uid` varchar(16) NOT NULL DEFAULT '' COMMENT '修改人id',
  `sort` int(11) not null default 0 comment '排序',
  `state` tinyint(1) not null default 0 comment '状态',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 创建分类字典规则表
-- CREATE TABLE IF NOT EXISTS `tb_category_kwargs_dict` (
--   `id` int(11) NOT NULL AUTO_INCREMENT comment '主键',
--   `category_dict_uuid` char(36) not null DEFAULT '' COMMENT '分类字典uuid',
--   `category_code_id` varchar(9) NOT NULL DEFAULT '0' COMMENT '分类表的业务id',
--   `kwargs_name` varchar(50) not null default '' comment '参数名称',
--   `kwargs_value` json not null default '' comment '分类参数值集合',
--   `create_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
--   `update_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
--   `create_uid` varchar(16) NOT NULL DEFAULT '' COMMENT '创建人id',
--   `update_uid` varchar(16) NOT NULL DEFAULT '' COMMENT '修改人id',
--   `state` tinyint NOT NULL DEFAULT '0' COMMENT '状态',
--   PRIMARY KEY (`id`)
-- ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



-- 创建元器件字典表
CREATE TABLE IF NOT EXISTS `tb_electron_dict` (
  `id` int(11) NOT NULL AUTO_INCREMENT comment '主键',
  `electron_uuid` char(36) not null COMMENT '元器件uuid',
  `org_electron_fid` int(11) NOT NULL DEFAULT 0 COMMENT '原始表中的元器件主键id',
  `category_id` varchar(9) NOT NULL DEFAULT '0' COMMENT '分类表的业务id',
  `name` varchar(128) NOT NULL DEFAULT '' COMMENT '内部型号',
  `part_number` varchar(128) NOT NULL DEFAULT '' COMMENT '型号',
  `data_sheet` varchar(256) NOT NULL DEFAULT '' COMMENT 'pdf下载地址',
  `source_web` varchar(255) not null default '' comment '来源站点',
  `state` tinyint(4) NOT NULL DEFAULT '0' COMMENT '状态',
  `create_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `create_uid` varchar(16) NOT NULL DEFAULT '' COMMENT '创建人id',
  `update_uid` varchar(16) NOT NULL DEFAULT '' COMMENT '修改人id',
  PRIMARY KEY (`id`),
  key idx_part_number (part_number) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



-- 创建元器件参数规则映射表
create TABLE if not exists `tb_electron_kwargs_mapping` (
  `id` int(11) not null AUTO_INCREMENT comment '主键',
  `electron_kwargs_uuid` char(36) not null COMMENT '元器件参数uuid',
  `category_id` varchar(9) NOT NULL DEFAULT '0' COMMENT '分类表的业务id',
  `field_name` varchar(10) not null default '' COMMENT '字段名',
  `tb_kwargs_id` int(11) not null default '0' comment '参数名主键id',
  `is_similar_args` tinyint(1) not null default 0 comment '0: 不是普通替代参数; 1: 是普通替代参数',
  `is_pintopin_args` tinyint(1) not null default 0 comment '0: 不是pintopin参数; 1: 是pintopin参数',
  `remark` varchar(100) not null default '' comment '备注',
  `state` tinyint(4) NOT NULL DEFAULT '0' COMMENT '状态',
  `create_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `create_uid` varchar(16) NOT NULL DEFAULT '' COMMENT '创建人id',
  `update_uid` varchar(16) NOT NULL DEFAULT '' COMMENT '修改人id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB default CHARSET=utf8mb4;


-- 创建参数字典表
create TABLE if not exists `tb_kwargs_dict` (
  `id` int(11) not null AUTO_INCREMENT comment '主键',
  `kwargs_uuid` char(36) not null COMMENT '参数uuid',
  `zh_name` varchar(30) not null default '' comment '中文参数名',
  `en_name` varchar(30) not null default '' comment '英文参数名',
  `state` tinyint(1) NOT NULL DEFAULT '0' COMMENT '状态',
  `create_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `create_uid` varchar(16) NOT NULL DEFAULT '' COMMENT '创建人id',
  `update_uid` varchar(16) NOT NULL DEFAULT '' COMMENT '修改人id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB default CHARSET=utf8mb4;


-- 创建热门数据类型表
create TABLE if not exists `tb_hotdata_type` (
  `id` int(11) not null AUTO_INCREMENT comment '主键',
  `hot_uuid` char(36) not null DEFAULT '' COMMENT '热门数据uuid',
  `org_type_id` int(11) not null default 0 comment '原始表中的主键id',
  `hot_name` varchar(10) not null default '' comment '热门数据名称',
  `hot_type` int(11) not null default 0 comment '热门类型，1：元器件，2：厂牌，3：分类，4：参数，5：视频，6：方案，7：成品',
  `remark` varchar(100) not null default '' comment '备注',
  `state` tinyint(1) NOT NULL DEFAULT '0' COMMENT '状态',
  `create_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `create_uid` varchar(16) NOT NULL DEFAULT '' COMMENT '创建人id',
  `update_uid` varchar(16) NOT NULL DEFAULT '' COMMENT '修改人id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB default CHARSET=utf8mb4;