平台发票优化.sql
-- 发票记录表
CREATE TABLE `tb_invoice_record`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` int(11) NOT NULL COMMENT '用户ID',
  `invoice_status` int(2) NULL DEFAULT 0 COMMENT '发票状态 1:待审核  2:待开票  3:审核不通过  4:已开票  5:已红冲  6:已开票',
  `money` decimal(18, 2) NULL DEFAULT NULL COMMENT '金额',
  `make_time` datetime(0) NULL DEFAULT NULL COMMENT '开票时间',
  `express` varchar(255)  NULL DEFAULT '' COMMENT '快递',
  `express_no` varchar(255) NULL DEFAULT '' COMMENT '快递单号',
  `remark` varchar(255) NULL DEFAULT '' COMMENT '发票备注',
  `back_body` text NULL COMMENT '返回体',
  `post_body` text  NULL COMMENT '请求体',
  `pdfUrl` varchar(255)  NULL DEFAULT NULL COMMENT '发票pdf地址',
  `serialNo` varchar(255) NULL DEFAULT NULL COMMENT '流水号',
  `invoice_no` varchar(50)  NULL DEFAULT NULL COMMENT '发票号(易票云)',
  `order_list` json  NULL COMMENT '订单列表(当前发票所包含的发票列表)',
  `cause` varchar(255) NULL DEFAULT '' COMMENT '审核不通过的原因',
  `is_status` tinyint(4) NULL DEFAULT 1 COMMENT '状态   1:正常   2:作废',
  `create_at` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `update_at` timestamp(0) NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '发票记录表' ROW_FORMAT = Dynamic;

-- 发票对应订单表
CREATE TABLE `tb_invoice_order`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` int(11) NOT NULL COMMENT '用户ID',
  `invoice_id` int(2) NULL DEFAULT 0 COMMENT '发票id',
  `order_no` varchar(255)  NULL DEFAULT '' COMMENT '订单编号',
  `product_name` varchar(528)  NULL DEFAULT '' COMMENT '产品名称(多个元器件 中间使用空格隔开)',
  `money` decimal(10, 2) NULL DEFAULT NULL COMMENT '实付金额',
  `tax_rate` decimal(10, 2) NULL DEFAULT NULL COMMENT '税率',
  `pay_type` datetime(0) NULL DEFAULT NULL COMMENT '支付方式 1:微信支付  2:支付宝支付  3:对公转账 4:银联支付  5:其它',
  `pay_subject` varchar(528)  NULL DEFAULT '' COMMENT '付款主体',
  `pay_at` timestamp(0) NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '付款时间',
  `is_status` tinyint(4) NULL DEFAULT 1 COMMENT '状态   1:正常   2:作废',
  `create_at` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `update_at` timestamp(0) NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '发票对应订单表' ROW_FORMAT = Dynamic;


-- 退票记录表
CREATE TABLE `tb_invoice_refund_record`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` int(11) NOT NULL COMMENT '用户ID',
  `invoice_id` int(11) NOT NULL COMMENT '发票 ID',
  `refund_type` tinyint(4) NULL DEFAULT 0 COMMENT '退票类型 1:发票信息错误  2:订单退款',
  `is_authentication` tinyint(4) NULL DEFAULT 0 COMMENT '发票认证状态 1:未认证  2:已认证',
  `cause` varchar(255) CHARACTER NULL DEFAULT '' COMMENT '退票原因',
  `express` varchar(255) CHARACTER NULL DEFAULT '' COMMENT '寄回快递',
  `express_no` varchar(255) CHARACTER NULL DEFAULT '' COMMENT '寄回快递单号',
  `audit_data` timestamp(0) NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '退票审核时间',
  `audit_type` tinyint(4) NULL DEFAULT 0 COMMENT '审核状态 1:待审核  2:审核通过  3:审核不通过  4:退票中  5:退票完成',
  `proof` tinyint(4) NULL DEFAULT 0 COMMENT '是否寄回凭证 1:已收到原发票  2:已收到红字信息表',
  `is_status` tinyint(4) NULL DEFAULT 1 COMMENT '状态   1:正常   2:作废',
  `create_at` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `update_at` timestamp(0) NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '发票记录表' ROW_FORMAT = Dynamic;   


-- 负数发票寄回信息表
CREATE TABLE `tb_invoice_negative_express`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` int(11) NOT NULL COMMENT '用户ID',
  `invoice_id` int(11) NOT NULL COMMENT '发票 ID',
  `express` varchar(255) CHARACTER NULL DEFAULT '' COMMENT '寄回快递',
  `express_no` varchar(255) CHARACTER NULL DEFAULT '' COMMENT '寄回快递单号',
  `is_status` tinyint(4) NULL DEFAULT 1 COMMENT '状态   1:正常   2:作废',
  `create_at` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `update_at` timestamp(0) NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '发票记录表' ROW_FORMAT = Dynamic;   


-- 用户开发票信息表
CREATE TABLE `tb_invoice_info`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '用户发票信息自增id',
  `uid` int(11) NOT NULL DEFAULT 0 COMMENT '用户id',
  `invoice_type` tinyint(4) NULL DEFAULT 2 COMMENT '发票类型  1:增值税纸质专用发票    2:增值税电子普通发票',
  `title_type` tinyint(4) NULL DEFAULT 0 COMMENT '发票抬头类型   1:企业   2:个人',
  `invoice_title` varchar(256) NOT NULL DEFAULT '' COMMENT '发票抬头',
  `tin` varchar(256) NOT NULL DEFAULT '' COMMENT '纳税人识别号',
  `company_bank` varchar(256) NOT NULL DEFAULT '' COMMENT '公司开户行',
  `bank_account_number` varchar(88) NOT NULL DEFAULT '' COMMENT '开户行账号',
  `company_address` varchar(256) NOT NULL DEFAULT '' COMMENT '公司注册地址',
  `company_phone` varchar(88) NOT NULL DEFAULT '' COMMENT '公司注册电话',
  `business_license` varchar(256) NOT NULL DEFAULT '' COMMENT '营业执照',
  `certificate` varchar(256) NOT NULL DEFAULT '' COMMENT '一般纳税人认定书',
  `account_opening_permit` varchar(256) NOT NULL DEFAULT '' COMMENT '开户许可证',
  `proposer` varchar(256) NOT NULL DEFAULT '' COMMENT '申请人(发票抬头为个人的时候)',
  `contact_way` varchar(256) NOT NULL DEFAULT '' COMMENT '联系方式(发票抬头为个人的时候)',
  `is_default` tinyint(4) NULL DEFAULT 1 COMMENT '是否为默认   1:不是默认   2:默认',
  `is_status` tinyint(4) NULL DEFAULT 1 COMMENT '状态   1:正常   2:作废',
  `create_at` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `update_at` timestamp(0) NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户开发票信息表' ROW_FORMAT = Dynamic;


-- 用户接收发票地址表
CREATE TABLE `tb_invoice_address`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '用户接收发票地址自增id',
  `uid` int(11) NOT NULL DEFAULT 0 COMMENT '用户id',
  `province` varchar(88) NOT NULL DEFAULT '' COMMENT '地区：省',
  `city` varchar(88) NOT NULL DEFAULT '' COMMENT '地区：市',
  `district` varchar(88) NOT NULL DEFAULT '' COMMENT '地区：区、县',
  `detailed_address` varchar(256) NOT NULL DEFAULT '' COMMENT '详细地址',
  `is_default` tinyint(4) NULL DEFAULT 1 COMMENT '是否为默认   1:不是默认   2:默认',
  `is_status` tinyint(4) NULL DEFAULT 1 COMMENT '状态   1:正常   2:作废',
  `create_at` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `update_at` timestamp(0) NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户接收发票地址表' ROW_FORMAT = Dynamic;


-- 用户接收发票邮箱表
CREATE TABLE `tb_invoice_email`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '用户接收发票地址自增id',
  `uid` int(11) NOT NULL DEFAULT 0 COMMENT '用户id',
  `email` varchar(256) NOT NULL DEFAULT '' COMMENT '邮箱',
  `is_default` tinyint(4) NULL DEFAULT 1 COMMENT '是否为默认   1:不是默认   2:默认',
  `is_status` tinyint(4) NULL DEFAULT 1 COMMENT '状态   1:正常   2:作废',
  `create_at` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `update_at` timestamp(0) NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户接收发票邮箱表' ROW_FORMAT = Dynamic;


-- 发票备注表
CREATE TABLE `tb_invoice_remark`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '发票备注表id',
  `invoice_id` int(11) NOT NULL DEFAULT 0 COMMENT '备注发票id',
  `content` varchar(256) NOT NULL DEFAULT '' COMMENT '备注内容',
  `is_status` tinyint(4) NULL DEFAULT 1 COMMENT '状态   1:正常   2:作废',
  `create_at` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `update_at` timestamp(0) NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '发票备注表(admin后台)' ROW_FORMAT = Dynamic;


-- 发票操作记录表
CREATE TABLE `tb_invoice_log`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '发票操作记录id',
  `invoice_id` int(11) NOT NULL DEFAULT 0 COMMENT '操作发票id',
  `content` varchar(256) NOT NULL DEFAULT '' COMMENT '操作内容',
  `is_status` tinyint(4) NULL DEFAULT 1 COMMENT '状态   1:正常   2:作废',
  `create_at` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `update_at` timestamp(0) NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '发票操作记录表' ROW_FORMAT = Dynamic;

-- 发票配置表
CREATE TABLE `tb_invoice_config`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '发票配置id',
  `order_type` varchar(256) NOT NULL DEFAULT '' COMMENT '订单类型',
  `invoice_comtent` varchar(256) NOT NULL DEFAULT '' COMMENT '发票内容',
  `tax_rate` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '税率',
  `is_status` tinyint(4) NULL DEFAULT 1 COMMENT '状态   1:正常   2:作废',
  `create_at` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `update_at` timestamp(0) NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '发票内容、税率配置表' ROW_FORMAT = Dynamic;


--发票寄回地址配置表
CREATE TABLE `tb_invoice_send_back_address_config`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '发票地址配置id',
  `recipients` varchar(88) NOT NULL DEFAULT '' COMMENT '收件人',
  `contact_way` varchar(88) NOT NULL DEFAULT '' COMMENT '联系方式',
  `address` varchar(88) NOT NULL DEFAULT '' COMMENT '邮寄地址',
  `is_status` tinyint(4) NULL DEFAULT 1 COMMENT '状态   1:正常   2:作废',
  `create_at` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `update_at` timestamp(0) NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '发票寄回地址配置表(退票)' ROW_FORMAT = Dynamic;



--在vip订单表、元器件订单便、获客保订单表、FAE订单表上加上付款主体字段