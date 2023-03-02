商城优化数据库更改.sql

--开票信息记录表
CREATE TABLE `tb_employ`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '用户ID',
  `header` int(2) NULL DEFAULT NULL COMMENT '发票抬头类型   1:企业   2:个人',
  `bill_type` int(2) NULL DEFAULT NULL COMMENT '发票材质  1:电子发票    2:纸质发票',
  `is_special` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '1:  普通发票    2:专用发票',
  `order_no` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '订单编号 ',
  `invoice_number` int(11) NULL DEFAULT NULL COMMENT '发票编号',
  `invoice_title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '发票抬头',
  `taxpayer` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '纳税人识别号',
  `registered_add` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '公司注册地址 ',
  `registered_phone` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '注册电话',
  `opening_bank` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '开户行',
  `contacts` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '联系人',
  `contacts_phone` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '联系电话',
  `province` int(10) NULL DEFAULT NULL COMMENT '地区:省',
  `city` int(10) NULL DEFAULT NULL COMMENT '地区:市',
  `district` int(10) NULL DEFAULT NULL COMMENT '地区:区/县',
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '详细地址',
  `license` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '营业执照',
  `certificate` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '一般纳税人认定书',
  `opening_accounts` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '开户许可证',
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '邮箱',
  `last_employ_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '最后一次使用时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 28 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '开票信息记录表' ROW_FORMAT = Dynamic;

SET FOREIGN_KEY_CHECKS = 1;





-- 专用发票表
CREATE TABLE `tb_special_invoice`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '用户ID',
  `bill_status` int(2) NULL DEFAULT 0 COMMENT '是否已开票    0:未开票   1:已开票  2:驳回',
  `header` int(2) NULL DEFAULT NULL COMMENT '发票抬头类型   1:企业   2:个人',
  `bill_type` int(2) NULL DEFAULT 1 COMMENT '发票材质  1:电子发票    2:纸质发票',
  `is_special` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '1' COMMENT '1:  普通发票    2:专用发票',
  `order_no` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '订单编号',
  `invoice_number` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '发票编号',
  `invoice_title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '发票抬头',
  `taxpayer` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '纳税人识别号',
  `registered_add` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '公司注册地址 ',
  `registered_phone` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '注册电话',
  `opening_bank` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '开户行',
  `contacts` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '联系人',
  `contacts_phone` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '联系电话',
  `province` int(10) NULL DEFAULT NULL COMMENT '地区:省',
  `city` int(10) NULL DEFAULT NULL COMMENT '地区:市',
  `district` int(10) NULL DEFAULT NULL COMMENT '地区:区/县',
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '详细地址',
  `services` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '服务名称',
  `figures` decimal(18, 4) NULL DEFAULT NULL COMMENT '金额',
  `license` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '营业执照',
  `certificate` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '一般纳税人认定书',
  `opening_accounts` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '开户许可证',
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `make_time` datetime(0) NULL DEFAULT NULL COMMENT '开票时间',
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '邮箱',
  `express` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '快递',
  `express_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '快递单号',
  `message` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '驳回理由',
  `back_body` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '返回体',
  `post_body` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '请求体',
  `pdfUrl` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '发票pdf地址',
  `serialNo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '流水号',
  `invoice_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '发票号(易票云)',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 347 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '专用发票表' ROW_FORMAT = Dynamic;

SET FOREIGN_KEY_CHECKS = 1;


-- 开票信息记录表增加字段
alter table db_user.tb_special_invoice add `bank_account` varchar(255) NULL DEFAULT NULL COMMENT '开户行账号';

-- 开票信息表更改字段类型
alter table db_user.tb_special_invoice modify column province  varchar(88) DEFAULT NULL COMMENT '地区:省';
alter table db_user.tb_special_invoice modify column city  varchar(88) DEFAULT NULL COMMENT '地区:市';
alter table db_user.tb_special_invoice modify column district  varchar(88) DEFAULT NULL COMMENT '地区:区、县';
alter table db_user.tb_special_invoice modify column order_on  varchar(256) DEFAULT NULL COMMENT '订单编号';

-- 开票信息表 （删除is_special字段）
alter table db_user.tb_special_invoice DROP column is_special;

-- 开票信息便（修改bill_status备注）
ALTER TABLE db_user.tb_special_invoice modify column bill_status int(2) DEFAULT '0' COMMENT '是否已开票    0:未开票  1:已开票  2:驳回  3：待开发票';
ALTER TABLE db_user.tb_special_invoice modify column bill_type int(2) DEFAULT '0' COMMENT '发票类型  1:增值税电子普通发票    2:增值税纸质专用发票';






--发票日志
CREATE TABLE `tb_invoice_log`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `invoice_title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '发票抬头',
  `taxpayer` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '纳税人识别号',
  `taxTotal` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '金额',
  `orderNo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '单号',
  `contacts` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '联系人',
  `contacts_phone` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '联系电话',
  `header` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '开票类型',
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '接收邮箱',
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `request_body` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '请求体',
  `back_body` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '返回体',
  `msg` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '状态信息',
  `serialNo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '发票流水号',
  `pdfUrl` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '发票PDF下载地址',
  `invoiceDate` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '开票日期（毫秒数）',
  `invoiceCode` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '发票代码',
  `invoiceNum` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '发票号码',
  `seq` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `bus` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 72 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '发票日志' ROW_FORMAT = Dynamic;

SET FOREIGN_KEY_CHECKS = 1;



--发票关联订单表
CREATE TABLE `tb_invoice_order`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `special_invoice_id` int(11) NOT NULL COMMENT '发票id',
  `order_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '订单号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 563 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '发票关联订单表' ROW_FORMAT = Dynamic;

SET FOREIGN_KEY_CHECKS = 1;


--发票订单临时表
CREATE TABLE `tb_invoice_order_temp`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `encrypt` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '加密串',
  `user_id` int(11) NULL DEFAULT NULL COMMENT '用户id',
  `order_no` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '订单字符串',
  `sum` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '总金额',
  `expiration_time` datetime(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 66 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '发票订单临时表' ROW_FORMAT = Dynamic;

SET FOREIGN_KEY_CHECKS = 1;