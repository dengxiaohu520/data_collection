
-- 红包活动配置表
CREATE TABLE `tb_user_active_config`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '活动配置id',
  `prize_count` int(11) NULL DEFAULT 0 COMMENT '用户每日最多中奖次数',
  `prize_total` int(11) NOT NULL DEFAULT 0 COMMENT '用户累计中奖次数',
  `prize_config` json NULL COMMENT '奖品配置，备注：prize_type: 奖品类型:1：不中奖，2：红包，3：优惠卷，4：实物',
  `status` int(11) NOT NULL DEFAULT 0 COMMENT '活动是否开启，1：开启，2：不开启',
  `create_at` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `update_at` timestamp(0) NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  `active_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '活动名称：活动一，活动二',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='红包活动配置表';

# 注：奖品配置中存JSON格式数据，里面字段为
[{"prize":"再接再励", "prize_image": "", "prize_probability": 0.5, "prize_count":100, "prize_total": 100, "prize_type":1},
{"prize":20, "prize_image": "www.baidu.com", "prize_probability": 0.5, "prize_count":100, "prize_total": 100, "prize_type":2}]


{奖品：prize
奖品图片：prize_image
中奖概率：prize_probability
每日中奖份数：prize_count
总奖品份数：prize_total
}



-- 创建用户活动奖品表
CREATE TABLE `tb_user_active_prize`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `uid` int(11) NOT NULL DEFAULT 0 COMMENT '用户id',
  `prize` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '用户获得的奖品',
  `prize_type` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '1' COMMENT '活动类型：cash,thinks,phone',
  `prize_amount` float(10, 2) NOT NULL DEFAULT 0.00 COMMENT '奖品金额',
  `issue_status` int(11) NOT NULL DEFAULT 1 COMMENT '奖品发放状态： 1：未中奖，2：未领取，3：已领取',
  `create_at` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `update_at` timestamp(0) NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  `mch_billno` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '支付订单号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='我的奖品表';



alter table db_user.tb_user_extra add (
  `is_fae` tinyint(1) not null DEFAULT 0 comment '是否是fae工程师： 0：不是，1：是',
  `prize_count` int(11) not null default 0 comment '用户红包活动抽奖资格次数'
)