mysql脚本创建库表.sql

-- ===========================================================================================
-- 创建字典库
-- ===========================================================================================
-- create database if not exists db_dictionary DEFAULT CHARACTER SET utf8mb4;

-- use db_dictionary;


-- 用户表
CREATE TABLE `tb_user`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `nickname` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '昵称',
  `username` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '用户名',
  `password` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '密码',
  `area_code` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '86' COMMENT '手机区号',
  `phone` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '手机',
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '邮箱',
  `real_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '真实用户名',
  `icon` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '头像',
  `gender` tinyint(1) NULL DEFAULT 0 COMMENT '性别，0：男，1：女',
  `birthday` date NULL DEFAULT NULL COMMENT '生日',
  `state` tinyint(1) NOT NULL DEFAULT 0 COMMENT '状态 0：正常',
  `create_at` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `update_at` timestamp(0) NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  `create_uid` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `update_uid` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `last_pwd_update_at` datetime(0) NULL DEFAULT NULL COMMENT '上次修改密码时间',
  `company` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '所在公司',
  `position` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '职位',
  `email_v` tinyint(4) NULL DEFAULT 0 COMMENT '邮箱验证状态： 0： 尚未验证  1： 已成功验证',
  `phone_v` tinyint(4) NULL DEFAULT 0 COMMENT '电话号码验证状态： 0： 尚未验证  1： 已成功验证',
  `address` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '地址',
  `fixed_phone` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '商家入驻页面所填写的固定电话',
  `company_contact_email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '公司联系邮箱，商家入驻页面所填写的联系邮箱',
  `wechat_open_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '微信open_id',
  `wechat_number` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '微信号',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `idx_id`(`id`) USING BTREE,
  UNIQUE INDEX `uk_username`(`username`) USING BTREE,
  UNIQUE INDEX `uk_nickname`(`nickname`) USING BTREE,
  UNIQUE INDEX `uk_email`(`email`) USING BTREE,
  UNIQUE INDEX `uk_area_code_phone`(`area_code`, `phone`) USING BTREE,
  INDEX `idx_username`(`username`) USING BTREE,
  INDEX `idx_phone`(`phone`) USING BTREE,
  INDEX `idx_email`(`email`) USING BTREE,
  INDEX `idx_real__name`(`real_name`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 227 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;


alter TABLE db_user.tb_user add `age` tinyint(3) NOT NULL DEFAULT 0 COMMENT '年龄',



-- 用户信息附属表
CREATE TABLE `tb_user_extra`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `uid` int(11) NOT NULL COMMENT '用户id',
  `is_lock` tinyint(1) NULL DEFAULT 0 COMMENT '是否锁定 0：未锁定，1：锁定',
  `is_superuser` tinyint(1) NULL DEFAULT 0 COMMENT '是否超级用户 0：非超级用户，1：超级用户',
  `is_vipuser` tinyint(1) NULL DEFAULT 0 COMMENT '是否拥有特权 0：否，1：是',
  `vip_id` int(11) NULL DEFAULT NULL COMMENT '特权id',
  `vip_useable_nums` int(11) NULL DEFAULT 0 COMMENT '特权可用次数',
  `vip_expire_time` datetime(0) NULL DEFAULT NULL COMMENT '特权过期时间',
  `last_login_time` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '上次登录日期',
  `last_login_ip` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '上次登录ip',
  `state` tinyint(1) NOT NULL DEFAULT 0 COMMENT '状态 0：正常',
  `vip_state` tinyint(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'VIP状态：  0：停用，1：正常（默认1）',
  `create_at` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `update_at` timestamp(0) NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  `create_uid` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `update_uid` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `is_merchant` tinyint(1) NULL DEFAULT 0 COMMENT '是否为商城商家 0：否， 1：是',
  `logins` int(11) NULL DEFAULT 0 COMMENT '登录次数',
  `is_agree` tinyint(1) UNSIGNED ZEROFILL NULL DEFAULT 0 COMMENT '是否同意协议内容：1 同意 ；其他 不同意',
  `is_student` tinyint(1) NULL DEFAULT 0 COMMENT '是否是学生：0：不是；1 是',
  `id_card_photo` json NULL COMMENT '身份证照片',
  `id_card_number` varchar(19) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '身份证号',
  `bank_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '银行名称',
  `user_account` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '银行账户账号',
  `bank_account_branch` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '银行账户（支行）',
  `business_card` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '名片',
  `pay_use_count` int(11) NOT NULL DEFAULT 0 COMMENT '付费功能使用次数（针对vip客户，除去免费的6次外，其它的加总）',
  `is_fae` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否是fae工程师： 0：不是，1：是',
  `prize_count` int(11) NOT NULL DEFAULT 0 COMMENT '用户红包活动抽奖资格次数',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_uid`(`uid`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 185 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

Precise consultation

alter table db_user.tb_user_extra add (
  `simple_consult_fae` int(11) NOT NULL DEFAULT 0 COMMENT 'fae简单咨询剩余次数',
  `precise_consult_fae` int(11) NOT NULL DEFAULT 0 COMMENT 'fae精准咨询剩余次数',
  `detail_consult_fae` int(11) NOT NULL DEFAULT 0 COMMENT 'fae详细咨询剩余次数'

)


--创建购买FAE咨询订单表
CREATE TABLE `tb_fae_order`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `uid` int(11) NOT NULL COMMENT '用户id',
  `consult_id` varchar(16) NULL DEFAULT NULL COMMENT '对应用户咨询表的id',
  `order_no` varchar(128) NOT NULL COMMENT '订单号',
  `consult_type` tinyint(1) NOT NULL DEFAULT 1 COMMENT '咨询类型 1：简单咨询，2：精确咨询，3:详细咨询',
  `category_name` varchar(256) NOT NULL DEFAULT '' COMMENT '咨询元器件类别名称(最后一级)',
  `category_id` varchar(126) NOT NULL DEFAULT '' COMMENT '咨询元器件类别id(最后一级)',
  `part_number` varchar(128) NOT NULL DEFAULT '' COMMENT '元器件名称',
  `money` double(10, 2) NOT NULL DEFAULT 0.00 COMMENT '订单金额（单位元）',
  `platform_divide` double(10, 2) NULL DEFAULT 0.00 COMMENT '平台抽成比例',
  `platform_money` double(10, 2) NULL DEFAULT 0.00 COMMENT '平台抽成金额',
  `leader_divide` double(10, 2) NULL DEFAULT 0.00 COMMENT '团长抽成比例',
  `leader_money` double(10, 2) NULL DEFAULT 0.00 COMMENT '团长抽成金额',
  `engineer_divide` double(10, 2) NULL DEFAULT 0.00 COMMENT '工程师抽成比例',
  `engineer_money` double(10, 2) NULL DEFAULT 0.00 COMMENT '工程师抽成金额',
  `reward` double(10, 2) NULL DEFAULT 0.00 COMMENT '打赏金额',
  `pay_order` varchar(256) NOT NULL DEFAULT '' COMMENT '支付流水号',
  `reciprocal_account` varchar(256) NOT NULL DEFAULT '' COMMENT '对方账户',
  `buy_type` tinyint(1) NOT NULL DEFAULT 1 COMMENT '购买类型 1：首次, 2: 续购',
  `is_invoice` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否开发票 1：未开发票，2：已开发票   3:申请中',
  `order_channel` tinyint(1) NULL DEFAULT 1 COMMENT '下单渠道 1: PC, 2: H5, 3: app, 4: 小程序',
  `appeal_state` tinyint(1) NULL DEFAULT 1 COMMENT '申诉状态 1: 无, 2: 待审核, 3: 审核中, 4: 申诉已处理',
  `pay_type` tinyint(1) NOT NULL DEFAULT 1 COMMENT '支付方式 1：微信，2：支付宝，3：预付费抵扣',
  `order_status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '订单状态 1：未付款，2：已付款, 3:已退款',
  `serve_type` tinyint(1) NOT NULL DEFAULT 1 COMMENT '服务状态 1：等待工程师接单，2：正在咨询中，3：服务已结束',
  `recoil_state` tinyint(1) NOT NULL DEFAULT 1 COMMENT '回复状态 1：已经回答，2：没有回答，3：拒绝回答，4：关闭',
  `is_delayed` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否增加时长 1：不增加, 2: 增加',
  `is_end_early` tinyint(1) NOT NULL DEFAULT 1 COMMENT '聊天是否提前结束 1：不提前, 2: 提前',
  `is_top` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否置顶 1：不置顶, 2: 置顶',
  `state` tinyint(1) NOT NULL DEFAULT 1 COMMENT '状态 1：正常, 2: 不正常',
  `pay_at` timestamp(0) NULL  COMMENT '支付时间',
  `start_at` timestamp(0) NULL  COMMENT '服务开始时间',
  `end_at` timestamp(0) NULL  COMMENT '服务结束时间',
  `create_at` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `update_at` timestamp(0) NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_uid`(`uid`) USING BTREE,
  INDEX `idx_order`(`order_no`) USING BTREE

) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='FAE咨询订单表';

-- alter table db_user.tb_fae_order add (
  -- `lock_time` timestamp(0) NULL  COMMENT '移入待发放时间',
  -- `reach_time` timestamp(0) NULL  COMMENT '移入工程师账户时间',
-- )


--创建预付费订单表
CREATE TABLE `tb_fae_prepayment_order`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `uid` int(11) NOT NULL COMMENT '用户id',
  `order_no` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '订单号',
  `order_status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '订单状态 1：未付款，2：已付款',
  `money` double(10, 2) NOT NULL DEFAULT 0.00 COMMENT '预付费金额（单位元）',
  `pay_type` tinyint(1) NOT NULL DEFAULT 1 COMMENT '支付方式 1：微信，2：支付宝',
  `pay_order` varchar(256) NOT NULL DEFAULT '' COMMENT '支付流水号',
  `is_invoice` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否开发票 1：未开发票，2：已开发票   3:申请中',
  `order_channel` tinyint(1) NULL DEFAULT NULL COMMENT '下单渠道 1: PC, 2: H5, 3: app, 4: 小程序',
  `pay_at` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '支付时间',
  `state` tinyint(1) NOT NULL DEFAULT 1 COMMENT '状态 1：正常, 2: 不正常',
  `create_at` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `update_at` timestamp(0) NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_uid`(`uid`) USING BTREE,
  INDEX `idx_order`(`order_no`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='预付费订单表';



--创建申诉详情表
CREATE TABLE `tb_fae_appeal`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `uid` int(11) NOT NULL COMMENT '用户id',
  `order_no` varchar(128) NOT NULL COMMENT '订单号',
  `content` varchar(528) NULL DEFAULT NULL COMMENT '申诉内容',
  `images` json NULL COMMENT '申诉图片',
  `handler` varchar(128) NULL DEFAULT NULL COMMENT '申诉受理人',
  --`appeal_type` varchar(128) NULL DEFAULT NULL COMMENT '申诉状态，1：审核中，2：成立，3：不成立',
  `result` varchar(128) NULL DEFAULT NULL COMMENT '处理结果',
  `state` tinyint(1) NOT NULL DEFAULT 1 COMMENT '状态 1：正常, 2: 不正常',
  `dispose_at` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '申诉处理时间',
  `dispose_cause` varchar(528) NULL DEFAULT NULL COMMENT '处理原因（成立原因，不成立原因）',
  `create_at` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `update_at` timestamp(0) NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_uid`(`uid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='创建申诉详情表';



--创建订单、工程师操作日志表(后台订单记录)
CREATE TABLE `tb_fae_order_log`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `operate_id` int(11) NOT NULL COMMENT '操作对象id(订单id, 工程师入驻id)',
  `content` varchar(528) NULL DEFAULT NULL COMMENT '操作内容',
  `operate_type` tinyint(1) NULL DEFAULT 1 COMMENT '操作类型 1：订单，2：工程师',
  `create_at` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `update_at` timestamp(0) NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_operate`(`operate_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='订单、工程师操作日志表';



--创建用户咨询表
CREATE TABLE IF NOT EXISTS `tb_fae_user_consult` (
  `id` int(11) NOT NULL AUTO_INCREMENT comment '主键',
  `uid` int(11) NOT NULL COMMENT '用户id',
  `order_no` varchar(128) NOT NULL COMMENT '订单号',
  `category_name` varchar(256) NOT NULL DEFAULT '' COMMENT '咨询元器件类别名称(最后一级)',
  `category_id` varchar(126) NOT NULL DEFAULT '' COMMENT '咨询元器件类别id(最后一级)',
  `part_number` varchar(256) NOT NULL DEFAULT '' COMMENT '元器件名称',
  `consult_content` varchar(528) NOT NULL DEFAULT '' COMMENT '咨询内容',
  `adjunct` json NULL COMMENT '附件',
  `area_code` varchar(10) not NULL DEFAULT '86' COMMENT '手机区号',
  `phone` varchar(50) NOT NULL DEFAULT '' COMMENT '用户咨询时填写的手机号',
  `is_consent` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否同意道合顺大数据咨询服务协议(0:不同意，1：同意)',
  `state` tinyint(1) NOT NULL DEFAULT 1 COMMENT '状态 1：正常, 2: 不正常',
  `create_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
  `update_at` datetime(3) NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_uid`(`uid`) USING BTREE,
  INDEX `idx_order`(`order_no`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户咨询表';


--聊天记录表
CREATE TABLE IF NOT EXISTS `tb_fae_user_chat_records` (
  `id` int(11) NOT NULL AUTO_INCREMENT comment '主键',
  `consult_id` int(11) NOT NULL COMMENT '咨询id',
  `speaker` tinyint(1) NOT NULL DEFAULT 1 COMMENT '说话者 1：用户, 2: FAE工程师',
  `uid` int(11) NOT NULL COMMENT '用户id',
  `fae_uid` int(11) NOT NULL COMMENT comment 'fae工程师id',
  `order_no` varchar(128) NOT NULL COMMENT '订单号',
  `chat_label` varchar(256) NOT NULL DEFAULT '' COMMENT '聊天标签',
  `chat_content` varchar(126) NOT NULL DEFAULT '' COMMENT '聊天内容',
  `voice` varchar(256) NOT NULL DEFAULT '' COMMENT '语音',
  `image` varchar(528) NOT NULL DEFAULT '' COMMENT '聊天图片',
  `create_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
  `update_at` datetime(3) NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_uid`(`uid`) USING BTREE,
  INDEX `idx_order`(`order_no`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='聊天记录表';



--创建FAE工程师入驻表
CREATE TABLE IF NOT EXISTS `tb_fae_engineer_enter` (
  `id` int(11) NOT NULL AUTO_INCREMENT comment '主键',
  `uid` int(11) NOT NULL DEFAULT 0 comment '用户id',
  `leader_uid` int(11) NULL COMMENT '团长id',
  `job_number` varchar(128) UNIQUE NOT NULL  comment '工程师编号(在平台具有唯一性)',
  `area_code` varchar(10) not NULL DEFAULT '86' COMMENT '手机区号',
  `phone` varchar(50) NOT NULL DEFAULT '' COMMENT '入驻FAE所填写的手机',
  `good_category` json NULL COMMENT '擅长的分类(分类id，分类名称)',
  `good_electron` json NULL COMMENT '擅长的元器件型号',
  `good_field` varchar(528) NOT NULL DEFAULT '' COMMENT '擅长的领域',
  `is_consent` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否同意道合顺大数据咨询服务协议(1:不同意，2：同意)',
  `state` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否关闭FAE权限 1：开放, 2: 关闭',
  `audit_status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '审核状态 1：待审核, 2: 审核通过， 3：审核未通过',
  `audit_at` datetime(3) NULL DEFAULT 0 COMMENT '审核通过的时间',
  `create_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
  `update_at` datetime(3) NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_uid`(`uid`) USING BTREE,
  INDEX `leader_uid`(`leader_uid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='FAE工程师入驻表';



--FAE后台配置表
CREATE TABLE IF NOT EXISTS `tb_fae_config` (
  `id` int(11) NOT NULL AUTO_INCREMENT comment '主键',
  `name` varchar(128) NOT NULL DEFAULT '' COMMENT '名称',
  `k` varchar(256) NOT NULL DEFAULT 0.00 COMMENT '关键字',
  `v` varchar(256) NOT NULL DEFAULT 0.00 COMMENT '内容',
  `description` varchar(256) NOT NULL DEFAULT '' COMMENT '说明',
  `state` tinyint(1) NOT NULL DEFAULT 2 COMMENT '是否启用(1：启用， 2:不启用)',
  `create_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
  `update_at` datetime(3) NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='FAE咨询类型表';


--我的资金表
CREATE TABLE IF NOT EXISTS `tb_user_money` (
  `id` int(11) NOT NULL AUTO_INCREMENT comment '主键',
  `uid` int(11) NOT NULL  comment '用户id',
  `drawable_money` double(10, 2)  NOT NULL DEFAULT 0.00 COMMENT '可提现金额',
  `prepayment` double(10, 2)  NOT NULL DEFAULT 0.00 COMMENT '预付费',
  `create_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
  `update_at` datetime(3) NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='我的资金表';


--提现记录表
CREATE TABLE IF NOT EXISTS `tb_withdraw_record` (
  `id` int(11) NOT NULL AUTO_INCREMENT comment '主键',
  `uid` int(11) NOT NULL  comment '用户id',
  `bank_name` varchar(128) NOT NULL DEFAULT '' COMMENT '提现银行',
  `user_account` varchar(128) NOT NULL DEFAULT '' COMMENT '提现银行银行卡号',
  `drawable_money` double(10, 2)  NOT NULL DEFAULT 0.00 COMMENT '提现金额',
  `drawable_type` tinyint(1) NOT NULL DEFAULT 1 COMMENT '提现状态：1：审核中，2：提现成功，3：提现失败',
  `cause` varchar(256) NOT NULL DEFAULT '' COMMENT '提现失败原因',
  `create_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '提现时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='提现记录表';


--订单完成分佣记录
CREATE TABLE IF NOT EXISTS `tb_commission_record` (
  `id` int(11) NOT NULL AUTO_INCREMENT comment '主键',
  `order_no` varchar(128) NOT NULL COMMENT '订单号',
  `money` double(10, 2) NOT NULL DEFAULT 0.00 COMMENT '订单金额（单位元）',
  `job_number` varchar(128) UNIQUE NOT NULL  comment '工程师编号(在平台具有唯一性)',
  `leader_uid` int(11) NULL COMMENT '团长id',
  `fae_income` COMMENT 'FAE订单赚取金额',
  `leader_income` COMMENT '团长订单赚取金额',
  `platform_income` COMMENT '平台订单赚取金额',
  `state` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否成效：0 无效，1 有效',
  `create_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
  `update_at` datetime(3) NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='订单完成分佣记录';


-- --FAE邀请表
-- CREATE TABLE IF NOT EXISTS `tb_fae_invitation` (
--   `id` int(11) NOT NULL AUTO_INCREMENT comment '主键',
--   `name` varchar(128) NOT NULL DEFAULT '' COMMENT '姓名',
--   `price` double(10, 2)  NOT NULL DEFAULT 0.00 COMMENT '累计贡献(元)',
--   `engineer_state` tinyint(1) NOT NULL DEFAULT 1 COMMENT '入驻状态(0:不成功，1：成功)',
--   `create_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
--   `update_at` datetime(3) NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3) COMMENT '更新时间',
--   PRIMARY KEY (`id`)
-- ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='FAE邀请表';




