成品数据库.sql

--成品表
CREATE TABLE `tb_product`  (
  `id` varchar(36) NOT NULL COMMENT '成品 id',
  `product_name` varchar(255)  NULL DEFAULT '' COMMENT '成品名称',
  `category_id` varchar(9) NOT NULL DEFAULT '0' COMMENT '分类id',
  `icons` json NULL COMMENT '图片',
  `parameter` json NULL COMMENT '参数',
  `description` text NULL COMMENT '描述',
  `view_count` int(11) NOT NULL DEFAULT 0 COMMENT '查看次数',
  `buy_count` int(11) NOT NULL DEFAULT 0 COMMENT '购买次数',
  `hot_cake` tinyint(4) NULL DEFAULT 1 COMMENT '是否为爆款抢购   1:是   2:不是',
  `new_product` tinyint(4) NULL DEFAULT 1 COMMENT '是否为芯品上架   1:是   2:不是',
  `is_recommend` tinyint(4) NULL DEFAULT 1 COMMENT '是否推荐   1:是   2:不是',
  `status` tinyint(4) NULL DEFAULT 1 COMMENT '状态   1:正常   2:作废',
  `create_at` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `update_at` timestamp(0) NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '成品表' ROW_FORMAT = Dynamic;


--成品分类表
CREATE TABLE `tb_product_category`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '分类表自增id',
  `category_id` varchar(88) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0' COMMENT '分类id(CR: level1: [01-99], level2: [001-999], level3: [0001-9999])',
  `category_name` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '分类名称',
  `parent_id` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '父级分类',
  `level` tinyint(4) NOT NULL DEFAULT 0 COMMENT '分类等级',
  `status` tinyint(4) NOT NULL DEFAULT 0 COMMENT '状态 0:正常 1:禁用',
  `create_at` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `update_at` timestamp(0) NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  `create_uid` varchar(16) NULL DEFAULT NULL COMMENT '创建人id',
  `update_uid` varchar(16) NULL DEFAULT NULL COMMENT '修改人id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '成品分类表' ROW_FORMAT = Dynamic;


--成品营销专区表
CREATE TABLE `tb_product_prefecture_config`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `prefecture` varchar(255) NULL DEFAULT NULL COMMENT '专区名称',
  `image` varchar(255) NULL DEFAULT NULL COMMENT '营销专区图片url',
  `status` varchar(255) NULL DEFAULT NULL COMMENT '状态  1：正常  2：禁用',
  `create_at` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_at` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '成品营销专区配置表' ROW_FORMAT = Dynamic;


-- 成品关联成品营销分区表 
CREATE TABLE `tb_product_prefecture`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `product_id` varchar(36) NOT NULL COMMENT '成品 id',
  `prefecture_id` int(11) NULL DEFAULT NULL COMMENT '营销专区id',
  `create_at` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_at` timestamp(0) NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '成品关联成品营销分区表' ROW_FORMAT = Dynamic;


-- 成品banner配置表 
CREATE TABLE `tb_product_banner_config`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `image` varchar(255) NULL DEFAULT NULL COMMENT 'banner图片url',
  `link` varchar(255) NULL DEFAULT NULL COMMENT 'banner链接地址',
  `status` varchar(255) NULL DEFAULT NULL COMMENT '状态  1：正常  2：禁用',
  `create_at` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_at` timestamp(0) NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '成品banner配置表' ROW_FORMAT = Dynamic;