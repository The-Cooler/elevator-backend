-- ============================================================
-- 老旧小区电梯故障报修与维保跟踪平台 - 数据库表结构
--
-- 本文件只含表结构（CREATE TABLE），不含任何数据。
-- 建表后系统可以启动，账号、电梯、维保计划等数据需自行录入。
--
-- 用法：
--   mysql -uroot -p < elevator_schema.sql
--   执行后库名为 elevator，与前后端配置一致。
--
-- 表清单：共 43 张
--   若依框架表 15 张（sys_ 前缀）：用户、角色、菜单、用户角色、角色菜单、
--     字典类型、字典数据、参数配置、定时任务、定时任务日志、登录日志、
--     操作日志、通知公告、公告已读、文件
--   Quartz 调度表 11 张（qrtz_ 前缀）：由 Quartz 使用，本脚本一并建好
--   电梯业务表 17 张：小区、楼栋、电梯、报修工单、维修记录、证据、流转记录、
--     维保计划、检查项、巡检记录、巡检结果、维保档案、
--     健康评分、预警规则、预警信息、维修员技能、消息
--
-- 注意：本文件不含 sys_dept（部门表）、sys_post（岗位表）、gen_table（代码生成器表），
--       这三类已在项目中移除。
-- ============================================================

CREATE DATABASE IF NOT EXISTS `elevator`
  DEFAULT CHARACTER SET utf8mb4
  COLLATE utf8mb4_general_ci;

USE `elevator`;

-- MySQL dump 10.13  Distrib 8.0.39, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: elevator
-- ------------------------------------------------------
-- Server version	8.0.39

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `building`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `building` (
  `building_id` bigint NOT NULL AUTO_INCREMENT COMMENT '楼栋ID',
  `community_id` bigint NOT NULL COMMENT '所属小区ID',
  `building_no` varchar(30) COLLATE utf8mb4_general_ci NOT NULL COMMENT '楼栋号',
  `unit_no` varchar(30) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '单元号',
  `floor_count` int DEFAULT '0' COMMENT '楼层数',
  `status` char(1) COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `del_flag` char(1) COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`building_id`),
  KEY `idx_building_community` (`community_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='楼栋信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `community`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `community` (
  `community_id` bigint NOT NULL AUTO_INCREMENT COMMENT '小区ID',
  `community_name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL COMMENT '小区名称',
  `address` varchar(200) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '小区地址',
  `build_year` varchar(10) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '建成时间',
  `property_contact` varchar(20) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '物业联系人',
  `property_phone` varchar(20) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '物业联系电话',
  `status` char(1) COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `del_flag` char(1) COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`community_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='小区信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `elevator`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `elevator` (
  `elevator_id` bigint NOT NULL AUTO_INCREMENT COMMENT '电梯ID',
  `elevator_code` varchar(50) COLLATE utf8mb4_general_ci NOT NULL COMMENT '电梯编号',
  `brand` varchar(50) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '品牌',
  `model` varchar(50) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '型号',
  `building_id` bigint NOT NULL COMMENT '所在楼栋ID',
  `unit_no` varchar(10) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '单元号',
  `maintain_unit` varchar(100) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '维保单位',
  `install_date` date DEFAULT NULL COMMENT '投用日期',
  `service_years` int DEFAULT '0' COMMENT '使用年限',
  `cert_file_id` bigint DEFAULT NULL COMMENT '年检报告附件ID',
  `status` char(1) COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '状态（0正常运行 1停梯检修 2已报废）',
  `longitude` decimal(10,7) DEFAULT NULL COMMENT '经度，维修员到场打卡的比对基准',
  `latitude` decimal(10,7) DEFAULT NULL COMMENT '纬度，维修员到场打卡的比对基准',
  `del_flag` char(1) COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`elevator_id`),
  KEY `idx_elevator_building` (`building_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='电梯信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `elevator_health`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `elevator_health` (
  `health_id` bigint NOT NULL AUTO_INCREMENT COMMENT '健康记录ID',
  `elevator_id` bigint NOT NULL COMMENT '电梯ID',
  `stat_period` varchar(20) COLLATE utf8mb4_general_ci NOT NULL COMMENT '统计周期（如 2026-10 或 2026-Q4）',
  `stat_start_date` date DEFAULT NULL COMMENT '统计开始日期',
  `stat_end_date` date DEFAULT NULL COMMENT '统计结束日期',
  `fault_count` int DEFAULT '0' COMMENT '统计周期内故障次数',
  `fault_rate` decimal(6,2) DEFAULT '0.00' COMMENT '故障率指标得分',
  `fault_score` decimal(5,2) DEFAULT '0.00' COMMENT '故障率得分',
  `maintain_done` int DEFAULT '0' COMMENT '应执行维保次数',
  `maintain_finish` int DEFAULT '0' COMMENT '实际执行维保次数',
  `maintain_rate` decimal(6,2) DEFAULT '0.00' COMMENT '维保完成率（百分比）',
  `maintain_score` decimal(5,2) DEFAULT '0.00' COMMENT '维保完成率得分',
  `inspect_total` int DEFAULT '0' COMMENT '巡检检查项总数',
  `inspect_normal` int DEFAULT '0' COMMENT '巡检正常项数',
  `inspect_rate` decimal(6,2) DEFAULT '0.00' COMMENT '巡检合格率（百分比）',
  `inspect_score` decimal(5,2) DEFAULT '0.00' COMMENT '巡检合格率得分',
  `maintain_applicable` tinyint(1) DEFAULT '1' COMMENT '维保完成率是否参与评分（0否 1是，统计周期内无维保计划时为0）',
  `inspect_applicable` tinyint(1) DEFAULT '1' COMMENT '巡检合格率是否参与评分（0否 1是，统计周期内无已完成巡检记录时为0）',
  `health_score` decimal(5,2) DEFAULT '0.00' COMMENT '健康评分',
  `health_level` varchar(20) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '健康等级（excellent优秀 good良好 fair一般 poor较差 danger危险）',
  `calc_time` datetime DEFAULT NULL COMMENT '计算时间',
  PRIMARY KEY (`health_id`),
  KEY `idx_health_elevator` (`elevator_id`),
  KEY `idx_health_period` (`stat_period`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='电梯健康评分表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `elevator_notice`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `elevator_notice` (
  `notice_id` bigint NOT NULL AUTO_INCREMENT COMMENT '消息ID',
  `notice_type` varchar(30) COLLATE utf8mb4_general_ci NOT NULL COMMENT '消息类型（assign派单 accept接单 progress进度 warning预警 appeal申诉）',
  `title` varchar(200) COLLATE utf8mb4_general_ci NOT NULL COMMENT '消息标题',
  `content` varchar(500) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '消息内容',
  `biz_id` bigint DEFAULT NULL COMMENT '关联业务ID',
  `biz_type` varchar(20) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '关联业务类型（order报修工单 inspection巡检记录 plan维保计划 空无关联），供前端跳转用',
  `receiver_id` bigint NOT NULL COMMENT '接收人ID',
  `is_read` char(1) COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '是否已读（0未读 1已读）',
  `read_time` datetime DEFAULT NULL COMMENT '阅读时间',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`notice_id`),
  KEY `idx_notice_receiver` (`receiver_id`,`is_read`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='通知消息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `inspection_item_result`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inspection_item_result` (
  `result_id` bigint NOT NULL AUTO_INCREMENT COMMENT '结果ID',
  `record_id` bigint NOT NULL COMMENT '巡检记录ID',
  `item_id` bigint DEFAULT NULL COMMENT '检查项ID',
  `item_name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL COMMENT '检查项名称',
  `item_category` varchar(30) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '检查项分类',
  `check_result` varchar(20) COLLATE utf8mb4_general_ci DEFAULT 'normal' COMMENT '检查结果（normal正常 abnormal异常 na不适用）',
  `abnormal_desc` varchar(500) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '异常说明',
  `file_id` bigint DEFAULT NULL COMMENT '现场照片文件ID',
  `order_num` int DEFAULT '0' COMMENT '排序号',
  PRIMARY KEY (`result_id`),
  KEY `idx_result_record` (`record_id`)
) ENGINE=InnoDB AUTO_INCREMENT=512 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='巡检检查项结果表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `inspection_record`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inspection_record` (
  `record_id` bigint NOT NULL AUTO_INCREMENT COMMENT '巡检记录ID',
  `record_no` varchar(50) COLLATE utf8mb4_general_ci NOT NULL COMMENT '巡检工单编号',
  `plan_id` bigint DEFAULT NULL COMMENT '关联维保计划ID',
  `elevator_id` bigint NOT NULL COMMENT '电梯ID',
  `maintain_type` varchar(30) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '维保类型',
  `plan_date` date DEFAULT NULL COMMENT '计划维保日期',
  `executor_id` bigint DEFAULT NULL COMMENT '执行人ID',
  `clock_in_time` datetime DEFAULT NULL COMMENT '打卡时间',
  `clock_in_location` varchar(200) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '打卡位置',
  `clock_in_longitude` decimal(10,7) DEFAULT NULL COMMENT '打卡时的经度，由浏览器定位取得',
  `clock_in_latitude` decimal(10,7) DEFAULT NULL COMMENT '打卡时的纬度，由浏览器定位取得',
  `clock_in_distance` int DEFAULT NULL COMMENT '打卡点与电梯台账坐标的距离（米）',
  `demo_flag` char(1) COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '是否演示打卡（0正常 1演示模式，未做位置校验）',
  `execute_date` date DEFAULT NULL COMMENT '实际执行日期',
  `execute_result` varchar(20) COLLATE utf8mb4_general_ci DEFAULT 'pending' COMMENT '执行结果（pending待执行 normal正常 abnormal异常）',
  `abnormal_desc` varchar(1000) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '异常说明',
  `normal_count` int DEFAULT '0' COMMENT '正常项数',
  `abnormal_count` int DEFAULT '0' COMMENT '异常项数',
  `na_count` int DEFAULT '0' COMMENT '不适用项数',
  `record_status` varchar(20) COLLATE utf8mb4_general_ci DEFAULT 'pending' COMMENT '记录状态（pending待执行 finished已完成 overdue已超期）',
  `del_flag` char(1) COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`record_id`),
  UNIQUE KEY `uk_record_no` (`record_no`),
  KEY `idx_inspection_elevator` (`elevator_id`),
  KEY `idx_inspection_plan` (`plan_id`),
  KEY `idx_inspection_executor` (`executor_id`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='巡检记录表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `maintain_archive`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `maintain_archive` (
  `archive_id` bigint NOT NULL AUTO_INCREMENT COMMENT '档案ID',
  `elevator_id` bigint NOT NULL COMMENT '电梯ID',
  `archive_type` varchar(30) COLLATE utf8mb4_general_ci NOT NULL COMMENT '归档类型（inspection巡检 maintain维保 repair维修）',
  `maintain_type` varchar(30) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '维保类型',
  `biz_id` bigint DEFAULT NULL COMMENT '关联业务ID，指向巡检记录或维修记录',
  `archive_time` datetime DEFAULT NULL COMMENT '归档时间',
  `summary` varchar(1000) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '记录摘要',
  `executor_name` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '执行人姓名',
  `execute_date` date DEFAULT NULL COMMENT '执行日期',
  `is_abnormal` char(1) COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '是否含异常（0正常 1异常）',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`archive_id`),
  KEY `idx_archive_elevator` (`elevator_id`),
  KEY `idx_archive_type` (`archive_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='维保档案表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `maintain_item`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `maintain_item` (
  `item_id` bigint NOT NULL AUTO_INCREMENT COMMENT '检查项ID',
  `template_name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL COMMENT '模板名称',
  `maintain_type` varchar(30) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '适用维保类型（half_month半月保 quarter季度检 half_year半年保 annual年检）',
  `item_name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL COMMENT '检查项名称',
  `item_category` varchar(30) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '检查项分类（traction曳引机 door_system门系统 safety安全装置 control控制系统 car轿厢 other其他）',
  `check_standard` varchar(500) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '检查标准',
  `order_num` int DEFAULT '0' COMMENT '排序号',
  `status` char(1) COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`item_id`),
  KEY `idx_item_type` (`maintain_type`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='维保检查项模板表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `maintain_plan`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `maintain_plan` (
  `plan_id` bigint NOT NULL AUTO_INCREMENT COMMENT '计划ID',
  `plan_name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL COMMENT '计划名称',
  `elevator_id` bigint NOT NULL COMMENT '电梯ID',
  `maintain_type` varchar(30) COLLATE utf8mb4_general_ci NOT NULL COMMENT '维保类型（half_month半月保 quarter季度检 half_year半年保 annual年检）',
  `cycle_days` int NOT NULL COMMENT '周期天数',
  `template_name` varchar(100) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '检查项模板名称',
  `start_date` date DEFAULT NULL COMMENT '生效日期',
  `end_date` date DEFAULT NULL COMMENT '失效日期',
  `next_date` date DEFAULT NULL COMMENT '下次维保日期',
  `last_date` date DEFAULT NULL COMMENT '上次维保日期',
  `owner_id` bigint DEFAULT NULL COMMENT '负责人ID',
  `plan_status` char(1) COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '计划状态（0启用 1停用）',
  `expect_count` int DEFAULT '0' COMMENT '应执行次数',
  `finish_count` int DEFAULT '0' COMMENT '已执行次数',
  `del_flag` char(1) COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`plan_id`),
  KEY `idx_plan_elevator` (`elevator_id`),
  KEY `idx_plan_next_date` (`next_date`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='维保计划表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `order_status_log`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_status_log` (
  `log_id` bigint NOT NULL AUTO_INCREMENT COMMENT '日志ID',
  `order_id` bigint NOT NULL COMMENT '关联工单ID',
  `from_status` varchar(20) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '原状态',
  `to_status` varchar(20) COLLATE utf8mb4_general_ci NOT NULL COMMENT '新状态',
  `operate_type` varchar(30) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '操作类型（report报修 reject驳回 assign派单 accept接单 arrive到场 investigate排查 finish维修完成 confirm业主确认 appeal申诉 reassign重新指派 escalate升级）',
  `operator_id` bigint DEFAULT NULL COMMENT '操作人ID',
  `operator_name` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '操作人姓名',
  `operator_role` varchar(30) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '操作人角色',
  `operate_time` datetime DEFAULT NULL COMMENT '操作时间',
  `remark` varchar(500) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '备注',
  PRIMARY KEY (`log_id`),
  KEY `idx_log_order` (`order_id`)
) ENGINE=InnoDB AUTO_INCREMENT=128 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工单状态流转表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `qrtz_blob_triggers`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_blob_triggers` (
  `sched_name` varchar(120) COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `blob_data` blob COMMENT '存放持久化Trigger对象',
  PRIMARY KEY (`sched_name`,`trigger_name`,`trigger_group`),
  CONSTRAINT `qrtz_blob_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Blob类型的触发器表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `qrtz_calendars`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_calendars` (
  `sched_name` varchar(120) COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度名称',
  `calendar_name` varchar(200) COLLATE utf8mb4_general_ci NOT NULL COMMENT '日历名称',
  `calendar` blob NOT NULL COMMENT '存放持久化calendar对象',
  PRIMARY KEY (`sched_name`,`calendar_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='日历信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `qrtz_cron_triggers`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_cron_triggers` (
  `sched_name` varchar(120) COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `cron_expression` varchar(200) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'cron表达式',
  `time_zone_id` varchar(80) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '时区',
  PRIMARY KEY (`sched_name`,`trigger_name`,`trigger_group`),
  CONSTRAINT `qrtz_cron_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Cron类型的触发器表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `qrtz_fired_triggers`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_fired_triggers` (
  `sched_name` varchar(120) COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度名称',
  `entry_id` varchar(95) COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度器实例id',
  `trigger_name` varchar(200) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `instance_name` varchar(200) COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度器实例名',
  `fired_time` bigint NOT NULL COMMENT '触发的时间',
  `sched_time` bigint NOT NULL COMMENT '定时器制定的时间',
  `priority` int NOT NULL COMMENT '优先级',
  `state` varchar(16) COLLATE utf8mb4_general_ci NOT NULL COMMENT '状态',
  `job_name` varchar(200) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '任务名称',
  `job_group` varchar(200) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '任务组名',
  `is_nonconcurrent` varchar(1) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '是否并发',
  `requests_recovery` varchar(1) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '是否接受恢复执行',
  PRIMARY KEY (`sched_name`,`entry_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='已触发的触发器表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `qrtz_job_details`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_job_details` (
  `sched_name` varchar(120) COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度名称',
  `job_name` varchar(200) COLLATE utf8mb4_general_ci NOT NULL COMMENT '任务名称',
  `job_group` varchar(200) COLLATE utf8mb4_general_ci NOT NULL COMMENT '任务组名',
  `description` varchar(250) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '相关介绍',
  `job_class_name` varchar(250) COLLATE utf8mb4_general_ci NOT NULL COMMENT '执行任务类名称',
  `is_durable` varchar(1) COLLATE utf8mb4_general_ci NOT NULL COMMENT '是否持久化',
  `is_nonconcurrent` varchar(1) COLLATE utf8mb4_general_ci NOT NULL COMMENT '是否并发',
  `is_update_data` varchar(1) COLLATE utf8mb4_general_ci NOT NULL COMMENT '是否更新数据',
  `requests_recovery` varchar(1) COLLATE utf8mb4_general_ci NOT NULL COMMENT '是否接受恢复执行',
  `job_data` blob COMMENT '存放持久化job对象',
  PRIMARY KEY (`sched_name`,`job_name`,`job_group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='任务详细信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `qrtz_locks`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_locks` (
  `sched_name` varchar(120) COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度名称',
  `lock_name` varchar(40) COLLATE utf8mb4_general_ci NOT NULL COMMENT '悲观锁名称',
  PRIMARY KEY (`sched_name`,`lock_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='存储的悲观锁信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `qrtz_paused_trigger_grps`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_paused_trigger_grps` (
  `sched_name` varchar(120) COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度名称',
  `trigger_group` varchar(200) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  PRIMARY KEY (`sched_name`,`trigger_group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='暂停的触发器表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `qrtz_scheduler_state`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_scheduler_state` (
  `sched_name` varchar(120) COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度名称',
  `instance_name` varchar(200) COLLATE utf8mb4_general_ci NOT NULL COMMENT '实例名称',
  `last_checkin_time` bigint NOT NULL COMMENT '上次检查时间',
  `checkin_interval` bigint NOT NULL COMMENT '检查间隔时间',
  PRIMARY KEY (`sched_name`,`instance_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='调度器状态表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `qrtz_simple_triggers`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_simple_triggers` (
  `sched_name` varchar(120) COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `repeat_count` bigint NOT NULL COMMENT '重复的次数统计',
  `repeat_interval` bigint NOT NULL COMMENT '重复的间隔时间',
  `times_triggered` bigint NOT NULL COMMENT '已经触发的次数',
  PRIMARY KEY (`sched_name`,`trigger_name`,`trigger_group`),
  CONSTRAINT `qrtz_simple_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='简单触发器的信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `qrtz_simprop_triggers`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_simprop_triggers` (
  `sched_name` varchar(120) COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `str_prop_1` varchar(512) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'String类型的trigger的第一个参数',
  `str_prop_2` varchar(512) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'String类型的trigger的第二个参数',
  `str_prop_3` varchar(512) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'String类型的trigger的第三个参数',
  `int_prop_1` int DEFAULT NULL COMMENT 'int类型的trigger的第一个参数',
  `int_prop_2` int DEFAULT NULL COMMENT 'int类型的trigger的第二个参数',
  `long_prop_1` bigint DEFAULT NULL COMMENT 'long类型的trigger的第一个参数',
  `long_prop_2` bigint DEFAULT NULL COMMENT 'long类型的trigger的第二个参数',
  `dec_prop_1` decimal(13,4) DEFAULT NULL COMMENT 'decimal类型的trigger的第一个参数',
  `dec_prop_2` decimal(13,4) DEFAULT NULL COMMENT 'decimal类型的trigger的第二个参数',
  `bool_prop_1` varchar(1) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'Boolean类型的trigger的第一个参数',
  `bool_prop_2` varchar(1) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'Boolean类型的trigger的第二个参数',
  PRIMARY KEY (`sched_name`,`trigger_name`,`trigger_group`),
  CONSTRAINT `qrtz_simprop_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='同步机制的行锁表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `qrtz_triggers`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_triggers` (
  `sched_name` varchar(120) COLLATE utf8mb4_general_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) COLLATE utf8mb4_general_ci NOT NULL COMMENT '触发器的名字',
  `trigger_group` varchar(200) COLLATE utf8mb4_general_ci NOT NULL COMMENT '触发器所属组的名字',
  `job_name` varchar(200) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_job_details表job_name的外键',
  `job_group` varchar(200) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'qrtz_job_details表job_group的外键',
  `description` varchar(250) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '相关介绍',
  `next_fire_time` bigint DEFAULT NULL COMMENT '上一次触发时间（毫秒）',
  `prev_fire_time` bigint DEFAULT NULL COMMENT '下一次触发时间（默认为-1表示不触发）',
  `priority` int DEFAULT NULL COMMENT '优先级',
  `trigger_state` varchar(16) COLLATE utf8mb4_general_ci NOT NULL COMMENT '触发器状态',
  `trigger_type` varchar(8) COLLATE utf8mb4_general_ci NOT NULL COMMENT '触发器的类型',
  `start_time` bigint NOT NULL COMMENT '开始时间',
  `end_time` bigint DEFAULT NULL COMMENT '结束时间',
  `calendar_name` varchar(200) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '日程表名称',
  `misfire_instr` smallint DEFAULT NULL COMMENT '补偿执行的策略',
  `job_data` blob COMMENT '存放持久化job对象',
  PRIMARY KEY (`sched_name`,`trigger_name`,`trigger_group`),
  KEY `sched_name` (`sched_name`,`job_name`,`job_group`),
  CONSTRAINT `qrtz_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `job_name`, `job_group`) REFERENCES `qrtz_job_details` (`sched_name`, `job_name`, `job_group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='触发器详细信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `repair_evidence`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `repair_evidence` (
  `evidence_id` bigint NOT NULL AUTO_INCREMENT COMMENT '证据ID',
  `order_id` bigint NOT NULL COMMENT '关联工单ID',
  `file_id` bigint NOT NULL COMMENT '文件ID',
  `evidence_type` varchar(20) COLLATE utf8mb4_general_ci DEFAULT 'image' COMMENT '证据类型（image图片 video视频）',
  `upload_time` datetime DEFAULT NULL COMMENT '上传时间',
  `create_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '创建者',
  `del_flag` char(1) COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  PRIMARY KEY (`evidence_id`),
  KEY `idx_evidence_order` (`order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='报修证据附件表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `repair_order`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `repair_order` (
  `order_id` bigint NOT NULL AUTO_INCREMENT COMMENT '工单ID',
  `order_no` varchar(50) COLLATE utf8mb4_general_ci NOT NULL COMMENT '工单编号',
  `user_id` bigint NOT NULL COMMENT '报修人ID',
  `elevator_id` bigint NOT NULL COMMENT '故障电梯ID',
  `fault_desc` varchar(500) COLLATE utf8mb4_general_ci NOT NULL COMMENT '故障现象描述',
  `fault_type` varchar(30) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '故障类型（abnormal_noise异响 stop停梯 trapped困人 door门故障 button按钮失灵 other其他）',
  `fault_level` char(1) COLLATE utf8mb4_general_ci DEFAULT '1' COMMENT '故障等级（0紧急 1一般）',
  `order_status` varchar(20) COLLATE utf8mb4_general_ci DEFAULT 'pending' COMMENT '工单状态（pending待处理 assigned已派单 accepted已接单 arrived已到场 repairing维修中 repaired已修复 confirmed已完成 rejected已驳回 appealed已申诉）',
  `reporter_phone` varchar(20) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '报修人联系电话',
  `report_time` datetime DEFAULT NULL COMMENT '报修时间',
  `assign_time` datetime DEFAULT NULL COMMENT '派单时间',
  `accept_time` datetime DEFAULT NULL COMMENT '接单时间',
  `arrive_time` datetime DEFAULT NULL COMMENT '到场时间',
  `finish_time` datetime DEFAULT NULL COMMENT '维修完成时间',
  `confirm_time` datetime DEFAULT NULL COMMENT '业主确认时间',
  `assignee_id` bigint DEFAULT NULL COMMENT '维修员ID',
  `assigner_id` bigint DEFAULT NULL COMMENT '派单人ID',
  `reject_reason` varchar(500) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '驳回原因',
  `deadline_time` datetime DEFAULT NULL COMMENT '处理时限',
  `del_flag` char(1) COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`order_id`),
  UNIQUE KEY `uk_order_no` (`order_no`),
  KEY `idx_order_elevator` (`elevator_id`),
  KEY `idx_order_user` (`user_id`),
  KEY `idx_order_assignee` (`assignee_id`),
  KEY `idx_order_status` (`order_status`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='报修工单表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `repair_record`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `repair_record` (
  `record_id` bigint NOT NULL AUTO_INCREMENT COMMENT '记录ID',
  `order_id` bigint NOT NULL COMMENT '关联工单ID',
  `worker_id` bigint NOT NULL COMMENT '维修员ID',
  `arrive_time` datetime DEFAULT NULL COMMENT '到场时间',
  `arrive_location` varchar(200) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '到场定位',
  `arrive_longitude` decimal(10,7) DEFAULT NULL COMMENT '到场时的经度，由浏览器定位取得',
  `arrive_latitude` decimal(10,7) DEFAULT NULL COMMENT '到场时的纬度，由浏览器定位取得',
  `arrive_distance` int DEFAULT NULL COMMENT '到场点与电梯台账坐标的距离（米）',
  `demo_flag` char(1) COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '是否演示打卡（0正常 1演示模式，未做位置校验）',
  `investigate_note` varchar(1000) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '排查记录',
  `repair_desc` varchar(1000) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '维修说明',
  `fault_reason` varchar(30) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '故障原因（normal_wear正常磨损 parts_damage配件损坏 improper_use使用不当 external外因 other其他）',
  `replace_parts` varchar(500) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '更换配件',
  `finish_time` datetime DEFAULT NULL COMMENT '完工时间',
  `result_file_id` bigint DEFAULT NULL COMMENT '完工凭证文件ID',
  `create_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`record_id`),
  KEY `idx_record_order` (`order_id`),
  KEY `idx_record_worker` (`worker_id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='维修记录表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sys_config`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_config` (
  `config_id` int NOT NULL AUTO_INCREMENT COMMENT '参数主键',
  `config_name` varchar(100) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '参数名称',
  `config_key` varchar(100) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '参数键名',
  `config_value` varchar(500) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '参数键值',
  `config_type` char(1) COLLATE utf8mb4_general_ci DEFAULT 'N' COMMENT '系统内置（Y是 N否）',
  `create_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`config_id`)
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='参数配置表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sys_dict_data`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_dict_data` (
  `dict_code` bigint NOT NULL AUTO_INCREMENT COMMENT '字典编码',
  `dict_sort` int DEFAULT '0' COMMENT '字典排序',
  `dict_label` varchar(100) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '字典标签',
  `dict_value` varchar(100) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '字典键值',
  `dict_type` varchar(100) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '字典类型',
  `css_class` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '样式属性（其他样式扩展）',
  `list_class` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '表格回显样式',
  `is_default` char(1) COLLATE utf8mb4_general_ci DEFAULT 'N' COMMENT '是否默认（Y是 N否）',
  `status` char(1) COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_code`)
) ENGINE=InnoDB AUTO_INCREMENT=182 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='字典数据表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sys_dict_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_dict_type` (
  `dict_id` bigint NOT NULL AUTO_INCREMENT COMMENT '字典主键',
  `dict_name` varchar(100) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '字典名称',
  `dict_type` varchar(100) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '字典类型',
  `status` char(1) COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_id`),
  UNIQUE KEY `dict_type` (`dict_type`)
) ENGINE=InnoDB AUTO_INCREMENT=108 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='字典类型表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sys_file`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_file` (
  `file_id` bigint NOT NULL AUTO_INCREMENT COMMENT '文件ID',
  `file_name` varchar(200) COLLATE utf8mb4_general_ci NOT NULL COMMENT '原文件名',
  `file_path` varchar(500) COLLATE utf8mb4_general_ci NOT NULL COMMENT '存储路径',
  `file_url` varchar(500) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '访问地址',
  `file_type` varchar(20) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '文件类型（image图片 video视频 doc文档 excel表格 pdf文档）',
  `file_suffix` varchar(20) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '文件后缀',
  `file_size` bigint DEFAULT '0' COMMENT '文件大小（字节）',
  `biz_type` varchar(30) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '业务类型（elevator_cert电梯证件 repair_evidence报修证据 inspection巡检结果 report导出报表）',
  `biz_id` bigint DEFAULT NULL COMMENT '关联业务ID',
  `upload_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '上传人',
  `upload_time` datetime DEFAULT NULL COMMENT '上传时间',
  `del_flag` char(1) COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  PRIMARY KEY (`file_id`),
  KEY `idx_file_biz` (`biz_type`,`biz_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='文件信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sys_job`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_job` (
  `job_id` bigint NOT NULL AUTO_INCREMENT COMMENT '任务ID',
  `job_name` varchar(64) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '任务名称',
  `job_group` varchar(64) COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'DEFAULT' COMMENT '任务组名',
  `invoke_target` varchar(500) COLLATE utf8mb4_general_ci NOT NULL COMMENT '调用目标字符串',
  `cron_expression` varchar(255) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT 'cron执行表达式',
  `misfire_policy` varchar(20) COLLATE utf8mb4_general_ci DEFAULT '3' COMMENT '计划执行错误策略（1立即执行 2执行一次 3放弃执行）',
  `concurrent` char(1) COLLATE utf8mb4_general_ci DEFAULT '1' COMMENT '是否并发执行（0允许 1禁止）',
  `status` char(1) COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '状态（0正常 1暂停）',
  `create_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '备注信息',
  PRIMARY KEY (`job_id`,`job_name`,`job_group`)
) ENGINE=InnoDB AUTO_INCREMENT=103 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='定时任务调度表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sys_job_log`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_job_log` (
  `job_log_id` bigint NOT NULL AUTO_INCREMENT COMMENT '任务日志ID',
  `job_name` varchar(64) COLLATE utf8mb4_general_ci NOT NULL COMMENT '任务名称',
  `job_group` varchar(64) COLLATE utf8mb4_general_ci NOT NULL COMMENT '任务组名',
  `invoke_target` varchar(500) COLLATE utf8mb4_general_ci NOT NULL COMMENT '调用目标字符串',
  `job_message` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '日志信息',
  `status` char(1) COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '执行状态（0正常 1失败）',
  `exception_info` varchar(2000) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '异常信息',
  `start_time` datetime DEFAULT NULL COMMENT '执行开始时间',
  `end_time` datetime DEFAULT NULL COMMENT '执行结束时间',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`job_log_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='定时任务调度日志表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sys_logininfor`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_logininfor` (
  `info_id` bigint NOT NULL AUTO_INCREMENT COMMENT '访问ID',
  `user_name` varchar(50) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '用户账号',
  `ipaddr` varchar(128) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '登录IP地址',
  `login_location` varchar(255) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '登录地点',
  `browser` varchar(50) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '浏览器类型',
  `os` varchar(50) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '操作系统',
  `status` char(1) COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '登录状态（0成功 1失败）',
  `msg` varchar(255) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '提示消息',
  `login_time` datetime DEFAULT NULL COMMENT '访问时间',
  PRIMARY KEY (`info_id`),
  KEY `idx_sys_logininfor_s` (`status`),
  KEY `idx_sys_logininfor_lt` (`login_time`)
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='系统访问记录';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sys_menu`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_menu` (
  `menu_id` bigint NOT NULL AUTO_INCREMENT COMMENT '菜单ID',
  `menu_name` varchar(50) COLLATE utf8mb4_general_ci NOT NULL COMMENT '菜单名称',
  `parent_id` bigint DEFAULT '0' COMMENT '父菜单ID',
  `order_num` int DEFAULT '0' COMMENT '显示顺序',
  `path` varchar(200) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '路由地址',
  `component` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '组件路径',
  `query` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '路由参数',
  `route_name` varchar(50) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '路由名称',
  `is_frame` int DEFAULT '1' COMMENT '是否为外链（0是 1否）',
  `is_cache` int DEFAULT '0' COMMENT '是否缓存（0缓存 1不缓存）',
  `menu_type` char(1) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '菜单类型（M目录 C菜单 F按钮）',
  `visible` char(1) COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '菜单状态（0显示 1隐藏）',
  `status` char(1) COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '菜单状态（0正常 1停用）',
  `perms` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '权限标识',
  `icon` varchar(100) COLLATE utf8mb4_general_ci DEFAULT '#' COMMENT '菜单图标',
  `create_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '备注',
  PRIMARY KEY (`menu_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2244 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='菜单权限表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sys_notice`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_notice` (
  `notice_id` int NOT NULL AUTO_INCREMENT COMMENT '公告ID',
  `notice_title` varchar(50) COLLATE utf8mb4_general_ci NOT NULL COMMENT '公告标题',
  `notice_type` char(1) COLLATE utf8mb4_general_ci NOT NULL COMMENT '公告类型（1通知 2公告）',
  `notice_content` longblob COMMENT '公告内容',
  `status` char(1) COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '公告状态（0正常 1关闭）',
  `create_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`notice_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='通知公告表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sys_notice_read`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_notice_read` (
  `read_id` bigint NOT NULL AUTO_INCREMENT COMMENT '已读主键',
  `notice_id` int NOT NULL COMMENT '公告id',
  `user_id` bigint NOT NULL COMMENT '用户id',
  `read_time` datetime NOT NULL COMMENT '阅读时间',
  PRIMARY KEY (`read_id`),
  UNIQUE KEY `uk_user_notice` (`user_id`,`notice_id`) COMMENT '同一用户同一公告只记录一次'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='公告已读记录表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sys_oper_log`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_oper_log` (
  `oper_id` bigint NOT NULL AUTO_INCREMENT COMMENT '日志主键',
  `title` varchar(50) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '模块标题',
  `business_type` int DEFAULT '0' COMMENT '业务类型（0其它 1新增 2修改 3删除）',
  `method` varchar(200) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '方法名称',
  `request_method` varchar(10) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '请求方式',
  `operator_type` int DEFAULT '0' COMMENT '操作类别（0其它 1后台用户 2手机端用户）',
  `oper_name` varchar(50) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '操作人员',
  `dept_name` varchar(50) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '部门名称',
  `oper_url` varchar(255) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '请求URL',
  `oper_ip` varchar(128) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '主机地址',
  `oper_location` varchar(255) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '操作地点',
  `oper_param` varchar(2000) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '请求参数',
  `json_result` varchar(2000) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '返回参数',
  `status` int DEFAULT '0' COMMENT '操作状态（0正常 1异常）',
  `error_msg` varchar(2000) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '错误消息',
  `oper_time` datetime DEFAULT NULL COMMENT '操作时间',
  `cost_time` bigint DEFAULT '0' COMMENT '消耗时间',
  PRIMARY KEY (`oper_id`),
  KEY `idx_sys_oper_log_bt` (`business_type`),
  KEY `idx_sys_oper_log_s` (`status`),
  KEY `idx_sys_oper_log_ot` (`oper_time`)
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='操作日志记录';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sys_role`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_role` (
  `role_id` bigint NOT NULL AUTO_INCREMENT COMMENT '角色ID',
  `role_name` varchar(30) COLLATE utf8mb4_general_ci NOT NULL COMMENT '角色名称',
  `role_key` varchar(100) COLLATE utf8mb4_general_ci NOT NULL COMMENT '角色权限字符串',
  `role_sort` int NOT NULL COMMENT '显示顺序',
  `data_scope` char(1) COLLATE utf8mb4_general_ci DEFAULT '1' COMMENT '数据范围（1：全部数据权限 5：仅本人数据权限）',
  `menu_check_strictly` tinyint(1) DEFAULT '1' COMMENT '菜单树选择项是否关联显示',
  `status` char(1) COLLATE utf8mb4_general_ci NOT NULL COMMENT '角色状态（0正常 1停用）',
  `del_flag` char(1) COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`role_id`)
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='角色信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sys_role_menu`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_role_menu` (
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `menu_id` bigint NOT NULL COMMENT '菜单ID',
  PRIMARY KEY (`role_id`,`menu_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='角色和菜单关联表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sys_user`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user` (
  `user_id` bigint NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `user_name` varchar(30) COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户账号',
  `nick_name` varchar(30) COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户昵称',
  `user_type` varchar(2) COLLATE utf8mb4_general_ci DEFAULT '00' COMMENT '用户类型（00系统用户）',
  `email` varchar(50) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '用户邮箱',
  `phonenumber` varchar(11) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '手机号码',
  `sex` char(1) COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '用户性别（0男 1女 2未知）',
  `avatar` varchar(100) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '头像地址',
  `password` varchar(100) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '密码',
  `status` char(1) COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '账号状态（0正常 1停用）',
  `del_flag` char(1) COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `login_ip` varchar(128) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '最后登录IP',
  `login_date` datetime DEFAULT NULL COMMENT '最后登录时间',
  `pwd_update_date` datetime DEFAULT NULL COMMENT '密码最后更新时间',
  `create_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  `community_id` bigint DEFAULT NULL COMMENT '所属小区ID（论文表3-1，用于数据权限按小区隔离）',
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `uk_user_phonenumber` (`phonenumber`)
) ENGINE=InnoDB AUTO_INCREMENT=105 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='用户信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sys_user_role`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user_role` (
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `role_id` bigint NOT NULL COMMENT '角色ID',
  PRIMARY KEY (`user_id`,`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='用户和角色关联表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `warning_info`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `warning_info` (
  `warning_id` bigint NOT NULL AUTO_INCREMENT COMMENT '预警ID',
  `rule_id` bigint DEFAULT NULL COMMENT '触发规则ID',
  `warning_type` varchar(30) COLLATE utf8mb4_general_ci NOT NULL COMMENT '预警类型（order_timeout工单超时 maintain_due维保临期）',
  `biz_sub_type` varchar(30) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '业务子类型',
  `biz_id` bigint DEFAULT NULL COMMENT '关联业务ID，指向工单或维保计划',
  `biz_no` varchar(50) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '关联业务编号',
  `warning_content` varchar(500) COLLATE utf8mb4_general_ci NOT NULL COMMENT '预警内容',
  `elevator_id` bigint DEFAULT NULL COMMENT '关联电梯ID',
  `receiver_id` bigint DEFAULT NULL COMMENT '接收人ID',
  `receiver_role` varchar(30) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '接收人角色',
  `is_read` char(1) COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '是否已读（0未读 1已读）',
  `read_time` datetime DEFAULT NULL COMMENT '阅读时间',
  `warning_time` datetime DEFAULT NULL COMMENT '预警生成时间',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`warning_id`),
  KEY `idx_warning_receiver` (`receiver_id`,`is_read`),
  KEY `idx_warning_biz` (`biz_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='预警信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `warning_rule`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `warning_rule` (
  `rule_id` bigint NOT NULL AUTO_INCREMENT COMMENT '规则ID',
  `rule_name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL COMMENT '规则名称',
  `rule_type` varchar(30) COLLATE utf8mb4_general_ci NOT NULL COMMENT '规则类型（order_timeout工单超时 maintain_due维保临期）',
  `biz_sub_type` varchar(30) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '业务子类型（assign派单超时 accept接单超时 arrive到场超时 repair维修超时 confirm确认超时 due_soon临近维保 overdue已超维保）',
  `threshold_value` int NOT NULL COMMENT '阈值',
  `threshold_unit` varchar(10) COLLATE utf8mb4_general_ci DEFAULT 'minute' COMMENT '阈值单位（minute分钟 hour小时 day天）',
  `notify_roles` varchar(100) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '通知对象角色（多个用逗号分隔，如 property,worker）',
  `enabled` char(1) COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '是否启用（0启用 1停用）',
  `repeat_interval` int DEFAULT '0' COMMENT '重复推送间隔（分钟），0表示同周期不重复推送',
  `create_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`rule_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='预警规则表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `worker_skill`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `worker_skill` (
  `skill_id` bigint NOT NULL AUTO_INCREMENT COMMENT '技能ID',
  `worker_id` bigint NOT NULL COMMENT '维修员ID',
  `community_id` bigint DEFAULT NULL COMMENT '负责小区ID',
  `skill_tags` varchar(200) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '技能标签（多个用逗号分隔，如 曳引机,门系统,控制系统）',
  `work_status` char(1) COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '在岗状态（0在岗 1休息 2请假）',
  `current_load` int DEFAULT '0' COMMENT '当前在手工单数',
  `total_finished` int DEFAULT '0' COMMENT '累计完成工单数',
  `avg_response` int DEFAULT '0' COMMENT '平均响应时长（分钟）',
  `create_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`skill_id`),
  KEY `idx_skill_worker` (`worker_id`),
  KEY `idx_skill_community` (`community_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='维修员技能与负责区域表';
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-12 20:45:59
