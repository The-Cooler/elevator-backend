-- ============================================================
-- 老旧小区电梯故障报修与维保跟踪平台 - 初始数据
--
-- 本文件只含 INSERT 语句，不含建表语句。
-- 执行前必须先跑 elevator_schema.sql 把 43 张表建好。
--
-- 用法：
--   mysql -uroot -p < elevator_schema.sql
--   mysql -uroot -p elevator < elevator_data.sql
--
-- 内容：21 张表共 890 条记录
--   账号与权限：sys_user、sys_role、sys_user_role、sys_menu、sys_role_menu
--   字典与参数：sys_dict_type、sys_dict_data、sys_config
--   定时任务：sys_job
--   基础台账：community、building、elevator
--   报修业务：repair_order、repair_record、order_status_log
--   维保业务：maintain_plan、maintain_item、inspection_record、inspection_item_result
--   预警与技能：warning_rule、worker_skill
--
-- 不含数据：sys_file、sys_notice、sys_notice_read、sys_oper_log、sys_logininfor、
--   sys_job_log、repair_evidence、maintain_archive、elevator_health、warning_info、
--   elevator_notice，这 11 张表在初始状态下为空，由程序运行期写入。
--
-- 可重复执行：每个表在插入前会先清空，重复执行结果一致。
-- ============================================================

USE `elevator`;

-- 先清空，保证脚本可重复执行
SET FOREIGN_KEY_CHECKS = 0;
DELETE FROM `sys_role_menu`;
DELETE FROM `sys_role`;
DELETE FROM `sys_user_role`;
DELETE FROM `sys_user`;
DELETE FROM `sys_menu`;
DELETE FROM `sys_dict_data`;
DELETE FROM `sys_dict_type`;
DELETE FROM `sys_config`;
DELETE FROM `sys_job`;
DELETE FROM `community`;
DELETE FROM `building`;
DELETE FROM `elevator`;
DELETE FROM `worker_skill`;
DELETE FROM `maintain_item`;
DELETE FROM `maintain_plan`;
DELETE FROM `inspection_item_result`;
DELETE FROM `inspection_record`;
DELETE FROM `repair_record`;
DELETE FROM `order_status_log`;
DELETE FROM `repair_order`;
DELETE FROM `warning_rule`;
SET FOREIGN_KEY_CHECKS = 1;

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
-- Dumping data for table `building`
--

LOCK TABLES `building` WRITE;
/*!40000 ALTER TABLE `building` DISABLE KEYS */;
INSERT INTO `building` (`building_id`, `community_id`, `building_no`, `unit_no`, `floor_count`, `status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1,1,'1号楼','1单元',7,'0','0','admin','2026-10-12 20:40:24','',NULL,NULL);
INSERT INTO `building` (`building_id`, `community_id`, `building_no`, `unit_no`, `floor_count`, `status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2,1,'1号楼','2单元',7,'0','0','admin','2026-10-12 20:40:24','',NULL,NULL);
INSERT INTO `building` (`building_id`, `community_id`, `building_no`, `unit_no`, `floor_count`, `status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (3,1,'2号楼','1单元',6,'0','0','admin','2026-10-12 20:40:24','',NULL,NULL);
INSERT INTO `building` (`building_id`, `community_id`, `building_no`, `unit_no`, `floor_count`, `status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (4,2,'3号楼','1单元',6,'0','0','admin','2026-10-12 20:40:24','',NULL,NULL);
INSERT INTO `building` (`building_id`, `community_id`, `building_no`, `unit_no`, `floor_count`, `status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (5,2,'4号楼','1单元',8,'0','0','admin','2026-10-12 20:40:24','',NULL,NULL);
INSERT INTO `building` (`building_id`, `community_id`, `building_no`, `unit_no`, `floor_count`, `status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (6,3,'A座','1单元',11,'0','0','admin','2026-10-12 20:40:24','',NULL,NULL);
/*!40000 ALTER TABLE `building` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `community`
--

LOCK TABLES `community` WRITE;
/*!40000 ALTER TABLE `community` DISABLE KEYS */;
INSERT INTO `community` (`community_id`, `community_name`, `address`, `build_year`, `property_contact`, `property_phone`, `status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1,'阳光家园小区','哈尔滨市南岗区学府路128号','2003','张建国','0451-86001122','0','0','admin','2026-10-12 20:40:24','',NULL,'典型老旧小区，无电梯加装于2021年');
INSERT INTO `community` (`community_id`, `community_name`, `address`, `build_year`, `property_contact`, `property_phone`, `status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2,'和平里小区','哈尔滨市道里区和平路56号','1998','李秀兰','0451-86003344','0','0','admin','2026-10-12 20:40:24','',NULL,'老旧小区，老年居民占比高');
INSERT INTO `community` (`community_id`, `community_name`, `address`, `build_year`, `property_contact`, `property_phone`, `status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (3,'铁路新村小区','哈尔滨市香坊区红旗大街211号','2001','王海涛','0451-86005566','0','0','admin','2026-10-12 20:40:24','',NULL,'原铁路系统职工住宅');
/*!40000 ALTER TABLE `community` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `elevator`
--

LOCK TABLES `elevator` WRITE;
/*!40000 ALTER TABLE `elevator` DISABLE KEYS */;
INSERT INTO `elevator` (`elevator_id`, `elevator_code`, `brand`, `model`, `building_id`, `unit_no`, `maintain_unit`, `install_date`, `service_years`, `cert_file_id`, `status`, `longitude`, `latitude`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1,'DT-A-001','日立','HGE-1000',1,'1单元','黑龙江安捷电梯维保有限公司','2010-06-01',15,NULL,'0',126.6178560,45.7031890,'0','admin','2026-10-12 20:40:24','',NULL,'运行平稳，钢丝绳有轻微磨损');
INSERT INTO `elevator` (`elevator_id`, `elevator_code`, `brand`, `model`, `building_id`, `unit_no`, `maintain_unit`, `install_date`, `service_years`, `cert_file_id`, `status`, `longitude`, `latitude`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2,'DT-A-002','日立','HGE-1000',2,'2单元','黑龙江安捷电梯维保有限公司','2010-06-01',15,NULL,'0',126.6181230,45.7034120,'0','admin','2026-10-12 20:40:24','',NULL,'门系统偶有异响');
INSERT INTO `elevator` (`elevator_id`, `elevator_code`, `brand`, `model`, `building_id`, `unit_no`, `maintain_unit`, `install_date`, `service_years`, `cert_file_id`, `status`, `longitude`, `latitude`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (3,'DT-B-001','三菱','LEHY-III',3,'1单元','哈尔滨华信机电设备有限公司','2012-09-15',13,NULL,'0',126.6185470,45.7028760,'0','admin','2026-10-12 20:40:24','',NULL,'');
INSERT INTO `elevator` (`elevator_id`, `elevator_code`, `brand`, `model`, `building_id`, `unit_no`, `maintain_unit`, `install_date`, `service_years`, `cert_file_id`, `status`, `longitude`, `latitude`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (4,'DT-C-001','通力','KONE-3000',4,'1单元','哈尔滨华信机电设备有限公司','2008-03-20',18,NULL,'1',126.6169120,45.7558320,'0','admin','2026-10-12 20:40:24','',NULL,'使用年限长，已停梯待大修');
INSERT INTO `elevator` (`elevator_id`, `elevator_code`, `brand`, `model`, `building_id`, `unit_no`, `maintain_unit`, `install_date`, `service_years`, `cert_file_id`, `status`, `longitude`, `latitude`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (5,'DT-C-002','奥的斯','OTIS-3200',5,'1单元','黑龙江安捷电梯维保有限公司','2015-11-08',10,NULL,'0',126.6172450,45.7561040,'0','admin','2026-10-12 20:40:24','',NULL,'');
INSERT INTO `elevator` (`elevator_id`, `elevator_code`, `brand`, `model`, `building_id`, `unit_no`, `maintain_unit`, `install_date`, `service_years`, `cert_file_id`, `status`, `longitude`, `latitude`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (6,'DT-D-001','迅达','Schindler-3300',6,'1单元','黑龙江广日电梯工程有限公司','2006-05-12',20,NULL,'0',126.6938960,45.7387050,'0','admin','2026-10-12 20:40:24','',NULL,'老旧电梯，故障率偏高，重点监控');
/*!40000 ALTER TABLE `elevator` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `elevator_health`
--

LOCK TABLES `elevator_health` WRITE;
/*!40000 ALTER TABLE `elevator_health` DISABLE KEYS */;
/*!40000 ALTER TABLE `elevator_health` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `elevator_notice`
--

LOCK TABLES `elevator_notice` WRITE;
/*!40000 ALTER TABLE `elevator_notice` DISABLE KEYS */;
/*!40000 ALTER TABLE `elevator_notice` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `inspection_item_result`
--

LOCK TABLES `inspection_item_result` WRITE;
/*!40000 ALTER TABLE `inspection_item_result` DISABLE KEYS */;
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (1,1,10,'轿厢内应急照明检查','car','normal','',NULL,10);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (2,1,9,'报警装置与对讲检查','car','normal','',NULL,9);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (3,1,8,'轿厢照明与通风检查','car','normal','',NULL,8);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (4,1,7,'控制柜运行状态检查','control','normal','',NULL,7);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (5,1,6,'制动器动作检查','safety','normal','',NULL,6);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (6,1,5,'限速器与安全钳检查','safety','normal','',NULL,5);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (7,1,4,'门锁电气触点检查','door_system','normal','',NULL,4);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (8,1,3,'层门与轿门开合检查','door_system','normal','',NULL,3);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (9,1,2,'钢丝绳磨损与断丝检查','traction','normal','',NULL,2);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (10,1,1,'曳引机运行状态检查','traction','normal','',NULL,1);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (11,2,10,'轿厢内应急照明检查','car','normal','',NULL,10);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (12,2,9,'报警装置与对讲检查','car','normal','',NULL,9);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (13,2,8,'轿厢照明与通风检查','car','normal','',NULL,8);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (14,2,7,'控制柜运行状态检查','control','normal','',NULL,7);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (15,2,6,'制动器动作检查','safety','normal','',NULL,6);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (16,2,5,'限速器与安全钳检查','safety','normal','',NULL,5);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (17,2,4,'门锁电气触点检查','door_system','normal','',NULL,4);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (18,2,3,'层门与轿门开合检查','door_system','normal','',NULL,3);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (19,2,2,'钢丝绳磨损与断丝检查','traction','normal','',NULL,2);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (20,2,1,'曳引机运行状态检查','traction','normal','',NULL,1);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (21,3,10,'轿厢内应急照明检查','car','abnormal','钢丝绳有轻微磨损，未达换绳标准，已记录观察',NULL,10);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (22,3,9,'报警装置与对讲检查','car','normal','',NULL,9);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (23,3,8,'轿厢照明与通风检查','car','normal','',NULL,8);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (24,3,7,'控制柜运行状态检查','control','normal','',NULL,7);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (25,3,6,'制动器动作检查','safety','normal','',NULL,6);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (26,3,5,'限速器与安全钳检查','safety','normal','',NULL,5);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (27,3,4,'门锁电气触点检查','door_system','normal','',NULL,4);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (28,3,3,'层门与轿门开合检查','door_system','normal','',NULL,3);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (29,3,2,'钢丝绳磨损与断丝检查','traction','normal','',NULL,2);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (30,3,1,'曳引机运行状态检查','traction','normal','',NULL,1);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (31,4,10,'轿厢内应急照明检查','car','normal','',NULL,10);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (32,4,9,'报警装置与对讲检查','car','normal','',NULL,9);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (33,4,8,'轿厢照明与通风检查','car','normal','',NULL,8);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (34,4,7,'控制柜运行状态检查','control','normal','',NULL,7);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (35,4,6,'制动器动作检查','safety','normal','',NULL,6);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (36,4,5,'限速器与安全钳检查','safety','normal','',NULL,5);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (37,4,4,'门锁电气触点检查','door_system','normal','',NULL,4);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (38,4,3,'层门与轿门开合检查','door_system','normal','',NULL,3);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (39,4,2,'钢丝绳磨损与断丝检查','traction','normal','',NULL,2);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (40,4,1,'曳引机运行状态检查','traction','normal','',NULL,1);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (41,5,18,'补偿链与随行电缆检查','other','abnormal','轿厢内应急照明电池电量偏低，已更换',NULL,8);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (42,5,17,'井道照明与底坑检查','other','normal','',NULL,7);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (43,5,16,'接地保护与绝缘检查','control','normal','',NULL,6);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (44,5,15,'超载装置动作检查','safety','normal','',NULL,5);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (45,5,14,'平层准确度检查','control','normal','',NULL,4);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (46,5,13,'导轨与导靴磨损检查','traction','normal','',NULL,3);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (47,5,12,'钢丝绳张力均衡检查','traction','normal','',NULL,2);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (48,5,11,'曳引机减速箱油质检查','traction','normal','',NULL,1);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (49,6,10,'轿厢内应急照明检查','car','abnormal','层门开合有卡阻，已调整门机',NULL,10);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (50,6,9,'报警装置与对讲检查','car','normal','',NULL,9);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (51,6,8,'轿厢照明与通风检查','car','normal','',NULL,8);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (52,6,7,'控制柜运行状态检查','control','normal','',NULL,7);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (53,6,6,'制动器动作检查','safety','normal','',NULL,6);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (54,6,5,'限速器与安全钳检查','safety','normal','',NULL,5);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (55,6,4,'门锁电气触点检查','door_system','normal','',NULL,4);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (56,6,3,'层门与轿门开合检查','door_system','normal','',NULL,3);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (57,6,2,'钢丝绳磨损与断丝检查','traction','normal','',NULL,2);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (58,6,1,'曳引机运行状态检查','traction','normal','',NULL,1);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (59,7,10,'轿厢内应急照明检查','car','abnormal','门锁电气触点有轻微烧蚀，已打磨处理',NULL,10);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (60,7,9,'报警装置与对讲检查','car','normal','',NULL,9);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (61,7,8,'轿厢照明与通风检查','car','normal','',NULL,8);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (62,7,7,'控制柜运行状态检查','control','normal','',NULL,7);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (63,7,6,'制动器动作检查','safety','normal','',NULL,6);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (64,7,5,'限速器与安全钳检查','safety','normal','',NULL,5);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (65,7,4,'门锁电气触点检查','door_system','normal','',NULL,4);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (66,7,3,'层门与轿门开合检查','door_system','normal','',NULL,3);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (67,7,2,'钢丝绳磨损与断丝检查','traction','normal','',NULL,2);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (68,7,1,'曳引机运行状态检查','traction','normal','',NULL,1);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (69,8,10,'轿厢内应急照明检查','car','abnormal','层门闭合到位但仍有异响',NULL,10);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (70,8,9,'报警装置与对讲检查','car','normal','',NULL,9);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (71,8,8,'轿厢照明与通风检查','car','normal','',NULL,8);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (72,8,7,'控制柜运行状态检查','control','normal','',NULL,7);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (73,8,6,'制动器动作检查','safety','normal','',NULL,6);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (74,8,5,'限速器与安全钳检查','safety','normal','',NULL,5);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (75,8,4,'门锁电气触点检查','door_system','normal','',NULL,4);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (76,8,3,'层门与轿门开合检查','door_system','normal','',NULL,3);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (77,8,2,'钢丝绳磨损与断丝检查','traction','normal','',NULL,2);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (78,8,1,'曳引机运行状态检查','traction','normal','',NULL,1);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (79,9,10,'轿厢内应急照明检查','car','abnormal','门机皮带磨损，建议下次维保更换',NULL,10);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (80,9,9,'报警装置与对讲检查','car','normal','',NULL,9);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (81,9,8,'轿厢照明与通风检查','car','normal','',NULL,8);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (82,9,7,'控制柜运行状态检查','control','normal','',NULL,7);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (83,9,6,'制动器动作检查','safety','normal','',NULL,6);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (84,9,5,'限速器与安全钳检查','safety','normal','',NULL,5);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (85,9,4,'门锁电气触点检查','door_system','normal','',NULL,4);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (86,9,3,'层门与轿门开合检查','door_system','normal','',NULL,3);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (87,9,2,'钢丝绳磨损与断丝检查','traction','normal','',NULL,2);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (88,9,1,'曳引机运行状态检查','traction','normal','',NULL,1);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (89,10,18,'补偿链与随行电缆检查','other','abnormal','平层准确度偏差接近上限，已重新校准',NULL,8);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (90,10,17,'井道照明与底坑检查','other','normal','',NULL,7);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (91,10,16,'接地保护与绝缘检查','control','normal','',NULL,6);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (92,10,15,'超载装置动作检查','safety','normal','',NULL,5);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (93,10,14,'平层准确度检查','control','normal','',NULL,4);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (94,10,13,'导轨与导靴磨损检查','traction','normal','',NULL,3);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (95,10,12,'钢丝绳张力均衡检查','traction','normal','',NULL,2);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (96,10,11,'曳引机减速箱油质检查','traction','normal','',NULL,1);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (97,11,10,'轿厢内应急照明检查','car','normal','',NULL,10);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (98,11,9,'报警装置与对讲检查','car','normal','',NULL,9);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (99,11,8,'轿厢照明与通风检查','car','normal','',NULL,8);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (100,11,7,'控制柜运行状态检查','control','normal','',NULL,7);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (101,11,6,'制动器动作检查','safety','normal','',NULL,6);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (102,11,5,'限速器与安全钳检查','safety','normal','',NULL,5);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (103,11,4,'门锁电气触点检查','door_system','normal','',NULL,4);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (104,11,3,'层门与轿门开合检查','door_system','normal','',NULL,3);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (105,11,2,'钢丝绳磨损与断丝检查','traction','normal','',NULL,2);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (106,11,1,'曳引机运行状态检查','traction','normal','',NULL,1);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (107,12,10,'轿厢内应急照明检查','car','normal','',NULL,10);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (108,12,9,'报警装置与对讲检查','car','normal','',NULL,9);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (109,12,8,'轿厢照明与通风检查','car','normal','',NULL,8);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (110,12,7,'控制柜运行状态检查','control','normal','',NULL,7);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (111,12,6,'制动器动作检查','safety','normal','',NULL,6);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (112,12,5,'限速器与安全钳检查','safety','normal','',NULL,5);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (113,12,4,'门锁电气触点检查','door_system','normal','',NULL,4);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (114,12,3,'层门与轿门开合检查','door_system','normal','',NULL,3);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (115,12,2,'钢丝绳磨损与断丝检查','traction','normal','',NULL,2);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (116,12,1,'曳引机运行状态检查','traction','normal','',NULL,1);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (117,13,10,'轿厢内应急照明检查','car','abnormal','控制柜接触器动作有轻微异响',NULL,10);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (118,13,9,'报警装置与对讲检查','car','normal','',NULL,9);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (119,13,8,'轿厢照明与通风检查','car','normal','',NULL,8);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (120,13,7,'控制柜运行状态检查','control','normal','',NULL,7);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (121,13,6,'制动器动作检查','safety','normal','',NULL,6);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (122,13,5,'限速器与安全钳检查','safety','normal','',NULL,5);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (123,13,4,'门锁电气触点检查','door_system','normal','',NULL,4);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (124,13,3,'层门与轿门开合检查','door_system','normal','',NULL,3);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (125,13,2,'钢丝绳磨损与断丝检查','traction','normal','',NULL,2);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (126,13,1,'曳引机运行状态检查','traction','normal','',NULL,1);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (127,14,18,'补偿链与随行电缆检查','other','abnormal','底坑有少量积水，已清理并疏通排水',NULL,8);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (128,14,17,'井道照明与底坑检查','other','normal','',NULL,7);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (129,14,16,'接地保护与绝缘检查','control','normal','',NULL,6);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (130,14,15,'超载装置动作检查','safety','normal','',NULL,5);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (131,14,14,'平层准确度检查','control','normal','',NULL,4);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (132,14,13,'导轨与导靴磨损检查','traction','normal','',NULL,3);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (133,14,12,'钢丝绳张力均衡检查','traction','normal','',NULL,2);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (134,14,11,'曳引机减速箱油质检查','traction','normal','',NULL,1);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (135,15,10,'轿厢内应急照明检查','car','abnormal','曳引机减速箱油质乳化，钢丝绳锈蚀，已上报大修',NULL,10);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (136,15,9,'报警装置与对讲检查','car','normal','',NULL,9);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (137,15,8,'轿厢照明与通风检查','car','normal','',NULL,8);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (138,15,7,'控制柜运行状态检查','control','normal','',NULL,7);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (139,15,6,'制动器动作检查','safety','normal','',NULL,6);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (140,15,5,'限速器与安全钳检查','safety','normal','',NULL,5);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (141,15,4,'门锁电气触点检查','door_system','normal','',NULL,4);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (142,15,3,'层门与轿门开合检查','door_system','normal','',NULL,3);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (143,15,2,'钢丝绳磨损与断丝检查','traction','normal','',NULL,2);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (144,15,1,'曳引机运行状态检查','traction','normal','',NULL,1);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (145,16,10,'轿厢内应急照明检查','car','abnormal','制动器间隙超标，限速器动作不灵活，已停梯',NULL,10);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (146,16,9,'报警装置与对讲检查','car','normal','',NULL,9);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (147,16,8,'轿厢照明与通风检查','car','normal','',NULL,8);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (148,16,7,'控制柜运行状态检查','control','normal','',NULL,7);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (149,16,6,'制动器动作检查','safety','normal','',NULL,6);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (150,16,5,'限速器与安全钳检查','safety','normal','',NULL,5);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (151,16,4,'门锁电气触点检查','door_system','normal','',NULL,4);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (152,16,3,'层门与轿门开合检查','door_system','normal','',NULL,3);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (153,16,2,'钢丝绳磨损与断丝检查','traction','normal','',NULL,2);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (154,16,1,'曳引机运行状态检查','traction','normal','',NULL,1);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (155,17,10,'轿厢内应急照明检查','car','normal','',NULL,10);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (156,17,9,'报警装置与对讲检查','car','normal','',NULL,9);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (157,17,8,'轿厢照明与通风检查','car','normal','',NULL,8);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (158,17,7,'控制柜运行状态检查','control','normal','',NULL,7);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (159,17,6,'制动器动作检查','safety','normal','',NULL,6);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (160,17,5,'限速器与安全钳检查','safety','normal','',NULL,5);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (161,17,4,'门锁电气触点检查','door_system','normal','',NULL,4);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (162,17,3,'层门与轿门开合检查','door_system','normal','',NULL,3);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (163,17,2,'钢丝绳磨损与断丝检查','traction','normal','',NULL,2);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (164,17,1,'曳引机运行状态检查','traction','normal','',NULL,1);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (165,18,10,'轿厢内应急照明检查','car','normal','',NULL,10);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (166,18,9,'报警装置与对讲检查','car','normal','',NULL,9);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (167,18,8,'轿厢照明与通风检查','car','normal','',NULL,8);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (168,18,7,'控制柜运行状态检查','control','normal','',NULL,7);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (169,18,6,'制动器动作检查','safety','normal','',NULL,6);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (170,18,5,'限速器与安全钳检查','safety','normal','',NULL,5);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (171,18,4,'门锁电气触点检查','door_system','normal','',NULL,4);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (172,18,3,'层门与轿门开合检查','door_system','normal','',NULL,3);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (173,18,2,'钢丝绳磨损与断丝检查','traction','normal','',NULL,2);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (174,18,1,'曳引机运行状态检查','traction','normal','',NULL,1);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (175,19,10,'轿厢内应急照明检查','car','normal','',NULL,10);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (176,19,9,'报警装置与对讲检查','car','normal','',NULL,9);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (177,19,8,'轿厢照明与通风检查','car','normal','',NULL,8);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (178,19,7,'控制柜运行状态检查','control','normal','',NULL,7);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (179,19,6,'制动器动作检查','safety','normal','',NULL,6);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (180,19,5,'限速器与安全钳检查','safety','normal','',NULL,5);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (181,19,4,'门锁电气触点检查','door_system','normal','',NULL,4);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (182,19,3,'层门与轿门开合检查','door_system','normal','',NULL,3);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (183,19,2,'钢丝绳磨损与断丝检查','traction','normal','',NULL,2);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (184,19,1,'曳引机运行状态检查','traction','normal','',NULL,1);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (185,20,10,'轿厢内应急照明检查','car','normal','',NULL,10);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (186,20,9,'报警装置与对讲检查','car','normal','',NULL,9);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (187,20,8,'轿厢照明与通风检查','car','normal','',NULL,8);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (188,20,7,'控制柜运行状态检查','control','normal','',NULL,7);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (189,20,6,'制动器动作检查','safety','normal','',NULL,6);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (190,20,5,'限速器与安全钳检查','safety','normal','',NULL,5);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (191,20,4,'门锁电气触点检查','door_system','normal','',NULL,4);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (192,20,3,'层门与轿门开合检查','door_system','normal','',NULL,3);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (193,20,2,'钢丝绳磨损与断丝检查','traction','normal','',NULL,2);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (194,20,1,'曳引机运行状态检查','traction','normal','',NULL,1);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (195,21,10,'轿厢内应急照明检查','car','normal','',NULL,10);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (196,21,9,'报警装置与对讲检查','car','normal','',NULL,9);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (197,21,8,'轿厢照明与通风检查','car','normal','',NULL,8);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (198,21,7,'控制柜运行状态检查','control','normal','',NULL,7);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (199,21,6,'制动器动作检查','safety','normal','',NULL,6);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (200,21,5,'限速器与安全钳检查','safety','normal','',NULL,5);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (201,21,4,'门锁电气触点检查','door_system','normal','',NULL,4);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (202,21,3,'层门与轿门开合检查','door_system','normal','',NULL,3);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (203,21,2,'钢丝绳磨损与断丝检查','traction','normal','',NULL,2);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (204,21,1,'曳引机运行状态检查','traction','normal','',NULL,1);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (205,22,18,'补偿链与随行电缆检查','other','normal','',NULL,8);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (206,22,17,'井道照明与底坑检查','other','normal','',NULL,7);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (207,22,16,'接地保护与绝缘检查','control','normal','',NULL,6);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (208,22,15,'超载装置动作检查','safety','normal','',NULL,5);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (209,22,14,'平层准确度检查','control','normal','',NULL,4);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (210,22,13,'导轨与导靴磨损检查','traction','normal','',NULL,3);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (211,22,12,'钢丝绳张力均衡检查','traction','normal','',NULL,2);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (212,22,11,'曳引机减速箱油质检查','traction','normal','',NULL,1);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (213,23,10,'轿厢内应急照明检查','car','abnormal','曳引机运行振动偏大，钢丝绳断丝 3 根',NULL,10);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (214,23,9,'报警装置与对讲检查','car','normal','',NULL,9);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (215,23,8,'轿厢照明与通风检查','car','normal','',NULL,8);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (216,23,7,'控制柜运行状态检查','control','normal','',NULL,7);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (217,23,6,'制动器动作检查','safety','normal','',NULL,6);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (218,23,5,'限速器与安全钳检查','safety','normal','',NULL,5);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (219,23,4,'门锁电气触点检查','door_system','normal','',NULL,4);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (220,23,3,'层门与轿门开合检查','door_system','normal','',NULL,3);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (221,23,2,'钢丝绳磨损与断丝检查','traction','normal','',NULL,2);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (222,23,1,'曳引机运行状态检查','traction','normal','',NULL,1);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (223,24,10,'轿厢内应急照明检查','car','abnormal','制动器动作迟缓，平层偏差超标',NULL,10);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (224,24,9,'报警装置与对讲检查','car','normal','',NULL,9);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (225,24,8,'轿厢照明与通风检查','car','normal','',NULL,8);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (226,24,7,'控制柜运行状态检查','control','normal','',NULL,7);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (227,24,6,'制动器动作检查','safety','normal','',NULL,6);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (228,24,5,'限速器与安全钳检查','safety','normal','',NULL,5);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (229,24,4,'门锁电气触点检查','door_system','normal','',NULL,4);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (230,24,3,'层门与轿门开合检查','door_system','normal','',NULL,3);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (231,24,2,'钢丝绳磨损与断丝检查','traction','normal','',NULL,2);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (232,24,1,'曳引机运行状态检查','traction','normal','',NULL,1);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (233,25,10,'轿厢内应急照明检查','car','abnormal','层门卡阻，门锁触点烧蚀，已临时处理',NULL,10);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (234,25,9,'报警装置与对讲检查','car','normal','',NULL,9);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (235,25,8,'轿厢照明与通风检查','car','normal','',NULL,8);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (236,25,7,'控制柜运行状态检查','control','normal','',NULL,7);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (237,25,6,'制动器动作检查','safety','normal','',NULL,6);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (238,25,5,'限速器与安全钳检查','safety','normal','',NULL,5);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (239,25,4,'门锁电气触点检查','door_system','normal','',NULL,4);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (240,25,3,'层门与轿门开合检查','door_system','normal','',NULL,3);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (241,25,2,'钢丝绳磨损与断丝检查','traction','normal','',NULL,2);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (242,25,1,'曳引机运行状态检查','traction','normal','',NULL,1);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (243,26,10,'轿厢内应急照明检查','car','abnormal','控制柜接触器频繁动作，触点磨损明显',NULL,10);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (244,26,9,'报警装置与对讲检查','car','normal','',NULL,9);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (245,26,8,'轿厢照明与通风检查','car','normal','',NULL,8);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (246,26,7,'控制柜运行状态检查','control','normal','',NULL,7);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (247,26,6,'制动器动作检查','safety','normal','',NULL,6);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (248,26,5,'限速器与安全钳检查','safety','normal','',NULL,5);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (249,26,4,'门锁电气触点检查','door_system','normal','',NULL,4);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (250,26,3,'层门与轿门开合检查','door_system','normal','',NULL,3);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (251,26,2,'钢丝绳磨损与断丝检查','traction','normal','',NULL,2);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (252,26,1,'曳引机运行状态检查','traction','normal','',NULL,1);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (253,27,10,'轿厢内应急照明检查','car','abnormal','导轨润滑不足，导靴磨损量接近上限',NULL,10);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (254,27,9,'报警装置与对讲检查','car','normal','',NULL,9);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (255,27,8,'轿厢照明与通风检查','car','normal','',NULL,8);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (256,27,7,'控制柜运行状态检查','control','normal','',NULL,7);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (257,27,6,'制动器动作检查','safety','normal','',NULL,6);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (258,27,5,'限速器与安全钳检查','safety','normal','',NULL,5);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (259,27,4,'门锁电气触点检查','door_system','normal','',NULL,4);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (260,27,3,'层门与轿门开合检查','door_system','normal','',NULL,3);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (261,27,2,'钢丝绳磨损与断丝检查','traction','normal','',NULL,2);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (262,27,1,'曳引机运行状态检查','traction','normal','',NULL,1);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (263,28,18,'补偿链与随行电缆检查','other','abnormal','补偿链磨损，随行电缆保护层破损',NULL,8);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (264,28,17,'井道照明与底坑检查','other','normal','',NULL,7);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (265,28,16,'接地保护与绝缘检查','control','normal','',NULL,6);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (266,28,15,'超载装置动作检查','safety','normal','',NULL,5);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (267,28,14,'平层准确度检查','control','normal','',NULL,4);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (268,28,13,'导轨与导靴磨损检查','traction','normal','',NULL,3);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (269,28,12,'钢丝绳张力均衡检查','traction','normal','',NULL,2);
INSERT INTO `inspection_item_result` (`result_id`, `record_id`, `item_id`, `item_name`, `item_category`, `check_result`, `abnormal_desc`, `file_id`, `order_num`) VALUES (270,28,11,'曳引机减速箱油质检查','traction','normal','',NULL,1);
/*!40000 ALTER TABLE `inspection_item_result` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `inspection_record`
--

LOCK TABLES `inspection_record` WRITE;
/*!40000 ALTER TABLE `inspection_record` DISABLE KEYS */;
INSERT INTO `inspection_record` (`record_id`, `record_no`, `plan_id`, `elevator_id`, `maintain_type`, `plan_date`, `executor_id`, `clock_in_time`, `clock_in_location`, `clock_in_longitude`, `clock_in_latitude`, `clock_in_distance`, `demo_flag`, `execute_date`, `execute_result`, `abnormal_desc`, `normal_count`, `abnormal_count`, `na_count`, `record_status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (1,'XJ20260716100001',1,1,'half_month','2026-07-16',101,'2026-07-16 09:12:00','阳光家园小区1号楼1单元电梯机房',NULL,NULL,NULL,'0','2026-07-16','normal','',10,0,0,'finished','0','admin','2026-10-12 20:40:24','',NULL);
INSERT INTO `inspection_record` (`record_id`, `record_no`, `plan_id`, `elevator_id`, `maintain_type`, `plan_date`, `executor_id`, `clock_in_time`, `clock_in_location`, `clock_in_longitude`, `clock_in_latitude`, `clock_in_distance`, `demo_flag`, `execute_date`, `execute_result`, `abnormal_desc`, `normal_count`, `abnormal_count`, `na_count`, `record_status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (2,'XJ20260801090002',1,1,'half_month','2026-08-01',101,'2026-08-01 09:05:00','阳光家园小区1号楼1单元电梯机房',NULL,NULL,NULL,'0','2026-08-01','normal','',10,0,0,'finished','0','admin','2026-10-12 20:40:24','',NULL);
INSERT INTO `inspection_record` (`record_id`, `record_no`, `plan_id`, `elevator_id`, `maintain_type`, `plan_date`, `executor_id`, `clock_in_time`, `clock_in_location`, `clock_in_longitude`, `clock_in_latitude`, `clock_in_distance`, `demo_flag`, `execute_date`, `execute_result`, `abnormal_desc`, `normal_count`, `abnormal_count`, `na_count`, `record_status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (3,'XJ20260816091003',1,1,'half_month','2026-08-16',101,'2026-08-16 09:20:00','阳光家园小区1号楼1单元电梯机房',NULL,NULL,NULL,'0','2026-08-16','abnormal','钢丝绳有轻微磨损，未达换绳标准，已记录观察',9,1,0,'finished','0','admin','2026-10-12 20:40:24','',NULL);
INSERT INTO `inspection_record` (`record_id`, `record_no`, `plan_id`, `elevator_id`, `maintain_type`, `plan_date`, `executor_id`, `clock_in_time`, `clock_in_location`, `clock_in_longitude`, `clock_in_latitude`, `clock_in_distance`, `demo_flag`, `execute_date`, `execute_result`, `abnormal_desc`, `normal_count`, `abnormal_count`, `na_count`, `record_status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (4,'XJ20260901090504',1,1,'half_month','2026-09-01',101,'2026-09-01 09:02:00','阳光家园小区1号楼1单元电梯机房',NULL,NULL,NULL,'0','2026-09-01','normal','',10,0,0,'finished','0','admin','2026-10-12 20:40:24','',NULL);
INSERT INTO `inspection_record` (`record_id`, `record_no`, `plan_id`, `elevator_id`, `maintain_type`, `plan_date`, `executor_id`, `clock_in_time`, `clock_in_location`, `clock_in_longitude`, `clock_in_latitude`, `clock_in_distance`, `demo_flag`, `execute_date`, `execute_result`, `abnormal_desc`, `normal_count`, `abnormal_count`, `na_count`, `record_status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (5,'XJ20260916091505',1,1,'quarter','2026-09-16',101,'2026-09-16 09:35:00','阳光家园小区1号楼1单元电梯机房',NULL,NULL,NULL,'0','2026-09-16','abnormal','轿厢内应急照明电池电量偏低，已更换',9,1,0,'finished','0','admin','2026-10-12 20:40:24','',NULL);
INSERT INTO `inspection_record` (`record_id`, `record_no`, `plan_id`, `elevator_id`, `maintain_type`, `plan_date`, `executor_id`, `clock_in_time`, `clock_in_location`, `clock_in_longitude`, `clock_in_latitude`, `clock_in_distance`, `demo_flag`, `execute_date`, `execute_result`, `abnormal_desc`, `normal_count`, `abnormal_count`, `na_count`, `record_status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (6,'XJ20260716103006',2,2,'half_month','2026-07-16',101,'2026-07-16 10:30:00','阳光家园小区1号楼2单元电梯机房',NULL,NULL,NULL,'0','2026-07-16','abnormal','层门开合有卡阻，已调整门机',9,1,0,'finished','0','admin','2026-10-12 20:40:24','',NULL);
INSERT INTO `inspection_record` (`record_id`, `record_no`, `plan_id`, `elevator_id`, `maintain_type`, `plan_date`, `executor_id`, `clock_in_time`, `clock_in_location`, `clock_in_longitude`, `clock_in_latitude`, `clock_in_distance`, `demo_flag`, `execute_date`, `execute_result`, `abnormal_desc`, `normal_count`, `abnormal_count`, `na_count`, `record_status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (7,'XJ20260801102007',2,2,'half_month','2026-08-01',101,'2026-08-01 10:22:00','阳光家园小区1号楼2单元电梯机房',NULL,NULL,NULL,'0','2026-08-01','abnormal','门锁电气触点有轻微烧蚀，已打磨处理',9,1,0,'finished','0','admin','2026-10-12 20:40:24','',NULL);
INSERT INTO `inspection_record` (`record_id`, `record_no`, `plan_id`, `elevator_id`, `maintain_type`, `plan_date`, `executor_id`, `clock_in_time`, `clock_in_location`, `clock_in_longitude`, `clock_in_latitude`, `clock_in_distance`, `demo_flag`, `execute_date`, `execute_result`, `abnormal_desc`, `normal_count`, `abnormal_count`, `na_count`, `record_status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (8,'XJ20260816104508',2,2,'half_month','2026-08-16',101,'2026-08-16 10:45:00','阳光家园小区1号楼2单元电梯机房',NULL,NULL,NULL,'0','2026-08-16','abnormal','层门闭合到位但仍有异响',9,1,0,'finished','0','admin','2026-10-12 20:40:24','',NULL);
INSERT INTO `inspection_record` (`record_id`, `record_no`, `plan_id`, `elevator_id`, `maintain_type`, `plan_date`, `executor_id`, `clock_in_time`, `clock_in_location`, `clock_in_longitude`, `clock_in_latitude`, `clock_in_distance`, `demo_flag`, `execute_date`, `execute_result`, `abnormal_desc`, `normal_count`, `abnormal_count`, `na_count`, `record_status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (9,'XJ20260901103209',2,2,'half_month','2026-09-01',101,'2026-09-01 10:32:00','阳光家园小区1号楼2单元电梯机房',NULL,NULL,NULL,'0','2026-09-01','abnormal','门机皮带磨损，建议下次维保更换',9,1,0,'finished','0','admin','2026-10-12 20:40:24','',NULL);
INSERT INTO `inspection_record` (`record_id`, `record_no`, `plan_id`, `elevator_id`, `maintain_type`, `plan_date`, `executor_id`, `clock_in_time`, `clock_in_location`, `clock_in_longitude`, `clock_in_latitude`, `clock_in_distance`, `demo_flag`, `execute_date`, `execute_result`, `abnormal_desc`, `normal_count`, `abnormal_count`, `na_count`, `record_status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (10,'XJ20260916110010',2,2,'quarter','2026-09-16',101,'2026-09-16 11:00:00','阳光家园小区1号楼2单元电梯机房',NULL,NULL,NULL,'0','2026-09-16','abnormal','平层准确度偏差接近上限，已重新校准',9,1,0,'finished','0','admin','2026-10-12 20:40:24','',NULL);
INSERT INTO `inspection_record` (`record_id`, `record_no`, `plan_id`, `elevator_id`, `maintain_type`, `plan_date`, `executor_id`, `clock_in_time`, `clock_in_location`, `clock_in_longitude`, `clock_in_latitude`, `clock_in_distance`, `demo_flag`, `execute_date`, `execute_result`, `abnormal_desc`, `normal_count`, `abnormal_count`, `na_count`, `record_status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (11,'XJ20260720140011',3,3,'half_month','2026-07-20',103,'2026-07-20 14:10:00','阳光家园小区2号楼1单元电梯机房',NULL,NULL,NULL,'0','2026-07-20','normal','',10,0,0,'finished','0','admin','2026-10-12 20:40:24','',NULL);
INSERT INTO `inspection_record` (`record_id`, `record_no`, `plan_id`, `elevator_id`, `maintain_type`, `plan_date`, `executor_id`, `clock_in_time`, `clock_in_location`, `clock_in_longitude`, `clock_in_latitude`, `clock_in_distance`, `demo_flag`, `execute_date`, `execute_result`, `abnormal_desc`, `normal_count`, `abnormal_count`, `na_count`, `record_status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (12,'XJ20260805141012',3,3,'half_month','2026-08-05',103,'2026-08-05 14:12:00','阳光家园小区2号楼1单元电梯机房',NULL,NULL,NULL,'0','2026-08-05','normal','',10,0,0,'finished','0','admin','2026-10-12 20:40:24','',NULL);
INSERT INTO `inspection_record` (`record_id`, `record_no`, `plan_id`, `elevator_id`, `maintain_type`, `plan_date`, `executor_id`, `clock_in_time`, `clock_in_location`, `clock_in_longitude`, `clock_in_latitude`, `clock_in_distance`, `demo_flag`, `execute_date`, `execute_result`, `abnormal_desc`, `normal_count`, `abnormal_count`, `na_count`, `record_status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (13,'XJ20260820142013',3,3,'half_month','2026-08-20',103,'2026-08-20 14:20:00','阳光家园小区2号楼1单元电梯机房',NULL,NULL,NULL,'0','2026-08-20','abnormal','控制柜接触器动作有轻微异响',9,1,0,'finished','0','admin','2026-10-12 20:40:24','',NULL);
INSERT INTO `inspection_record` (`record_id`, `record_no`, `plan_id`, `elevator_id`, `maintain_type`, `plan_date`, `executor_id`, `clock_in_time`, `clock_in_location`, `clock_in_longitude`, `clock_in_latitude`, `clock_in_distance`, `demo_flag`, `execute_date`, `execute_result`, `abnormal_desc`, `normal_count`, `abnormal_count`, `na_count`, `record_status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (14,'XJ20260920143014',3,3,'quarter','2026-09-20',103,'2026-09-20 14:30:00','阳光家园小区2号楼1单元电梯机房',NULL,NULL,NULL,'0','2026-09-20','abnormal','底坑有少量积水，已清理并疏通排水',9,1,0,'finished','0','admin','2026-10-12 20:40:24','',NULL);
INSERT INTO `inspection_record` (`record_id`, `record_no`, `plan_id`, `elevator_id`, `maintain_type`, `plan_date`, `executor_id`, `clock_in_time`, `clock_in_location`, `clock_in_longitude`, `clock_in_latitude`, `clock_in_distance`, `demo_flag`, `execute_date`, `execute_result`, `abnormal_desc`, `normal_count`, `abnormal_count`, `na_count`, `record_status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (15,'XJ20260710150015',4,4,'half_month','2026-07-10',103,'2026-07-10 15:05:00','和平里小区3号楼1单元电梯机房',NULL,NULL,NULL,'0','2026-07-10','abnormal','曳引机减速箱油质乳化，钢丝绳锈蚀，已上报大修',7,3,0,'finished','0','admin','2026-10-12 20:40:24','',NULL);
INSERT INTO `inspection_record` (`record_id`, `record_no`, `plan_id`, `elevator_id`, `maintain_type`, `plan_date`, `executor_id`, `clock_in_time`, `clock_in_location`, `clock_in_longitude`, `clock_in_latitude`, `clock_in_distance`, `demo_flag`, `execute_date`, `execute_result`, `abnormal_desc`, `normal_count`, `abnormal_count`, `na_count`, `record_status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (16,'XJ20260725151016',4,4,'half_month','2026-07-25',103,'2026-07-25 15:10:00','和平里小区3号楼1单元电梯机房',NULL,NULL,NULL,'0','2026-07-25','abnormal','制动器间隙超标，限速器动作不灵活，已停梯',7,3,0,'finished','0','admin','2026-10-12 20:40:24','',NULL);
INSERT INTO `inspection_record` (`record_id`, `record_no`, `plan_id`, `elevator_id`, `maintain_type`, `plan_date`, `executor_id`, `clock_in_time`, `clock_in_location`, `clock_in_longitude`, `clock_in_latitude`, `clock_in_distance`, `demo_flag`, `execute_date`, `execute_result`, `abnormal_desc`, `normal_count`, `abnormal_count`, `na_count`, `record_status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (17,'XJ20260715160017',5,5,'half_month','2026-07-15',104,'2026-07-15 16:00:00','和平里小区4号楼1单元电梯机房',NULL,NULL,NULL,'0','2026-07-15','normal','',10,0,0,'finished','0','admin','2026-10-12 20:40:24','',NULL);
INSERT INTO `inspection_record` (`record_id`, `record_no`, `plan_id`, `elevator_id`, `maintain_type`, `plan_date`, `executor_id`, `clock_in_time`, `clock_in_location`, `clock_in_longitude`, `clock_in_latitude`, `clock_in_distance`, `demo_flag`, `execute_date`, `execute_result`, `abnormal_desc`, `normal_count`, `abnormal_count`, `na_count`, `record_status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (18,'XJ20260730160518',5,5,'half_month','2026-07-30',104,'2026-07-30 16:05:00','和平里小区4号楼1单元电梯机房',NULL,NULL,NULL,'0','2026-07-30','normal','',10,0,0,'finished','0','admin','2026-10-12 20:40:24','',NULL);
INSERT INTO `inspection_record` (`record_id`, `record_no`, `plan_id`, `elevator_id`, `maintain_type`, `plan_date`, `executor_id`, `clock_in_time`, `clock_in_location`, `clock_in_longitude`, `clock_in_latitude`, `clock_in_distance`, `demo_flag`, `execute_date`, `execute_result`, `abnormal_desc`, `normal_count`, `abnormal_count`, `na_count`, `record_status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (19,'XJ20260814161019',5,5,'half_month','2026-08-14',104,'2026-08-14 16:10:00','和平里小区4号楼1单元电梯机房',NULL,NULL,NULL,'0','2026-08-14','normal','',10,0,0,'finished','0','admin','2026-10-12 20:40:24','',NULL);
INSERT INTO `inspection_record` (`record_id`, `record_no`, `plan_id`, `elevator_id`, `maintain_type`, `plan_date`, `executor_id`, `clock_in_time`, `clock_in_location`, `clock_in_longitude`, `clock_in_latitude`, `clock_in_distance`, `demo_flag`, `execute_date`, `execute_result`, `abnormal_desc`, `normal_count`, `abnormal_count`, `na_count`, `record_status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (20,'XJ20260829161520',5,5,'half_month','2026-08-29',104,'2026-08-29 16:15:00','和平里小区4号楼1单元电梯机房',NULL,NULL,NULL,'0','2026-08-29','normal','',10,0,0,'finished','0','admin','2026-10-12 20:40:24','',NULL);
INSERT INTO `inspection_record` (`record_id`, `record_no`, `plan_id`, `elevator_id`, `maintain_type`, `plan_date`, `executor_id`, `clock_in_time`, `clock_in_location`, `clock_in_longitude`, `clock_in_latitude`, `clock_in_distance`, `demo_flag`, `execute_date`, `execute_result`, `abnormal_desc`, `normal_count`, `abnormal_count`, `na_count`, `record_status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (21,'XJ20260913162021',5,5,'half_month','2026-09-13',104,'2026-09-13 16:20:00','和平里小区4号楼1单元电梯机房',NULL,NULL,NULL,'0','2026-09-13','normal','',10,0,0,'finished','0','admin','2026-10-12 20:40:24','',NULL);
INSERT INTO `inspection_record` (`record_id`, `record_no`, `plan_id`, `elevator_id`, `maintain_type`, `plan_date`, `executor_id`, `clock_in_time`, `clock_in_location`, `clock_in_longitude`, `clock_in_latitude`, `clock_in_distance`, `demo_flag`, `execute_date`, `execute_result`, `abnormal_desc`, `normal_count`, `abnormal_count`, `na_count`, `record_status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (22,'XJ20260928162522',5,5,'quarter','2026-09-28',104,'2026-09-28 16:25:00','和平里小区4号楼1单元电梯机房',NULL,NULL,NULL,'0','2026-09-28','normal','',10,0,0,'finished','0','admin','2026-10-12 20:40:24','',NULL);
INSERT INTO `inspection_record` (`record_id`, `record_no`, `plan_id`, `elevator_id`, `maintain_type`, `plan_date`, `executor_id`, `clock_in_time`, `clock_in_location`, `clock_in_longitude`, `clock_in_latitude`, `clock_in_distance`, `demo_flag`, `execute_date`, `execute_result`, `abnormal_desc`, `normal_count`, `abnormal_count`, `na_count`, `record_status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (23,'XJ20260708170023',6,6,'half_month','2026-07-08',104,'2026-07-08 17:00:00','铁路新村小区A座1单元电梯机房',NULL,NULL,NULL,'0','2026-07-08','abnormal','曳引机运行振动偏大，钢丝绳断丝 3 根',8,2,0,'finished','0','admin','2026-10-12 20:40:24','',NULL);
INSERT INTO `inspection_record` (`record_id`, `record_no`, `plan_id`, `elevator_id`, `maintain_type`, `plan_date`, `executor_id`, `clock_in_time`, `clock_in_location`, `clock_in_longitude`, `clock_in_latitude`, `clock_in_distance`, `demo_flag`, `execute_date`, `execute_result`, `abnormal_desc`, `normal_count`, `abnormal_count`, `na_count`, `record_status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (24,'XJ20260722170524',6,6,'half_month','2026-07-22',104,'2026-07-22 17:05:00','铁路新村小区A座1单元电梯机房',NULL,NULL,NULL,'0','2026-07-22','abnormal','制动器动作迟缓，平层偏差超标',8,2,0,'finished','0','admin','2026-10-12 20:40:24','',NULL);
INSERT INTO `inspection_record` (`record_id`, `record_no`, `plan_id`, `elevator_id`, `maintain_type`, `plan_date`, `executor_id`, `clock_in_time`, `clock_in_location`, `clock_in_longitude`, `clock_in_latitude`, `clock_in_distance`, `demo_flag`, `execute_date`, `execute_result`, `abnormal_desc`, `normal_count`, `abnormal_count`, `na_count`, `record_status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (25,'XJ20260805171025',6,6,'half_month','2026-08-05',104,'2026-08-05 17:10:00','铁路新村小区A座1单元电梯机房',NULL,NULL,NULL,'0','2026-08-05','abnormal','层门卡阻，门锁触点烧蚀，已临时处理',8,2,0,'finished','0','admin','2026-10-12 20:40:24','',NULL);
INSERT INTO `inspection_record` (`record_id`, `record_no`, `plan_id`, `elevator_id`, `maintain_type`, `plan_date`, `executor_id`, `clock_in_time`, `clock_in_location`, `clock_in_longitude`, `clock_in_latitude`, `clock_in_distance`, `demo_flag`, `execute_date`, `execute_result`, `abnormal_desc`, `normal_count`, `abnormal_count`, `na_count`, `record_status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (26,'XJ20260819171526',6,6,'half_month','2026-08-19',104,'2026-08-19 17:15:00','铁路新村小区A座1单元电梯机房',NULL,NULL,NULL,'0','2026-08-19','abnormal','控制柜接触器频繁动作，触点磨损明显',8,2,0,'finished','0','admin','2026-10-12 20:40:24','',NULL);
INSERT INTO `inspection_record` (`record_id`, `record_no`, `plan_id`, `elevator_id`, `maintain_type`, `plan_date`, `executor_id`, `clock_in_time`, `clock_in_location`, `clock_in_longitude`, `clock_in_latitude`, `clock_in_distance`, `demo_flag`, `execute_date`, `execute_result`, `abnormal_desc`, `normal_count`, `abnormal_count`, `na_count`, `record_status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (27,'XJ20260902172027',6,6,'half_month','2026-09-02',104,'2026-09-02 17:20:00','铁路新村小区A座1单元电梯机房',NULL,NULL,NULL,'0','2026-09-02','abnormal','导轨润滑不足，导靴磨损量接近上限',8,2,0,'finished','0','admin','2026-10-12 20:40:24','',NULL);
INSERT INTO `inspection_record` (`record_id`, `record_no`, `plan_id`, `elevator_id`, `maintain_type`, `plan_date`, `executor_id`, `clock_in_time`, `clock_in_location`, `clock_in_longitude`, `clock_in_latitude`, `clock_in_distance`, `demo_flag`, `execute_date`, `execute_result`, `abnormal_desc`, `normal_count`, `abnormal_count`, `na_count`, `record_status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (28,'XJ20260916172528',6,6,'quarter','2026-09-16',104,'2026-09-16 17:25:00','铁路新村小区A座1单元电梯机房',NULL,NULL,NULL,'0','2026-09-16','abnormal','补偿链磨损，随行电缆保护层破损',8,2,0,'finished','0','admin','2026-10-12 20:40:24','',NULL);
/*!40000 ALTER TABLE `inspection_record` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `maintain_archive`
--

LOCK TABLES `maintain_archive` WRITE;
/*!40000 ALTER TABLE `maintain_archive` DISABLE KEYS */;
/*!40000 ALTER TABLE `maintain_archive` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `maintain_item`
--

LOCK TABLES `maintain_item` WRITE;
/*!40000 ALTER TABLE `maintain_item` DISABLE KEYS */;
INSERT INTO `maintain_item` (`item_id`, `template_name`, `maintain_type`, `item_name`, `item_category`, `check_standard`, `order_num`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (1,'半月保标准模板','half_month','曳引机运行状态检查','traction','运行平稳无异响，无异常振动',1,'0','admin','2026-10-12 20:40:24','',NULL);
INSERT INTO `maintain_item` (`item_id`, `template_name`, `maintain_type`, `item_name`, `item_category`, `check_standard`, `order_num`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (2,'半月保标准模板','half_month','钢丝绳磨损与断丝检查','traction','断丝数不超过标准要求，无锈蚀',2,'0','admin','2026-10-12 20:40:24','',NULL);
INSERT INTO `maintain_item` (`item_id`, `template_name`, `maintain_type`, `item_name`, `item_category`, `check_standard`, `order_num`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (3,'半月保标准模板','half_month','层门与轿门开合检查','door_system','开合顺畅，无卡阻，闭合到位',3,'0','admin','2026-10-12 20:40:24','',NULL);
INSERT INTO `maintain_item` (`item_id`, `template_name`, `maintain_type`, `item_name`, `item_category`, `check_standard`, `order_num`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (4,'半月保标准模板','half_month','门锁电气触点检查','door_system','触点接触良好，无烧蚀',4,'0','admin','2026-10-12 20:40:24','',NULL);
INSERT INTO `maintain_item` (`item_id`, `template_name`, `maintain_type`, `item_name`, `item_category`, `check_standard`, `order_num`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (5,'半月保标准模板','half_month','限速器与安全钳检查','safety','动作可靠，无卡阻',5,'0','admin','2026-10-12 20:40:24','',NULL);
INSERT INTO `maintain_item` (`item_id`, `template_name`, `maintain_type`, `item_name`, `item_category`, `check_standard`, `order_num`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (6,'半月保标准模板','half_month','制动器动作检查','safety','制动可靠，间隙符合要求',6,'0','admin','2026-10-12 20:40:24','',NULL);
INSERT INTO `maintain_item` (`item_id`, `template_name`, `maintain_type`, `item_name`, `item_category`, `check_standard`, `order_num`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (7,'半月保标准模板','half_month','控制柜运行状态检查','control','无异味，接触器动作正常',7,'0','admin','2026-10-12 20:40:24','',NULL);
INSERT INTO `maintain_item` (`item_id`, `template_name`, `maintain_type`, `item_name`, `item_category`, `check_standard`, `order_num`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (8,'半月保标准模板','half_month','轿厢照明与通风检查','car','照明正常，通风良好',8,'0','admin','2026-10-12 20:40:24','',NULL);
INSERT INTO `maintain_item` (`item_id`, `template_name`, `maintain_type`, `item_name`, `item_category`, `check_standard`, `order_num`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (9,'半月保标准模板','half_month','报警装置与对讲检查','car','报警按钮有效，对讲清晰',9,'0','admin','2026-10-12 20:40:24','',NULL);
INSERT INTO `maintain_item` (`item_id`, `template_name`, `maintain_type`, `item_name`, `item_category`, `check_standard`, `order_num`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (10,'半月保标准模板','half_month','轿厢内应急照明检查','car','断电后应急照明自动点亮',10,'0','admin','2026-10-12 20:40:24','',NULL);
INSERT INTO `maintain_item` (`item_id`, `template_name`, `maintain_type`, `item_name`, `item_category`, `check_standard`, `order_num`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (11,'季度检标准模板','quarter','曳引机减速箱油质检查','traction','油位正常，无乳化变质',1,'0','admin','2026-10-12 20:40:24','',NULL);
INSERT INTO `maintain_item` (`item_id`, `template_name`, `maintain_type`, `item_name`, `item_category`, `check_standard`, `order_num`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (12,'季度检标准模板','quarter','钢丝绳张力均衡检查','traction','各绳张力偏差不超过5%',2,'0','admin','2026-10-12 20:40:24','',NULL);
INSERT INTO `maintain_item` (`item_id`, `template_name`, `maintain_type`, `item_name`, `item_category`, `check_standard`, `order_num`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (13,'季度检标准模板','quarter','导轨与导靴磨损检查','traction','导靴磨损量在允许范围内',3,'0','admin','2026-10-12 20:40:24','',NULL);
INSERT INTO `maintain_item` (`item_id`, `template_name`, `maintain_type`, `item_name`, `item_category`, `check_standard`, `order_num`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (14,'季度检标准模板','quarter','平层准确度检查','control','平层误差不超过正负5毫米',4,'0','admin','2026-10-12 20:40:24','',NULL);
INSERT INTO `maintain_item` (`item_id`, `template_name`, `maintain_type`, `item_name`, `item_category`, `check_standard`, `order_num`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (15,'季度检标准模板','quarter','超载装置动作检查','safety','超载报警与保护动作可靠',5,'0','admin','2026-10-12 20:40:24','',NULL);
INSERT INTO `maintain_item` (`item_id`, `template_name`, `maintain_type`, `item_name`, `item_category`, `check_standard`, `order_num`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (16,'季度检标准模板','quarter','接地保护与绝缘检查','control','接地良好，绝缘电阻符合标准',6,'0','admin','2026-10-12 20:40:24','',NULL);
INSERT INTO `maintain_item` (`item_id`, `template_name`, `maintain_type`, `item_name`, `item_category`, `check_standard`, `order_num`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (17,'季度检标准模板','quarter','井道照明与底坑检查','other','照明正常，底坑无积水杂物',7,'0','admin','2026-10-12 20:40:24','',NULL);
INSERT INTO `maintain_item` (`item_id`, `template_name`, `maintain_type`, `item_name`, `item_category`, `check_standard`, `order_num`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (18,'季度检标准模板','quarter','补偿链与随行电缆检查','other','无破损，固定牢靠',8,'0','admin','2026-10-12 20:40:24','',NULL);
/*!40000 ALTER TABLE `maintain_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `maintain_plan`
--

LOCK TABLES `maintain_plan` WRITE;
/*!40000 ALTER TABLE `maintain_plan` DISABLE KEYS */;
INSERT INTO `maintain_plan` (`plan_id`, `plan_name`, `elevator_id`, `maintain_type`, `cycle_days`, `template_name`, `start_date`, `end_date`, `next_date`, `last_date`, `owner_id`, `plan_status`, `expect_count`, `finish_count`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1,'1号楼1单元半月保',1,'half_month',15,'半月保标准模板','2026-07-01','2027-06-30','2026-10-16','2026-10-01',101,'0',6,6,'0','admin','2026-10-12 20:40:24','',NULL,'业主反馈运行平稳，按周期正常维保');
INSERT INTO `maintain_plan` (`plan_id`, `plan_name`, `elevator_id`, `maintain_type`, `cycle_days`, `template_name`, `start_date`, `end_date`, `next_date`, `last_date`, `owner_id`, `plan_status`, `expect_count`, `finish_count`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2,'1号楼2单元半月保',2,'half_month',15,'半月保标准模板','2026-07-01','2027-06-30','2026-10-16','2026-10-01',101,'0',6,6,'0','admin','2026-10-12 20:40:24','',NULL,'门系统有异响，维保时重点关注');
INSERT INTO `maintain_plan` (`plan_id`, `plan_name`, `elevator_id`, `maintain_type`, `cycle_days`, `template_name`, `start_date`, `end_date`, `next_date`, `last_date`, `owner_id`, `plan_status`, `expect_count`, `finish_count`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (3,'2号楼1单元半月保',3,'half_month',15,'半月保标准模板','2026-07-01','2027-06-30','2026-10-16','2026-09-16',101,'0',6,5,'0','admin','2026-10-12 20:40:24','',NULL,'有一次因配件到货延迟未按期执行，已补做');
INSERT INTO `maintain_plan` (`plan_id`, `plan_name`, `elevator_id`, `maintain_type`, `cycle_days`, `template_name`, `start_date`, `end_date`, `next_date`, `last_date`, `owner_id`, `plan_status`, `expect_count`, `finish_count`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (4,'3号楼1单元半月保',4,'half_month',15,'半月保标准模板','2026-07-01','2027-06-30','2026-07-16','2026-08-01',103,'0',6,2,'0','admin','2026-10-12 20:40:24','',NULL,'已停梯待大修，维保暂停，待大修完成恢复');
INSERT INTO `maintain_plan` (`plan_id`, `plan_name`, `elevator_id`, `maintain_type`, `cycle_days`, `template_name`, `start_date`, `end_date`, `next_date`, `last_date`, `owner_id`, `plan_status`, `expect_count`, `finish_count`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (5,'4号楼1单元半月保',5,'half_month',15,'半月保标准模板','2026-07-01','2027-06-30','2026-10-16','2026-10-01',103,'0',6,6,'0','admin','2026-10-12 20:40:24','',NULL,'投用年限较短，运行状况良好');
INSERT INTO `maintain_plan` (`plan_id`, `plan_name`, `elevator_id`, `maintain_type`, `cycle_days`, `template_name`, `start_date`, `end_date`, `next_date`, `last_date`, `owner_id`, `plan_status`, `expect_count`, `finish_count`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (6,'A座1单元半月保',6,'half_month',7,'半月保标准模板','2026-07-01','2027-06-30','2026-10-09','2026-09-11',104,'0',12,6,'0','admin','2026-10-12 20:40:24','',NULL,'老旧电梯故障率高，已缩短维保周期，但仍多次漏保');
INSERT INTO `maintain_plan` (`plan_id`, `plan_name`, `elevator_id`, `maintain_type`, `cycle_days`, `template_name`, `start_date`, `end_date`, `next_date`, `last_date`, `owner_id`, `plan_status`, `expect_count`, `finish_count`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (7,'1号楼1单元季度检',1,'quarter',90,'季度检标准模板','2026-07-01','2027-06-30','2026-10-01','2026-07-01',101,'0',2,2,'0','admin','2026-10-12 20:40:24','',NULL,'季度检正常执行');
INSERT INTO `maintain_plan` (`plan_id`, `plan_name`, `elevator_id`, `maintain_type`, `cycle_days`, `template_name`, `start_date`, `end_date`, `next_date`, `last_date`, `owner_id`, `plan_status`, `expect_count`, `finish_count`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (8,'1号楼2单元季度检',2,'quarter',90,'季度检标准模板','2026-07-01','2027-06-30','2026-10-01','2026-07-01',101,'0',2,2,'0','admin','2026-10-12 20:40:24','',NULL,'季度检正常执行');
INSERT INTO `maintain_plan` (`plan_id`, `plan_name`, `elevator_id`, `maintain_type`, `cycle_days`, `template_name`, `start_date`, `end_date`, `next_date`, `last_date`, `owner_id`, `plan_status`, `expect_count`, `finish_count`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (9,'2号楼1单元季度检',3,'quarter',90,'季度检标准模板','2026-07-01','2027-06-30','2026-10-01','2026-07-01',101,'0',2,2,'0','admin','2026-10-12 20:40:24','',NULL,'季度检正常执行');
INSERT INTO `maintain_plan` (`plan_id`, `plan_name`, `elevator_id`, `maintain_type`, `cycle_days`, `template_name`, `start_date`, `end_date`, `next_date`, `last_date`, `owner_id`, `plan_status`, `expect_count`, `finish_count`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (10,'4号楼1单元季度检',5,'quarter',90,'季度检标准模板','2026-07-01','2027-06-30','2026-10-01','2026-07-01',103,'0',2,2,'0','admin','2026-10-12 20:40:24','',NULL,'季度检正常执行');
/*!40000 ALTER TABLE `maintain_plan` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `order_status_log`
--

LOCK TABLES `order_status_log` WRITE;
/*!40000 ALTER TABLE `order_status_log` DISABLE KEYS */;
INSERT INTO `order_status_log` (`log_id`, `order_id`, `from_status`, `to_status`, `operate_type`, `operator_id`, `operator_name`, `operator_role`, `operate_time`, `remark`) VALUES (1,1,'','pending','report',102,'业主张阿姨','owner','2026-07-22 10:15:00','业主提交故障报修');
INSERT INTO `order_status_log` (`log_id`, `order_id`, `from_status`, `to_status`, `operate_type`, `operator_id`, `operator_name`, `operator_role`, `operate_time`, `remark`) VALUES (2,1,'pending','assigned','assign',100,'物业管理员','property','2026-07-22 10:22:00','物业审核后指派维修员');
INSERT INTO `order_status_log` (`log_id`, `order_id`, `from_status`, `to_status`, `operate_type`, `operator_id`, `operator_name`, `operator_role`, `operate_time`, `remark`) VALUES (3,1,'assigned','accepted','accept',104,'维修员赵师傅','worker','2026-07-22 10:25:00','维修员确认接单');
INSERT INTO `order_status_log` (`log_id`, `order_id`, `from_status`, `to_status`, `operate_type`, `operator_id`, `operator_name`, `operator_role`, `operate_time`, `remark`) VALUES (4,1,'accepted','arrived','arrive',104,'维修员赵师傅','worker','2026-07-22 10:48:00','维修员已到达现场');
INSERT INTO `order_status_log` (`log_id`, `order_id`, `from_status`, `to_status`, `operate_type`, `operator_id`, `operator_name`, `operator_role`, `operate_time`, `remark`) VALUES (5,1,'arrived','repairing','investigate',104,'维修员赵师傅','worker','2026-07-22 10:58:00','维修员排查故障原因');
INSERT INTO `order_status_log` (`log_id`, `order_id`, `from_status`, `to_status`, `operate_type`, `operator_id`, `operator_name`, `operator_role`, `operate_time`, `remark`) VALUES (6,1,'repairing','repaired','finish',104,'维修员赵师傅','worker','2026-07-22 12:30:00','维修完成，提交处理说明');
INSERT INTO `order_status_log` (`log_id`, `order_id`, `from_status`, `to_status`, `operate_type`, `operator_id`, `operator_name`, `operator_role`, `operate_time`, `remark`) VALUES (7,1,'repaired','confirmed','confirm',102,'业主张阿姨','owner','2026-07-22 14:00:00','业主确认故障已消除，工单闭环');
INSERT INTO `order_status_log` (`log_id`, `order_id`, `from_status`, `to_status`, `operate_type`, `operator_id`, `operator_name`, `operator_role`, `operate_time`, `remark`) VALUES (8,2,'','pending','report',102,'业主张阿姨','owner','2026-08-03 14:20:00','业主提交故障报修');
INSERT INTO `order_status_log` (`log_id`, `order_id`, `from_status`, `to_status`, `operate_type`, `operator_id`, `operator_name`, `operator_role`, `operate_time`, `remark`) VALUES (9,2,'pending','assigned','assign',100,'物业管理员','property','2026-08-03 14:40:00','物业审核后指派维修员');
INSERT INTO `order_status_log` (`log_id`, `order_id`, `from_status`, `to_status`, `operate_type`, `operator_id`, `operator_name`, `operator_role`, `operate_time`, `remark`) VALUES (10,2,'assigned','accepted','accept',104,'维修员赵师傅','worker','2026-08-03 14:45:00','维修员确认接单');
INSERT INTO `order_status_log` (`log_id`, `order_id`, `from_status`, `to_status`, `operate_type`, `operator_id`, `operator_name`, `operator_role`, `operate_time`, `remark`) VALUES (11,2,'accepted','arrived','arrive',104,'维修员赵师傅','worker','2026-08-03 15:30:00','维修员已到达现场');
INSERT INTO `order_status_log` (`log_id`, `order_id`, `from_status`, `to_status`, `operate_type`, `operator_id`, `operator_name`, `operator_role`, `operate_time`, `remark`) VALUES (12,2,'arrived','repairing','investigate',104,'维修员赵师傅','worker','2026-08-03 15:40:00','维修员排查故障原因');
INSERT INTO `order_status_log` (`log_id`, `order_id`, `from_status`, `to_status`, `operate_type`, `operator_id`, `operator_name`, `operator_role`, `operate_time`, `remark`) VALUES (13,2,'repairing','repaired','finish',104,'维修员赵师傅','worker','2026-08-03 17:00:00','维修完成，提交处理说明');
INSERT INTO `order_status_log` (`log_id`, `order_id`, `from_status`, `to_status`, `operate_type`, `operator_id`, `operator_name`, `operator_role`, `operate_time`, `remark`) VALUES (14,2,'repaired','confirmed','confirm',102,'业主张阿姨','owner','2026-08-03 18:00:00','业主确认故障已消除，工单闭环');
INSERT INTO `order_status_log` (`log_id`, `order_id`, `from_status`, `to_status`, `operate_type`, `operator_id`, `operator_name`, `operator_role`, `operate_time`, `remark`) VALUES (15,3,'','pending','report',102,'业主张阿姨','owner','2026-08-18 09:30:00','业主提交故障报修');
INSERT INTO `order_status_log` (`log_id`, `order_id`, `from_status`, `to_status`, `operate_type`, `operator_id`, `operator_name`, `operator_role`, `operate_time`, `remark`) VALUES (16,3,'pending','assigned','assign',100,'物业管理员','property','2026-08-18 09:50:00','物业审核后指派维修员');
INSERT INTO `order_status_log` (`log_id`, `order_id`, `from_status`, `to_status`, `operate_type`, `operator_id`, `operator_name`, `operator_role`, `operate_time`, `remark`) VALUES (17,3,'assigned','accepted','accept',104,'维修员赵师傅','worker','2026-08-18 10:00:00','维修员确认接单');
INSERT INTO `order_status_log` (`log_id`, `order_id`, `from_status`, `to_status`, `operate_type`, `operator_id`, `operator_name`, `operator_role`, `operate_time`, `remark`) VALUES (18,3,'accepted','arrived','arrive',104,'维修员赵师傅','worker','2026-08-18 11:20:00','维修员已到达现场');
INSERT INTO `order_status_log` (`log_id`, `order_id`, `from_status`, `to_status`, `operate_type`, `operator_id`, `operator_name`, `operator_role`, `operate_time`, `remark`) VALUES (19,3,'arrived','repairing','investigate',104,'维修员赵师傅','worker','2026-08-18 11:30:00','维修员排查故障原因');
INSERT INTO `order_status_log` (`log_id`, `order_id`, `from_status`, `to_status`, `operate_type`, `operator_id`, `operator_name`, `operator_role`, `operate_time`, `remark`) VALUES (20,3,'repairing','repaired','finish',104,'维修员赵师傅','worker','2026-08-18 15:00:00','维修完成，提交处理说明');
INSERT INTO `order_status_log` (`log_id`, `order_id`, `from_status`, `to_status`, `operate_type`, `operator_id`, `operator_name`, `operator_role`, `operate_time`, `remark`) VALUES (21,3,'repaired','confirmed','confirm',102,'业主张阿姨','owner','2026-08-18 16:00:00','业主确认故障已消除，工单闭环');
INSERT INTO `order_status_log` (`log_id`, `order_id`, `from_status`, `to_status`, `operate_type`, `operator_id`, `operator_name`, `operator_role`, `operate_time`, `remark`) VALUES (22,4,'','pending','report',102,'业主张阿姨','owner','2026-09-05 16:10:00','业主提交故障报修');
INSERT INTO `order_status_log` (`log_id`, `order_id`, `from_status`, `to_status`, `operate_type`, `operator_id`, `operator_name`, `operator_role`, `operate_time`, `remark`) VALUES (23,4,'pending','assigned','assign',100,'物业管理员','property','2026-09-05 16:18:00','物业审核后指派维修员');
INSERT INTO `order_status_log` (`log_id`, `order_id`, `from_status`, `to_status`, `operate_type`, `operator_id`, `operator_name`, `operator_role`, `operate_time`, `remark`) VALUES (24,4,'assigned','accepted','accept',104,'维修员赵师傅','worker','2026-09-05 16:20:00','维修员确认接单');
INSERT INTO `order_status_log` (`log_id`, `order_id`, `from_status`, `to_status`, `operate_type`, `operator_id`, `operator_name`, `operator_role`, `operate_time`, `remark`) VALUES (25,4,'accepted','arrived','arrive',104,'维修员赵师傅','worker','2026-09-05 16:50:00','维修员已到达现场');
INSERT INTO `order_status_log` (`log_id`, `order_id`, `from_status`, `to_status`, `operate_type`, `operator_id`, `operator_name`, `operator_role`, `operate_time`, `remark`) VALUES (26,4,'arrived','repairing','investigate',104,'维修员赵师傅','worker','2026-09-05 17:00:00','维修员排查故障原因');
INSERT INTO `order_status_log` (`log_id`, `order_id`, `from_status`, `to_status`, `operate_type`, `operator_id`, `operator_name`, `operator_role`, `operate_time`, `remark`) VALUES (27,4,'repairing','repaired','finish',104,'维修员赵师傅','worker','2026-09-05 21:00:00','维修完成，提交处理说明');
INSERT INTO `order_status_log` (`log_id`, `order_id`, `from_status`, `to_status`, `operate_type`, `operator_id`, `operator_name`, `operator_role`, `operate_time`, `remark`) VALUES (28,4,'repaired','confirmed','confirm',102,'业主张阿姨','owner','2026-09-06 09:00:00','业主确认故障已消除，工单闭环');
INSERT INTO `order_status_log` (`log_id`, `order_id`, `from_status`, `to_status`, `operate_type`, `operator_id`, `operator_name`, `operator_role`, `operate_time`, `remark`) VALUES (29,5,'','pending','report',102,'业主张阿姨','owner','2026-09-22 11:05:00','业主提交故障报修');
INSERT INTO `order_status_log` (`log_id`, `order_id`, `from_status`, `to_status`, `operate_type`, `operator_id`, `operator_name`, `operator_role`, `operate_time`, `remark`) VALUES (30,5,'pending','assigned','assign',100,'物业管理员','property','2026-09-22 11:12:00','物业审核后指派维修员');
INSERT INTO `order_status_log` (`log_id`, `order_id`, `from_status`, `to_status`, `operate_type`, `operator_id`, `operator_name`, `operator_role`, `operate_time`, `remark`) VALUES (31,5,'assigned','accepted','accept',104,'维修员赵师傅','worker','2026-09-22 11:15:00','维修员确认接单');
INSERT INTO `order_status_log` (`log_id`, `order_id`, `from_status`, `to_status`, `operate_type`, `operator_id`, `operator_name`, `operator_role`, `operate_time`, `remark`) VALUES (32,5,'accepted','arrived','arrive',104,'维修员赵师傅','worker','2026-09-22 11:40:00','维修员已到达现场');
INSERT INTO `order_status_log` (`log_id`, `order_id`, `from_status`, `to_status`, `operate_type`, `operator_id`, `operator_name`, `operator_role`, `operate_time`, `remark`) VALUES (33,5,'arrived','repairing','investigate',104,'维修员赵师傅','worker','2026-09-22 11:50:00','维修员排查故障原因');
INSERT INTO `order_status_log` (`log_id`, `order_id`, `from_status`, `to_status`, `operate_type`, `operator_id`, `operator_name`, `operator_role`, `operate_time`, `remark`) VALUES (34,5,'repairing','repaired','finish',104,'维修员赵师傅','worker','2026-09-22 18:00:00','维修完成，提交处理说明');
INSERT INTO `order_status_log` (`log_id`, `order_id`, `from_status`, `to_status`, `operate_type`, `operator_id`, `operator_name`, `operator_role`, `operate_time`, `remark`) VALUES (35,6,'','pending','report',102,'业主张阿姨','owner','2026-07-12 10:30:00','业主提交故障报修');
INSERT INTO `order_status_log` (`log_id`, `order_id`, `from_status`, `to_status`, `operate_type`, `operator_id`, `operator_name`, `operator_role`, `operate_time`, `remark`) VALUES (36,6,'pending','assigned','assign',100,'物业管理员','property','2026-07-12 10:36:00','物业审核后指派维修员');
INSERT INTO `order_status_log` (`log_id`, `order_id`, `from_status`, `to_status`, `operate_type`, `operator_id`, `operator_name`, `operator_role`, `operate_time`, `remark`) VALUES (37,6,'assigned','accepted','accept',103,'维修员李师傅','worker','2026-07-12 10:40:00','维修员确认接单');
INSERT INTO `order_status_log` (`log_id`, `order_id`, `from_status`, `to_status`, `operate_type`, `operator_id`, `operator_name`, `operator_role`, `operate_time`, `remark`) VALUES (38,6,'accepted','arrived','arrive',103,'维修员李师傅','worker','2026-07-12 11:05:00','维修员已到达现场');
INSERT INTO `order_status_log` (`log_id`, `order_id`, `from_status`, `to_status`, `operate_type`, `operator_id`, `operator_name`, `operator_role`, `operate_time`, `remark`) VALUES (39,6,'arrived','repairing','investigate',103,'维修员李师傅','worker','2026-07-12 11:15:00','维修员排查故障原因');
INSERT INTO `order_status_log` (`log_id`, `order_id`, `from_status`, `to_status`, `operate_type`, `operator_id`, `operator_name`, `operator_role`, `operate_time`, `remark`) VALUES (40,6,'repairing','repaired','finish',103,'维修员李师傅','worker','2026-07-12 13:00:00','维修完成，提交处理说明');
INSERT INTO `order_status_log` (`log_id`, `order_id`, `from_status`, `to_status`, `operate_type`, `operator_id`, `operator_name`, `operator_role`, `operate_time`, `remark`) VALUES (41,6,'repaired','confirmed','confirm',102,'业主张阿姨','owner','2026-07-12 15:00:00','业主确认故障已消除，工单闭环');
INSERT INTO `order_status_log` (`log_id`, `order_id`, `from_status`, `to_status`, `operate_type`, `operator_id`, `operator_name`, `operator_role`, `operate_time`, `remark`) VALUES (42,7,'','pending','report',102,'业主张阿姨','owner','2026-07-24 15:00:00','业主提交故障报修');
INSERT INTO `order_status_log` (`log_id`, `order_id`, `from_status`, `to_status`, `operate_type`, `operator_id`, `operator_name`, `operator_role`, `operate_time`, `remark`) VALUES (43,7,'pending','assigned','assign',100,'物业管理员','property','2026-07-24 15:20:00','物业审核后指派维修员');
INSERT INTO `order_status_log` (`log_id`, `order_id`, `from_status`, `to_status`, `operate_type`, `operator_id`, `operator_name`, `operator_role`, `operate_time`, `remark`) VALUES (44,7,'assigned','accepted','accept',103,'维修员李师傅','worker','2026-07-24 15:25:00','维修员确认接单');
INSERT INTO `order_status_log` (`log_id`, `order_id`, `from_status`, `to_status`, `operate_type`, `operator_id`, `operator_name`, `operator_role`, `operate_time`, `remark`) VALUES (45,7,'accepted','arrived','arrive',103,'维修员李师傅','worker','2026-07-24 16:10:00','维修员已到达现场');
INSERT INTO `order_status_log` (`log_id`, `order_id`, `from_status`, `to_status`, `operate_type`, `operator_id`, `operator_name`, `operator_role`, `operate_time`, `remark`) VALUES (46,7,'arrived','repairing','investigate',103,'维修员李师傅','worker','2026-07-24 16:20:00','维修员排查故障原因');
INSERT INTO `order_status_log` (`log_id`, `order_id`, `from_status`, `to_status`, `operate_type`, `operator_id`, `operator_name`, `operator_role`, `operate_time`, `remark`) VALUES (47,7,'repairing','repaired','finish',103,'维修员李师傅','worker','2026-07-24 18:00:00','维修完成，提交处理说明');
INSERT INTO `order_status_log` (`log_id`, `order_id`, `from_status`, `to_status`, `operate_type`, `operator_id`, `operator_name`, `operator_role`, `operate_time`, `remark`) VALUES (48,7,'repaired','confirmed','confirm',102,'业主张阿姨','owner','2026-07-25 09:00:00','业主确认故障已消除，工单闭环');
INSERT INTO `order_status_log` (`log_id`, `order_id`, `from_status`, `to_status`, `operate_type`, `operator_id`, `operator_name`, `operator_role`, `operate_time`, `remark`) VALUES (49,8,'','pending','report',102,'业主张阿姨','owner','2026-08-11 10:15:00','业主提交故障报修');
INSERT INTO `order_status_log` (`log_id`, `order_id`, `from_status`, `to_status`, `operate_type`, `operator_id`, `operator_name`, `operator_role`, `operate_time`, `remark`) VALUES (50,8,'pending','assigned','assign',100,'物业管理员','property','2026-08-11 10:30:00','物业审核后指派维修员');
INSERT INTO `order_status_log` (`log_id`, `order_id`, `from_status`, `to_status`, `operate_type`, `operator_id`, `operator_name`, `operator_role`, `operate_time`, `remark`) VALUES (51,8,'assigned','accepted','accept',103,'维修员李师傅','worker','2026-08-11 10:35:00','维修员确认接单');
INSERT INTO `order_status_log` (`log_id`, `order_id`, `from_status`, `to_status`, `operate_type`, `operator_id`, `operator_name`, `operator_role`, `operate_time`, `remark`) VALUES (52,8,'accepted','arrived','arrive',103,'维修员李师傅','worker','2026-08-11 11:30:00','维修员已到达现场');
INSERT INTO `order_status_log` (`log_id`, `order_id`, `from_status`, `to_status`, `operate_type`, `operator_id`, `operator_name`, `operator_role`, `operate_time`, `remark`) VALUES (53,8,'arrived','repairing','investigate',103,'维修员李师傅','worker','2026-08-11 11:40:00','维修员排查故障原因');
INSERT INTO `order_status_log` (`log_id`, `order_id`, `from_status`, `to_status`, `operate_type`, `operator_id`, `operator_name`, `operator_role`, `operate_time`, `remark`) VALUES (54,8,'repairing','repaired','finish',103,'维修员李师傅','worker','2026-08-11 16:00:00','维修完成，提交处理说明');
INSERT INTO `order_status_log` (`log_id`, `order_id`, `from_status`, `to_status`, `operate_type`, `operator_id`, `operator_name`, `operator_role`, `operate_time`, `remark`) VALUES (55,8,'repaired','confirmed','confirm',102,'业主张阿姨','owner','2026-08-12 09:00:00','业主确认故障已消除，工单闭环');
INSERT INTO `order_status_log` (`log_id`, `order_id`, `from_status`, `to_status`, `operate_type`, `operator_id`, `operator_name`, `operator_role`, `operate_time`, `remark`) VALUES (56,9,'','pending','report',102,'业主张阿姨','owner','2026-09-15 14:20:00','业主提交故障报修');
INSERT INTO `order_status_log` (`log_id`, `order_id`, `from_status`, `to_status`, `operate_type`, `operator_id`, `operator_name`, `operator_role`, `operate_time`, `remark`) VALUES (57,9,'pending','assigned','assign',100,'物业管理员','property','2026-09-15 14:26:00','物业审核后指派维修员');
INSERT INTO `order_status_log` (`log_id`, `order_id`, `from_status`, `to_status`, `operate_type`, `operator_id`, `operator_name`, `operator_role`, `operate_time`, `remark`) VALUES (58,9,'assigned','accepted','accept',103,'维修员李师傅','worker','2026-09-15 14:30:00','维修员确认接单');
INSERT INTO `order_status_log` (`log_id`, `order_id`, `from_status`, `to_status`, `operate_type`, `operator_id`, `operator_name`, `operator_role`, `operate_time`, `remark`) VALUES (59,9,'accepted','arrived','arrive',103,'维修员李师傅','worker','2026-09-15 15:00:00','维修员已到达现场');
INSERT INTO `order_status_log` (`log_id`, `order_id`, `from_status`, `to_status`, `operate_type`, `operator_id`, `operator_name`, `operator_role`, `operate_time`, `remark`) VALUES (60,9,'arrived','repairing','investigate',103,'维修员李师傅','worker','2026-09-15 15:10:00','维修员排查故障原因');
INSERT INTO `order_status_log` (`log_id`, `order_id`, `from_status`, `to_status`, `operate_type`, `operator_id`, `operator_name`, `operator_role`, `operate_time`, `remark`) VALUES (61,9,'repairing','repaired','finish',103,'维修员李师傅','worker','2026-09-15 17:30:00','维修完成，提交处理说明');
INSERT INTO `order_status_log` (`log_id`, `order_id`, `from_status`, `to_status`, `operate_type`, `operator_id`, `operator_name`, `operator_role`, `operate_time`, `remark`) VALUES (62,9,'repaired','confirmed','confirm',102,'业主张阿姨','owner','2026-09-16 09:00:00','业主确认故障已消除，工单闭环');
INSERT INTO `order_status_log` (`log_id`, `order_id`, `from_status`, `to_status`, `operate_type`, `operator_id`, `operator_name`, `operator_role`, `operate_time`, `remark`) VALUES (63,10,'','pending','report',102,'业主张阿姨','owner','2026-08-26 10:30:00','业主提交故障报修');
INSERT INTO `order_status_log` (`log_id`, `order_id`, `from_status`, `to_status`, `operate_type`, `operator_id`, `operator_name`, `operator_role`, `operate_time`, `remark`) VALUES (64,10,'pending','assigned','assign',100,'物业管理员','property','2026-08-26 10:50:00','物业审核后指派维修员');
INSERT INTO `order_status_log` (`log_id`, `order_id`, `from_status`, `to_status`, `operate_type`, `operator_id`, `operator_name`, `operator_role`, `operate_time`, `remark`) VALUES (65,10,'assigned','accepted','accept',101,'维修员王师傅','worker','2026-08-26 11:00:00','维修员确认接单');
INSERT INTO `order_status_log` (`log_id`, `order_id`, `from_status`, `to_status`, `operate_type`, `operator_id`, `operator_name`, `operator_role`, `operate_time`, `remark`) VALUES (66,10,'accepted','arrived','arrive',101,'维修员王师傅','worker','2026-08-26 11:40:00','维修员已到达现场');
INSERT INTO `order_status_log` (`log_id`, `order_id`, `from_status`, `to_status`, `operate_type`, `operator_id`, `operator_name`, `operator_role`, `operate_time`, `remark`) VALUES (67,10,'arrived','repairing','investigate',101,'维修员王师傅','worker','2026-08-26 11:50:00','维修员排查故障原因');
INSERT INTO `order_status_log` (`log_id`, `order_id`, `from_status`, `to_status`, `operate_type`, `operator_id`, `operator_name`, `operator_role`, `operate_time`, `remark`) VALUES (68,10,'repairing','repaired','finish',101,'维修员王师傅','worker','2026-08-26 14:00:00','维修完成，提交处理说明');
INSERT INTO `order_status_log` (`log_id`, `order_id`, `from_status`, `to_status`, `operate_type`, `operator_id`, `operator_name`, `operator_role`, `operate_time`, `remark`) VALUES (69,10,'repaired','confirmed','confirm',102,'业主张阿姨','owner','2026-08-26 16:00:00','业主确认故障已消除，工单闭环');
INSERT INTO `order_status_log` (`log_id`, `order_id`, `from_status`, `to_status`, `operate_type`, `operator_id`, `operator_name`, `operator_role`, `operate_time`, `remark`) VALUES (70,11,'','pending','report',102,'业主张阿姨','owner','2026-09-19 15:30:00','业主提交故障报修');
INSERT INTO `order_status_log` (`log_id`, `order_id`, `from_status`, `to_status`, `operate_type`, `operator_id`, `operator_name`, `operator_role`, `operate_time`, `remark`) VALUES (71,11,'pending','assigned','assign',100,'物业管理员','property','2026-09-19 15:45:00','物业审核后指派维修员');
INSERT INTO `order_status_log` (`log_id`, `order_id`, `from_status`, `to_status`, `operate_type`, `operator_id`, `operator_name`, `operator_role`, `operate_time`, `remark`) VALUES (72,11,'assigned','accepted','accept',101,'维修员王师傅','worker','2026-09-19 15:50:00','维修员确认接单');
INSERT INTO `order_status_log` (`log_id`, `order_id`, `from_status`, `to_status`, `operate_type`, `operator_id`, `operator_name`, `operator_role`, `operate_time`, `remark`) VALUES (73,11,'accepted','arrived','arrive',101,'维修员王师傅','worker','2026-09-19 16:30:00','维修员已到达现场');
INSERT INTO `order_status_log` (`log_id`, `order_id`, `from_status`, `to_status`, `operate_type`, `operator_id`, `operator_name`, `operator_role`, `operate_time`, `remark`) VALUES (74,11,'arrived','repairing','investigate',101,'维修员王师傅','worker','2026-09-19 16:40:00','维修员排查故障原因');
INSERT INTO `order_status_log` (`log_id`, `order_id`, `from_status`, `to_status`, `operate_type`, `operator_id`, `operator_name`, `operator_role`, `operate_time`, `remark`) VALUES (75,11,'repairing','repaired','finish',101,'维修员王师傅','worker','2026-09-19 18:00:00','维修完成，提交处理说明');
INSERT INTO `order_status_log` (`log_id`, `order_id`, `from_status`, `to_status`, `operate_type`, `operator_id`, `operator_name`, `operator_role`, `operate_time`, `remark`) VALUES (76,11,'repaired','confirmed','confirm',102,'业主张阿姨','owner','2026-09-20 09:00:00','业主确认故障已消除，工单闭环');
INSERT INTO `order_status_log` (`log_id`, `order_id`, `from_status`, `to_status`, `operate_type`, `operator_id`, `operator_name`, `operator_role`, `operate_time`, `remark`) VALUES (77,12,'','pending','report',102,'业主张阿姨','owner','2026-09-08 11:00:00','业主提交故障报修');
INSERT INTO `order_status_log` (`log_id`, `order_id`, `from_status`, `to_status`, `operate_type`, `operator_id`, `operator_name`, `operator_role`, `operate_time`, `remark`) VALUES (78,12,'pending','assigned','assign',100,'物业管理员','property','2026-09-08 11:20:00','物业审核后指派维修员');
INSERT INTO `order_status_log` (`log_id`, `order_id`, `from_status`, `to_status`, `operate_type`, `operator_id`, `operator_name`, `operator_role`, `operate_time`, `remark`) VALUES (79,12,'assigned','accepted','accept',103,'维修员李师傅','worker','2026-09-08 11:30:00','维修员确认接单');
INSERT INTO `order_status_log` (`log_id`, `order_id`, `from_status`, `to_status`, `operate_type`, `operator_id`, `operator_name`, `operator_role`, `operate_time`, `remark`) VALUES (80,12,'accepted','arrived','arrive',103,'维修员李师傅','worker','2026-09-08 14:00:00','维修员已到达现场');
INSERT INTO `order_status_log` (`log_id`, `order_id`, `from_status`, `to_status`, `operate_type`, `operator_id`, `operator_name`, `operator_role`, `operate_time`, `remark`) VALUES (81,12,'arrived','repairing','investigate',103,'维修员李师傅','worker','2026-09-08 14:10:00','维修员排查故障原因');
INSERT INTO `order_status_log` (`log_id`, `order_id`, `from_status`, `to_status`, `operate_type`, `operator_id`, `operator_name`, `operator_role`, `operate_time`, `remark`) VALUES (82,12,'repairing','repaired','finish',103,'维修员李师傅','worker','2026-09-08 16:00:00','维修完成，提交处理说明');
INSERT INTO `order_status_log` (`log_id`, `order_id`, `from_status`, `to_status`, `operate_type`, `operator_id`, `operator_name`, `operator_role`, `operate_time`, `remark`) VALUES (83,12,'repaired','confirmed','confirm',102,'业主张阿姨','owner','2026-09-09 09:00:00','业主确认故障已消除，工单闭环');
/*!40000 ALTER TABLE `order_status_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `repair_evidence`
--

LOCK TABLES `repair_evidence` WRITE;
/*!40000 ALTER TABLE `repair_evidence` DISABLE KEYS */;
/*!40000 ALTER TABLE `repair_evidence` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `repair_order`
--

LOCK TABLES `repair_order` WRITE;
/*!40000 ALTER TABLE `repair_order` DISABLE KEYS */;
INSERT INTO `repair_order` (`order_id`, `order_no`, `user_id`, `elevator_id`, `fault_desc`, `fault_type`, `fault_level`, `order_status`, `reporter_phone`, `report_time`, `assign_time`, `accept_time`, `arrive_time`, `finish_time`, `confirm_time`, `assignee_id`, `assigner_id`, `reject_reason`, `deadline_time`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1,'BX20260722101501',102,6,'电梯运行中突然停梯，轿厢困人，需紧急救援','stop','0','confirmed','13800000003','2026-07-22 10:15:00','2026-07-22 10:22:00','2026-07-22 10:25:00','2026-07-22 10:48:00','2026-07-22 12:30:00','2026-07-22 14:00:00',104,100,NULL,'2026-07-22 10:35:00','0','admin','2026-10-12 20:40:24','',NULL,'困人事故，紧急救援后恢复运行');
INSERT INTO `repair_order` (`order_id`, `order_no`, `user_id`, `elevator_id`, `fault_desc`, `fault_type`, `fault_level`, `order_status`, `reporter_phone`, `report_time`, `assign_time`, `accept_time`, `arrive_time`, `finish_time`, `confirm_time`, `assignee_id`, `assigner_id`, `reject_reason`, `deadline_time`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2,'BX20260803142002',102,6,'电梯门关不上，反复开合','door','1','confirmed','13800000003','2026-08-03 14:20:00','2026-08-03 14:40:00','2026-08-03 14:45:00','2026-08-03 15:30:00','2026-08-03 17:00:00','2026-08-03 18:00:00',104,100,NULL,'2026-08-03 15:00:00','0','admin','2026-10-12 20:40:24','',NULL,'层门卡阻，调整后恢复');
INSERT INTO `repair_order` (`order_id`, `order_no`, `user_id`, `elevator_id`, `fault_desc`, `fault_type`, `fault_level`, `order_status`, `reporter_phone`, `report_time`, `assign_time`, `accept_time`, `arrive_time`, `finish_time`, `confirm_time`, `assignee_id`, `assigner_id`, `reject_reason`, `deadline_time`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (3,'BX20260818093003',102,6,'电梯运行时异响明显，轿厢晃动','noise','1','confirmed','13800000003','2026-08-18 09:30:00','2026-08-18 09:50:00','2026-08-18 10:00:00','2026-08-18 11:20:00','2026-08-18 15:00:00','2026-08-18 16:00:00',104,100,NULL,'2026-08-18 10:10:00','0','admin','2026-10-12 20:40:24','',NULL,'导靴磨损，更换后异响消除');
INSERT INTO `repair_order` (`order_id`, `order_no`, `user_id`, `elevator_id`, `fault_desc`, `fault_type`, `fault_level`, `order_status`, `reporter_phone`, `report_time`, `assign_time`, `accept_time`, `arrive_time`, `finish_time`, `confirm_time`, `assignee_id`, `assigner_id`, `reject_reason`, `deadline_time`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (4,'BX20260905161004',102,6,'电梯急停后无法再启动，楼层显示异常','stop','0','confirmed','13800000003','2026-09-05 16:10:00','2026-09-05 16:18:00','2026-09-05 16:20:00','2026-09-05 16:50:00','2026-09-05 21:00:00','2026-09-06 09:00:00',104,100,NULL,'2026-09-05 16:30:00','0','admin','2026-10-12 20:40:24','',NULL,'控制柜接触器故障，更换接触器');
INSERT INTO `repair_order` (`order_id`, `order_no`, `user_id`, `elevator_id`, `fault_desc`, `fault_type`, `fault_level`, `order_status`, `reporter_phone`, `report_time`, `assign_time`, `accept_time`, `arrive_time`, `finish_time`, `confirm_time`, `assignee_id`, `assigner_id`, `reject_reason`, `deadline_time`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (5,'BX20260922110505',102,6,'电梯溜梯，轿厢下坠半层后停住','slip','0','repaired','13800000003','2026-09-22 11:05:00','2026-09-22 11:12:00','2026-09-22 11:15:00','2026-09-22 11:40:00','2026-09-22 18:00:00',NULL,104,100,NULL,'2026-09-22 11:25:00','0','admin','2026-10-12 20:40:24','',NULL,'制动器间隙超标，已调整，待业主确认');
INSERT INTO `repair_order` (`order_id`, `order_no`, `user_id`, `elevator_id`, `fault_desc`, `fault_type`, `fault_level`, `order_status`, `reporter_phone`, `report_time`, `assign_time`, `accept_time`, `arrive_time`, `finish_time`, `confirm_time`, `assignee_id`, `assigner_id`, `reject_reason`, `deadline_time`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (6,'BX20260712103006',102,4,'电梯运行中突然停梯，乘客被困','stop','0','confirmed','13800000003','2026-07-12 10:30:00','2026-07-12 10:36:00','2026-07-12 10:40:00','2026-07-12 11:05:00','2026-07-12 13:00:00','2026-07-12 15:00:00',103,100,NULL,'2026-07-12 10:50:00','0','admin','2026-10-12 20:40:24','',NULL,'钢丝绳锈蚀卡阻，已停梯');
INSERT INTO `repair_order` (`order_id`, `order_no`, `user_id`, `elevator_id`, `fault_desc`, `fault_type`, `fault_level`, `order_status`, `reporter_phone`, `report_time`, `assign_time`, `accept_time`, `arrive_time`, `finish_time`, `confirm_time`, `assignee_id`, `assigner_id`, `reject_reason`, `deadline_time`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (7,'BX20260724150007',102,4,'电梯门无法关闭，多次反复','door','1','confirmed','13800000003','2026-07-24 15:00:00','2026-07-24 15:20:00','2026-07-24 15:25:00','2026-07-24 16:10:00','2026-07-24 18:00:00','2026-07-25 09:00:00',103,100,NULL,'2026-07-24 15:40:00','0','admin','2026-10-12 20:40:24','',NULL,'门锁触点烧蚀，更换后恢复');
INSERT INTO `repair_order` (`order_id`, `order_no`, `user_id`, `elevator_id`, `fault_desc`, `fault_type`, `fault_level`, `order_status`, `reporter_phone`, `report_time`, `assign_time`, `accept_time`, `arrive_time`, `finish_time`, `confirm_time`, `assignee_id`, `assigner_id`, `reject_reason`, `deadline_time`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (8,'BX20260811101508',102,4,'电梯制动时异响，停层不准','noise','1','confirmed','13800000003','2026-08-11 10:15:00','2026-08-11 10:30:00','2026-08-11 10:35:00','2026-08-11 11:30:00','2026-08-11 16:00:00','2026-08-12 09:00:00',103,100,NULL,'2026-08-11 10:45:00','0','admin','2026-10-12 20:40:24','',NULL,'制动器间隙超标，已调整');
INSERT INTO `repair_order` (`order_id`, `order_no`, `user_id`, `elevator_id`, `fault_desc`, `fault_type`, `fault_level`, `order_status`, `reporter_phone`, `report_time`, `assign_time`, `accept_time`, `arrive_time`, `finish_time`, `confirm_time`, `assignee_id`, `assigner_id`, `reject_reason`, `deadline_time`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (9,'BX20260915142009',102,4,'电梯困人，轿厢停在两层之间','stop','0','confirmed','13800000003','2026-09-15 14:20:00','2026-09-15 14:26:00','2026-09-15 14:30:00','2026-09-15 15:00:00','2026-09-15 17:30:00','2026-09-16 09:00:00',103,100,NULL,'2026-09-15 14:40:00','0','admin','2026-10-12 20:40:24','',NULL,'限速器动作异常，已检修，电梯停用待大修');
INSERT INTO `repair_order` (`order_id`, `order_no`, `user_id`, `elevator_id`, `fault_desc`, `fault_type`, `fault_level`, `order_status`, `reporter_phone`, `report_time`, `assign_time`, `accept_time`, `arrive_time`, `finish_time`, `confirm_time`, `assignee_id`, `assigner_id`, `reject_reason`, `deadline_time`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (10,'BX20260826103010',102,2,'电梯门开合时有异响','noise','1','confirmed','13800000003','2026-08-26 10:30:00','2026-08-26 10:50:00','2026-08-26 11:00:00','2026-08-26 11:40:00','2026-08-26 14:00:00','2026-08-26 16:00:00',101,100,NULL,'2026-08-26 11:10:00','0','admin','2026-10-12 20:40:24','',NULL,'层门滑道缺油，润滑后异响减轻');
INSERT INTO `repair_order` (`order_id`, `order_no`, `user_id`, `elevator_id`, `fault_desc`, `fault_type`, `fault_level`, `order_status`, `reporter_phone`, `report_time`, `assign_time`, `accept_time`, `arrive_time`, `finish_time`, `confirm_time`, `assignee_id`, `assigner_id`, `reject_reason`, `deadline_time`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (11,'BX20260919153011',102,2,'电梯按钮失灵，按了没反应','button','1','confirmed','13800000003','2026-09-19 15:30:00','2026-09-19 15:45:00','2026-09-19 15:50:00','2026-09-19 16:30:00','2026-09-19 18:00:00','2026-09-20 09:00:00',101,100,NULL,'2026-09-19 16:00:00','0','admin','2026-10-12 20:40:24','',NULL,'按钮触点氧化，更换按钮');
INSERT INTO `repair_order` (`order_id`, `order_no`, `user_id`, `elevator_id`, `fault_desc`, `fault_type`, `fault_level`, `order_status`, `reporter_phone`, `report_time`, `assign_time`, `accept_time`, `arrive_time`, `finish_time`, `confirm_time`, `assignee_id`, `assigner_id`, `reject_reason`, `deadline_time`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (12,'BX20260908110012',102,3,'电梯运行中有轻微异响','noise','1','confirmed','13800000003','2026-09-08 11:00:00','2026-09-08 11:20:00','2026-09-08 11:30:00','2026-09-08 14:00:00','2026-09-08 16:00:00','2026-09-09 09:00:00',103,100,NULL,'2026-09-08 11:40:00','0','admin','2026-10-12 20:40:24','',NULL,'控制柜接触器异响，已更换');
/*!40000 ALTER TABLE `repair_order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `repair_record`
--

LOCK TABLES `repair_record` WRITE;
/*!40000 ALTER TABLE `repair_record` DISABLE KEYS */;
INSERT INTO `repair_record` (`record_id`, `order_id`, `worker_id`, `arrive_time`, `arrive_location`, `arrive_longitude`, `arrive_latitude`, `arrive_distance`, `demo_flag`, `investigate_note`, `repair_desc`, `fault_reason`, `replace_parts`, `finish_time`, `result_file_id`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (1,1,104,'2026-07-22 10:48:00','铁路新村小区 A座 1单元 1层',NULL,NULL,NULL,'0','到达现场确认轿厢停在 3 层与 4 层之间，两人被困，先手动盘车至平层放人','手动盘车放人后检查限速器与安全钳，复位安全回路，试运行恢复正常','限速器误动作触发安全回路','限速器复位弹簧 1 套','2026-07-22 12:30:00',NULL,'admin','2026-10-12 20:40:24',NULL,NULL);
INSERT INTO `repair_record` (`record_id`, `order_id`, `worker_id`, `arrive_time`, `arrive_location`, `arrive_longitude`, `arrive_latitude`, `arrive_distance`, `demo_flag`, `investigate_note`, `repair_desc`, `fault_reason`, `replace_parts`, `finish_time`, `result_file_id`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (2,2,104,'2026-08-03 15:30:00','铁路新村小区 A座 1单元 1层',NULL,NULL,NULL,'0','检查层门地坎有异物，门机力矩偏小','清理地坎异物并调整门机力矩，反复开合 20 次无卡阻','层门地坎卡阻','无','2026-08-03 17:00:00',NULL,'admin','2026-10-12 20:40:24',NULL,NULL);
INSERT INTO `repair_record` (`record_id`, `order_id`, `worker_id`, `arrive_time`, `arrive_location`, `arrive_longitude`, `arrive_latitude`, `arrive_distance`, `demo_flag`, `investigate_note`, `repair_desc`, `fault_reason`, `replace_parts`, `finish_time`, `result_file_id`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (3,3,104,'2026-08-18 11:20:00','铁路新村小区 A座 1单元 6层',NULL,NULL,NULL,'0','随梯运行听音定位，异响来自轿厢导靴与导轨摩擦','更换四只导靴并加注润滑油，试运行异响消除','导靴磨损超限','导靴 4 只、导轨油 1 桶','2026-08-18 15:00:00',NULL,'admin','2026-10-12 20:40:24',NULL,NULL);
INSERT INTO `repair_record` (`record_id`, `order_id`, `worker_id`, `arrive_time`, `arrive_location`, `arrive_longitude`, `arrive_latitude`, `arrive_distance`, `demo_flag`, `investigate_note`, `repair_desc`, `fault_reason`, `replace_parts`, `finish_time`, `result_file_id`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (4,4,104,'2026-09-05 16:50:00','铁路新村小区 A座 1单元 1层',NULL,NULL,NULL,'0','控制柜内接触器吸合时有明显打火痕迹，触点烧蚀','更换主接触器并紧固接线端子，恢复运行观察 2 小时无异常','主接触器触点烧蚀','交流接触器 1 台','2026-09-05 21:00:00',NULL,'admin','2026-10-12 20:40:24',NULL,NULL);
INSERT INTO `repair_record` (`record_id`, `order_id`, `worker_id`, `arrive_time`, `arrive_location`, `arrive_longitude`, `arrive_latitude`, `arrive_distance`, `demo_flag`, `investigate_note`, `repair_desc`, `fault_reason`, `replace_parts`, `finish_time`, `result_file_id`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (5,5,104,'2026-09-22 11:40:00','铁路新村小区 A座 1单元 1层',NULL,NULL,NULL,'0','用塞尺测量制动器间隙，左右两侧均超过 0.7mm 标准值','调整制动器间隙至 0.4mm 并做 125% 额定载荷制动试验，合格','制动器间隙超标','制动器闸瓦 2 副','2026-09-22 18:00:00',NULL,'admin','2026-10-12 20:40:24',NULL,NULL);
INSERT INTO `repair_record` (`record_id`, `order_id`, `worker_id`, `arrive_time`, `arrive_location`, `arrive_longitude`, `arrive_latitude`, `arrive_distance`, `demo_flag`, `investigate_note`, `repair_desc`, `fault_reason`, `replace_parts`, `finish_time`, `result_file_id`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (6,6,103,'2026-07-12 11:05:00','和平里小区 3号楼 1单元 1层',NULL,NULL,NULL,'0','检查发现曳引钢丝绳锈蚀，局部断丝超标，运行中卡阻导致急停','更换全部曳引钢丝绳，复检张力均匀后停梯待大修评估','钢丝绳锈蚀断丝','曳引钢丝绳 6 根','2026-07-12 13:00:00',NULL,'admin','2026-10-12 20:40:24',NULL,NULL);
INSERT INTO `repair_record` (`record_id`, `order_id`, `worker_id`, `arrive_time`, `arrive_location`, `arrive_longitude`, `arrive_latitude`, `arrive_distance`, `demo_flag`, `investigate_note`, `repair_desc`, `fault_reason`, `replace_parts`, `finish_time`, `result_file_id`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (7,7,103,'2026-07-24 16:10:00','和平里小区 3号楼 1单元 1层',NULL,NULL,NULL,'0','拆检门锁发现触点烧蚀发黑，接触电阻偏大','更换门锁触点组件，调整门锁啮合深度，开关门测试正常','门锁触点烧蚀','门锁触点 2 套','2026-07-24 18:00:00',NULL,'admin','2026-10-12 20:40:24',NULL,NULL);
INSERT INTO `repair_record` (`record_id`, `order_id`, `worker_id`, `arrive_time`, `arrive_location`, `arrive_longitude`, `arrive_latitude`, `arrive_distance`, `demo_flag`, `investigate_note`, `repair_desc`, `fault_reason`, `replace_parts`, `finish_time`, `result_file_id`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (8,8,103,'2026-08-11 11:30:00','和平里小区 3号楼 1单元 1层',NULL,NULL,NULL,'0','测量制动器间隙超标，制动时闸瓦与制动轮摩擦产生异响','调整制动器间隙并做制动试验，停层准确度恢复正常','制动器间隙超标','无','2026-08-11 16:00:00',NULL,'admin','2026-10-12 20:40:24',NULL,NULL);
INSERT INTO `repair_record` (`record_id`, `order_id`, `worker_id`, `arrive_time`, `arrive_location`, `arrive_longitude`, `arrive_latitude`, `arrive_distance`, `demo_flag`, `investigate_note`, `repair_desc`, `fault_reason`, `replace_parts`, `finish_time`, `result_file_id`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (9,9,103,'2026-09-15 15:00:00','和平里小区 3号楼 1单元 1层',NULL,NULL,NULL,'0','限速器动作后未正常复位，安全钳楔块卡滞','复位安全钳并检修限速器，因曳引机亦有异常，电梯停用待大修','限速器动作异常、安全钳卡滞','安全钳楔块 2 块','2026-09-15 17:30:00',NULL,'admin','2026-10-12 20:40:24',NULL,NULL);
INSERT INTO `repair_record` (`record_id`, `order_id`, `worker_id`, `arrive_time`, `arrive_location`, `arrive_longitude`, `arrive_latitude`, `arrive_distance`, `demo_flag`, `investigate_note`, `repair_desc`, `fault_reason`, `replace_parts`, `finish_time`, `result_file_id`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (10,10,101,'2026-08-26 11:40:00','阳光家园小区 1号楼 2单元 1层',NULL,NULL,NULL,'0','随梯听音确认异响来自层门滑道，滑道干涩','清理滑道并加注润滑脂，开关门异响明显减轻','层门滑道缺油','润滑脂 1 支','2026-08-26 14:00:00',NULL,'admin','2026-10-12 20:40:24',NULL,NULL);
INSERT INTO `repair_record` (`record_id`, `order_id`, `worker_id`, `arrive_time`, `arrive_location`, `arrive_longitude`, `arrive_latitude`, `arrive_distance`, `demo_flag`, `investigate_note`, `repair_desc`, `fault_reason`, `replace_parts`, `finish_time`, `result_file_id`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (11,11,101,'2026-09-19 16:30:00','阳光家园小区 1号楼 2单元 3层',NULL,NULL,NULL,'0','拆下按钮实测触点氧化，导通不良','更换该层外呼按钮并除尘，逐层测试信号正常','按钮触点氧化','外呼按钮 1 只','2026-09-19 18:00:00',NULL,'admin','2026-10-12 20:40:24',NULL,NULL);
INSERT INTO `repair_record` (`record_id`, `order_id`, `worker_id`, `arrive_time`, `arrive_location`, `arrive_longitude`, `arrive_latitude`, `arrive_distance`, `demo_flag`, `investigate_note`, `repair_desc`, `fault_reason`, `replace_parts`, `finish_time`, `result_file_id`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (12,12,103,'2026-09-08 14:00:00','阳光家园小区 2号楼 1单元 1层',NULL,NULL,NULL,'0','打开控制柜听音确认异响来自接触器，吸合时有轻微打火','更换控制柜接触器并紧固接线，试运行异响消除','控制柜接触器异响','交流接触器 1 台','2026-09-08 16:00:00',NULL,'admin','2026-10-12 20:40:24',NULL,NULL);
/*!40000 ALTER TABLE `repair_record` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `sys_config`
--

LOCK TABLES `sys_config` WRITE;
/*!40000 ALTER TABLE `sys_config` DISABLE KEYS */;
INSERT INTO `sys_config` (`config_id`, `config_name`, `config_key`, `config_value`, `config_type`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1,'主框架页-默认皮肤样式名称','sys.index.skinName','skin-blue','Y','admin','2026-10-12 20:40:23','',NULL,'蓝色 skin-blue、绿色 skin-green、紫色 skin-purple、红色 skin-red、黄色 skin-yellow');
INSERT INTO `sys_config` (`config_id`, `config_name`, `config_key`, `config_value`, `config_type`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2,'用户管理-账号初始密码','sys.user.initPassword','123456','Y','admin','2026-10-12 20:40:23','',NULL,'初始化密码 123456');
INSERT INTO `sys_config` (`config_id`, `config_name`, `config_key`, `config_value`, `config_type`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (3,'主框架页-侧边栏主题','sys.index.sideTheme','theme-dark','Y','admin','2026-10-12 20:40:23','',NULL,'深色主题theme-dark，浅色主题theme-light');
INSERT INTO `sys_config` (`config_id`, `config_name`, `config_key`, `config_value`, `config_type`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (4,'账号自助-验证码开关','sys.account.captchaEnabled','true','Y','admin','2026-10-12 20:40:23','',NULL,'是否开启验证码功能（true开启，false关闭）');
INSERT INTO `sys_config` (`config_id`, `config_name`, `config_key`, `config_value`, `config_type`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (5,'账号自助-是否开启用户注册功能','sys.account.registerUser','false','Y','admin','2026-10-12 20:40:23','',NULL,'是否开启注册用户功能（true开启，false关闭）');
INSERT INTO `sys_config` (`config_id`, `config_name`, `config_key`, `config_value`, `config_type`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (6,'用户登录-黑名单列表','sys.login.blackIPList','','Y','admin','2026-10-12 20:40:23','',NULL,'设置登录IP黑名单限制，多个匹配项以;分隔，支持匹配（*通配、网段）');
INSERT INTO `sys_config` (`config_id`, `config_name`, `config_key`, `config_value`, `config_type`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (7,'用户管理-初始密码修改策略','sys.account.initPasswordModify','1','Y','admin','2026-10-12 20:40:23','',NULL,'0：初始密码修改策略关闭，没有任何提示，1：提醒用户，如果未修改初始密码，则在登录时就会提醒修改密码对话框');
INSERT INTO `sys_config` (`config_id`, `config_name`, `config_key`, `config_value`, `config_type`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (8,'用户管理-账号密码更新周期','sys.account.passwordValidateDays','0','Y','admin','2026-10-12 20:40:23','',NULL,'密码更新周期（填写数字，数据初始化值为0不限制，若修改必须为大于0小于365的正整数），如果超过这个周期登录系统时，则在登录时就会提醒修改密码对话框');
INSERT INTO `sys_config` (`config_id`, `config_name`, `config_key`, `config_value`, `config_type`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (9,'用户管理-密码字符范围','sys.account.chrtype','0','Y','admin','2026-10-12 20:40:23','',NULL,'默认任意字符范围，0任意（密码可以输入任意字符），1数字（密码只能为0-9数字），2英文字母（密码只能为a-z和A-Z字母），3字母和数字（密码必须包含字母，数字）,4字母数字和特殊字符（目前支持的特殊字符包括：~!@#$%^&*()-=_+）');
/*!40000 ALTER TABLE `sys_config` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `sys_dict_data`
--

LOCK TABLES `sys_dict_data` WRITE;
/*!40000 ALTER TABLE `sys_dict_data` DISABLE KEYS */;
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1,1,'男','0','sys_user_sex','','','Y','0','admin','2026-10-12 20:40:22','',NULL,'性别男');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2,2,'女','1','sys_user_sex','','','N','0','admin','2026-10-12 20:40:22','',NULL,'性别女');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (3,3,'未知','2','sys_user_sex','','','N','0','admin','2026-10-12 20:40:22','',NULL,'性别未知');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (4,1,'显示','0','sys_show_hide','','primary','Y','0','admin','2026-10-12 20:40:22','',NULL,'显示菜单');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (5,2,'隐藏','1','sys_show_hide','','danger','N','0','admin','2026-10-12 20:40:22','',NULL,'隐藏菜单');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (6,1,'正常','0','sys_normal_disable','','primary','Y','0','admin','2026-10-12 20:40:22','',NULL,'正常状态');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (7,2,'停用','1','sys_normal_disable','','danger','N','0','admin','2026-10-12 20:40:22','',NULL,'停用状态');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (8,1,'正常','0','sys_job_status','','primary','Y','0','admin','2026-10-12 20:40:22','',NULL,'正常状态');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (9,2,'暂停','1','sys_job_status','','danger','N','0','admin','2026-10-12 20:40:22','',NULL,'停用状态');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (10,1,'默认','DEFAULT','sys_job_group','','','Y','0','admin','2026-10-12 20:40:22','',NULL,'默认分组');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (11,2,'系统','SYSTEM','sys_job_group','','','N','0','admin','2026-10-12 20:40:22','',NULL,'系统分组');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (12,1,'是','Y','sys_yes_no','','primary','Y','0','admin','2026-10-12 20:40:22','',NULL,'系统默认是');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (13,2,'否','N','sys_yes_no','','danger','N','0','admin','2026-10-12 20:40:22','',NULL,'系统默认否');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (14,1,'通知','1','sys_notice_type','','warning','Y','0','admin','2026-10-12 20:40:22','',NULL,'通知');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (15,2,'公告','2','sys_notice_type','','success','N','0','admin','2026-10-12 20:40:22','',NULL,'公告');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (16,1,'正常','0','sys_notice_status','','primary','Y','0','admin','2026-10-12 20:40:22','',NULL,'正常状态');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (17,2,'关闭','1','sys_notice_status','','danger','N','0','admin','2026-10-12 20:40:22','',NULL,'关闭状态');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (18,99,'其他','0','sys_oper_type','','info','N','0','admin','2026-10-12 20:40:22','',NULL,'其他操作');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (19,1,'新增','1','sys_oper_type','','info','N','0','admin','2026-10-12 20:40:22','',NULL,'新增操作');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (20,2,'修改','2','sys_oper_type','','info','N','0','admin','2026-10-12 20:40:23','',NULL,'修改操作');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (21,3,'删除','3','sys_oper_type','','danger','N','0','admin','2026-10-12 20:40:23','',NULL,'删除操作');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (22,4,'授权','4','sys_oper_type','','primary','N','0','admin','2026-10-12 20:40:23','',NULL,'授权操作');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (23,5,'导出','5','sys_oper_type','','warning','N','0','admin','2026-10-12 20:40:23','',NULL,'导出操作');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (24,6,'导入','6','sys_oper_type','','warning','N','0','admin','2026-10-12 20:40:23','',NULL,'导入操作');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (25,7,'强退','7','sys_oper_type','','danger','N','0','admin','2026-10-12 20:40:23','',NULL,'强退操作');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (26,8,'生成代码','8','sys_oper_type','','warning','N','0','admin','2026-10-12 20:40:23','',NULL,'生成操作');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (27,9,'清空数据','9','sys_oper_type','','danger','N','0','admin','2026-10-12 20:40:23','',NULL,'清空操作');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (28,1,'成功','0','sys_common_status','','primary','N','0','admin','2026-10-12 20:40:23','',NULL,'正常状态');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (29,2,'失败','1','sys_common_status','','danger','N','0','admin','2026-10-12 20:40:23','',NULL,'停用状态');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (100,1,'待处理','pending','repair_order_status','','warning','Y','0','admin','2026-10-12 20:40:24','',NULL,'报修已提交，等待物业审核');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (101,2,'已派单','assigned','repair_order_status','','primary','N','0','admin','2026-10-12 20:40:24','',NULL,'物业已指派维修员');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (102,3,'已接单','accepted','repair_order_status','','info','N','0','admin','2026-10-12 20:40:24','',NULL,'维修员已确认接单');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (103,4,'已到场','arrived','repair_order_status','','info','N','0','admin','2026-10-12 20:40:24','',NULL,'维修员已到达现场');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (104,5,'维修中','repairing','repair_order_status','','info','N','0','admin','2026-10-12 20:40:24','',NULL,'正在排查与维修');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (105,6,'已修复','repaired','repair_order_status','','success','N','0','admin','2026-10-12 20:40:24','',NULL,'维修完成，等待业主确认');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (106,7,'已完成','confirmed','repair_order_status','','success','N','0','admin','2026-10-12 20:40:24','',NULL,'业主已确认，工单闭环');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (107,8,'已驳回','rejected','repair_order_status','','danger','N','0','admin','2026-10-12 20:40:24','',NULL,'物业驳回，待业主补充');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (108,9,'已申诉','appealed','repair_order_status','','danger','N','0','admin','2026-10-12 20:40:24','',NULL,'业主对结果不满意，转物业处理');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (110,1,'紧急','0','fault_level','','danger','N','0','admin','2026-10-12 20:40:24','',NULL,'困人、停梯、溜梯等危及人身安全的情形');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (111,2,'一般','1','fault_level','','warning','N','0','admin','2026-10-12 20:40:24','',NULL,'异响、按键失灵、照明故障等不影响安全的情形');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (120,1,'异响','abnormal_noise','fault_type','','','N','0','admin','2026-10-12 20:40:24','',NULL,'');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (121,2,'停梯','stop','fault_type','','','N','0','admin','2026-10-12 20:40:24','',NULL,'');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (122,3,'困人','trapped','fault_type','','','N','0','admin','2026-10-12 20:40:24','',NULL,'');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (123,4,'门故障','door','fault_type','','','N','0','admin','2026-10-12 20:40:24','',NULL,'');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (124,5,'按钮失灵','button','fault_type','','','N','0','admin','2026-10-12 20:40:24','',NULL,'');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (125,6,'其他','other','fault_type','','','N','0','admin','2026-10-12 20:40:24','',NULL,'');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (130,1,'半月保','half_month','maintain_type','','','N','0','admin','2026-10-12 20:40:24','',NULL,'每15天一次');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (131,2,'季度检','quarter','maintain_type','','','N','0','admin','2026-10-12 20:40:24','',NULL,'每90天一次');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (132,3,'半年保','half_year','maintain_type','','','N','0','admin','2026-10-12 20:40:24','',NULL,'每180天一次');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (133,4,'年检','annual','maintain_type','','','N','0','admin','2026-10-12 20:40:24','',NULL,'每365天一次');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (140,1,'正常运行','0','elevator_status','','success','N','0','admin','2026-10-12 20:40:24','',NULL,'');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (141,2,'停梯检修','1','elevator_status','','warning','N','0','admin','2026-10-12 20:40:24','',NULL,'');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (142,3,'已报废','2','elevator_status','','danger','N','0','admin','2026-10-12 20:40:24','',NULL,'');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (150,1,'提交报修','report','order_operation','','','N','0','admin','2026-10-12 20:40:24','',NULL,'');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (151,2,'驳回','reject','order_operation','','','N','0','admin','2026-10-12 20:40:24','',NULL,'');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (152,3,'派单','assign','order_operation','','','N','0','admin','2026-10-12 20:40:24','',NULL,'');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (153,4,'接单','accept','order_operation','','','N','0','admin','2026-10-12 20:40:24','',NULL,'');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (154,5,'到场','arrive','order_operation','','','N','0','admin','2026-10-12 20:40:24','',NULL,'');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (155,6,'排查','investigate','order_operation','','','N','0','admin','2026-10-12 20:40:24','',NULL,'');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (156,7,'维修完成','finish','order_operation','','','N','0','admin','2026-10-12 20:40:24','',NULL,'');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (157,8,'业主确认','confirm','order_operation','','','N','0','admin','2026-10-12 20:40:24','',NULL,'');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (158,9,'申诉','appeal','order_operation','','','N','0','admin','2026-10-12 20:40:24','',NULL,'');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (159,10,'重新指派','reassign','order_operation','','','N','0','admin','2026-10-12 20:40:24','',NULL,'');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (160,11,'升级处理','escalate','order_operation','','','N','0','admin','2026-10-12 20:40:24','',NULL,'');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (170,1,'优秀','excellent','health_level','','success','N','0','admin','2026-10-12 20:40:24','',NULL,'90分及以上');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (171,2,'良好','good','health_level','','success','N','0','admin','2026-10-12 20:40:24','',NULL,'80-89分');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (172,3,'一般','fair','health_level','','warning','N','0','admin','2026-10-12 20:40:24','',NULL,'70-79分');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (173,4,'较差','poor','health_level','','warning','N','0','admin','2026-10-12 20:40:24','',NULL,'60-69分');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (174,5,'危险','danger','health_level','','danger','N','0','admin','2026-10-12 20:40:24','',NULL,'60分以下');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (180,1,'工单超时','order_timeout','warning_type','','warning','N','0','admin','2026-10-12 20:40:24','',NULL,'');
INSERT INTO `sys_dict_data` (`dict_code`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (181,2,'维保临期','maintain_due','warning_type','','warning','N','0','admin','2026-10-12 20:40:24','',NULL,'');
/*!40000 ALTER TABLE `sys_dict_data` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `sys_dict_type`
--

LOCK TABLES `sys_dict_type` WRITE;
/*!40000 ALTER TABLE `sys_dict_type` DISABLE KEYS */;
INSERT INTO `sys_dict_type` (`dict_id`, `dict_name`, `dict_type`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1,'用户性别','sys_user_sex','0','admin','2026-10-12 20:40:22','',NULL,'用户性别列表');
INSERT INTO `sys_dict_type` (`dict_id`, `dict_name`, `dict_type`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2,'菜单状态','sys_show_hide','0','admin','2026-10-12 20:40:22','',NULL,'菜单状态列表');
INSERT INTO `sys_dict_type` (`dict_id`, `dict_name`, `dict_type`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (3,'系统开关','sys_normal_disable','0','admin','2026-10-12 20:40:22','',NULL,'系统开关列表');
INSERT INTO `sys_dict_type` (`dict_id`, `dict_name`, `dict_type`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (4,'任务状态','sys_job_status','0','admin','2026-10-12 20:40:22','',NULL,'任务状态列表');
INSERT INTO `sys_dict_type` (`dict_id`, `dict_name`, `dict_type`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (5,'任务分组','sys_job_group','0','admin','2026-10-12 20:40:22','',NULL,'任务分组列表');
INSERT INTO `sys_dict_type` (`dict_id`, `dict_name`, `dict_type`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (6,'系统是否','sys_yes_no','0','admin','2026-10-12 20:40:22','',NULL,'系统是否列表');
INSERT INTO `sys_dict_type` (`dict_id`, `dict_name`, `dict_type`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (7,'通知类型','sys_notice_type','0','admin','2026-10-12 20:40:22','',NULL,'通知类型列表');
INSERT INTO `sys_dict_type` (`dict_id`, `dict_name`, `dict_type`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (8,'通知状态','sys_notice_status','0','admin','2026-10-12 20:40:22','',NULL,'通知状态列表');
INSERT INTO `sys_dict_type` (`dict_id`, `dict_name`, `dict_type`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (9,'操作类型','sys_oper_type','0','admin','2026-10-12 20:40:22','',NULL,'操作类型列表');
INSERT INTO `sys_dict_type` (`dict_id`, `dict_name`, `dict_type`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (10,'系统状态','sys_common_status','0','admin','2026-10-12 20:40:22','',NULL,'登录状态列表');
INSERT INTO `sys_dict_type` (`dict_id`, `dict_name`, `dict_type`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (100,'工单状态','repair_order_status','0','admin','2026-10-12 20:40:24','',NULL,'报修工单状态列表');
INSERT INTO `sys_dict_type` (`dict_id`, `dict_name`, `dict_type`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (101,'故障等级','fault_level','0','admin','2026-10-12 20:40:24','',NULL,'故障等级列表');
INSERT INTO `sys_dict_type` (`dict_id`, `dict_name`, `dict_type`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (102,'故障类型','fault_type','0','admin','2026-10-12 20:40:24','',NULL,'故障现象类型列表');
INSERT INTO `sys_dict_type` (`dict_id`, `dict_name`, `dict_type`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (103,'维保类型','maintain_type','0','admin','2026-10-12 20:40:24','',NULL,'维保类型列表');
INSERT INTO `sys_dict_type` (`dict_id`, `dict_name`, `dict_type`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (104,'电梯状态','elevator_status','0','admin','2026-10-12 20:40:24','',NULL,'电梯状态列表');
INSERT INTO `sys_dict_type` (`dict_id`, `dict_name`, `dict_type`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (105,'工单操作类型','order_operation','0','admin','2026-10-12 20:40:24','',NULL,'工单状态流转操作类型');
INSERT INTO `sys_dict_type` (`dict_id`, `dict_name`, `dict_type`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (106,'健康等级','health_level','0','admin','2026-10-12 20:40:24','',NULL,'电梯健康等级列表');
INSERT INTO `sys_dict_type` (`dict_id`, `dict_name`, `dict_type`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (107,'预警类型','warning_type','0','admin','2026-10-12 20:40:24','',NULL,'预警类型列表');
/*!40000 ALTER TABLE `sys_dict_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `sys_file`
--

LOCK TABLES `sys_file` WRITE;
/*!40000 ALTER TABLE `sys_file` DISABLE KEYS */;
/*!40000 ALTER TABLE `sys_file` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `sys_job`
--

LOCK TABLES `sys_job` WRITE;
/*!40000 ALTER TABLE `sys_job` DISABLE KEYS */;
INSERT INTO `sys_job` (`job_id`, `job_name`, `job_group`, `invoke_target`, `cron_expression`, `misfire_policy`, `concurrent`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1,'系统默认（无参）','DEFAULT','ryTask.ryNoParams','0/10 * * * * ?','3','1','1','admin','2026-10-12 20:40:23','',NULL,'');
INSERT INTO `sys_job` (`job_id`, `job_name`, `job_group`, `invoke_target`, `cron_expression`, `misfire_policy`, `concurrent`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2,'系统默认（有参）','DEFAULT','ryTask.ryParams(\'ry\')','0/15 * * * * ?','3','1','1','admin','2026-10-12 20:40:23','',NULL,'');
INSERT INTO `sys_job` (`job_id`, `job_name`, `job_group`, `invoke_target`, `cron_expression`, `misfire_policy`, `concurrent`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (3,'系统默认（多参）','DEFAULT','ryTask.ryMultipleParams(\'ry\', true, 2000L, 316.50D, 100)','0/20 * * * * ?','3','1','1','admin','2026-10-12 20:40:23','',NULL,'');
INSERT INTO `sys_job` (`job_id`, `job_name`, `job_group`, `invoke_target`, `cron_expression`, `misfire_policy`, `concurrent`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (100,'巡检工单自动生成','DEFAULT','inspectionGenerateTask.execute()','0 0 1 * * ?','3','1','0','admin','2026-10-12 20:40:24','',NULL,'每日 01:00 扫描到期维保计划，自动生成巡检工单并标记超期任务');
INSERT INTO `sys_job` (`job_id`, `job_name`, `job_group`, `invoke_target`, `cron_expression`, `misfire_policy`, `concurrent`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (101,'超期预警扫描','DEFAULT','warningScanTask.execute()','0 0/30 * * * ?','3','1','0','admin','2026-10-12 20:40:24','',NULL,'每 30 分钟扫描工单超时与维保临期，按启用规则生成预警并推送');
INSERT INTO `sys_job` (`job_id`, `job_name`, `job_group`, `invoke_target`, `cron_expression`, `misfire_policy`, `concurrent`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (102,'电梯健康评分重算','DEFAULT','healthScoreTask.execute()','0 0 2 * * ?','3','1','0','admin','2026-10-12 20:40:24','',NULL,'每日 02:00 按统计周期重算全部电梯的健康评分');
/*!40000 ALTER TABLE `sys_job` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `sys_menu`
--

LOCK TABLES `sys_menu` WRITE;
/*!40000 ALTER TABLE `sys_menu` DISABLE KEYS */;
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1,'系统管理',0,1,'system',NULL,'','',1,0,'M','0','0','','system','admin','2026-10-12 20:40:22','',NULL,'系统管理目录');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2,'系统监控',0,2,'monitor',NULL,'','',1,0,'M','0','0','','monitor','admin','2026-10-12 20:40:22','',NULL,'系统监控目录');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (100,'用户管理',1,1,'user','system/user/index','','',1,0,'C','0','0','system:user:list','user','admin','2026-10-12 20:40:22','',NULL,'用户管理菜单');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (101,'角色管理',1,2,'role','system/role/index','','',1,0,'C','0','0','system:role:list','peoples','admin','2026-10-12 20:40:22','',NULL,'角色管理菜单');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (102,'菜单管理',1,3,'menu','system/menu/index','','',1,0,'C','0','0','system:menu:list','tree-table','admin','2026-10-12 20:40:22','',NULL,'菜单管理菜单');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (105,'字典管理',1,6,'dict','system/dict/index','','',1,0,'C','0','0','system:dict:list','dict','admin','2026-10-12 20:40:22','',NULL,'字典管理菜单');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (106,'参数设置',1,7,'config','system/config/index','','',1,0,'C','0','0','system:config:list','edit','admin','2026-10-12 20:40:22','',NULL,'参数设置菜单');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (107,'通知公告',1,8,'notice','system/notice/index','','',1,0,'C','0','0','system:notice:list','message','admin','2026-10-12 20:40:22','',NULL,'通知公告菜单');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (108,'日志管理',1,9,'log','','','',1,0,'M','0','0','','log','admin','2026-10-12 20:40:22','',NULL,'日志管理菜单');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (109,'在线用户',2,1,'online','monitor/online/index','','',1,0,'C','0','0','monitor:online:list','online','admin','2026-10-12 20:40:22','',NULL,'在线用户菜单');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (110,'定时任务',2,2,'job','monitor/job/index','','',1,0,'C','0','0','monitor:job:list','job','admin','2026-10-12 20:40:22','',NULL,'定时任务菜单');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (111,'数据监控',2,3,'druid','monitor/druid/index','','',1,0,'C','0','0','monitor:druid:list','druid','admin','2026-10-12 20:40:22','',NULL,'数据监控菜单');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (112,'服务监控',2,4,'server','monitor/server/index','','',1,0,'C','0','0','monitor:server:list','server','admin','2026-10-12 20:40:22','',NULL,'服务监控菜单');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (113,'缓存监控',2,5,'cache','monitor/cache/index','','',1,0,'C','0','0','monitor:cache:list','redis','admin','2026-10-12 20:40:22','',NULL,'缓存监控菜单');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (114,'缓存列表',2,6,'cacheList','monitor/cache/list','','',1,0,'C','0','0','monitor:cache:list','redis-list','admin','2026-10-12 20:40:22','',NULL,'缓存列表菜单');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (500,'操作日志',108,1,'operlog','monitor/operlog/index','','',1,0,'C','0','0','monitor:operlog:list','form','admin','2026-10-12 20:40:22','',NULL,'操作日志菜单');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (501,'登录日志',108,2,'logininfor','monitor/logininfor/index','','',1,0,'C','0','0','monitor:logininfor:list','logininfor','admin','2026-10-12 20:40:22','',NULL,'登录日志菜单');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1000,'用户查询',100,1,'','','','',1,0,'F','0','0','system:user:query','#','admin','2026-10-12 20:40:22','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1001,'用户新增',100,2,'','','','',1,0,'F','0','0','system:user:add','#','admin','2026-10-12 20:40:22','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1002,'用户修改',100,3,'','','','',1,0,'F','0','0','system:user:edit','#','admin','2026-10-12 20:40:22','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1003,'用户删除',100,4,'','','','',1,0,'F','0','0','system:user:remove','#','admin','2026-10-12 20:40:22','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1004,'用户导出',100,5,'','','','',1,0,'F','0','0','system:user:export','#','admin','2026-10-12 20:40:22','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1005,'用户导入',100,6,'','','','',1,0,'F','0','0','system:user:import','#','admin','2026-10-12 20:40:22','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1006,'重置密码',100,7,'','','','',1,0,'F','0','0','system:user:resetPwd','#','admin','2026-10-12 20:40:22','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1007,'角色查询',101,1,'','','','',1,0,'F','0','0','system:role:query','#','admin','2026-10-12 20:40:22','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1008,'角色新增',101,2,'','','','',1,0,'F','0','0','system:role:add','#','admin','2026-10-12 20:40:22','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1009,'角色修改',101,3,'','','','',1,0,'F','0','0','system:role:edit','#','admin','2026-10-12 20:40:22','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1010,'角色删除',101,4,'','','','',1,0,'F','0','0','system:role:remove','#','admin','2026-10-12 20:40:22','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1011,'角色导出',101,5,'','','','',1,0,'F','0','0','system:role:export','#','admin','2026-10-12 20:40:22','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1012,'菜单查询',102,1,'','','','',1,0,'F','0','0','system:menu:query','#','admin','2026-10-12 20:40:22','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1013,'菜单新增',102,2,'','','','',1,0,'F','0','0','system:menu:add','#','admin','2026-10-12 20:40:22','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1014,'菜单修改',102,3,'','','','',1,0,'F','0','0','system:menu:edit','#','admin','2026-10-12 20:40:22','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1015,'菜单删除',102,4,'','','','',1,0,'F','0','0','system:menu:remove','#','admin','2026-10-12 20:40:22','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1025,'字典查询',105,1,'#','','','',1,0,'F','0','0','system:dict:query','#','admin','2026-10-12 20:40:22','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1026,'字典新增',105,2,'#','','','',1,0,'F','0','0','system:dict:add','#','admin','2026-10-12 20:40:22','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1027,'字典修改',105,3,'#','','','',1,0,'F','0','0','system:dict:edit','#','admin','2026-10-12 20:40:22','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1028,'字典删除',105,4,'#','','','',1,0,'F','0','0','system:dict:remove','#','admin','2026-10-12 20:40:22','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1029,'字典导出',105,5,'#','','','',1,0,'F','0','0','system:dict:export','#','admin','2026-10-12 20:40:22','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1030,'参数查询',106,1,'#','','','',1,0,'F','0','0','system:config:query','#','admin','2026-10-12 20:40:22','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1031,'参数新增',106,2,'#','','','',1,0,'F','0','0','system:config:add','#','admin','2026-10-12 20:40:22','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1032,'参数修改',106,3,'#','','','',1,0,'F','0','0','system:config:edit','#','admin','2026-10-12 20:40:22','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1033,'参数删除',106,4,'#','','','',1,0,'F','0','0','system:config:remove','#','admin','2026-10-12 20:40:22','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1034,'参数导出',106,5,'#','','','',1,0,'F','0','0','system:config:export','#','admin','2026-10-12 20:40:22','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1035,'公告查询',107,1,'#','','','',1,0,'F','0','0','system:notice:query','#','admin','2026-10-12 20:40:22','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1036,'公告新增',107,2,'#','','','',1,0,'F','0','0','system:notice:add','#','admin','2026-10-12 20:40:22','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1037,'公告修改',107,3,'#','','','',1,0,'F','0','0','system:notice:edit','#','admin','2026-10-12 20:40:22','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1038,'公告删除',107,4,'#','','','',1,0,'F','0','0','system:notice:remove','#','admin','2026-10-12 20:40:22','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1039,'操作查询',500,1,'#','','','',1,0,'F','0','0','monitor:operlog:query','#','admin','2026-10-12 20:40:22','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1040,'操作删除',500,2,'#','','','',1,0,'F','0','0','monitor:operlog:remove','#','admin','2026-10-12 20:40:22','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1041,'日志导出',500,3,'#','','','',1,0,'F','0','0','monitor:operlog:export','#','admin','2026-10-12 20:40:22','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1042,'登录查询',501,1,'#','','','',1,0,'F','0','0','monitor:logininfor:query','#','admin','2026-10-12 20:40:22','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1043,'登录删除',501,2,'#','','','',1,0,'F','0','0','monitor:logininfor:remove','#','admin','2026-10-12 20:40:22','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1044,'日志导出',501,3,'#','','','',1,0,'F','0','0','monitor:logininfor:export','#','admin','2026-10-12 20:40:22','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1045,'账户解锁',501,4,'#','','','',1,0,'F','0','0','monitor:logininfor:unlock','#','admin','2026-10-12 20:40:22','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1046,'在线查询',109,1,'#','','','',1,0,'F','0','0','monitor:online:query','#','admin','2026-10-12 20:40:22','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1047,'批量强退',109,2,'#','','','',1,0,'F','0','0','monitor:online:batchLogout','#','admin','2026-10-12 20:40:22','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1048,'单条强退',109,3,'#','','','',1,0,'F','0','0','monitor:online:forceLogout','#','admin','2026-10-12 20:40:22','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1049,'任务查询',110,1,'#','','','',1,0,'F','0','0','monitor:job:query','#','admin','2026-10-12 20:40:22','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1050,'任务新增',110,2,'#','','','',1,0,'F','0','0','monitor:job:add','#','admin','2026-10-12 20:40:22','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1051,'任务修改',110,3,'#','','','',1,0,'F','0','0','monitor:job:edit','#','admin','2026-10-12 20:40:22','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1052,'任务删除',110,4,'#','','','',1,0,'F','0','0','monitor:job:remove','#','admin','2026-10-12 20:40:22','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1053,'状态修改',110,5,'#','','','',1,0,'F','0','0','monitor:job:changeStatus','#','admin','2026-10-12 20:40:22','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1054,'任务导出',110,6,'#','','','',1,0,'F','0','0','monitor:job:export','#','admin','2026-10-12 20:40:22','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2000,'基础数据与权限管理',0,1,'basic',NULL,'','',1,0,'M','0','0','','peoples','admin','2026-10-12 20:40:24','',NULL,'模块一目录');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2001,'故障报修与跟踪',0,2,'repair',NULL,'','',1,0,'M','0','0','','message','admin','2026-10-12 20:40:24','',NULL,'模块二目录');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2002,'工单调度与执行',0,3,'order',NULL,'','',1,0,'M','0','0','','job','admin','2026-10-12 20:40:24','',NULL,'模块三目录');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2003,'预防性维保',0,4,'maintain',NULL,'','',1,0,'M','0','0','','server','admin','2026-10-12 20:40:24','',NULL,'模块四目录');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2004,'数据分析与预警',0,5,'analysis',NULL,'','',1,0,'M','0','0','','chart','admin','2026-10-12 20:40:24','',NULL,'模块五目录');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2102,'基础信息管理',2000,3,'info','basic/info/index','','',1,0,'C','0','0','basic:info:list','tree','admin','2026-10-12 20:40:24','',NULL,'基础信息管理菜单');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2103,'故障一键报修',2001,1,'repairOrder','repair/order/index','','',1,0,'C','0','0','repair:order:list','form','admin','2026-10-12 20:40:24','',NULL,'故障一键报修菜单');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2104,'故障分级管理',2001,2,'level','repair/level/index','','',1,0,'C','0','0','repair:level:list','star','admin','2026-10-12 20:40:24','',NULL,'故障分级管理菜单');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2105,'多媒体证据上传',2001,3,'evidence','repair/evidence/index','','',1,0,'C','0','0','repair:evidence:list','upload','admin','2026-10-12 20:40:24','',NULL,'多媒体证据上传菜单');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2106,'报修进度跟踪',2001,4,'track','repair/track/index','','',1,0,'C','0','0','repair:track:list','time-range','admin','2026-10-12 20:40:24','',NULL,'报修进度跟踪菜单');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2107,'智能派单',2002,1,'dispatch','order/dispatch/index','','',1,0,'C','0','0','order:dispatch:list','guide','admin','2026-10-12 20:40:24','',NULL,'智能派单菜单');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2108,'维修人员接单',2002,2,'accept','order/accept/index','','',1,0,'C','0','0','order:accept:list','checkbox','admin','2026-10-12 20:40:24','',NULL,'维修人员接单菜单');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2109,'维修过程管理',2002,3,'process','order/process/index','','',1,0,'C','0','0','order:process:list','edit','admin','2026-10-12 20:40:24','',NULL,'维修过程管理菜单');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2110,'工单异常处理',2002,4,'exception','order/exception/index','','',1,0,'C','0','0','order:exception:list','bug','admin','2026-10-12 20:40:24','',NULL,'工单异常处理菜单');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2111,'维保计划管理',2003,1,'plan','maintain/plan/index','','',1,0,'C','0','0','maintain:plan:list','date','admin','2026-10-12 20:40:24','',NULL,'维保计划管理菜单');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2112,'定期巡检执行',2003,2,'inspection','maintain/inspection/index','','',1,0,'C','0','0','maintain:inspection:list','validCode','admin','2026-10-12 20:40:24','',NULL,'定期巡检执行菜单');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2113,'维保档案归档',2003,3,'archive','maintain/archive/index','','',1,0,'C','0','0','maintain:archive:list','documentation','admin','2026-10-12 20:40:24','',NULL,'维保档案归档菜单');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2114,'故障频次统计',2004,1,'frequency','analysis/frequency/index','','',1,0,'C','0','0','analysis:frequency:list','chart','admin','2026-10-12 20:40:24','',NULL,'故障频次统计菜单');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2115,'超期预警监控',2004,2,'warning','analysis/warning/index','','',1,0,'C','0','0','analysis:warning:list','bell','admin','2026-10-12 20:40:24','',NULL,'超期预警监控菜单');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2116,'电梯健康档案生成',2004,3,'health','analysis/health/index','','',1,0,'C','0','0','analysis:health:list','monitor','admin','2026-10-12 20:40:24','',NULL,'电梯健康档案生成菜单');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2208,'小区楼栋电梯查询',2102,1,'','','','',1,0,'F','0','0','basic:info:query','#','admin','2026-10-12 20:40:24','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2209,'基础信息新增',2102,2,'','','','',1,0,'F','0','0','basic:info:add','#','admin','2026-10-12 20:40:24','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2210,'基础信息修改',2102,3,'','','','',1,0,'F','0','0','basic:info:edit','#','admin','2026-10-12 20:40:24','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2211,'基础信息删除',2102,4,'','','','',1,0,'F','0','0','basic:info:remove','#','admin','2026-10-12 20:40:24','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2212,'基础信息导出',2102,5,'','','','',1,0,'F','0','0','basic:info:export','#','admin','2026-10-12 20:40:24','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2213,'报修单查询',2103,1,'','','','',1,0,'F','0','0','repair:order:query','#','admin','2026-10-12 20:40:24','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2214,'报修单驳回',2103,2,'','','','',1,0,'F','0','0','repair:order:reject','#','admin','2026-10-12 20:40:24','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2215,'报修单导出',2103,3,'','','','',1,0,'F','0','0','repair:order:export','#','admin','2026-10-12 20:40:24','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2216,'故障等级查询',2104,1,'','','','',1,0,'F','0','0','repair:level:query','#','admin','2026-10-12 20:40:24','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2217,'调整故障等级',2104,2,'','','','',1,0,'F','0','0','repair:order:changeLevel','#','admin','2026-10-12 20:40:24','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2218,'证据查询',2105,1,'','','','',1,0,'F','0','0','repair:evidence:query','#','admin','2026-10-12 20:40:24','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2219,'证据删除',2105,2,'','','','',1,0,'F','0','0','repair:evidence:remove','#','admin','2026-10-12 20:40:24','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2220,'进度查询',2106,1,'','','','',1,0,'F','0','0','repair:track:query','#','admin','2026-10-12 20:40:24','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2221,'待派单查询',2107,1,'','','','',1,0,'F','0','0','order:dispatch:query','#','admin','2026-10-12 20:40:24','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2222,'执行派单',2107,2,'','','','',1,0,'F','0','0','order:dispatch:assign','#','admin','2026-10-12 20:40:24','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2223,'接单查询',2108,1,'','','','',1,0,'F','0','0','order:accept:query','#','admin','2026-10-12 20:40:24','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2224,'确认接单',2108,2,'','','','',1,0,'F','0','0','order:accept:confirm','#','admin','2026-10-12 20:40:24','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2225,'维修过程查询',2109,1,'','','','',1,0,'F','0','0','order:process:query','#','admin','2026-10-12 20:40:24','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2226,'推进维修状态',2109,2,'','','','',1,0,'F','0','0','order:process:edit','#','admin','2026-10-12 20:40:24','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2227,'异常工单查询',2110,1,'','','','',1,0,'F','0','0','order:exception:query','#','admin','2026-10-12 20:40:24','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2228,'异常工单处理',2110,2,'','','','',1,0,'F','0','0','order:exception:edit','#','admin','2026-10-12 20:40:24','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2229,'维保计划查询',2111,1,'','','','',1,0,'F','0','0','maintain:plan:query','#','admin','2026-10-12 20:40:24','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2230,'维保计划新增',2111,2,'','','','',1,0,'F','0','0','maintain:plan:add','#','admin','2026-10-12 20:40:24','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2231,'维保计划修改',2111,3,'','','','',1,0,'F','0','0','maintain:plan:edit','#','admin','2026-10-12 20:40:24','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2232,'维保计划删除',2111,4,'','','','',1,0,'F','0','0','maintain:plan:remove','#','admin','2026-10-12 20:40:24','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2233,'巡检任务查询',2112,1,'','','','',1,0,'F','0','0','maintain:inspection:query','#','admin','2026-10-12 20:40:24','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2234,'巡检打卡执行',2112,2,'','','','',1,0,'F','0','0','maintain:inspection:execute','#','admin','2026-10-12 20:40:24','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2235,'巡检记录导出',2112,3,'','','','',1,0,'F','0','0','maintain:inspection:export','#','admin','2026-10-12 20:40:24','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2236,'维保档案查询',2113,1,'','','','',1,0,'F','0','0','maintain:archive:query','#','admin','2026-10-12 20:40:24','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2237,'维保档案导出',2113,2,'','','','',1,0,'F','0','0','maintain:archive:export','#','admin','2026-10-12 20:40:24','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2238,'频次统计查询',2114,1,'','','','',1,0,'F','0','0','analysis:frequency:query','#','admin','2026-10-12 20:40:24','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2239,'频次统计导出',2114,2,'','','','',1,0,'F','0','0','analysis:frequency:export','#','admin','2026-10-12 20:40:24','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2240,'预警查询',2115,1,'','','','',1,0,'F','0','0','analysis:warning:query','#','admin','2026-10-12 20:40:24','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2241,'预警规则配置',2115,2,'','','','',1,0,'F','0','0','analysis:warning:rule','#','admin','2026-10-12 20:40:24','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2242,'健康档案查询',2116,1,'','','','',1,0,'F','0','0','analysis:health:query','#','admin','2026-10-12 20:40:24','',NULL,'');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `route_name`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2243,'健康档案导出',2116,2,'','','','',1,0,'F','0','0','analysis:health:export','#','admin','2026-10-12 20:40:24','',NULL,'');
/*!40000 ALTER TABLE `sys_menu` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `sys_notice`
--

LOCK TABLES `sys_notice` WRITE;
/*!40000 ALTER TABLE `sys_notice` DISABLE KEYS */;
/*!40000 ALTER TABLE `sys_notice` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `sys_notice_read`
--

LOCK TABLES `sys_notice_read` WRITE;
/*!40000 ALTER TABLE `sys_notice_read` DISABLE KEYS */;
/*!40000 ALTER TABLE `sys_notice_read` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `sys_role`
--

LOCK TABLES `sys_role` WRITE;
/*!40000 ALTER TABLE `sys_role` DISABLE KEYS */;
INSERT INTO `sys_role` (`role_id`, `role_name`, `role_key`, `role_sort`, `data_scope`, `menu_check_strictly`, `status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1,'超级管理员','admin',1,'1',1,'0','0','admin','2026-10-12 20:40:22','',NULL,'超级管理员');
INSERT INTO `sys_role` (`role_id`, `role_name`, `role_key`, `role_sort`, `data_scope`, `menu_check_strictly`, `status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2,'普通角色','common',2,'2',1,'0','0','admin','2026-10-12 20:40:22','',NULL,'普通角色');
INSERT INTO `sys_role` (`role_id`, `role_name`, `role_key`, `role_sort`, `data_scope`, `menu_check_strictly`, `status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (3,'物业','property',2,'1',1,'0','0','admin','2026-10-12 20:40:24','',NULL,'物业管理人员，负责审核报修单、派发工单、管理维保计划、查看统计报表');
INSERT INTO `sys_role` (`role_id`, `role_name`, `role_key`, `role_sort`, `data_scope`, `menu_check_strictly`, `status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (4,'维修员','worker',3,'1',1,'0','0','admin','2026-10-12 20:40:24','',NULL,'维保单位人员，负责接单、反馈到场时间、记录维修过程、执行巡检任务');
INSERT INTO `sys_role` (`role_id`, `role_name`, `role_key`, `role_sort`, `data_scope`, `menu_check_strictly`, `status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (5,'业主','owner',4,'5',1,'0','0','admin','2026-10-12 20:40:24','',NULL,'电梯使用者，负责提交故障报修、上传证据、查看报修进度、确认维修结果');
/*!40000 ALTER TABLE `sys_role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `sys_role_menu`
--

LOCK TABLES `sys_role_menu` WRITE;
/*!40000 ALTER TABLE `sys_role_menu` DISABLE KEYS */;
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1,2000);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1,2001);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1,2002);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1,2003);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1,2004);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1,2102);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1,2103);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1,2104);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1,2105);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1,2106);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1,2107);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1,2108);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1,2109);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1,2110);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1,2111);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1,2112);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1,2113);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1,2114);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1,2115);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1,2116);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1,2208);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1,2209);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1,2210);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1,2211);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1,2212);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1,2213);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1,2214);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1,2215);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1,2216);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1,2217);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1,2218);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1,2219);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1,2220);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1,2221);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1,2222);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1,2223);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1,2224);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1,2225);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1,2226);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1,2227);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1,2228);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1,2229);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1,2230);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1,2231);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1,2232);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1,2233);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1,2234);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1,2235);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1,2236);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1,2237);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1,2238);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1,2239);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1,2240);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1,2241);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1,2242);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1,2243);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (2,1);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (2,2);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (2,100);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (2,101);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (2,102);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (2,105);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (2,106);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (2,107);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (2,108);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (2,109);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (2,110);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (2,111);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (2,112);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (2,113);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (2,114);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (2,500);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (2,501);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (2,1000);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (2,1001);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (2,1002);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (2,1003);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (2,1004);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (2,1005);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (2,1006);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (2,1007);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (2,1008);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (2,1009);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (2,1010);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (2,1011);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (2,1012);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (2,1013);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (2,1014);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (2,1015);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (2,1025);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (2,1026);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (2,1027);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (2,1028);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (2,1029);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (2,1030);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (2,1031);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (2,1032);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (2,1033);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (2,1034);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (2,1035);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (2,1036);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (2,1037);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (2,1038);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (2,1039);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (2,1040);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (2,1041);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (2,1042);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (2,1043);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (2,1044);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (2,1045);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (2,1046);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (2,1047);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (2,1048);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (2,1049);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (2,1050);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (2,1051);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (2,1052);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (2,1053);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (2,1054);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (3,2000);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (3,2001);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (3,2002);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (3,2003);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (3,2004);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (3,2102);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (3,2103);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (3,2104);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (3,2105);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (3,2106);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (3,2107);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (3,2108);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (3,2109);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (3,2110);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (3,2111);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (3,2112);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (3,2113);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (3,2114);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (3,2115);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (3,2116);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (3,2208);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (3,2209);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (3,2210);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (3,2211);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (3,2212);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (3,2213);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (3,2214);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (3,2215);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (3,2216);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (3,2217);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (3,2218);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (3,2219);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (3,2220);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (3,2221);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (3,2222);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (3,2223);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (3,2224);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (3,2225);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (3,2226);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (3,2227);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (3,2228);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (3,2229);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (3,2230);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (3,2231);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (3,2232);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (3,2233);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (3,2234);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (3,2235);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (3,2236);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (3,2237);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (3,2238);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (3,2239);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (3,2240);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (3,2241);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (3,2242);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (3,2243);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (4,2001);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (4,2002);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (4,2003);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (4,2106);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (4,2108);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (4,2109);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (4,2112);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (4,2220);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (4,2223);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (4,2224);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (4,2225);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (4,2226);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (4,2233);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (4,2234);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (5,2001);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (5,2106);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (5,2220);
/*!40000 ALTER TABLE `sys_role_menu` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `sys_user`
--

LOCK TABLES `sys_user` WRITE;
/*!40000 ALTER TABLE `sys_user` DISABLE KEYS */;
INSERT INTO `sys_user` (`user_id`, `user_name`, `nick_name`, `user_type`, `email`, `phonenumber`, `sex`, `avatar`, `password`, `status`, `del_flag`, `login_ip`, `login_date`, `pwd_update_date`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`, `community_id`) VALUES (1,'admin','系统管理员','00','ry@163.com','15888888888','1','','$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2','0','0','127.0.0.1','2026-10-12 20:40:22','2026-10-12 20:40:22','admin','2026-10-12 20:40:22','',NULL,'管理员',NULL);
INSERT INTO `sys_user` (`user_id`, `user_name`, `nick_name`, `user_type`, `email`, `phonenumber`, `sex`, `avatar`, `password`, `status`, `del_flag`, `login_ip`, `login_date`, `pwd_update_date`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`, `community_id`) VALUES (100,'wuye01','物业管理员','00','wuye01@elevator.com','13800000001','1','','$2a$10$pdXrbtI9oylyNZP2jNorMOFsPnxkobyrXlZ1xzSj7nCAngvoz2pBC','0','0','127.0.0.1','2026-10-12 20:40:24','2026-10-12 20:40:24','admin','2026-10-12 20:40:24','',NULL,'阳光家园小区物业管理员',1);
INSERT INTO `sys_user` (`user_id`, `user_name`, `nick_name`, `user_type`, `email`, `phonenumber`, `sex`, `avatar`, `password`, `status`, `del_flag`, `login_ip`, `login_date`, `pwd_update_date`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`, `community_id`) VALUES (101,'weixiu01','维修员王师傅','00','weixiu01@elevator.com','13800000002','1','','$2a$10$pdXrbtI9oylyNZP2jNorMOFsPnxkobyrXlZ1xzSj7nCAngvoz2pBC','0','0','127.0.0.1','2026-10-12 20:40:24','2026-10-12 20:40:24','admin','2026-10-12 20:40:24','',NULL,'黑龙江安捷电梯维保有限公司，负责阳光家园小区',1);
INSERT INTO `sys_user` (`user_id`, `user_name`, `nick_name`, `user_type`, `email`, `phonenumber`, `sex`, `avatar`, `password`, `status`, `del_flag`, `login_ip`, `login_date`, `pwd_update_date`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`, `community_id`) VALUES (102,'yezhu01','业主张阿姨','00','yezhu01@elevator.com','13800000003','1','','$2a$10$pdXrbtI9oylyNZP2jNorMOFsPnxkobyrXlZ1xzSj7nCAngvoz2pBC','0','0','127.0.0.1','2026-10-12 20:40:24','2026-10-12 20:40:24','admin','2026-10-12 20:40:24','',NULL,'阳光家园小区1号楼1单元业主',1);
INSERT INTO `sys_user` (`user_id`, `user_name`, `nick_name`, `user_type`, `email`, `phonenumber`, `sex`, `avatar`, `password`, `status`, `del_flag`, `login_ip`, `login_date`, `pwd_update_date`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`, `community_id`) VALUES (103,'weixiu02','维修员李师傅','00','weixiu02@elevator.com','13800000004','1','','$2a$10$pdXrbtI9oylyNZP2jNorMOFsPnxkobyrXlZ1xzSj7nCAngvoz2pBC','0','0','127.0.0.1','2026-10-12 20:40:24','2026-10-12 20:40:24','admin','2026-10-12 20:40:24','',NULL,'哈尔滨华信机电设备有限公司，负责和平里小区',2);
INSERT INTO `sys_user` (`user_id`, `user_name`, `nick_name`, `user_type`, `email`, `phonenumber`, `sex`, `avatar`, `password`, `status`, `del_flag`, `login_ip`, `login_date`, `pwd_update_date`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`, `community_id`) VALUES (104,'weixiu03','维修员赵师傅','00','weixiu03@elevator.com','13800000005','1','','$2a$10$pdXrbtI9oylyNZP2jNorMOFsPnxkobyrXlZ1xzSj7nCAngvoz2pBC','0','0','127.0.0.1','2026-10-12 20:40:24','2026-10-12 20:40:24','admin','2026-10-12 20:40:24','',NULL,'黑龙江广日电梯工程有限公司，负责铁路新村小区',3);
/*!40000 ALTER TABLE `sys_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `sys_user_role`
--

LOCK TABLES `sys_user_role` WRITE;
/*!40000 ALTER TABLE `sys_user_role` DISABLE KEYS */;
INSERT INTO `sys_user_role` (`user_id`, `role_id`) VALUES (1,1);
INSERT INTO `sys_user_role` (`user_id`, `role_id`) VALUES (2,2);
INSERT INTO `sys_user_role` (`user_id`, `role_id`) VALUES (100,3);
INSERT INTO `sys_user_role` (`user_id`, `role_id`) VALUES (101,4);
INSERT INTO `sys_user_role` (`user_id`, `role_id`) VALUES (102,5);
INSERT INTO `sys_user_role` (`user_id`, `role_id`) VALUES (103,4);
INSERT INTO `sys_user_role` (`user_id`, `role_id`) VALUES (104,4);
/*!40000 ALTER TABLE `sys_user_role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `warning_info`
--

LOCK TABLES `warning_info` WRITE;
/*!40000 ALTER TABLE `warning_info` DISABLE KEYS */;
/*!40000 ALTER TABLE `warning_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `warning_rule`
--

LOCK TABLES `warning_rule` WRITE;
/*!40000 ALTER TABLE `warning_rule` DISABLE KEYS */;
INSERT INTO `warning_rule` (`rule_id`, `rule_name`, `rule_type`, `biz_sub_type`, `threshold_value`, `threshold_unit`, `notify_roles`, `enabled`, `repeat_interval`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1,'派单超时预警','order_timeout','assign',30,'minute','property','0',0,'admin','2026-10-12 20:40:24','',NULL,'工单报修后30分钟未派单');
INSERT INTO `warning_rule` (`rule_id`, `rule_name`, `rule_type`, `biz_sub_type`, `threshold_value`, `threshold_unit`, `notify_roles`, `enabled`, `repeat_interval`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2,'接单超时预警','order_timeout','accept',30,'minute','worker,property','0',0,'admin','2026-10-12 20:40:24','',NULL,'派单后30分钟未接单');
INSERT INTO `warning_rule` (`rule_id`, `rule_name`, `rule_type`, `biz_sub_type`, `threshold_value`, `threshold_unit`, `notify_roles`, `enabled`, `repeat_interval`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (3,'到场超时预警','order_timeout','arrive',120,'minute','worker,property','0',0,'admin','2026-10-12 20:40:24','',NULL,'接单后2小时未到场');
INSERT INTO `warning_rule` (`rule_id`, `rule_name`, `rule_type`, `biz_sub_type`, `threshold_value`, `threshold_unit`, `notify_roles`, `enabled`, `repeat_interval`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (4,'维修超时预警','order_timeout','repair',24,'hour','worker,property','0',0,'admin','2026-10-12 20:40:24','',NULL,'到场后24小时未完成维修');
INSERT INTO `warning_rule` (`rule_id`, `rule_name`, `rule_type`, `biz_sub_type`, `threshold_value`, `threshold_unit`, `notify_roles`, `enabled`, `repeat_interval`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (5,'维保临期预警','maintain_due','due_soon',3,'day','property,worker','0',0,'admin','2026-10-12 20:40:24','',NULL,'距离计划维保日期不足3天');
INSERT INTO `warning_rule` (`rule_id`, `rule_name`, `rule_type`, `biz_sub_type`, `threshold_value`, `threshold_unit`, `notify_roles`, `enabled`, `repeat_interval`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (6,'维保超期预警','maintain_due','overdue',0,'day','property,worker','0',0,'admin','2026-10-12 20:40:24','',NULL,'已超过计划维保日期未执行');
/*!40000 ALTER TABLE `warning_rule` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `worker_skill`
--

LOCK TABLES `worker_skill` WRITE;
/*!40000 ALTER TABLE `worker_skill` DISABLE KEYS */;
INSERT INTO `worker_skill` (`skill_id`, `worker_id`, `community_id`, `skill_tags`, `work_status`, `current_load`, `total_finished`, `avg_response`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (1,101,1,'曳引机,门系统,控制系统','0',0,0,0,'admin','2026-10-12 20:40:24','',NULL);
INSERT INTO `worker_skill` (`skill_id`, `worker_id`, `community_id`, `skill_tags`, `work_status`, `current_load`, `total_finished`, `avg_response`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (2,103,2,'门系统,轿厢,安全装置','0',0,0,0,'admin','2026-10-12 20:40:24','',NULL);
INSERT INTO `worker_skill` (`skill_id`, `worker_id`, `community_id`, `skill_tags`, `work_status`, `current_load`, `total_finished`, `avg_response`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (3,104,3,'控制系统,曳引机,电气','0',0,0,0,'admin','2026-10-12 20:40:24','',NULL);
/*!40000 ALTER TABLE `worker_skill` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-12 20:57:18
