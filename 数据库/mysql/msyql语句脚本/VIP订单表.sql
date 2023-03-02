VIP订单表.sql

-- 用户累计充值金额
CREATE TABLE `tb_pay_balance` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `uid` int(11) NOT NULL COMMENT '用户id',
  `total_money` double(10,4) DEFAULT NULL COMMENT '累积充值总金额（单位元）',
  `total_fee` int(11) DEFAULT NULL COMMENT '累积充值总金额（单位分）',
  `state` tinyint(1) NOT NULL DEFAULT '0' COMMENT '状态 0：正常',
  `create_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `create_uid` varchar(16) NOT NULL DEFAULT '',
  `update_uid` varchar(16) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_uid` (`uid`),
  KEY `idx_uid` (`uid`)
) ENGINE=InnoDB AUTO_INCREMENT=298 DEFAULT CHARSET=utf8mb4;


-- 用户支付记录
CREATE TABLE `tb_pay_record` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `uid` int(11) NOT NULL COMMENT '用户id',
  `order_no` varchar(32) NOT NULL COMMENT '订单号（规则见tapd 其明制定的规则）',
  `serial_number` varchar(48) DEFAULT NULL COMMENT '原始订单号（支付流水号）',
  `money` double(10,4) DEFAULT NULL COMMENT '支付金额（单位元）',
  `fee` int(11) DEFAULT NULL COMMENT '支付金额（单位分）',
  `unit` varchar(5) DEFAULT 'CNY' COMMENT '金额币种，默认为CNY',
  `pay_method` tinyint(1) DEFAULT NULL COMMENT '支付方式 1：微信，2：支付宝，3：银联，4：其他',
  `pay_status` tinyint(1) DEFAULT NULL COMMENT '支付状态 0：成功，1：失败，3：待支付，4：失效',
  `pay_descr` varchar(200) DEFAULT NULL COMMENT '支付结果描述',
  `post_body` text COMMENT '请求信息',
  `back_body` text COMMENT '返回信息',
  `expire_time` datetime DEFAULT NULL COMMENT '过期时间',
  `state` tinyint(1) NOT NULL DEFAULT '0' COMMENT '状态 0：正常',
  `create_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `create_uid` varchar(16) NOT NULL DEFAULT '' COMMENT '创建人id',
  `update_uid` varchar(16) NOT NULL DEFAULT '' COMMENT '修改人id',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_serial_number` (`serial_number`),
  KEY `idx_uid` (`uid`),
  KEY `idx_order_no` (`order_no`),
  KEY `idx_serial_number` (`serial_number`),
  KEY `idx_pay_method` (`pay_method`),
  KEY `idx_pay_status` (`pay_status`)
) ENGINE=InnoDB AUTO_INCREMENT=933 DEFAULT CHARSET=utf8mb4;


-- 订单表
CREATE TABLE `tb_order` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `uid` int(11) NOT NULL COMMENT '用户id',
  `order_no` varchar(32) NOT NULL COMMENT '订单号（规则见tapd 其明制定的规则）',
  `serial_number` varchar(48) DEFAULT NULL COMMENT '原始订单号（支付流水号）',
  `origin_money` double(10,4) DEFAULT NULL COMMENT '原金额',
  `money` double(10,4) DEFAULT NULL COMMENT '订单金额（单位元）',
  `fee` int(11) DEFAULT NULL COMMENT '订单金额（单位分）',
  `unit` varchar(5) DEFAULT 'CNY' COMMENT '金额币种，默认为CNY',
  `order_channel` tinyint(1) DEFAULT NULL COMMENT '下单渠道 1PC 2手机 3手机端微信浏览器',
  `pay_method` tinyint(1) DEFAULT NULL COMMENT '支付方式 1：微信，2：支付宝，3：银联，4：其他',
  `order_status` tinyint(1) DEFAULT NULL COMMENT '订单状态 0：完成，1：未完成，2：已失效，3：已关闭，4：支付超时',
  `business_type` tinyint(1) DEFAULT NULL COMMENT '业务类型 1.预留 2.商品购买 3.VIP开通 4.特权购买 5.FAE咨询',
  `is_invoice` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否开发票 1：未开发票，2：已开发票   3:申请中',
  `description` varchar(100) DEFAULT NULL COMMENT '订单描述',
  `details` text COMMENT '商品详情',
  `product_id` varchar(16) DEFAULT NULL COMMENT '购买的产品id',
  `expire_time` datetime DEFAULT NULL COMMENT '过期时间',
  `notify_url` text COMMENT '订单回调地址',
  `trade_type` varchar(10) DEFAULT NULL COMMENT '交易类型 "NATIVE","H5","APP"等',
  `client_ip` varchar(16) DEFAULT NULL COMMENT '下单客户端ip',
  `state` tinyint(1) NOT NULL DEFAULT '0' COMMENT '状态 0：正常',
  `create_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时`),
间',
  `update_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `create_uid` varchar(16) NOT NULL DEFAULT '' COMMENT '创建人id',
  `update_uid` varchar(16) NOT NULL DEFAULT '' COMMENT '修改人id',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_order_no` (`order_no`),
  KEY `idx_uid` (`uid  KEY `idx_order_no` (`order_no`),
  KEY `idx_product_id` (`product_id`),
  KEY `idx_order_status` (`order_status`)
) ENGINE=InnoDB AUTO_INCREMENT=586 DEFAULT CHARSET=utf8mb4;



-- 订单表增加字段
alter table db_user.tb_order add (
  `pay_method` tinyint(1) DEFAULT NULL COMMENT '支付方式 1：微信，2：支付宝，3：银联，4：其他',
  `serial_number` varchar(48) DEFAULT NULL COMMENT '支付流水号',
  `back_body` text COMMENT '返回信息'
);


--修复数据
UPDATE tb_order t1 JOIN tb_pay_record t2 
ON t1.order_no = t2.order_no
SET t1.pay_method=t2.pay_method,t1.serial_number=t2.serial_number,t1.back_body=t2.back_body;