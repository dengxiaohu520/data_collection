
-- 创建活动配置表
CREATE TABLE IF NOT EXISTS `tb_user_active_config`(
  `id` int(11) NOT NULL AUTO_INCREMENT comment '活动配置id',
  `once_money` decimal(10, 2) UNSIGNED NULL DEFAULT 0.00 COMMENT '用户单次抽奖红包金额最大值',
  `count_maney` decimal(10, 2) UNSIGNED NULL DEFAULT 0.00 COMMENT '用户活动期间累计中奖红包金额最大',
  `issue_maney` decimal(10, 2) UNSIGNED NULL DEFAULT 0.00 COMMENT '平台每日发放红包金额',
  `draw_total` int(11) DEFAULT 0 COMMENT '用户活动期间累计抽奖次数最多',
  `draw_count` int(11) not null DEFAULT 0 COMMENT '用户每天获取抽奖资格次数',
  `status` int(11) not null DEFAULT 1 COMMENT '活动状态：0 关闭， 1 开启',
  `create_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



-- 创建用户活动奖品表
CREATE TABLE IF NOT EXISTS `tb_user_active_prize` (
  `id` int(11) NOT NULL AUTO_INCREMENT comment '主键id',
  `uid` int(11) NOT NULL default 0 comment '用户id',
  `prize` varchar(128) not null default '' COMMENT '用户获得的奖品',
  `issue_status` int(11) not null default 1 comment '奖品发放状态： 1：未中奖，2：未领取红包，3：已领取红包',
  `create_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- 创建用户活动投诉原因配置表
CREATE TABLE IF NOT EXISTS `tb_user_complain_cause`(
  `id` int(11) NOT NULL AUTO_INCREMENT comment '主键id',
  `cause` varchar(128) not null default '' COMMENT '用户投诉原因',
  `create_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;




-- 创建用户活动投诉管理表
CREATE TABLE IF NOT EXISTS `tb_user_active_complain` (
  `id` int(11) NOT NULL AUTO_INCREMENT comment '主键id',
  `uid` int(11) NOT NULL default 0 comment '用户id',
  `cause` int(11) not null default 0 COMMENT '用户投诉原因',
  `describe` varchar(3000) not null default '' COMMENT '用户投诉描述',
  `image` varchar(528) not null default '' COMMENT '用户投诉图片',
  `create_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;





-- 创建用户参与活动额外信息表
CREATE TABLE IF NOT EXISTS `tb_user_active_extra` (
  `id` int(11) NOT NULL AUTO_INCREMENT comment '主键id',
  `uid` int(11) NOT NULL default 0 comment '用户id',
  `invite_login` int(11) NOT NULL default 0 comment '通过分享的链接注册的用户',
  `draw_total` int(11) NOT NULL default 0 comment '用户抽奖的总次数',
  `count_maney` decimal(10, 2) UNSIGNED NULL DEFAULT 0.00 COMMENT '用户活动期间中奖总金额',
  `protocol_status` int(11) not null default 1 comment '用户是否同意协议状态， 1：同意， 2：不同意',
  `create_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;




-- 添加邮箱字段
alter table tb_user_extra add business_card varchar(512) not Null DEFAULT '' comment '名片';