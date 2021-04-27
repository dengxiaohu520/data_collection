ALTER TABLE tb_user_extra ADD pay_use_count int(11) not Null DEFAULT 0 COMMENT '付费功能使用次数（针对vip客户，除去免费的6次外，其它的加总）';

-- 创建bom总表
CREATE TABLE IF NOT EXISTS `tb_user_bom` (
  `id` int(11) NOT NULL AUTO_INCREMENT comment 'BOM id',
  `uid` int(11) NOT NULL DEFAULT 0 COMMENT '用户id',
  `bom_name` varchar(256) not null DEFAULT '' COMMENT 'bom名称',
  `application_domain` varchar(256) DEFAULT '' COMMENT 'bom应用领域',
  `bom_total` int(11) DEFAULT 0 COMMENT '原始bom表中，器件的总数量',
  `copy_number` int(11) not null DEFAULT 0 COMMENT 'bom复制次数',
  `origin_bom` json NULL COMMENT '用户上传的原始bom内容',
  `head_json` json NULL COMMENT '原始bom head表头',
  `create_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- 创建bom临时表
CREATE TABLE IF NOT EXISTS `tb_bom_electron` (
  `temporary_id` int(11) NOT NULL AUTO_INCREMENT comment '单条数据临时 id',
  `bom_id` int(11) NOT NULL default 0 comment 'bom总表 id',
  `sequence` int(11) not null default 0 comment '序列号',
  `parameter` varchar(256) not null DEFAULT '' COMMENT '参数',
  `part_number` varchar(256) not null DEFAULT '' COMMENT '器件型号名称',
  `factory_name` varchar(256) not null DEFAULT '' COMMENT '厂牌名称',
  `electron_uuid` varchar(36) not null DEFAULT '' COMMENT '元器件uuid',
  `count` int(11) not null DEFAULT 1 COMMENT '元器件数量',
  `temporary_supplier` int(11)  COMMENT '供应商筛选： 1：全部， 2：原厂，3：代理商，4：贸易商',
  `refer_price` decimal(10, 2) UNSIGNED NULL DEFAULT 0.00 COMMENT '参考单价',
  `store_id` int(11) NOT NULL default 0 comment '商家id',
  `company_name` varchar(256) not null default '' comment '供应商名称',
  `contacts_name` varchar(128) not null default '' comment '联系人',
  `contacts_phone` varchar(128) not null default '' comment '手机号',
  `goods_storage` int(11) not null default 0 comment '库存',
  `goods_add_num` int(11) not null default 0 comment '增量',
  `goods_start_num` int(11) not null default 0 comment '起订量',
  `external_time` varchar(128) not null default '' comment "香港货期",
  `external_time_unit` int(11)  comment "香港货期单位（1、工作日 2、周）",
  `interior_time` varchar(128) not null default '' comment "内地货期",
  `interior_time_unit` int(11)  comment "内地货期单位（1、工作日 2、周）",
  `packing_id` int(11) comment "包装id",
  `interior_price` decimal(10, 2) UNSIGNED NULL DEFAULT 0.00 COMMENT '内地价格',
  `external_price` decimal(10, 2) UNSIGNED NULL DEFAULT 0.00 COMMENT '香港价格',
  `price_count` decimal(10, 2) UNSIGNED NULL DEFAULT 0.00 COMMENT '小计',
  `gradient` json NULL COMMENT '梯度价格',
  `bom_json` json NULL COMMENT '用户上传的单条bom内容',
  `store_type` varchar(88) comment "商家类型（1、制造商 2、代理商  3、现货商）",
  `status` int(11) not null DEFAULT 1 COMMENT '获取推荐型号状态，1：加载中，2：有完整的返回结果，3：只返回推荐型号，4：返回结果为空',
  `create_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`temporary_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



-- 创建bom推荐元器件表
CREATE TABLE IF NOT EXISTS `tb_bom_recommend_electron` (
  `id` int(11) NOT NULL AUTO_INCREMENT comment '单条数据临时 id',
  `temporary_id` int(11) NOT NULL default 0 comment '原bom数据的id',
  `bom_id` int(11) NOT NULL default 0 comment 'bom总表 id',
  `electron_uuid` varchar(36) not null DEFAULT '' COMMENT '元器件uuid',
  `part_number` varchar(256) not null DEFAULT '' COMMENT '器件型号名称',
  `factory_name` varchar(256) not null DEFAULT '' COMMENT '厂牌名称',
  `replace_supplier` int(11) COMMENT '供应商筛选： 1：全部， 2：原厂，3：代理商，4：贸易商',
  `refer_price` decimal(10, 2) UNSIGNED NULL DEFAULT 0.00 COMMENT '参考单价',
  `store_id` int(11) NOT NULL default 0 comment '商家id',
  `company_name` varchar(256) not null default '' comment '供应商名称',
  `contacts_name` varchar(128) not null default '' comment '联系人',
  `contacts_phone` varchar(128) not null default '' comment '手机号',
  `goods_storage` int(11) not null default 0 comment '库存',
  `goods_add_num` int(11) not null default 0 comment '增量',
  `goods_start_num` int(11) not null default 0 comment '起订量',
  `external_time` varchar(128) not null default '' comment "香港货期",
  `external_time_unit` int(11) comment "香港货期单位（1、工作日 2、周）",
  `interior_time` varchar(128) not null default '' comment "内地货期",
  `interior_time_unit` int(11) comment "内地货期单位（1、工作日 2、周）",
  `packing_id` int(11) comment "包装id",
  `interior_price` decimal(10, 2) UNSIGNED NULL DEFAULT 0.00 COMMENT '内地价格',
  `external_price` decimal(10, 2) UNSIGNED NULL DEFAULT 0.00 COMMENT '香港价格',
  `price_count` decimal(10, 2) UNSIGNED NULL DEFAULT 0.00 COMMENT '小计',
  `gradient` json NULL COMMENT '梯度价格',
  `store_type` varchar(88) comment "商家类型（1、制造商 2、代理商  3、现货商）",
  `status` int(11) not null DEFAULT 1 COMMENT '获取推荐型号状态，1：加载中，2：有完整的返回结果，3：只返回推荐型号，4：返回结果为空',
  `create_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- 创建VIP权限配置模块表
CREATE TABLE IF NOT EXISTS `tb_vip_limits` (
  `id` int(11) NOT NULL AUTO_INCREMENT comment '主键id',
  `name` varchar(88) NOT NULL default '' comment '权限领域模块',
  `code` varchar(88) NOT NULL default '' comment '权限所对应的代号编码',
  `n_vip` int(10) NOT NULL default 0 comment '非vip会员可查看次数',
  `vip` varchar(88) not null DEFAULT '' COMMENT 'vip会员可查看次数',
  `single_purchase` double(10, 2) not null DEFAULT 0 COMMENT '单次购买价格',
  `create_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- 创建vip类型表
CREATE TABLE IF NOT EXISTS `tb_vip_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT comment '主键id',
  `name` int(11) NOT NULL default '' comment '会员类别',
  `duration` varchar(88) NOT NULL default '' comment '会员时长（天、次）',
  `price` double(10, 2) not null DEFAULT '0.00' COMMENT '会员价格（元）',
  `create_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- 创建用户在infinigo搜索平台消费总金额表
CREATE TABLE IF NOT EXISTS `tb_pay_balace` (
  `id` int(11) NOT NULL AUTO_INCREMENT comment '主键id',
  `uid` int(11) NOT NULL default '' comment '用户id',
  `total_money` double(10, 4) not null DEFAULT '0.00' COMMENT '累积消费总金额（单位元）',
  `total_fee` int(11) NULL DEFAULT NULL COMMENT '累积消费总金额（单位分）',
  `state` tinyint(1) NOT NULL DEFAULT 0 COMMENT '状态 0：正常',
  `create_uid` varchar(16) NOT NULL DEFAULT '' comment '创建人id',
  `update_uid` varchar(16) NOT NULL DEFAULT '' comment '修改人id',
  `create_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- 创建用户支付记录表
CREATE TABLE IF NOT EXISTS `tb_pay_record`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `uid` int(11) NOT NULL COMMENT '用户id',
  `order_no` varchar(32)  NOT NULL COMMENT '订单号（规则见tapd 其明制定的规则）',
  `serial_number` varchar(48) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '原始订单号（支付流水号）',
  `money` double(10, 4) NULL DEFAULT NULL COMMENT '支付金额（单位元）',
  `fee` int(11) NULL DEFAULT NULL COMMENT '支付金额（单位分）',
  `unit` varchar(5) NULL DEFAULT 'CNY' COMMENT '金额币种，默认为CNY',
  `pay_method` tinyint(1) NULL DEFAULT NULL COMMENT '支付方式 1：微信，2：支付宝，3：银联，4：其他',
  `pay_status` tinyint(1) NULL DEFAULT NULL COMMENT '支付状态 0：成功，1：失败，3：待支付，4：失效',
  `pay_descr` varchar(200) NULL DEFAULT NULL COMMENT '支付结果描述',
  `post_body` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '请求信息',
  `back_body` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '返回信息',
  `expire_time` datetime(0) NULL DEFAULT NULL COMMENT '过期时间',
  `state` tinyint(1) NOT NULL DEFAULT 0 COMMENT '状态 0：正常',
  `create_at` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `update_at` timestamp(0) NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  `create_uid` varchar(16) NOT NULL DEFAULT '' comment '创建人id',
  `update_uid` varchar(16) NOT NULL DEFAULT '' comment '修改人id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB DEFAULT CHARSET=utf8mb4;


-- 创建用户订单表
CREATE TABLE `tb_order`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `uid` int(11) NOT NULL COMMENT '用户id',
  `order_no` varchar(32) NOT NULL COMMENT '订单号（规则见tapd 其明制定的规则）',
  `origin_money` double(10, 4) NULL DEFAULT NULL COMMENT '原金额',
  `money` double(10, 4) NULL DEFAULT NULL COMMENT '订单金额（单位元）',
  `fee` int(11) NULL DEFAULT NULL COMMENT '订单金额（单位分）',
  `unit` varchar(5)  DEFAULT 'CNY' COMMENT '金额币种，默认为CNY',
  `order_channel` tinyint(1) NULL DEFAULT NULL COMMENT '下单渠道 1PC 2手机 3手机端微信浏览器',
  `order_status` tinyint(1) NULL DEFAULT NULL COMMENT '订单状态 0：完成，1：未完成，2：已失效，3：已关闭，4：支付超时',
  `business_type` tinyint(1) NULL DEFAULT NULL COMMENT '业务类型 1.预留 2.商品购买 3.VIP开通 4.特权购买',
  `is_invoice` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否开发票 1：未开发票，2：已开发票',
  `description` varchar(100)  DEFAULT NULL COMMENT '订单描述',
  `details` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '商品详情',
  `product_id` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '购买的产品id',
  `expire_time` datetime(0) NULL DEFAULT NULL COMMENT '过期时间',
  `notify_url` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '订单回调地址',
  `trade_type` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '交易类型 \"NATIVE\",\"H5\",\"APP\"等',
  `client_ip` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '下单客户端ip',
  `state` tinyint(1) NOT NULL DEFAULT 0 COMMENT '状态 0：正常',
  `create_at` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `update_at` timestamp(0) NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  `create_uid` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '创建人id',
  `update_uid` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '修改人id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB DEFAULT CHARSET=utf8mb4;





-- 创建元器件商家表（IC交易网）
CREATE TABLE IF NOT EXISTS `tb_electron_merchant` (
  `id` int(11) NOT NULL AUTO_INCREMENT comment '自增 id',
  `electron_uuid` varchar(36) not null DEFAULT '' COMMENT '元器件uuid',
  `part_number` varchar(256) not null DEFAULT '' COMMENT '器件型号名称',
  `merchant_name` varchar(256) not null DEFAULT '' COMMENT '商家名称',
  `merchant_url` varchar(256) not null DEFAULT '' COMMENT '商家在IC交易网上的url',
  `phone` json NULL COMMENT '固定电话、联系人',
  `qq` json NULL COMMENT 'QQ',
  `member_rete` varchar(256) not null DEFAULT '' COMMENT '商家在ic交易网的评级',
  `paid_listing` varchar(256) not null DEFAULT '' COMMENT '现货排名（ic交易网）',
  `factory` varchar(256) not null DEFAULT '' COMMENT '厂牌',
  `batch_number` varchar(256) not null DEFAULT '' COMMENT '元器件批号',
  `repertory` int(11) not null DEFAULT 0 COMMENT '元器件库存',
  `pakaging` varchar(256) not null DEFAULT '' COMMENT '元器件封装',
  `explain` varchar(256) not null DEFAULT '' COMMENT '说明',
  `storage_location` varchar(256) not null DEFAULT '' COMMENT '库位',
  `mobile` varchar(256) not null DEFAULT '' COMMENT '手机号',
  `faxes` varchar(256) not null DEFAULT '' COMMENT '传真',
  `business_address` varchar(256) not null DEFAULT '' COMMENT '办公地址',
  `address` varchar(256) not null DEFAULT '' COMMENT '地址',
  `create_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;




# 增加元器件商家表字段
ALTER TABLE db_business_electron.tb_electron_merchant
ADD  goods_add_num  int(11) NULL DEFAULT 0 COMMENT '增量',
ADD  goods_start_num  int(11) NULL DEFAULT 0 COMMENT '起订量',
ADD  external_time  varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '香港货期',
ADD  external_time_unit  int(11) NULL DEFAULT NULL COMMENT '香港货期单位（1、工作日 2、周）',
ADD  interior_time  varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '内地货期',
ADD  interior_time_unit  int(11) NULL DEFAULT NULL COMMENT '内地货期单位（1、工作日 2、周）',
ADD  packing_id  int(11) NULL DEFAULT NULL COMMENT '包装id',
ADD  interior_price  decimal(10, 2) UNSIGNED NULL DEFAULT 0.00 COMMENT '内地价格',
ADD  external_price  decimal(10, 2) UNSIGNED NULL DEFAULT 0.00 COMMENT '香港价格',
ADD  store_type  varchar(88) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '3' COMMENT '商家类型（1、制造商 2、代理商  3、现货商）',
ADD  gradient  varchar(88) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '梯度价格',
ADD  store_id  varchar(36) NULL DEFAULT NULL COMMENT '商家uuid(区分商城端商家id)'



# 增加BOM元器件推荐表字段
ALTER TABLE db_user.tb_bom_recommend_electron
ADD  factory_recommend  int(11) NULL DEFAULT 0 COMMENT '是否原厂推荐(0: 不是， 1.是)',
ADD  pintopin  int(11) NULL DEFAULT 0 COMMENT '是否pintopin替代(0: 不是， 1.是)',
ADD  innovate  int(11) NULL DEFAULT 0 COMMENT '是否创新替代(0: 不是， 1.是)'



# 增加原始bom表字段
ALTER TABLE db_user.tb_bom_electron
ADD  model_name  varchar(128) NULL DEFAULT '' COMMENT '型号名称(不用于页面展示，只用于查询更多替代型号)'


ALTER TABLE db_user.tb_bom_electron
ADD  goods_show_price  decimal(10, 2) NULL DEFAULT 0.00 COMMENT '商城端展示价格';
ALTER TABLE db_user.tb_bom_recommend_electron
ADD  goods_show_price  decimal(10, 2) NULL DEFAULT 0.00 COMMENT '商城端展示价格';


ALTER TABLE db_user.tb_bom_electron
ADD  origin_factory  varchar(128) NULL DEFAULT '' COMMENT '推荐厂牌';





-- 今日大瓜目标网站分类
CREATE TABLE IF NOT EXISTS `tb_portal_category_origin` (
  `id` int(11) NOT NULL AUTO_INCREMENT comment '主键 id',
  `origin_site_category` varchar(256) NOT NULL default '' comment '原网站分类名',
  `origin_category_url` varchar(528) not null DEFAULT '' COMMENT '原网站分类url',
  `origin_site` varchar(256) NOT NULL default'' comment '网站名称',
  `site_url` varchar(256) not null DEFAULT '' COMMENT '网站url地址',
  `create_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



