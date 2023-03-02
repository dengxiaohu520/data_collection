微信授权登录.sql
-- 微信(微信、微信公众号、微信小程序)登录用户数据
CREATE TABLE `tb_user_wechat`  (
  `uid` int(11) NOT NULL COMMENT '用户ID',
  `applet_openid` varchar(255) NULL DEFAULT '' COMMENT '微信小程序的open_id',
  `wechart_openid` varchar(255)  NULL DEFAULT '' COMMENT '微信公众号open_id',
  `wechat_unionid` varchar(255) NULL DEFAULT '' COMMENT '微信生态圈标识用户唯一的id(小程序、公众号都一样)',
  PRIMARY KEY (`uid`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '微信(微信、微信公众号、微信小程序)登录用户数据' ROW_FORMAT = Dynamic;


-- 用户职位表
CREATE TABLE `tb_user_position`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '职位自增id',
  `position_name` varchar(255) NULL DEFAULT '' COMMENT '职位名称',
  `state` tinyint(4) NULL DEFAULT 1 COMMENT '状态，1：正常，2：删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户职位表' ROW_FORMAT = Dynamic;

alter table db_user.tb_user add COLUMN position_list varchar(255) COMMENT '用户职位id';

-- 1. 生成老用户虚拟id
-- 2. 生成微信授权登录表
-- 3. 迁移微信授权open_id
-- 4. 用户表增加用户职位id的栏位，性别增加保密一项


-- BOM总表
CREATE TABLE `tb_bom`  (
  `id` varchar(36) NOT NULL COMMENT 'BOM uuid',
  `uid` int(11) NOT NULL DEFAULT 0 COMMENT '用户id',
  `bom_name` varchar(256) NOT NULL DEFAULT '' COMMENT 'bom名称',
  `application_domain` varchar(256) NULL DEFAULT '' COMMENT 'bom应用领域',
  `bom_total` int(11) NULL DEFAULT 0 COMMENT '原始bom表中，器件的总数量',
  `origin_bom` json NULL COMMENT '用户上传的原始bom内容',
  `bom_fileurl` json NULL COMMENT '用户上传的bom保存路径',
  `state` tinyint(4) not NULL DEFAULT 1 COMMENT '状态，1：正常，2：删除',
  `create_at` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `update_at` timestamp(0) NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `idx_id`(`id`) USING BTREE COMMENT '按id查找',
  INDEX `bom_name_index`(`bom_name`) USING BTREE COMMENT '按表名查找',
  INDEX `create_at_index`(`create_at`) USING BTREE COMMENT '按创建时间',
  INDEX `idx_bom`(`id`, `bom_name`, `bom_total`, `create_at`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = 'bom总表' ROW_FORMAT = Dynamic;



--BOM平台型号匹配结果表
CREATE TABLE `tb_bom_matching_electron`  (
  `temporary_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '单条数据临时 id',
  `bom_id` varchar(36) NOT NULL DEFAULT '0' COMMENT 'bom总表 id',
  `sequence` int(11) NULL DEFAULT 0 COMMENT '序列号',
  `parameter` varchar(128) NULL DEFAULT '' COMMENT '参数',
  `part_number` varchar(128) NULL DEFAULT '' COMMENT '器件型号名称',
  `factory_name` varchar(128) NULL DEFAULT '' COMMENT '厂牌名称',
  `count` int(11) NULL DEFAULT 1 COMMENT '用户上传的数量',
  `matching_electron_uuid` varchar(36)  NULL DEFAULT '' COMMENT '元器件uuid',
  `matching_part_number` varchar(128) NULL DEFAULT '' COMMENT '匹配元器件型号名称',
  `matching_factory` varchar(128) NULL DEFAULT '' COMMENT '匹配元器件厂牌',
  `matching_package` varchar(128) NULL DEFAULT '' COMMENT '匹配元器件封装',
  `matching_lifecycle` tinyint(4)  not null DEFAULT 0 COMMENT '匹配元器件生命周期: 0: 量产（Active）1: 不推荐用于新设计（Not Recommended for New Design）2: 停产（Obsolete）',
  `bom_json` json NULL COMMENT '用户上传的原始单条bom内容',
  `status` tinyint(4) NULL DEFAULT 1 COMMENT '获取推荐型号状态，1：加载中，2：返回推荐型号，3：返回结果为空',
  `create_at` timestamp(0) NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `update_at` timestamp(0) NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  PRIMARY KEY (`temporary_id`) USING BTREE,
  INDEX `idx_temporary_id`(`temporary_id`) USING BTREE COMMENT '原始bom id',
  INDEX `idx_bom_id`(`bom_id`) USING BTREE COMMENT 'BOM id'
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = 'BOM平台匹配结果表' ROW_FORMAT = Dynamic;



--根据匹配出来型号找到对应的替代型号
CREATE TABLE `tb_bom_replace_electron`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '单条数据临时 id',
  `temporary_id` int(11) NOT NULL DEFAULT 0 COMMENT '原bom数据的id',
  `bom_id` varchar(36)  NOT NULL DEFAULT '0' COMMENT 'bom总表 id',
  `replace_electron_uuid` varchar(36) NULL DEFAULT '' COMMENT '元器件uuid',
  `replace_part_number` varchar(128)  NULL DEFAULT '' COMMENT '器件型号名称',
  `replace_factory_name` varchar(128) NULL DEFAULT '' COMMENT '厂牌名称',
  `replace_package` varchar(128) NULL DEFAULT '' COMMENT '匹配元器件封装',
  `replace_lifecycle`  tinyint(4)  not null DEFAULT 0 COMMENT '替代元器件生命周期: 0: 量产（Active）1: 不推荐用于新设计（Not Recommended for New Design）2: 停产（Obsolete）',
  `factory_recommend` int(11) NULL DEFAULT 0 COMMENT '是否原厂推荐(0: 不是， 1.是)',
  `status` tinyint(4) NULL DEFAULT 1 COMMENT '获取推荐型号状态，1：加载中，2：返回替代型号，3：返回结果为空',
  `create_at` timestamp(0) NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `update_at` timestamp(0) NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_bom_id`(`bom_id`) USING BTREE COMMENT 'bom id',
  INDEX `idx_temporary_id`(`temporary_id`) USING BTREE COMMENT '原始bom id',
  INDEX `idx_id`(`id`) USING BTREE COMMENT '推荐bom id'
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = 'BOM替代型号型号表' ROW_FORMAT = Dynamic;





