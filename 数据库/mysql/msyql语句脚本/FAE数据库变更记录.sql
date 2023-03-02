# FAE数据库变更记录

--提现记录表
CREATE TABLE `tb_withdraw_record`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `uid` int(11) NOT NULL COMMENT '用户id',
  `bank_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '提现银行',
  `user_account` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '提现银行银行卡号',
  `drawable_money` double(10, 2) NOT NULL DEFAULT 0.00 COMMENT '提现金额',
  `personal_tax_rate` int(11) NOT NULL DEFAULT 0 COMMENT '个税预扣率，0%，20%，30%，40%',
  `personal_tax_money` double(10, 2) NOT NULL DEFAULT 0.00 COMMENT '个税缴纳金额',
  `end_money` double(10, 2) NOT NULL DEFAULT 0.00 COMMENT '实际到账金额',
  `drawable_type` tinyint(1) NOT NULL DEFAULT 1 COMMENT '提现状态：1：审核中，2：提现成功，3：提现失败',
  `cause` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '提现失败原因',
  `create_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '提现时间',
  `update_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '提现记录表' ROW_FORMAT = Dynamic;


--我的资金表
CREATE TABLE `tb_user_money`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `uid` int(11) NOT NULL COMMENT '用户id',
  `wait_money` double(10, 2) NOT NULL DEFAULT 0.00 COMMENT '待发放金额',
  `commission_money` double(10, 2) NOT NULL DEFAULT 0.00 COMMENT '分佣金额',
  `drawable_money` double(10, 2) NOT NULL DEFAULT 0.00 COMMENT '可提现金额',
  `prepayment` double(10, 2) NOT NULL DEFAULT 0.00 COMMENT '预付费',
  `create_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
  `update_at` datetime(3) NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `_inx_uid`(`uid`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '我的资金表' ROW_FORMAT = Dynamic;


--订单完成分佣记录
CREATE TABLE `tb_commission_record`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `order_no` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '订单号',
  `money` double(10, 2) NOT NULL DEFAULT 0.00 COMMENT '订单金额（单位元）',
  `job_number` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '工程师ID编号',
  `fae_uid` int(11) NULL DEFAULT NULL,
  `leader_uid` int(11) NULL DEFAULT NULL COMMENT '团长id',
  `fae_income` double(10, 2) NOT NULL DEFAULT 0.00 COMMENT 'FAE订单赚取金额',
  `leader_income` double(10, 2) NOT NULL DEFAULT 0.00 COMMENT '团长订单赚取金额',
  `platform_income` double(10, 2) NOT NULL DEFAULT 0.00 COMMENT '平台订单赚取金额',
  `total_commission` double(10, 2) NULL DEFAULT NULL COMMENT '团长账户分佣累计金额',
  `state` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否成效：0 无效，1 有效',
  `create_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
  `update_at` datetime(3) NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3) COMMENT '更新时间',
  `uid` int(11) NULL DEFAULT NULL COMMENT '用户id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '订单完成分佣记录' ROW_FORMAT = Dynamic;



--用户基础信息表
alter table db_user.tb_user add 'age' tinyint(3) NOT NULL DEFAULT 1 COMMENT '年龄';


# 开发环境中db_fae库