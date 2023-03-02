BOM优化新表.sql

-- 创建bom总表
CREATE TABLE `tb_user_bom`  (
  `id` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'BOM id',
  `uid` int(11) NOT NULL DEFAULT 0 COMMENT '用户id',
  `bom_name` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT 'bom名称',
  `application_domain` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT 'bom应用领域',
  `bom_total` int(11) NULL DEFAULT 0 COMMENT '原始bom表中，器件的总数量',
  `copy_number` int(11) NOT NULL DEFAULT 0 COMMENT 'bom复制次数',
  `origin_bom` json NULL COMMENT '用户上传的原始bom内容',
  `bom_fileurl` json NULL COMMENT '用户上传的bom保存路径',
  `newly_add_offer` int(11) NOT NULL DEFAULT 0 COMMENT '未查看报价次数',
  `offer` int(11) NOT NULL DEFAULT 0 COMMENT '供应商报价次数',
  `create_at` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `update_at` timestamp(0) NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `idx_id`(`id`) USING BTREE COMMENT '按id查找',
  INDEX `bom_name_index`(`bom_name`) USING BTREE COMMENT '按表名查找',
  INDEX `create_at_index`(`create_at`) USING BTREE COMMENT '按创建时间',
  INDEX `idx_bom`(`id`, `bom_name`, `bom_total`, `create_at`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = 'bom总表' ROW_FORMAT = Dynamic;


-- 创建bom临时表
CREATE TABLE `tb_bom_electron`  (
  `temporary_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '单条数据临时 id',
  `bom_id` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT 'bom总表 id',
  `sequence` int(11) NULL DEFAULT 0 COMMENT '序列号',
  `parameter` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '参数',
  `part_number` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '器件型号名称',
  `factory_name` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '厂牌名称',
  `electron_uuid` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '元器件uuid',
  `count` int(11) NULL DEFAULT 1 COMMENT '元器件数量',
  `temporary_supplier` int(11) NULL DEFAULT NULL COMMENT '供应商筛选： 1：全部， 2：原厂，3：代理商，4：贸易商',
  `store_id` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商家id',
  `company_name` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '供应商名称',
  `contacts_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '联系人',
  `contacts_phone` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '手机号',
  `goods_storage` int(11) NULL DEFAULT 0 COMMENT '平台库存',
  `goods_add_num` int(11) NULL DEFAULT 0 COMMENT '增量',
  `goods_start_num` int(11) NULL DEFAULT 0 COMMENT '起订量',
  `interior_time` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '内地货期',
  `packing_id` int(11) NULL DEFAULT NULL COMMENT '包装id',
  `gradient` varchar(3000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '梯度价格',
  `store_type` varchar(88) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商家类型（1、制造商 2、代理商  3、现货商）',
  `status` int(11) NULL DEFAULT 1 COMMENT '获取推荐型号状态，1：加载中，2：有完整的返回结果，3：只返回推荐型号，4：返回结果为空',
  `platform_price` decimal(10, 2) UNSIGNED NULL DEFAULT 0.00 COMMENT '平台售价',
  `source` tinyint(4) NULL DEFAULT NULL COMMENT '商家来源：1.搜索引擎，2.商城',
  `price` decimal(10, 2) UNSIGNED NULL DEFAULT 0.00 COMMENT '供应商价格(供应商报价)',
  `storage` int(11) NULL DEFAULT 0 COMMENT '供应商库存(供应商报价)',
  `delivery_time` int(11) NULL DEFAULT 0 COMMENT '供应商货期(工作日)(供应商报价)',
  `offer_period` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '供应商报价有效期',
  `offer_type` tinyint(4) NOT NULL DEFAULT 1 COMMENT '商家报价状态：1：未报价，2：等待报价， 3：报价成功 ',
  `bom_json` json NULL COMMENT '用户上传的原始单条bom内容',
  `model_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '型号名称(不用于页面展示，只用于查询更多替代型号)',
  `origin_factory` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '推荐厂牌',
  `refer_price` decimal(10, 2) UNSIGNED NULL DEFAULT 0.00 COMMENT '参考单价',
  `goods_show_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '商城端展示价格',
  `interior_price` decimal(10, 2) UNSIGNED NULL DEFAULT 0.00 COMMENT '内地价格',
  `price_count` decimal(10, 2) UNSIGNED NULL DEFAULT 0.00 COMMENT '小计',
  `external_price` decimal(10, 2) UNSIGNED NULL DEFAULT 0.00 COMMENT '香港价格',
  `external_time` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '香港货期',
  `external_time_unit` int(11) NULL DEFAULT NULL COMMENT '香港货期单位（1、工作日 2、周）',
  `interior_time_unit` int(11) NULL DEFAULT NULL COMMENT '内地货期单位（1、工作日 2、周）',
  `create_at` timestamp(0) NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `update_at` timestamp(0) NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  PRIMARY KEY (`temporary_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;


-- 创建bom推荐元器件表
CREATE TABLE `tb_bom_recommend_electron`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '单条数据临时 id',
  `temporary_id` int(11) NOT NULL DEFAULT 0 COMMENT '原bom数据的id',
  `bom_id` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT 'bom总表 id',
  `electron_uuid` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '元器件uuid',
  `part_number` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '器件型号名称',
  `replace_supplier` int(11) NULL DEFAULT NULL COMMENT '供应商筛选： 1：全部， 2：原厂，3：代理商，4：贸易商',
  `refer_price` decimal(10, 2) UNSIGNED NULL DEFAULT 0.00 COMMENT '参考单价',
  `company_name` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '供应商名称',
  `contacts_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '联系人',
  `contacts_phone` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '手机号',
  `goods_storage` int(11) NULL DEFAULT 0 COMMENT '库存',
  `goods_add_num` int(11) NULL DEFAULT 0 COMMENT '增量',
  `goods_start_num` int(11) NULL DEFAULT 0 COMMENT '起订量',
  `platform_price` decimal(10, 2) UNSIGNED NULL DEFAULT 0.00 COMMENT '平台售价',
  `source` tinyint(4) NULL DEFAULT NULL COMMENT '商家来源：1.搜索引擎，2.商城',
  `price` decimal(10, 2) UNSIGNED NULL DEFAULT 0.00 COMMENT '供应商价格(供应商报价)',
  `storage` int(11) NULL DEFAULT 0 COMMENT '供应商库存(供应商报价)',
  `delivery_time` int(11) NULL DEFAULT 0 COMMENT '供应商货期(工作日)(供应商报价)',
  `offer_period` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '供应商报价有效期',
  `offer_type` tinyint(4) NOT NULL DEFAULT 1 COMMENT '商家报价状态：1：未报价，2：等待报价， 3：报价成功 ',
  `external_time` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '香港货期',
  `external_time_unit` int(11) NULL DEFAULT NULL COMMENT '香港货期单位（1、工作日 2、周）',
  `interior_time` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '内地货期',
  `interior_time_unit` int(11) NULL DEFAULT NULL COMMENT '内地货期单位（1、工作日 2、周）',
  `packing_id` int(11) NULL DEFAULT NULL COMMENT '包装id',
  `interior_price` decimal(10, 2) UNSIGNED NULL DEFAULT 0.00 COMMENT '内地价格',
  `external_price` decimal(10, 2) UNSIGNED NULL DEFAULT 0.00 COMMENT '香港价格',
  `price_count` decimal(10, 2) UNSIGNED NULL DEFAULT 0.00 COMMENT '小计',
  `store_type` varchar(88) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商家类型（1、制造商 2、代理商  3、现货商）',
  `gradient` varchar(3000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '梯度价格',
  `status` int(11) NULL DEFAULT 1 COMMENT '获取推荐型号状态，1：加载中，2：有完整的返回结果，3：只返回推荐型号，4：返回结果为空',
  `create_at` timestamp(0) NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `update_at` timestamp(0) NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  `factory_name` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '厂牌名称',
  `store_id` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商家id',
  `factory_recommend` int(11) NULL DEFAULT 0 COMMENT '是否原厂推荐(0: 不是， 1.是)',
  `pintopin` int(11) NULL DEFAULT 0 COMMENT '是否pintopin替代(0: 不是， 1.是)',
  `innovate` int(11) NULL DEFAULT 0 COMMENT '是否创新替代(0: 不是， 1.是)',
  `goods_show_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '商城端展示价格',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;



 # tb_bom_electron增加字段(20210616)
  `platform_price` decimal(10, 2) UNSIGNED NULL DEFAULT 0.00 COMMENT '平台售价',
  `source` tinyint(4) NULL DEFAULT NULL COMMENT '商家来源：1.搜索引擎，2.商城',
  `price` decimal(10, 2) UNSIGNED NULL DEFAULT 0.00 COMMENT '供应商价格(供应商报价)',
  `storage` int(11) NULL DEFAULT 0 COMMENT '供应商库存(供应商报价)',
  `delivery_time` int(11) NULL DEFAULT 0 COMMENT '供应商货期(工作日)(供应商报价)',
  `offer_period` timestamp(0) NOT NULL COMMENT '供应商报价有效期',
  `offer_type` tinyint(4) NOT NULL DEFAULT 1 COMMENT '商家报价状态：1：未报价，2：等待报价， 3：报价成功 ',
  `goods_id` int(11) NULL COMMENT '元器件在商城的id',






-- 用户询价表
CREATE TABLE `tb_user_bom_enquiry`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键 id',
  `enquiry_uid` int(11) NOT NULL DEFAULT 0 COMMENT '询价者uid',
  `recommend_id` int(11) NOT NULL DEFAULT 0 COMMENT '推荐数据 id',
  `temporary_id` int(11) NOT NULL DEFAULT 0 COMMENT '原bom数据的id',
  `bom_id` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT 'bom总表 id',
  `store_id` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `bom_name` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT 'bom名称',
  `enquiry_company_name` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '询价者公司名称',
  `enquiry_contacts_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '询价者姓名',
  `enquiry_contacts_phone` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '询价者手机号',
  `part_number` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '需求型号名称',
  `factory_name` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '厂牌',
  `count` int(11) NOT NULL DEFAULT 0 COMMENT '需求数量',
  `create_at` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `update_at` timestamp(0) NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 43 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户询价表(BOM模块)' ROW_FORMAT = Dynamic;


-- 供应商报价表
CREATE TABLE `tb_user_bom_offer`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键 id',
  `enquiry_id` int(11) NOT NULL DEFAULT 0 COMMENT '询价id',
  `offer_uid` int(11) NOT NULL DEFAULT 0 COMMENT '报价者uid',
  `store_id` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '商家id',
  `company_name` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '商家公司名称',
  `contacts_name` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '商家联系人',
  `contacts_phone` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '商家手机号',
  `price` decimal(10, 2) UNSIGNED NULL DEFAULT 0.00 COMMENT '供应商价格',
  `delivery_time` int(11) NULL DEFAULT 0 COMMENT '供应商货期(工作日)',
  `goods_storage` int(11) NULL DEFAULT 0 COMMENT '供应商库存',
  `is_offer` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否报价 1.未报价， 2.已报价',
  `offer_period` timestamp(0) NOT NULL COMMENT '供应商报价有效期',
  `create_at` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `update_at` timestamp(0) NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 43 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '供应商报价表(BOM模块)' ROW_FORMAT = Dynamic;









-- 用户询价表
CREATE TABLE `tb_user_bom_enquiry`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键 id',
  `enquiry_uid` int(11) NOT NULL DEFAULT 0 COMMENT '询价者uid',
  `recommend_id` int(11) NOT NULL DEFAULT 0 COMMENT '推荐数据 id',
  `temporary_id` int(11) NOT NULL DEFAULT 0 COMMENT '原bom数据的id',
  `bom_id` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT 'bom总表 id',
  `bom_name` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT 'bom名称',
  `enquiry_company_name` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '询价者公司名称',
  `enquiry_contacts_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '询价者姓名',
  `enquiry_contacts_phone` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '询价者手机号',
  `part_number` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '需求型号名称',
  `factory_name` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '厂牌',
  `count` int(11) NOT NULL DEFAULT 0 COMMENT '需求数量',
  `create_at` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `update_at` timestamp(0) NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 43 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户询价表(BOM模块)' ROW_FORMAT = Dynamic;


-- 供应商报价表
CREATE TABLE `tb_user_bom_offer`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键 id',
  `store_id` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '商家id',
  `company_name` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '商家公司名称',
  `contacts_name` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '商家联系人',
  `contacts_phone` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '商家手机号',
  `price` decimal(10, 2) UNSIGNED NULL DEFAULT 0.00 COMMENT '供应商价格',
  `delivery_time` int(11) NULL DEFAULT 0 COMMENT '供应商货期(工作日)',
  `goods_storage` int(11) NULL DEFAULT 0 COMMENT '供应商库存',
  `offer_period` timestamp(0) NOT NULL COMMENT '供应商报价有效期',
  `create_at` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `update_at` timestamp(0) NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 43 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '供应商报价表(BOM模块)' ROW_FORMAT = Dynamic;





--用户、商家中间表(bom)
CREATE TABLE `tb_user_merchant`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键 id',
  `enquiry_id` int(11) NOT NULL DEFAULT 0 COMMENT '询价id',
  `offer_id` int(11) NOT NULL DEFAULT 0 COMMENT '报价id',
  `enquiry_type` tinyint(1) NOT NULL DEFAULT 1 COMMENT '询价状态 1.未询价， 2.等待报价，3.已报价',
  `is_offer` tinyint(1) NOT NULL DEFAULT 1 COMMENT '商家报价状态 1.未报价， 2.已报价',
  `is_type` tinyint(1) NOT NULL DEFAULT 1 COMMENT '选中状态（是否展示在匹配结果页） 1.未选中， 2.已选中',
  `create_at` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `update_at` timestamp(0) NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 43 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户、商家报价关系中间表(bom)' ROW_FORMAT = Dynamic;




CREATE TABLE `dhs_sms` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL COMMENT '名称',
  `abbreviation` varchar(255) DEFAULT NULL,
  `type` int(2) DEFAULT NULL COMMENT '参数类型值',
  `template` varchar(255) DEFAULT NULL COMMENT '模板',
  `template_id` varchar(50) DEFAULT NULL COMMENT '模板id',
  `reception` varchar(255) DEFAULT NULL COMMENT '电话  用英文逗号隔开',
  `branches` int(11) DEFAULT '0' COMMENT '条数',
  `create_time` datetime DEFAULT NULL,
  `status` int(1) DEFAULT '1' COMMENT '状态 1:启用  0:关闭',
  `update` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8 COMMENT='短信配置表\r\n下单  place an order\r\n发货  shipments\r\n客户 client\r\n平台  infinigo\r\n获客宝  huokebao\r\n购买 buy';



CREATE TABLE `tb_user_sms_config` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL COMMENT '短信应用名称',
  `abbreviation` varchar(255) DEFAULT NULL COMMENT "应用简称",
  `type` int(2) DEFAULT NULL COMMENT '参数类型值',
  `template` varchar(255) DEFAULT NULL COMMENT '模板',
  `template_id` varchar(50) DEFAULT NULL COMMENT '模板id',
  `reception` varchar(255) DEFAULT NULL COMMENT '电话  用英文逗号隔开',
  `branches` int(11) DEFAULT '0' COMMENT '条数',
  `create_time` datetime DEFAULT NULL,
  `status` int(1) DEFAULT '1' COMMENT '状态 1:启用  0:关闭',
  `update` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8 COMMENT='短信配置表\r\n下单  place an order\r\n发货  shipments\r\n客户 client\r\n平台  infinigo\r\n获客宝  huokebao\r\n购买 VIP';