-- ============================================================
-- 老旧小区电梯故障报修与维保跟踪平台 - 数据库初始化脚本
-- 论文题目：基于SpringBoot的老旧小区电梯故障报修与维保跟踪平台设计与实现
-- 学生：董泽晟
-- 适用库：elevator
--
-- 用法：mysql -uroot -p < elevator_init.sql
--   （脚本内部会自行 CREATE DATABASE 并 USE，无需事先建库）
--
-- 本脚本整合全部建库内容，一次执行即可得到可运行的完整数据库：
--   第 1 章  建库
--   第 2 章  若依框架表 14 张（用户/角色/菜单/字典/参数/日志/定时任务/公告）
--   第 3 章  Quartz 定时任务调度表 11 张
--   第 4 章  电梯业务表 19 张
--   第 5 章  初始化数据（角色、菜单权限、字典、演示账号、业务基础数据、定时任务）
--
-- 说明：
--   1. 本脚本可重复执行，会先 drop 再 create，重复执行不会报错
--   2. 若依框架表已按论文要求剔除部门表、岗位表与代码生成器表，
--      依据为论文 3.2.2 节：数据库表设计仅列 5 张表，用户表 8 个字段，
--      均无 dept_id、无部门、无岗位
--   3. sys_user 的 community_id 字段在框架表建表语句中直接定义，
--      不再用 ALTER 事后补列
-- ============================================================

-- ============================================================
-- 第 1 章  建库
-- ============================================================
CREATE DATABASE IF NOT EXISTS `elevator` CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `elevator`;


-- ============================================================
-- 第 2 章  若依框架表
-- 上游来源：RuoYi-Vue springboot3 分支 sql/ry_20260417.sql
-- 改动：剔除 sys_dept、sys_post、sys_user_post、sys_role_dept、
--       gen_table、gen_table_column 六张表及其全部初始化数据与菜单，
--       并移除 sys_user.dept_id、sys_role.dept_check_strictly、
--       sys_oper_log.dept_name 三个列；新增 sys_user.community_id
-- ============================================================

-- ----------------------------
-- 2、用户信息表
-- ----------------------------
drop table if exists sys_user;
create table sys_user (
  user_id           bigint(20)      not null auto_increment    comment '用户ID',
  user_name         varchar(30)     not null                   comment '用户账号',
  nick_name         varchar(30)     not null                   comment '用户昵称',
  user_type         varchar(2)      default '00'               comment '用户类型（00系统用户）',
  email             varchar(50)     default ''                 comment '用户邮箱',
  phonenumber       varchar(11)     default ''                 comment '手机号码',
  sex               char(1)         default '0'                comment '用户性别（0男 1女 2未知）',
  avatar            varchar(100)    default ''                 comment '头像地址',
  password          varchar(100)    default ''                 comment '密码',
  status            char(1)         default '0'                comment '账号状态（0正常 1停用）',
  del_flag          char(1)         default '0'                comment '删除标志（0代表存在 2代表删除）',
  login_ip          varchar(128)    default ''                 comment '最后登录IP',
  login_date        datetime                                   comment '最后登录时间',
  pwd_update_date   datetime                                   comment '密码最后更新时间',
  create_by         varchar(64)     default ''                 comment '创建者',
  create_time       datetime                                   comment '创建时间',
  update_by         varchar(64)     default ''                 comment '更新者',
  update_time       datetime                                   comment '更新时间',
  remark            varchar(500)    default null               comment '备注',
  community_id      bigint(20)      default null               comment '所属小区ID（论文表3-1，用于数据权限按小区隔离）',
  primary key (user_id),
  unique key uk_user_phonenumber (phonenumber)
) engine=innodb auto_increment=100 comment = '用户信息表';

-- ----------------------------
-- 初始化-用户信息表数据
-- ----------------------------
insert into sys_user values(1, 'admin', '若依', '00', 'ry@163.com', '15888888888', '1', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', sysdate(), sysdate(), 'admin', sysdate(), '', null, '管理员', null);
insert into sys_user values(2, 'ry',    '若依', '00', 'ry@qq.com',  '15666666666', '1', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', sysdate(), sysdate(), 'admin', sysdate(), '', null, '测试员', null);


-- ----------------------------
-- 4、角色信息表
-- ----------------------------
drop table if exists sys_role;
create table sys_role (
  role_id              bigint(20)      not null auto_increment    comment '角色ID',
  role_name            varchar(30)     not null                   comment '角色名称',
  role_key             varchar(100)    not null                   comment '角色权限字符串',
  role_sort            int(4)          not null                   comment '显示顺序',
  data_scope           char(1)         default '1'                comment '数据范围（1：全部数据权限 5：仅本人数据权限）',
  menu_check_strictly  tinyint(1)      default 1                  comment '菜单树选择项是否关联显示',
  status               char(1)         not null                   comment '角色状态（0正常 1停用）',
  del_flag             char(1)         default '0'                comment '删除标志（0代表存在 2代表删除）',
  create_by            varchar(64)     default ''                 comment '创建者',
  create_time          datetime                                   comment '创建时间',
  update_by            varchar(64)     default ''                 comment '更新者',
  update_time          datetime                                   comment '更新时间',
  remark               varchar(500)    default null               comment '备注',
  primary key (role_id)
) engine=innodb auto_increment=100 comment = '角色信息表';

-- ----------------------------
-- 初始化-角色信息表数据
-- ----------------------------
insert into sys_role values('1', '超级管理员',  'admin',  1, 1, 1, '0', '0', 'admin', sysdate(), '', null, '超级管理员');
insert into sys_role values('2', '普通角色',    'common', 2, 2, 1, '0', '0', 'admin', sysdate(), '', null, '普通角色');


-- ----------------------------
-- 5、菜单权限表
-- ----------------------------
drop table if exists sys_menu;
create table sys_menu (
  menu_id           bigint(20)      not null auto_increment    comment '菜单ID',
  menu_name         varchar(50)     not null                   comment '菜单名称',
  parent_id         bigint(20)      default 0                  comment '父菜单ID',
  order_num         int(4)          default 0                  comment '显示顺序',
  path              varchar(200)    default ''                 comment '路由地址',
  component         varchar(255)    default null               comment '组件路径',
  query             varchar(255)    default null               comment '路由参数',
  route_name        varchar(50)     default ''                 comment '路由名称',
  is_frame          int(1)          default 1                  comment '是否为外链（0是 1否）',
  is_cache          int(1)          default 0                  comment '是否缓存（0缓存 1不缓存）',
  menu_type         char(1)         default ''                 comment '菜单类型（M目录 C菜单 F按钮）',
  visible           char(1)         default 0                  comment '菜单状态（0显示 1隐藏）',
  status            char(1)         default 0                  comment '菜单状态（0正常 1停用）',
  perms             varchar(100)    default null               comment '权限标识',
  icon              varchar(100)    default '#'                comment '菜单图标',
  create_by         varchar(64)     default ''                 comment '创建者',
  create_time       datetime                                   comment '创建时间',
  update_by         varchar(64)     default ''                 comment '更新者',
  update_time       datetime                                   comment '更新时间',
  remark            varchar(500)    default ''                 comment '备注',
  primary key (menu_id)
) engine=innodb auto_increment=2000 comment = '菜单权限表';

-- ----------------------------
-- 初始化-菜单信息表数据
-- ----------------------------
-- 一级菜单
insert into sys_menu values('1', '系统管理', '0', '1', 'system',           null, '', '', 1, 0, 'M', '0', '0', '', 'system',   'admin', sysdate(), '', null, '系统管理目录');
insert into sys_menu values('2', '系统监控', '0', '2', 'monitor',          null, '', '', 1, 0, 'M', '0', '0', '', 'monitor',  'admin', sysdate(), '', null, '系统监控目录');
-- 二级菜单
insert into sys_menu values('100',  '用户管理', '1',   '1', 'user',       'system/user/index',        '', '', 1, 0, 'C', '0', '0', 'system:user:list',        'user',          'admin', sysdate(), '', null, '用户管理菜单');
insert into sys_menu values('101',  '角色管理', '1',   '2', 'role',       'system/role/index',        '', '', 1, 0, 'C', '0', '0', 'system:role:list',        'peoples',       'admin', sysdate(), '', null, '角色管理菜单');
insert into sys_menu values('102',  '菜单管理', '1',   '3', 'menu',       'system/menu/index',        '', '', 1, 0, 'C', '0', '0', 'system:menu:list',        'tree-table',    'admin', sysdate(), '', null, '菜单管理菜单');
insert into sys_menu values('105',  '字典管理', '1',   '6', 'dict',       'system/dict/index',        '', '', 1, 0, 'C', '0', '0', 'system:dict:list',        'dict',          'admin', sysdate(), '', null, '字典管理菜单');
insert into sys_menu values('106',  '参数设置', '1',   '7', 'config',     'system/config/index',      '', '', 1, 0, 'C', '0', '0', 'system:config:list',      'edit',          'admin', sysdate(), '', null, '参数设置菜单');
insert into sys_menu values('107',  '通知公告', '1',   '8', 'notice',     'system/notice/index',      '', '', 1, 0, 'C', '0', '0', 'system:notice:list',      'message',       'admin', sysdate(), '', null, '通知公告菜单');
insert into sys_menu values('108',  '日志管理', '1',   '9', 'log',        '',                         '', '', 1, 0, 'M', '0', '0', '',                        'log',           'admin', sysdate(), '', null, '日志管理菜单');
insert into sys_menu values('109',  '在线用户', '2',   '1', 'online',     'monitor/online/index',     '', '', 1, 0, 'C', '0', '0', 'monitor:online:list',     'online',        'admin', sysdate(), '', null, '在线用户菜单');
insert into sys_menu values('110',  '定时任务', '2',   '2', 'job',        'monitor/job/index',        '', '', 1, 0, 'C', '0', '0', 'monitor:job:list',        'job',           'admin', sysdate(), '', null, '定时任务菜单');
insert into sys_menu values('111',  '数据监控', '2',   '3', 'druid',      'monitor/druid/index',      '', '', 1, 0, 'C', '0', '0', 'monitor:druid:list',      'druid',         'admin', sysdate(), '', null, '数据监控菜单');
insert into sys_menu values('112',  '服务监控', '2',   '4', 'server',     'monitor/server/index',     '', '', 1, 0, 'C', '0', '0', 'monitor:server:list',     'server',        'admin', sysdate(), '', null, '服务监控菜单');
insert into sys_menu values('113',  '缓存监控', '2',   '5', 'cache',      'monitor/cache/index',      '', '', 1, 0, 'C', '0', '0', 'monitor:cache:list',      'redis',         'admin', sysdate(), '', null, '缓存监控菜单');
insert into sys_menu values('114',  '缓存列表', '2',   '6', 'cacheList',  'monitor/cache/list',       '', '', 1, 0, 'C', '0', '0', 'monitor:cache:list',      'redis-list',    'admin', sysdate(), '', null, '缓存列表菜单');
-- 三级菜单
insert into sys_menu values('500',  '操作日志', '108', '1', 'operlog',    'monitor/operlog/index',    '', '', 1, 0, 'C', '0', '0', 'monitor:operlog:list',    'form',          'admin', sysdate(), '', null, '操作日志菜单');
insert into sys_menu values('501',  '登录日志', '108', '2', 'logininfor', 'monitor/logininfor/index', '', '', 1, 0, 'C', '0', '0', 'monitor:logininfor:list', 'logininfor',    'admin', sysdate(), '', null, '登录日志菜单');
-- 用户管理按钮
insert into sys_menu values('1000', '用户查询', '100', '1',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:query',          '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1001', '用户新增', '100', '2',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:add',            '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1002', '用户修改', '100', '3',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:edit',           '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1003', '用户删除', '100', '4',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:remove',         '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1004', '用户导出', '100', '5',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:export',         '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1005', '用户导入', '100', '6',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:import',         '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1006', '重置密码', '100', '7',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:resetPwd',       '#', 'admin', sysdate(), '', null, '');
-- 角色管理按钮
insert into sys_menu values('1007', '角色查询', '101', '1',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:query',          '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1008', '角色新增', '101', '2',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:add',            '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1009', '角色修改', '101', '3',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:edit',           '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1010', '角色删除', '101', '4',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:remove',         '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1011', '角色导出', '101', '5',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:export',         '#', 'admin', sysdate(), '', null, '');
-- 菜单管理按钮
insert into sys_menu values('1012', '菜单查询', '102', '1',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:query',          '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1013', '菜单新增', '102', '2',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:add',            '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1014', '菜单修改', '102', '3',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:edit',           '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1015', '菜单删除', '102', '4',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:remove',         '#', 'admin', sysdate(), '', null, '');
-- 字典管理按钮
insert into sys_menu values('1025', '字典查询', '105', '1', '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:query',          '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1026', '字典新增', '105', '2', '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:add',            '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1027', '字典修改', '105', '3', '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:edit',           '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1028', '字典删除', '105', '4', '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:remove',         '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1029', '字典导出', '105', '5', '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:export',         '#', 'admin', sysdate(), '', null, '');
-- 参数设置按钮
insert into sys_menu values('1030', '参数查询', '106', '1', '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:query',        '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1031', '参数新增', '106', '2', '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:add',          '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1032', '参数修改', '106', '3', '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:edit',         '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1033', '参数删除', '106', '4', '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:remove',       '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1034', '参数导出', '106', '5', '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:export',       '#', 'admin', sysdate(), '', null, '');
-- 通知公告按钮
insert into sys_menu values('1035', '公告查询', '107', '1', '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:query',        '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1036', '公告新增', '107', '2', '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:add',          '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1037', '公告修改', '107', '3', '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:edit',         '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1038', '公告删除', '107', '4', '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:remove',       '#', 'admin', sysdate(), '', null, '');
-- 操作日志按钮
insert into sys_menu values('1039', '操作查询', '500', '1', '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:query',      '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1040', '操作删除', '500', '2', '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:remove',     '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1041', '日志导出', '500', '3', '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:export',     '#', 'admin', sysdate(), '', null, '');
-- 登录日志按钮
insert into sys_menu values('1042', '登录查询', '501', '1', '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:query',   '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1043', '登录删除', '501', '2', '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:remove',  '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1044', '日志导出', '501', '3', '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:export',  '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1045', '账户解锁', '501', '4', '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:unlock',  '#', 'admin', sysdate(), '', null, '');
-- 在线用户按钮
insert into sys_menu values('1046', '在线查询', '109', '1', '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:online:query',       '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1047', '批量强退', '109', '2', '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:online:batchLogout', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1048', '单条强退', '109', '3', '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:online:forceLogout', '#', 'admin', sysdate(), '', null, '');
-- 定时任务按钮
insert into sys_menu values('1049', '任务查询', '110', '1', '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:query',          '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1050', '任务新增', '110', '2', '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:add',            '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1051', '任务修改', '110', '3', '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:edit',           '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1052', '任务删除', '110', '4', '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:remove',         '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1053', '状态修改', '110', '5', '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:changeStatus',   '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1054', '任务导出', '110', '6', '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:export',         '#', 'admin', sysdate(), '', null, '');


-- ----------------------------
-- 6、用户和角色关联表  用户N-1角色
-- ----------------------------
drop table if exists sys_user_role;
create table sys_user_role (
  user_id   bigint(20) not null comment '用户ID',
  role_id   bigint(20) not null comment '角色ID',
  primary key(user_id, role_id)
) engine=innodb comment = '用户和角色关联表';

-- ----------------------------
-- 初始化-用户和角色关联表数据
-- ----------------------------
insert into sys_user_role values ('1', '1');
insert into sys_user_role values ('2', '2');


-- ----------------------------
-- 7、角色和菜单关联表  角色1-N菜单
-- ----------------------------
drop table if exists sys_role_menu;
create table sys_role_menu (
  role_id   bigint(20) not null comment '角色ID',
  menu_id   bigint(20) not null comment '菜单ID',
  primary key(role_id, menu_id)
) engine=innodb comment = '角色和菜单关联表';

-- ----------------------------
-- 初始化-角色和菜单关联表数据
-- ----------------------------
insert into sys_role_menu values ('2', '1');
insert into sys_role_menu values ('2', '2');
insert into sys_role_menu values ('2', '100');
insert into sys_role_menu values ('2', '101');
insert into sys_role_menu values ('2', '102');
insert into sys_role_menu values ('2', '105');
insert into sys_role_menu values ('2', '106');
insert into sys_role_menu values ('2', '107');
insert into sys_role_menu values ('2', '108');
insert into sys_role_menu values ('2', '109');
insert into sys_role_menu values ('2', '110');
insert into sys_role_menu values ('2', '111');
insert into sys_role_menu values ('2', '112');
insert into sys_role_menu values ('2', '113');
insert into sys_role_menu values ('2', '114');
insert into sys_role_menu values ('2', '500');
insert into sys_role_menu values ('2', '501');
insert into sys_role_menu values ('2', '1000');
insert into sys_role_menu values ('2', '1001');
insert into sys_role_menu values ('2', '1002');
insert into sys_role_menu values ('2', '1003');
insert into sys_role_menu values ('2', '1004');
insert into sys_role_menu values ('2', '1005');
insert into sys_role_menu values ('2', '1006');
insert into sys_role_menu values ('2', '1007');
insert into sys_role_menu values ('2', '1008');
insert into sys_role_menu values ('2', '1009');
insert into sys_role_menu values ('2', '1010');
insert into sys_role_menu values ('2', '1011');
insert into sys_role_menu values ('2', '1012');
insert into sys_role_menu values ('2', '1013');
insert into sys_role_menu values ('2', '1014');
insert into sys_role_menu values ('2', '1015');
insert into sys_role_menu values ('2', '1025');
insert into sys_role_menu values ('2', '1026');
insert into sys_role_menu values ('2', '1027');
insert into sys_role_menu values ('2', '1028');
insert into sys_role_menu values ('2', '1029');
insert into sys_role_menu values ('2', '1030');
insert into sys_role_menu values ('2', '1031');
insert into sys_role_menu values ('2', '1032');
insert into sys_role_menu values ('2', '1033');
insert into sys_role_menu values ('2', '1034');
insert into sys_role_menu values ('2', '1035');
insert into sys_role_menu values ('2', '1036');
insert into sys_role_menu values ('2', '1037');
insert into sys_role_menu values ('2', '1038');
insert into sys_role_menu values ('2', '1039');
insert into sys_role_menu values ('2', '1040');
insert into sys_role_menu values ('2', '1041');
insert into sys_role_menu values ('2', '1042');
insert into sys_role_menu values ('2', '1043');
insert into sys_role_menu values ('2', '1044');
insert into sys_role_menu values ('2', '1045');
insert into sys_role_menu values ('2', '1046');
insert into sys_role_menu values ('2', '1047');
insert into sys_role_menu values ('2', '1048');
insert into sys_role_menu values ('2', '1049');
insert into sys_role_menu values ('2', '1050');
insert into sys_role_menu values ('2', '1051');
insert into sys_role_menu values ('2', '1052');
insert into sys_role_menu values ('2', '1053');
insert into sys_role_menu values ('2', '1054');

-- ----------------------------
-- 10、操作日志记录
-- ----------------------------
drop table if exists sys_oper_log;
create table sys_oper_log (
  oper_id           bigint(20)      not null auto_increment    comment '日志主键',
  title             varchar(50)     default ''                 comment '模块标题',
  business_type     int(2)          default 0                  comment '业务类型（0其它 1新增 2修改 3删除）',
  method            varchar(200)    default ''                 comment '方法名称',
  request_method    varchar(10)     default ''                 comment '请求方式',
  operator_type     int(1)          default 0                  comment '操作类别（0其它 1后台用户 2手机端用户）',
  oper_name         varchar(50)     default ''                 comment '操作人员',
  dept_name         varchar(50)     default ''                 comment '部门名称',
  oper_url          varchar(255)    default ''                 comment '请求URL',
  oper_ip           varchar(128)    default ''                 comment '主机地址',
  oper_location     varchar(255)    default ''                 comment '操作地点',
  oper_param        varchar(2000)   default ''                 comment '请求参数',
  json_result       varchar(2000)   default ''                 comment '返回参数',
  status            int(1)          default 0                  comment '操作状态（0正常 1异常）',
  error_msg         varchar(2000)   default ''                 comment '错误消息',
  oper_time         datetime                                   comment '操作时间',
  cost_time         bigint(20)      default 0                  comment '消耗时间',
  primary key (oper_id),
  key idx_sys_oper_log_bt (business_type),
  key idx_sys_oper_log_s  (status),
  key idx_sys_oper_log_ot (oper_time)
) engine=innodb auto_increment=100 comment = '操作日志记录';


-- ----------------------------
-- 11、字典类型表
-- ----------------------------
drop table if exists sys_dict_type;
create table sys_dict_type
(
  dict_id          bigint(20)      not null auto_increment    comment '字典主键',
  dict_name        varchar(100)    default ''                 comment '字典名称',
  dict_type        varchar(100)    default ''                 comment '字典类型',
  status           char(1)         default '0'                comment '状态（0正常 1停用）',
  create_by        varchar(64)     default ''                 comment '创建者',
  create_time      datetime                                   comment '创建时间',
  update_by        varchar(64)     default ''                 comment '更新者',
  update_time      datetime                                   comment '更新时间',
  remark           varchar(500)    default null               comment '备注',
  primary key (dict_id),
  unique (dict_type)
) engine=innodb auto_increment=100 comment = '字典类型表';

insert into sys_dict_type values(1,  '用户性别', 'sys_user_sex',        '0', 'admin', sysdate(), '', null, '用户性别列表');
insert into sys_dict_type values(2,  '菜单状态', 'sys_show_hide',       '0', 'admin', sysdate(), '', null, '菜单状态列表');
insert into sys_dict_type values(3,  '系统开关', 'sys_normal_disable',  '0', 'admin', sysdate(), '', null, '系统开关列表');
insert into sys_dict_type values(4,  '任务状态', 'sys_job_status',      '0', 'admin', sysdate(), '', null, '任务状态列表');
insert into sys_dict_type values(5,  '任务分组', 'sys_job_group',       '0', 'admin', sysdate(), '', null, '任务分组列表');
insert into sys_dict_type values(6,  '系统是否', 'sys_yes_no',          '0', 'admin', sysdate(), '', null, '系统是否列表');
insert into sys_dict_type values(7,  '通知类型', 'sys_notice_type',     '0', 'admin', sysdate(), '', null, '通知类型列表');
insert into sys_dict_type values(8,  '通知状态', 'sys_notice_status',   '0', 'admin', sysdate(), '', null, '通知状态列表');
insert into sys_dict_type values(9,  '操作类型', 'sys_oper_type',       '0', 'admin', sysdate(), '', null, '操作类型列表');
insert into sys_dict_type values(10, '系统状态', 'sys_common_status',   '0', 'admin', sysdate(), '', null, '登录状态列表');


-- ----------------------------
-- 12、字典数据表
-- ----------------------------
drop table if exists sys_dict_data;
create table sys_dict_data
(
  dict_code        bigint(20)      not null auto_increment    comment '字典编码',
  dict_sort        int(4)          default 0                  comment '字典排序',
  dict_label       varchar(100)    default ''                 comment '字典标签',
  dict_value       varchar(100)    default ''                 comment '字典键值',
  dict_type        varchar(100)    default ''                 comment '字典类型',
  css_class        varchar(100)    default null               comment '样式属性（其他样式扩展）',
  list_class       varchar(100)    default null               comment '表格回显样式',
  is_default       char(1)         default 'N'                comment '是否默认（Y是 N否）',
  status           char(1)         default '0'                comment '状态（0正常 1停用）',
  create_by        varchar(64)     default ''                 comment '创建者',
  create_time      datetime                                   comment '创建时间',
  update_by        varchar(64)     default ''                 comment '更新者',
  update_time      datetime                                   comment '更新时间',
  remark           varchar(500)    default null               comment '备注',
  primary key (dict_code)
) engine=innodb auto_increment=100 comment = '字典数据表';

insert into sys_dict_data values(1,  1,  '男',       '0',       'sys_user_sex',        '',   '',        'Y', '0', 'admin', sysdate(), '', null, '性别男');
insert into sys_dict_data values(2,  2,  '女',       '1',       'sys_user_sex',        '',   '',        'N', '0', 'admin', sysdate(), '', null, '性别女');
insert into sys_dict_data values(3,  3,  '未知',     '2',       'sys_user_sex',        '',   '',        'N', '0', 'admin', sysdate(), '', null, '性别未知');
insert into sys_dict_data values(4,  1,  '显示',     '0',       'sys_show_hide',       '',   'primary', 'Y', '0', 'admin', sysdate(), '', null, '显示菜单');
insert into sys_dict_data values(5,  2,  '隐藏',     '1',       'sys_show_hide',       '',   'danger',  'N', '0', 'admin', sysdate(), '', null, '隐藏菜单');
insert into sys_dict_data values(6,  1,  '正常',     '0',       'sys_normal_disable',  '',   'primary', 'Y', '0', 'admin', sysdate(), '', null, '正常状态');
insert into sys_dict_data values(7,  2,  '停用',     '1',       'sys_normal_disable',  '',   'danger',  'N', '0', 'admin', sysdate(), '', null, '停用状态');
insert into sys_dict_data values(8,  1,  '正常',     '0',       'sys_job_status',      '',   'primary', 'Y', '0', 'admin', sysdate(), '', null, '正常状态');
insert into sys_dict_data values(9,  2,  '暂停',     '1',       'sys_job_status',      '',   'danger',  'N', '0', 'admin', sysdate(), '', null, '停用状态');
insert into sys_dict_data values(10, 1,  '默认',     'DEFAULT', 'sys_job_group',       '',   '',        'Y', '0', 'admin', sysdate(), '', null, '默认分组');
insert into sys_dict_data values(11, 2,  '系统',     'SYSTEM',  'sys_job_group',       '',   '',        'N', '0', 'admin', sysdate(), '', null, '系统分组');
insert into sys_dict_data values(12, 1,  '是',       'Y',       'sys_yes_no',          '',   'primary', 'Y', '0', 'admin', sysdate(), '', null, '系统默认是');
insert into sys_dict_data values(13, 2,  '否',       'N',       'sys_yes_no',          '',   'danger',  'N', '0', 'admin', sysdate(), '', null, '系统默认否');
insert into sys_dict_data values(14, 1,  '通知',     '1',       'sys_notice_type',     '',   'warning', 'Y', '0', 'admin', sysdate(), '', null, '通知');
insert into sys_dict_data values(15, 2,  '公告',     '2',       'sys_notice_type',     '',   'success', 'N', '0', 'admin', sysdate(), '', null, '公告');
insert into sys_dict_data values(16, 1,  '正常',     '0',       'sys_notice_status',   '',   'primary', 'Y', '0', 'admin', sysdate(), '', null, '正常状态');
insert into sys_dict_data values(17, 2,  '关闭',     '1',       'sys_notice_status',   '',   'danger',  'N', '0', 'admin', sysdate(), '', null, '关闭状态');
insert into sys_dict_data values(18, 99, '其他',     '0',       'sys_oper_type',       '',   'info',    'N', '0', 'admin', sysdate(), '', null, '其他操作');
insert into sys_dict_data values(19, 1,  '新增',     '1',       'sys_oper_type',       '',   'info',    'N', '0', 'admin', sysdate(), '', null, '新增操作');
insert into sys_dict_data values(20, 2,  '修改',     '2',       'sys_oper_type',       '',   'info',    'N', '0', 'admin', sysdate(), '', null, '修改操作');
insert into sys_dict_data values(21, 3,  '删除',     '3',       'sys_oper_type',       '',   'danger',  'N', '0', 'admin', sysdate(), '', null, '删除操作');
insert into sys_dict_data values(22, 4,  '授权',     '4',       'sys_oper_type',       '',   'primary', 'N', '0', 'admin', sysdate(), '', null, '授权操作');
insert into sys_dict_data values(23, 5,  '导出',     '5',       'sys_oper_type',       '',   'warning', 'N', '0', 'admin', sysdate(), '', null, '导出操作');
insert into sys_dict_data values(24, 6,  '导入',     '6',       'sys_oper_type',       '',   'warning', 'N', '0', 'admin', sysdate(), '', null, '导入操作');
insert into sys_dict_data values(25, 7,  '强退',     '7',       'sys_oper_type',       '',   'danger',  'N', '0', 'admin', sysdate(), '', null, '强退操作');
insert into sys_dict_data values(26, 8,  '生成代码', '8',       'sys_oper_type',       '',   'warning', 'N', '0', 'admin', sysdate(), '', null, '生成操作');
insert into sys_dict_data values(27, 9,  '清空数据', '9',       'sys_oper_type',       '',   'danger',  'N', '0', 'admin', sysdate(), '', null, '清空操作');
insert into sys_dict_data values(28, 1,  '成功',     '0',       'sys_common_status',   '',   'primary', 'N', '0', 'admin', sysdate(), '', null, '正常状态');
insert into sys_dict_data values(29, 2,  '失败',     '1',       'sys_common_status',   '',   'danger',  'N', '0', 'admin', sysdate(), '', null, '停用状态');


-- ----------------------------
-- 13、参数配置表
-- ----------------------------
drop table if exists sys_config;
create table sys_config (
  config_id         int(5)          not null auto_increment    comment '参数主键',
  config_name       varchar(100)    default ''                 comment '参数名称',
  config_key        varchar(100)    default ''                 comment '参数键名',
  config_value      varchar(500)    default ''                 comment '参数键值',
  config_type       char(1)         default 'N'                comment '系统内置（Y是 N否）',
  create_by         varchar(64)     default ''                 comment '创建者',
  create_time       datetime                                   comment '创建时间',
  update_by         varchar(64)     default ''                 comment '更新者',
  update_time       datetime                                   comment '更新时间',
  remark            varchar(500)    default null               comment '备注',
  primary key (config_id)
) engine=innodb auto_increment=100 comment = '参数配置表';

insert into sys_config values(1, '主框架页-默认皮肤样式名称',     'sys.index.skinName',               'skin-blue',     'Y', 'admin', sysdate(), '', null, '蓝色 skin-blue、绿色 skin-green、紫色 skin-purple、红色 skin-red、黄色 skin-yellow' );
insert into sys_config values(2, '用户管理-账号初始密码',         'sys.user.initPassword',            '123456',        'Y', 'admin', sysdate(), '', null, '初始化密码 123456' );
insert into sys_config values(3, '主框架页-侧边栏主题',           'sys.index.sideTheme',              'theme-dark',    'Y', 'admin', sysdate(), '', null, '深色主题theme-dark，浅色主题theme-light' );
insert into sys_config values(4, '账号自助-验证码开关',           'sys.account.captchaEnabled',       'true',          'Y', 'admin', sysdate(), '', null, '是否开启验证码功能（true开启，false关闭）');
insert into sys_config values(5, '账号自助-是否开启用户注册功能', 'sys.account.registerUser',         'false',         'Y', 'admin', sysdate(), '', null, '是否开启注册用户功能（true开启，false关闭）');
insert into sys_config values(6, '用户登录-黑名单列表',           'sys.login.blackIPList',            '',              'Y', 'admin', sysdate(), '', null, '设置登录IP黑名单限制，多个匹配项以;分隔，支持匹配（*通配、网段）');
insert into sys_config values(7, '用户管理-初始密码修改策略',     'sys.account.initPasswordModify',   '1',             'Y', 'admin', sysdate(), '', null, '0：初始密码修改策略关闭，没有任何提示，1：提醒用户，如果未修改初始密码，则在登录时就会提醒修改密码对话框');
insert into sys_config values(8, '用户管理-账号密码更新周期',     'sys.account.passwordValidateDays', '0',             'Y', 'admin', sysdate(), '', null, '密码更新周期（填写数字，数据初始化值为0不限制，若修改必须为大于0小于365的正整数），如果超过这个周期登录系统时，则在登录时就会提醒修改密码对话框');
insert into sys_config values(9, '用户管理-密码字符范围',         'sys.account.chrtype',              '0',             'Y', 'admin', sysdate(), '', null, '默认任意字符范围，0任意（密码可以输入任意字符），1数字（密码只能为0-9数字），2英文字母（密码只能为a-z和A-Z字母），3字母和数字（密码必须包含字母，数字）,4字母数字和特殊字符（目前支持的特殊字符包括：~!@#$%^&*()-=_+）');


-- ----------------------------
-- 14、系统访问记录
-- ----------------------------
drop table if exists sys_logininfor;
create table sys_logininfor (
  info_id        bigint(20)     not null auto_increment   comment '访问ID',
  user_name      varchar(50)    default ''                comment '用户账号',
  ipaddr         varchar(128)   default ''                comment '登录IP地址',
  login_location varchar(255)   default ''                comment '登录地点',
  browser        varchar(50)    default ''                comment '浏览器类型',
  os             varchar(50)    default ''                comment '操作系统',
  status         char(1)        default '0'               comment '登录状态（0成功 1失败）',
  msg            varchar(255)   default ''                comment '提示消息',
  login_time     datetime                                 comment '访问时间',
  primary key (info_id),
  key idx_sys_logininfor_s  (status),
  key idx_sys_logininfor_lt (login_time)
) engine=innodb auto_increment=100 comment = '系统访问记录';


-- ----------------------------
-- 15、定时任务调度表
-- ----------------------------
drop table if exists sys_job;
create table sys_job (
  job_id              bigint(20)    not null auto_increment    comment '任务ID',
  job_name            varchar(64)   default ''                 comment '任务名称',
  job_group           varchar(64)   default 'DEFAULT'          comment '任务组名',
  invoke_target       varchar(500)  not null                   comment '调用目标字符串',
  cron_expression     varchar(255)  default ''                 comment 'cron执行表达式',
  misfire_policy      varchar(20)   default '3'                comment '计划执行错误策略（1立即执行 2执行一次 3放弃执行）',
  concurrent          char(1)       default '1'                comment '是否并发执行（0允许 1禁止）',
  status              char(1)       default '0'                comment '状态（0正常 1暂停）',
  create_by           varchar(64)   default ''                 comment '创建者',
  create_time         datetime                                 comment '创建时间',
  update_by           varchar(64)   default ''                 comment '更新者',
  update_time         datetime                                 comment '更新时间',
  remark              varchar(500)  default ''                 comment '备注信息',
  primary key (job_id, job_name, job_group)
) engine=innodb auto_increment=100 comment = '定时任务调度表';

insert into sys_job values(1, '系统默认（无参）', 'DEFAULT', 'ryTask.ryNoParams',        '0/10 * * * * ?', '3', '1', '1', 'admin', sysdate(), '', null, '');
insert into sys_job values(2, '系统默认（有参）', 'DEFAULT', 'ryTask.ryParams(\'ry\')',  '0/15 * * * * ?', '3', '1', '1', 'admin', sysdate(), '', null, '');
insert into sys_job values(3, '系统默认（多参）', 'DEFAULT', 'ryTask.ryMultipleParams(\'ry\', true, 2000L, 316.50D, 100)',  '0/20 * * * * ?', '3', '1', '1', 'admin', sysdate(), '', null, '');


-- ----------------------------
-- 16、定时任务调度日志表
-- ----------------------------
drop table if exists sys_job_log;
create table sys_job_log (
  job_log_id          bigint(20)     not null auto_increment    comment '任务日志ID',
  job_name            varchar(64)    not null                   comment '任务名称',
  job_group           varchar(64)    not null                   comment '任务组名',
  invoke_target       varchar(500)   not null                   comment '调用目标字符串',
  job_message         varchar(500)                              comment '日志信息',
  status              char(1)        default '0'                comment '执行状态（0正常 1失败）',
  exception_info      varchar(2000)  default ''                 comment '异常信息',
  start_time          datetime                                  comment '执行开始时间',
  end_time            datetime                                  comment '执行结束时间',
  create_time         datetime                                  comment '创建时间',
  primary key (job_log_id)
) engine=innodb comment = '定时任务调度日志表';


-- ----------------------------
-- 17、通知公告表
-- ----------------------------
drop table if exists sys_notice;
create table sys_notice (
  notice_id         int(4)          not null auto_increment    comment '公告ID',
  notice_title      varchar(50)     not null                   comment '公告标题',
  notice_type       char(1)         not null                   comment '公告类型（1通知 2公告）',
  notice_content    longblob        default null               comment '公告内容',
  status            char(1)         default '0'                comment '公告状态（0正常 1关闭）',
  create_by         varchar(64)     default ''                 comment '创建者',
  create_time       datetime                                   comment '创建时间',
  update_by         varchar(64)     default ''                 comment '更新者',
  update_time       datetime                                   comment '更新时间',
  remark            varchar(255)    default null               comment '备注',
  primary key (notice_id)
) engine=innodb auto_increment=10 comment = '通知公告表';

-- ----------------------------
-- 初始化-公告信息表数据
-- ----------------------------
insert into sys_notice values('1', '温馨提醒：2018-07-01 若依新版本发布啦', '2', '新版本内容', '0', 'admin', sysdate(), '', null, '管理员');
insert into sys_notice values('2', '维护通知：2018-07-01 若依系统凌晨维护', '1', '维护内容',   '0', 'admin', sysdate(), '', null, '管理员');
insert into sys_notice values('3', '若依开源框架介绍', '1', '<p><span style=\"color: rgb(230, 0, 0);\">项目介绍</span></p><p><font color=\"#333333\">RuoYi开源项目是为企业用户定制的后台脚手架框架，为企业打造的一站式解决方案，降低企业开发成本，提升开发效率。主要包括用户管理、角色管理、部门管理、菜单管理、参数管理、字典管理、</font><span style=\"color: rgb(51, 51, 51);\">岗位管理</span><span style=\"color: rgb(51, 51, 51);\">、定时任务</span><span style=\"color: rgb(51, 51, 51);\">、</span><span style=\"color: rgb(51, 51, 51);\">服务监控、登录日志、操作日志、代码生成等功能。其中，还支持多数据源、数据权限、国际化、Redis缓存、Docker部署、滑动验证码、第三方认证登录、分布式事务、</span><font color=\"#333333\">分布式文件存储</font><span style=\"color: rgb(51, 51, 51);\">、分库分表处理等技术特点。</span></p><p><img src=\"https://foruda.gitee.com/images/1773931848342439032/a4d22313_1815095.png\" style=\"width: 64px;\"><br></p><p><span style=\"color: rgb(230, 0, 0);\">官网及演示</span></p><p><span style=\"color: rgb(51, 51, 51);\">若依官网地址：&nbsp;</span><a href=\"http://ruoyi.vip\" target=\"_blank\">http://ruoyi.vip</a><a href=\"http://ruoyi.vip\" target=\"_blank\"></a></p><p><span style=\"color: rgb(51, 51, 51);\">若依文档地址：&nbsp;</span><a href=\"http://doc.ruoyi.vip\" target=\"_blank\">http://doc.ruoyi.vip</a><br></p><p><span style=\"color: rgb(51, 51, 51);\">演示地址【不分离版】：&nbsp;</span><a href=\"http://demo.ruoyi.vip\" target=\"_blank\">http://demo.ruoyi.vip</a></p><p><span style=\"color: rgb(51, 51, 51);\">演示地址【分离版本】：&nbsp;</span><a href=\"http://vue.ruoyi.vip\" target=\"_blank\">http://vue.ruoyi.vip</a></p><p><span style=\"color: rgb(51, 51, 51);\">演示地址【微服务版】：&nbsp;</span><a href=\"http://cloud.ruoyi.vip\" target=\"_blank\">http://cloud.ruoyi.vip</a></p><p><span style=\"color: rgb(51, 51, 51);\">演示地址【移动端版】：&nbsp;</span><a href=\"http://h5.ruoyi.vip\" target=\"_blank\">http://h5.ruoyi.vip</a></p><p><br style=\"color: rgb(48, 49, 51); font-family: &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif; font-size: 12px;\"></p>', '0', 'admin', sysdate(), '', null, '管理员');


-- ----------------------------
-- 18、公告已读记录表
-- ----------------------------
drop table if exists sys_notice_read;
create table sys_notice_read (
  read_id          bigint(20)       not null auto_increment    comment '已读主键',
  notice_id        int(4)           not null                   comment '公告id',
  user_id          bigint(20)       not null                   comment '用户id',
  read_time        datetime         not null                   comment '阅读时间',
  primary key (read_id),
  unique key uk_user_notice (user_id, notice_id)   comment '同一用户同一公告只记录一次'
) engine=innodb auto_increment=1 comment='公告已读记录表';

-- ============================================================
-- 第 3 章  Quartz 定时任务调度表
-- 上游来源：RuoYi-Vue springboot3 分支 sql/quartz.sql，原样保留
-- ============================================================

DROP TABLE IF EXISTS QRTZ_FIRED_TRIGGERS;
DROP TABLE IF EXISTS QRTZ_PAUSED_TRIGGER_GRPS;
DROP TABLE IF EXISTS QRTZ_SCHEDULER_STATE;
DROP TABLE IF EXISTS QRTZ_LOCKS;
DROP TABLE IF EXISTS QRTZ_SIMPLE_TRIGGERS;
DROP TABLE IF EXISTS QRTZ_SIMPROP_TRIGGERS;
DROP TABLE IF EXISTS QRTZ_CRON_TRIGGERS;
DROP TABLE IF EXISTS QRTZ_BLOB_TRIGGERS;
DROP TABLE IF EXISTS QRTZ_TRIGGERS;
DROP TABLE IF EXISTS QRTZ_JOB_DETAILS;
DROP TABLE IF EXISTS QRTZ_CALENDARS;

-- ----------------------------
-- 1、存储每一个已配置的 jobDetail 的详细信息
-- ----------------------------
create table QRTZ_JOB_DETAILS (
    sched_name           varchar(120)    not null            comment '调度名称',
    job_name             varchar(200)    not null            comment '任务名称',
    job_group            varchar(200)    not null            comment '任务组名',
    description          varchar(250)    null                comment '相关介绍',
    job_class_name       varchar(250)    not null            comment '执行任务类名称',
    is_durable           varchar(1)      not null            comment '是否持久化',
    is_nonconcurrent     varchar(1)      not null            comment '是否并发',
    is_update_data       varchar(1)      not null            comment '是否更新数据',
    requests_recovery    varchar(1)      not null            comment '是否接受恢复执行',
    job_data             blob            null                comment '存放持久化job对象',
    primary key (sched_name, job_name, job_group)
) engine=innodb comment = '任务详细信息表';

-- ----------------------------
-- 2、 存储已配置的 Trigger 的信息
-- ----------------------------
create table QRTZ_TRIGGERS (
    sched_name           varchar(120)    not null            comment '调度名称',
    trigger_name         varchar(200)    not null            comment '触发器的名字',
    trigger_group        varchar(200)    not null            comment '触发器所属组的名字',
    job_name             varchar(200)    not null            comment 'qrtz_job_details表job_name的外键',
    job_group            varchar(200)    not null            comment 'qrtz_job_details表job_group的外键',
    description          varchar(250)    null                comment '相关介绍',
    next_fire_time       bigint(13)      null                comment '上一次触发时间（毫秒）',
    prev_fire_time       bigint(13)      null                comment '下一次触发时间（默认为-1表示不触发）',
    priority             integer         null                comment '优先级',
    trigger_state        varchar(16)     not null            comment '触发器状态',
    trigger_type         varchar(8)      not null            comment '触发器的类型',
    start_time           bigint(13)      not null            comment '开始时间',
    end_time             bigint(13)      null                comment '结束时间',
    calendar_name        varchar(200)    null                comment '日程表名称',
    misfire_instr        smallint(2)     null                comment '补偿执行的策略',
    job_data             blob            null                comment '存放持久化job对象',
    primary key (sched_name, trigger_name, trigger_group),
    foreign key (sched_name, job_name, job_group) references QRTZ_JOB_DETAILS(sched_name, job_name, job_group)
) engine=innodb comment = '触发器详细信息表';

-- ----------------------------
-- 3、 存储简单的 Trigger，包括重复次数，间隔，以及已触发的次数
-- ----------------------------
create table QRTZ_SIMPLE_TRIGGERS (
    sched_name           varchar(120)    not null            comment '调度名称',
    trigger_name         varchar(200)    not null            comment 'qrtz_triggers表trigger_name的外键',
    trigger_group        varchar(200)    not null            comment 'qrtz_triggers表trigger_group的外键',
    repeat_count         bigint(7)       not null            comment '重复的次数统计',
    repeat_interval      bigint(12)      not null            comment '重复的间隔时间',
    times_triggered      bigint(10)      not null            comment '已经触发的次数',
    primary key (sched_name, trigger_name, trigger_group),
    foreign key (sched_name, trigger_name, trigger_group) references QRTZ_TRIGGERS(sched_name, trigger_name, trigger_group)
) engine=innodb comment = '简单触发器的信息表';

-- ----------------------------
-- 4、 存储 Cron Trigger，包括 Cron 表达式和时区信息
-- ---------------------------- 
create table QRTZ_CRON_TRIGGERS (
    sched_name           varchar(120)    not null            comment '调度名称',
    trigger_name         varchar(200)    not null            comment 'qrtz_triggers表trigger_name的外键',
    trigger_group        varchar(200)    not null            comment 'qrtz_triggers表trigger_group的外键',
    cron_expression      varchar(200)    not null            comment 'cron表达式',
    time_zone_id         varchar(80)                         comment '时区',
    primary key (sched_name, trigger_name, trigger_group),
    foreign key (sched_name, trigger_name, trigger_group) references QRTZ_TRIGGERS(sched_name, trigger_name, trigger_group)
) engine=innodb comment = 'Cron类型的触发器表';

-- ----------------------------
-- 5、 Trigger 作为 Blob 类型存储(用于 Quartz 用户用 JDBC 创建他们自己定制的 Trigger 类型，JobStore 并不知道如何存储实例的时候)
-- ---------------------------- 
create table QRTZ_BLOB_TRIGGERS (
    sched_name           varchar(120)    not null            comment '调度名称',
    trigger_name         varchar(200)    not null            comment 'qrtz_triggers表trigger_name的外键',
    trigger_group        varchar(200)    not null            comment 'qrtz_triggers表trigger_group的外键',
    blob_data            blob            null                comment '存放持久化Trigger对象',
    primary key (sched_name, trigger_name, trigger_group),
    foreign key (sched_name, trigger_name, trigger_group) references QRTZ_TRIGGERS(sched_name, trigger_name, trigger_group)
) engine=innodb comment = 'Blob类型的触发器表';

-- ----------------------------
-- 6、 以 Blob 类型存储存放日历信息， quartz可配置一个日历来指定一个时间范围
-- ---------------------------- 
create table QRTZ_CALENDARS (
    sched_name           varchar(120)    not null            comment '调度名称',
    calendar_name        varchar(200)    not null            comment '日历名称',
    calendar             blob            not null            comment '存放持久化calendar对象',
    primary key (sched_name, calendar_name)
) engine=innodb comment = '日历信息表';

-- ----------------------------
-- 7、 存储已暂停的 Trigger 组的信息
-- ---------------------------- 
create table QRTZ_PAUSED_TRIGGER_GRPS (
    sched_name           varchar(120)    not null            comment '调度名称',
    trigger_group        varchar(200)    not null            comment 'qrtz_triggers表trigger_group的外键',
    primary key (sched_name, trigger_group)
) engine=innodb comment = '暂停的触发器表';

-- ----------------------------
-- 8、 存储与已触发的 Trigger 相关的状态信息，以及相联 Job 的执行信息
-- ---------------------------- 
create table QRTZ_FIRED_TRIGGERS (
    sched_name           varchar(120)    not null            comment '调度名称',
    entry_id             varchar(95)     not null            comment '调度器实例id',
    trigger_name         varchar(200)    not null            comment 'qrtz_triggers表trigger_name的外键',
    trigger_group        varchar(200)    not null            comment 'qrtz_triggers表trigger_group的外键',
    instance_name        varchar(200)    not null            comment '调度器实例名',
    fired_time           bigint(13)      not null            comment '触发的时间',
    sched_time           bigint(13)      not null            comment '定时器制定的时间',
    priority             integer         not null            comment '优先级',
    state                varchar(16)     not null            comment '状态',
    job_name             varchar(200)    null                comment '任务名称',
    job_group            varchar(200)    null                comment '任务组名',
    is_nonconcurrent     varchar(1)      null                comment '是否并发',
    requests_recovery    varchar(1)      null                comment '是否接受恢复执行',
    primary key (sched_name, entry_id)
) engine=innodb comment = '已触发的触发器表';

-- ----------------------------
-- 9、 存储少量的有关 Scheduler 的状态信息，假如是用于集群中，可以看到其他的 Scheduler 实例
-- ---------------------------- 
create table QRTZ_SCHEDULER_STATE (
    sched_name           varchar(120)    not null            comment '调度名称',
    instance_name        varchar(200)    not null            comment '实例名称',
    last_checkin_time    bigint(13)      not null            comment '上次检查时间',
    checkin_interval     bigint(13)      not null            comment '检查间隔时间',
    primary key (sched_name, instance_name)
) engine=innodb comment = '调度器状态表';

-- ----------------------------
-- 10、 存储程序的悲观锁的信息(假如使用了悲观锁)
-- ---------------------------- 
create table QRTZ_LOCKS (
    sched_name           varchar(120)    not null            comment '调度名称',
    lock_name            varchar(40)     not null            comment '悲观锁名称',
    primary key (sched_name, lock_name)
) engine=innodb comment = '存储的悲观锁信息表';

-- ----------------------------
-- 11、 Quartz集群实现同步机制的行锁表
-- ---------------------------- 
create table QRTZ_SIMPROP_TRIGGERS (
    sched_name           varchar(120)    not null            comment '调度名称',
    trigger_name         varchar(200)    not null            comment 'qrtz_triggers表trigger_name的外键',
    trigger_group        varchar(200)    not null            comment 'qrtz_triggers表trigger_group的外键',
    str_prop_1           varchar(512)    null                comment 'String类型的trigger的第一个参数',
    str_prop_2           varchar(512)    null                comment 'String类型的trigger的第二个参数',
    str_prop_3           varchar(512)    null                comment 'String类型的trigger的第三个参数',
    int_prop_1           int             null                comment 'int类型的trigger的第一个参数',
    int_prop_2           int             null                comment 'int类型的trigger的第二个参数',
    long_prop_1          bigint          null                comment 'long类型的trigger的第一个参数',
    long_prop_2          bigint          null                comment 'long类型的trigger的第二个参数',
    dec_prop_1           numeric(13,4)   null                comment 'decimal类型的trigger的第一个参数',
    dec_prop_2           numeric(13,4)   null                comment 'decimal类型的trigger的第二个参数',
    bool_prop_1          varchar(1)      null                comment 'Boolean类型的trigger的第一个参数',
    bool_prop_2          varchar(1)      null                comment 'Boolean类型的trigger的第二个参数',
    primary key (sched_name, trigger_name, trigger_group),
    foreign key (sched_name, trigger_name, trigger_group) references QRTZ_TRIGGERS(sched_name, trigger_name, trigger_group)
) engine=innodb comment = '同步机制的行锁表';

commit;
-- ============================================================
-- 第 4 章  电梯业务表
-- 本项目新增的 19 张业务表，覆盖论文五个功能模块
-- ============================================================

-- 1、小区表
-- ----------------------------
drop table if exists community;
create table community (
  community_id      bigint(20)      not null auto_increment    comment '小区ID',
  community_name    varchar(100)    not null                   comment '小区名称',
  address           varchar(200)    default ''                 comment '小区地址',
  build_year        varchar(10)     default ''                 comment '建成时间',
  property_contact  varchar(20)     default ''                 comment '物业联系人',
  property_phone    varchar(20)     default ''                 comment '物业联系电话',
  status            char(1)         default '0'                comment '状态（0正常 1停用）',
  del_flag          char(1)         default '0'                comment '删除标志（0代表存在 2代表删除）',
  create_by         varchar(64)     default ''                 comment '创建者',
  create_time       datetime                                   comment '创建时间',
  update_by         varchar(64)     default ''                 comment '更新者',
  update_time       datetime                                   comment '更新时间',
  remark            varchar(500)    default null               comment '备注',
  primary key (community_id)
) engine=innodb auto_increment=1 comment = '小区信息表';

-- ----------------------------
-- 2、楼栋表
-- ----------------------------
drop table if exists building;
create table building (
  building_id       bigint(20)      not null auto_increment    comment '楼栋ID',
  community_id      bigint(20)      not null                   comment '所属小区ID',
  building_no       varchar(30)     not null                   comment '楼栋号',
  unit_no           varchar(30)     default ''                 comment '单元号',
  floor_count       int(4)          default 0                  comment '楼层数',
  status            char(1)         default '0'                comment '状态（0正常 1停用）',
  del_flag          char(1)         default '0'                comment '删除标志（0代表存在 2代表删除）',
  create_by         varchar(64)     default ''                 comment '创建者',
  create_time       datetime                                   comment '创建时间',
  update_by         varchar(64)     default ''                 comment '更新者',
  update_time       datetime                                   comment '更新时间',
  remark            varchar(500)    default null               comment '备注',
  primary key (building_id),
  key idx_building_community (community_id)
) engine=innodb auto_increment=1 comment = '楼栋信息表';

-- ----------------------------
-- 3、电梯表
-- ----------------------------
drop table if exists elevator;
create table elevator (
  elevator_id       bigint(20)      not null auto_increment    comment '电梯ID',
  elevator_code     varchar(50)     not null                   comment '电梯编号',
  brand             varchar(50)     default ''                 comment '品牌',
  model             varchar(50)     default ''                 comment '型号',
  building_id       bigint(20)      not null                   comment '所在楼栋ID',
  unit_no           varchar(10)     default ''                 comment '单元号',
  maintain_unit     varchar(100)    default ''                 comment '维保单位',
  install_date      date                                       comment '投用日期',
  service_years     int(4)          default 0                  comment '使用年限',
  cert_file_id      bigint(20)      default null               comment '年检报告附件ID',
  status            char(1)         default '0'                comment '状态（0正常运行 1停梯检修 2已报废）',
  del_flag          char(1)         default '0'                comment '删除标志（0代表存在 2代表删除）',
  create_by         varchar(64)     default ''                 comment '创建者',
  create_time       datetime                                   comment '创建时间',
  update_by         varchar(64)     default ''                 comment '更新者',
  update_time       datetime                                   comment '更新时间',
  remark            varchar(500)    default null               comment '备注',
  primary key (elevator_id),
  key idx_elevator_building (building_id)
) engine=innodb auto_increment=1 comment = '电梯信息表';

-- ----------------------------
-- 4、文件表
-- ----------------------------
drop table if exists sys_file;
create table sys_file (
  file_id           bigint(20)      not null auto_increment    comment '文件ID',
  file_name         varchar(200)    not null                   comment '原文件名',
  file_path         varchar(500)    not null                   comment '存储路径',
  file_url          varchar(500)    default ''                 comment '访问地址',
  file_type         varchar(20)     default ''                 comment '文件类型（image图片 video视频 doc文档 excel表格 pdf文档）',
  file_suffix       varchar(20)     default ''                 comment '文件后缀',
  file_size         bigint(20)      default 0                  comment '文件大小（字节）',
  biz_type          varchar(30)     default ''                 comment '业务类型（elevator_cert电梯证件 repair_evidence报修证据 inspection巡检结果 report导出报表）',
  biz_id            bigint(20)      default null               comment '关联业务ID',
  upload_by         varchar(64)     default ''                 comment '上传人',
  upload_time       datetime                                   comment '上传时间',
  del_flag          char(1)         default '0'                comment '删除标志（0代表存在 2代表删除）',
  primary key (file_id),
  key idx_file_biz (biz_type, biz_id)
) engine=innodb auto_increment=1 comment = '文件信息表';

-- ----------------------------
-- 5、报修工单表
-- ----------------------------
drop table if exists repair_order;
create table repair_order (
  order_id          bigint(20)      not null auto_increment    comment '工单ID',
  order_no          varchar(50)     not null                   comment '工单编号',
  user_id           bigint(20)      not null                   comment '报修人ID',
  elevator_id       bigint(20)      not null                   comment '故障电梯ID',
  fault_desc        varchar(500)    not null                   comment '故障现象描述',
  fault_type        varchar(30)     default ''                 comment '故障类型（abnormal_noise异响 stop停梯 trapped困人 door门故障 button按钮失灵 other其他）',
  fault_level       char(1)         default '1'                comment '故障等级（0紧急 1一般）',
  order_status      varchar(20)     default 'pending'          comment '工单状态（pending待处理 assigned已派单 accepted已接单 arrived已到场 repairing维修中 repaired已修复 confirmed已完成 rejected已驳回 appealed已申诉）',
  reporter_phone    varchar(20)     default ''                 comment '报修人联系电话',
  report_time       datetime                                   comment '报修时间',
  assign_time       datetime                                   comment '派单时间',
  accept_time       datetime                                   comment '接单时间',
  arrive_time       datetime                                   comment '到场时间',
  finish_time       datetime                                   comment '维修完成时间',
  confirm_time      datetime                                   comment '业主确认时间',
  assignee_id       bigint(20)      default null               comment '维修员ID',
  assigner_id       bigint(20)      default null               comment '派单人ID',
  reject_reason     varchar(500)    default ''                 comment '驳回原因',
  deadline_time     datetime                                   comment '处理时限',
  del_flag          char(1)         default '0'                comment '删除标志（0代表存在 2代表删除）',
  create_by         varchar(64)     default ''                 comment '创建者',
  create_time       datetime                                   comment '创建时间',
  update_by         varchar(64)     default ''                 comment '更新者',
  update_time       datetime                                   comment '更新时间',
  remark            varchar(500)    default null               comment '备注',
  primary key (order_id),
  unique key uk_order_no (order_no),
  key idx_order_elevator (elevator_id),
  key idx_order_user (user_id),
  key idx_order_assignee (assignee_id),
  key idx_order_status (order_status)
) engine=innodb auto_increment=1 comment = '报修工单表';

-- ----------------------------
-- 6、报修证据附件表
-- ----------------------------
drop table if exists repair_evidence;
create table repair_evidence (
  evidence_id       bigint(20)      not null auto_increment    comment '证据ID',
  order_id          bigint(20)      not null                   comment '关联工单ID',
  file_id           bigint(20)      not null                   comment '文件ID',
  evidence_type     varchar(20)     default 'image'            comment '证据类型（image图片 video视频）',
  upload_time       datetime                                   comment '上传时间',
  create_by         varchar(64)     default ''                 comment '创建者',
  del_flag          char(1)         default '0'                comment '删除标志（0代表存在 2代表删除）',
  primary key (evidence_id),
  key idx_evidence_order (order_id)
) engine=innodb auto_increment=1 comment = '报修证据附件表';

-- ----------------------------
-- 7、维修记录表
-- ----------------------------
drop table if exists repair_record;
create table repair_record (
  record_id         bigint(20)      not null auto_increment    comment '记录ID',
  order_id          bigint(20)      not null                   comment '关联工单ID',
  worker_id         bigint(20)      not null                   comment '维修员ID',
  arrive_time       datetime                                   comment '到场时间',
  arrive_location   varchar(200)    default ''                 comment '到场定位',
  investigate_note  varchar(1000)   default ''                 comment '排查记录',
  repair_desc       varchar(1000)   default ''                 comment '维修说明',
  fault_reason      varchar(30)     default ''                 comment '故障原因（normal_wear正常磨损 parts_damage配件损坏 improper_use使用不当 external外因 other其他）',
  replace_parts     varchar(500)    default ''                 comment '更换配件',
  finish_time       datetime                                   comment '完工时间',
  result_file_id    bigint(20)      default null               comment '完工凭证文件ID',
  create_by         varchar(64)     default ''                 comment '创建者',
  create_time       datetime                                   comment '创建时间',
  update_by         varchar(64)     default ''                 comment '更新者',
  update_time       datetime                                   comment '更新时间',
  primary key (record_id),
  key idx_record_order (order_id),
  key idx_record_worker (worker_id)
) engine=innodb auto_increment=1 comment = '维修记录表';

-- ----------------------------
-- 8、工单状态流转表
-- ----------------------------
drop table if exists order_status_log;
create table order_status_log (
  log_id            bigint(20)      not null auto_increment    comment '日志ID',
  order_id          bigint(20)      not null                   comment '关联工单ID',
  from_status       varchar(20)     default ''                 comment '原状态',
  to_status         varchar(20)     not null                   comment '新状态',
  operate_type      varchar(30)     default ''                 comment '操作类型（report报修 reject驳回 assign派单 accept接单 arrive到场 investigate排查 finish维修完成 confirm业主确认 appeal申诉 reassign重新指派 escalate升级）',
  operator_id       bigint(20)      default null               comment '操作人ID',
  operator_name     varchar(64)     default ''                 comment '操作人姓名',
  operator_role     varchar(30)     default ''                 comment '操作人角色',
  operate_time      datetime                                   comment '操作时间',
  remark            varchar(500)    default ''                 comment '备注',
  primary key (log_id),
  key idx_log_order (order_id)
) engine=innodb auto_increment=1 comment = '工单状态流转表';

-- ----------------------------
-- 9、维修员技能与区域表
-- ----------------------------
drop table if exists worker_skill;
create table worker_skill (
  skill_id          bigint(20)      not null auto_increment    comment '技能ID',
  worker_id         bigint(20)      not null                   comment '维修员ID',
  community_id      bigint(20)      default null               comment '负责小区ID',
  skill_tags        varchar(200)    default ''                 comment '技能标签（多个用逗号分隔，如 曳引机,门系统,控制系统）',
  work_status       char(1)         default '0'                comment '在岗状态（0在岗 1休息 2请假）',
  current_load      int(4)          default 0                  comment '当前在手工单数',
  total_finished    int(8)          default 0                  comment '累计完成工单数',
  avg_response      int(8)          default 0                  comment '平均响应时长（分钟）',
  create_by         varchar(64)     default ''                 comment '创建者',
  create_time       datetime                                   comment '创建时间',
  update_by         varchar(64)     default ''                 comment '更新者',
  update_time       datetime                                   comment '更新时间',
  primary key (skill_id),
  key idx_skill_worker (worker_id),
  key idx_skill_community (community_id)
) engine=innodb auto_increment=1 comment = '维修员技能与负责区域表';

-- ----------------------------
-- 10、维保检查项模板表
-- ----------------------------
drop table if exists maintain_item;
create table maintain_item (
  item_id           bigint(20)      not null auto_increment    comment '检查项ID',
  template_name     varchar(100)    not null                   comment '模板名称',
  maintain_type     varchar(30)     default ''                 comment '适用维保类型（half_month半月保 quarter季度检 half_year半年保 annual年检）',
  item_name         varchar(100)    not null                   comment '检查项名称',
  item_category     varchar(30)     default ''                 comment '检查项分类（traction曳引机 door_system门系统 safety安全装置 control控制系统 car轿厢 other其他）',
  check_standard    varchar(500)    default ''                 comment '检查标准',
  order_num         int(4)          default 0                  comment '排序号',
  status            char(1)         default '0'                comment '状态（0正常 1停用）',
  create_by         varchar(64)     default ''                 comment '创建者',
  create_time       datetime                                   comment '创建时间',
  update_by         varchar(64)     default ''                 comment '更新者',
  update_time       datetime                                   comment '更新时间',
  primary key (item_id),
  key idx_item_type (maintain_type)
) engine=innodb auto_increment=1 comment = '维保检查项模板表';

-- ----------------------------
-- 11、维保计划表
-- ----------------------------
drop table if exists maintain_plan;
create table maintain_plan (
  plan_id           bigint(20)      not null auto_increment    comment '计划ID',
  plan_name         varchar(100)    not null                   comment '计划名称',
  elevator_id       bigint(20)      not null                   comment '电梯ID',
  maintain_type     varchar(30)     not null                   comment '维保类型（half_month半月保 quarter季度检 half_year半年保 annual年检）',
  cycle_days        int(4)          not null                   comment '周期天数',
  template_name     varchar(100)    default ''                 comment '检查项模板名称',
  start_date        date                                       comment '生效日期',
  end_date          date                                       comment '失效日期',
  next_date         date                                       comment '下次维保日期',
  last_date         date                                       comment '上次维保日期',
  owner_id          bigint(20)      default null               comment '负责人ID',
  plan_status       char(1)         default '0'                comment '计划状态（0启用 1停用）',
  expect_count      int(8)          default 0                  comment '应执行次数',
  finish_count      int(8)          default 0                  comment '已执行次数',
  del_flag          char(1)         default '0'                comment '删除标志（0代表存在 2代表删除）',
  create_by         varchar(64)     default ''                 comment '创建者',
  create_time       datetime                                   comment '创建时间',
  update_by         varchar(64)     default ''                 comment '更新者',
  update_time       datetime                                   comment '更新时间',
  remark            varchar(500)    default null               comment '备注',
  primary key (plan_id),
  key idx_plan_elevator (elevator_id),
  key idx_plan_next_date (next_date)
) engine=innodb auto_increment=1 comment = '维保计划表';

-- ----------------------------
-- 12、巡检记录表
-- ----------------------------
drop table if exists inspection_record;
create table inspection_record (
  record_id         bigint(20)      not null auto_increment    comment '巡检记录ID',
  record_no         varchar(50)     not null                   comment '巡检工单编号',
  plan_id           bigint(20)      default null               comment '关联维保计划ID',
  elevator_id       bigint(20)      not null                   comment '电梯ID',
  maintain_type     varchar(30)     default ''                 comment '维保类型',
  plan_date         date                                       comment '计划维保日期',
  executor_id       bigint(20)      default null               comment '执行人ID',
  clock_in_time     datetime                                   comment '打卡时间',
  clock_in_location varchar(200)    default ''                 comment '打卡位置',
  execute_date      date                                       comment '实际执行日期',
  execute_result    varchar(20)     default 'pending'          comment '执行结果（pending待执行 normal正常 abnormal异常）',
  abnormal_desc     varchar(1000)   default ''                 comment '异常说明',
  normal_count      int(4)          default 0                  comment '正常项数',
  abnormal_count    int(4)          default 0                  comment '异常项数',
  na_count          int(4)          default 0                  comment '不适用项数',
  record_status     varchar(20)     default 'pending'          comment '记录状态（pending待执行 finished已完成 overdue已超期）',
  del_flag          char(1)         default '0'                comment '删除标志（0代表存在 2代表删除）',
  create_by         varchar(64)     default ''                 comment '创建者',
  create_time       datetime                                   comment '创建时间',
  update_by         varchar(64)     default ''                 comment '更新者',
  update_time       datetime                                   comment '更新时间',
  primary key (record_id),
  unique key uk_record_no (record_no),
  key idx_inspection_elevator (elevator_id),
  key idx_inspection_plan (plan_id),
  key idx_inspection_executor (executor_id)
) engine=innodb auto_increment=1 comment = '巡检记录表';

-- ----------------------------
-- 13、巡检检查项结果表
-- ----------------------------
drop table if exists inspection_item_result;
create table inspection_item_result (
  result_id         bigint(20)      not null auto_increment    comment '结果ID',
  record_id         bigint(20)      not null                   comment '巡检记录ID',
  item_id           bigint(20)      default null               comment '检查项ID',
  item_name         varchar(100)    not null                   comment '检查项名称',
  item_category     varchar(30)     default ''                 comment '检查项分类',
  check_result      varchar(20)     default 'normal'           comment '检查结果（normal正常 abnormal异常 na不适用）',
  abnormal_desc     varchar(500)    default ''                 comment '异常说明',
  file_id           bigint(20)      default null               comment '现场照片文件ID',
  order_num         int(4)          default 0                  comment '排序号',
  primary key (result_id),
  key idx_result_record (record_id)
) engine=innodb auto_increment=1 comment = '巡检检查项结果表';

-- ----------------------------
-- 14、维保档案表
-- ----------------------------
drop table if exists maintain_archive;
create table maintain_archive (
  archive_id        bigint(20)      not null auto_increment    comment '档案ID',
  elevator_id       bigint(20)      not null                   comment '电梯ID',
  archive_type      varchar(30)     not null                   comment '归档类型（inspection巡检 maintain维保 repair维修）',
  maintain_type     varchar(30)     default ''                 comment '维保类型',
  biz_id            bigint(20)      default null               comment '关联业务ID，指向巡检记录或维修记录',
  archive_time      datetime                                   comment '归档时间',
  summary           varchar(1000)   default ''                 comment '记录摘要',
  executor_name     varchar(64)     default ''                 comment '执行人姓名',
  execute_date      date                                       comment '执行日期',
  is_abnormal       char(1)         default '0'                comment '是否含异常（0正常 1异常）',
  create_time       datetime                                   comment '创建时间',
  primary key (archive_id),
  key idx_archive_elevator (elevator_id),
  key idx_archive_type (archive_type)
) engine=innodb auto_increment=1 comment = '维保档案表';

-- ----------------------------
-- 15、预警规则表
-- ----------------------------
drop table if exists warning_rule;
create table warning_rule (
  rule_id           bigint(20)      not null auto_increment    comment '规则ID',
  rule_name         varchar(100)    not null                   comment '规则名称',
  rule_type         varchar(30)     not null                   comment '规则类型（order_timeout工单超时 maintain_due维保临期）',
  biz_sub_type      varchar(30)     default ''                 comment '业务子类型（assign派单超时 accept接单超时 arrive到场超时 repair维修超时 confirm确认超时 due_soon临近维保 overdue已超维保）',
  threshold_value   int(8)          not null                   comment '阈值',
  threshold_unit    varchar(10)     default 'minute'           comment '阈值单位（minute分钟 hour小时 day天）',
  notify_roles      varchar(100)    default ''                 comment '通知对象角色（多个用逗号分隔，如 property,worker）',
  enabled           char(1)         default '0'                comment '是否启用（0启用 1停用）',
  repeat_interval   int(8)          default 0                  comment '重复推送间隔（分钟），0表示同周期不重复推送',
  create_by         varchar(64)     default ''                 comment '创建者',
  create_time       datetime                                   comment '创建时间',
  update_by         varchar(64)     default ''                 comment '更新者',
  update_time       datetime                                   comment '更新时间',
  remark            varchar(500)    default null               comment '备注',
  primary key (rule_id)
) engine=innodb auto_increment=1 comment = '预警规则表';

-- ----------------------------
-- 16、预警信息表
-- ----------------------------
drop table if exists warning_info;
create table warning_info (
  warning_id        bigint(20)      not null auto_increment    comment '预警ID',
  rule_id           bigint(20)      default null               comment '触发规则ID',
  warning_type      varchar(30)     not null                   comment '预警类型（order_timeout工单超时 maintain_due维保临期）',
  biz_sub_type      varchar(30)     default ''                 comment '业务子类型',
  biz_id            bigint(20)      default null               comment '关联业务ID，指向工单或维保计划',
  biz_no            varchar(50)     default ''                 comment '关联业务编号',
  warning_content   varchar(500)    not null                   comment '预警内容',
  elevator_id       bigint(20)      default null               comment '关联电梯ID',
  receiver_id       bigint(20)      default null               comment '接收人ID',
  receiver_role     varchar(30)     default ''                 comment '接收人角色',
  is_read           char(1)         default '0'                comment '是否已读（0未读 1已读）',
  read_time         datetime                                   comment '阅读时间',
  warning_time      datetime                                   comment '预警生成时间',
  create_time       datetime                                   comment '创建时间',
  primary key (warning_id),
  key idx_warning_receiver (receiver_id, is_read),
  key idx_warning_biz (biz_id)
) engine=innodb auto_increment=1 comment = '预警信息表';

-- ----------------------------
-- 17、电梯健康评分表
-- ----------------------------
drop table if exists elevator_health;
create table elevator_health (
  health_id         bigint(20)      not null auto_increment    comment '健康记录ID',
  elevator_id       bigint(20)      not null                   comment '电梯ID',
  stat_period       varchar(20)     not null                   comment '统计周期（如 2026-10 或 2026-Q4）',
  stat_start_date   date                                       comment '统计开始日期',
  stat_end_date     date                                       comment '统计结束日期',
  fault_count       int(8)          default 0                  comment '统计周期内故障次数',
  fault_rate        decimal(6,2)    default 0.00               comment '故障率指标得分',
  fault_score       decimal(5,2)    default 0.00               comment '故障率得分',
  maintain_done     int(8)          default 0                  comment '应执行维保次数',
  maintain_finish   int(8)          default 0                  comment '实际执行维保次数',
  maintain_rate     decimal(6,2)    default 0.00               comment '维保完成率（百分比）',
  maintain_score    decimal(5,2)    default 0.00               comment '维保完成率得分',
  inspect_total     int(8)          default 0                  comment '巡检检查项总数',
  inspect_normal    int(8)          default 0                  comment '巡检正常项数',
  inspect_rate      decimal(6,2)    default 0.00               comment '巡检合格率（百分比）',
  inspect_score     decimal(5,2)    default 0.00               comment '巡检合格率得分',
  maintain_applicable tinyint(1)    default 1                  comment '维保完成率是否参与评分（0否 1是，统计周期内无维保计划时为0）',
  inspect_applicable  tinyint(1)    default 1                  comment '巡检合格率是否参与评分（0否 1是，统计周期内无已完成巡检记录时为0）',
  health_score      decimal(5,2)    default 0.00               comment '健康评分',
  health_level      varchar(20)     default ''                 comment '健康等级（excellent优秀 good良好 fair一般 poor较差 danger危险）',
  calc_time         datetime                                   comment '计算时间',
  primary key (health_id),
  key idx_health_elevator (elevator_id),
  key idx_health_period (stat_period)
) engine=innodb auto_increment=1 comment = '电梯健康评分表';

-- ----------------------------
-- 18、通知消息表
-- ----------------------------
drop table if exists elevator_notice;
create table elevator_notice (
  notice_id         bigint(20)      not null auto_increment    comment '消息ID',
  notice_type       varchar(30)     not null                   comment '消息类型（assign派单 accept接单 progress进度 warning预警 appeal申诉）',
  title             varchar(200)    not null                   comment '消息标题',
  content           varchar(500)    default ''                 comment '消息内容',
  biz_id            bigint(20)      default null               comment '关联业务ID',
  receiver_id       bigint(20)      not null                   comment '接收人ID',
  is_read           char(1)         default '0'                comment '是否已读（0未读 1已读）',
  read_time         datetime                                   comment '阅读时间',
  create_time       datetime                                   comment '创建时间',
  primary key (notice_id),
  key idx_notice_receiver (receiver_id, is_read)
) engine=innodb auto_increment=1 comment = '通知消息表';


-- ============================================================
-- 第 5 章  初始化数据
-- 内容：角色、菜单权限、字典、演示账号、业务基础数据、定时任务
-- 说明：本章可重复执行，各段会先清空再插入
-- ============================================================

-- ============================================================
-- 一、角色
-- ============================================================
-- 1  超级管理员 admin      （RuoYi 自带）
-- 3  物业    property
-- 4  维修员  worker
-- 5  业主    owner
delete from sys_role where role_id in (3, 4, 5);
insert into sys_role
  (role_id, role_name, role_key, role_sort, data_scope, menu_check_strictly, status, del_flag, create_by, create_time, update_by, update_time, remark)
values
  (3, '物业', 'property', 2, '1', 1, '0', '0', 'admin', sysdate(), '', null, '物业管理人员，负责审核报修单、派发工单、管理维保计划、查看统计报表'),
  (4, '维修员', 'worker', 3, '1', 1, '0', '0', 'admin', sysdate(), '', null, '维保单位人员，负责接单、反馈到场时间、记录维修过程、执行巡检任务'),
  (5, '业主', 'owner', 4, '5', 1, '0', '0', 'admin', sysdate(), '', null, '电梯使用者，负责提交故障报修、上传证据、查看报修进度、确认维修结果');

-- ============================================================
-- 二、菜单与权限
-- 一级目录 menu_id 2000-2004，二级菜单 2100 起，按钮 2200 起
-- ============================================================
delete from sys_menu where menu_id >= 2000;
delete from sys_role_menu where menu_id >= 2000;

-- ---------- 模块一 基础数据与权限管理 ----------
insert into sys_menu values('2000', '基础数据与权限管理', '0', '1', 'basic', null, '', '', 1, 0, 'M', '0', '0', '', 'peoples', 'admin', sysdate(), '', null, '模块一目录');
insert into sys_menu values('2102', '基础信息管理', '2000', '3', 'info', 'basic/info/index', '', '', 1, 0, 'C', '0', '0', 'basic:info:list', 'tree', 'admin', sysdate(), '', null, '基础信息管理菜单');

-- ---------- 模块二 故障报修与跟踪 ----------
insert into sys_menu values('2001', '故障报修与跟踪', '0', '2', 'repair', null, '', '', 1, 0, 'M', '0', '0', '', 'message', 'admin', sysdate(), '', null, '模块二目录');
insert into sys_menu values('2103', '故障一键报修', '2001', '1', 'order', 'repair/order/index', '', '', 1, 0, 'C', '0', '0', 'repair:order:list', 'form', 'admin', sysdate(), '', null, '故障一键报修菜单');
insert into sys_menu values('2104', '故障分级管理', '2001', '2', 'level', 'repair/level/index', '', '', 1, 0, 'C', '0', '0', 'repair:level:list', 'star', 'admin', sysdate(), '', null, '故障分级管理菜单');
insert into sys_menu values('2105', '多媒体证据上传', '2001', '3', 'evidence', 'repair/evidence/index', '', '', 1, 0, 'C', '0', '0', 'repair:evidence:list', 'upload', 'admin', sysdate(), '', null, '多媒体证据上传菜单');
insert into sys_menu values('2106', '报修进度跟踪', '2001', '4', 'track', 'repair/track/index', '', '', 1, 0, 'C', '0', '0', 'repair:track:list', 'time-range', 'admin', sysdate(), '', null, '报修进度跟踪菜单');

-- ---------- 模块三 工单调度与执行 ----------
insert into sys_menu values('2002', '工单调度与执行', '0', '3', 'order', null, '', '', 1, 0, 'M', '0', '0', '', 'job', 'admin', sysdate(), '', null, '模块三目录');
insert into sys_menu values('2107', '智能派单', '2002', '1', 'dispatch', 'order/dispatch/index', '', '', 1, 0, 'C', '0', '0', 'order:dispatch:list', 'guide', 'admin', sysdate(), '', null, '智能派单菜单');
insert into sys_menu values('2108', '维保人员接单', '2002', '2', 'accept', 'order/accept/index', '', '', 1, 0, 'C', '0', '0', 'order:accept:list', 'checkbox', 'admin', sysdate(), '', null, '维保人员接单菜单');
insert into sys_menu values('2109', '维修过程管理', '2002', '3', 'process', 'order/process/index', '', '', 1, 0, 'C', '0', '0', 'order:process:list', 'edit', 'admin', sysdate(), '', null, '维修过程管理菜单');
insert into sys_menu values('2110', '工单异常处理', '2002', '4', 'exception', 'order/exception/index', '', '', 1, 0, 'C', '0', '0', 'order:exception:list', 'bug', 'admin', sysdate(), '', null, '工单异常处理菜单');

-- ---------- 模块四 预防性维保 ----------
insert into sys_menu values('2003', '预防性维保', '0', '4', 'maintain', null, '', '', 1, 0, 'M', '0', '0', '', 'server', 'admin', sysdate(), '', null, '模块四目录');
insert into sys_menu values('2111', '维保计划管理', '2003', '1', 'plan', 'maintain/plan/index', '', '', 1, 0, 'C', '0', '0', 'maintain:plan:list', 'date', 'admin', sysdate(), '', null, '维保计划管理菜单');
insert into sys_menu values('2112', '定期巡检执行', '2003', '2', 'inspection', 'maintain/inspection/index', '', '', 1, 0, 'C', '0', '0', 'maintain:inspection:list', 'validCode', 'admin', sysdate(), '', null, '定期巡检执行菜单');
insert into sys_menu values('2113', '维保档案归档', '2003', '3', 'archive', 'maintain/archive/index', '', '', 1, 0, 'C', '0', '0', 'maintain:archive:list', 'documentation', 'admin', sysdate(), '', null, '维保档案归档菜单');

-- ---------- 模块五 数据分析与预警 ----------
insert into sys_menu values('2004', '数据分析与预警', '0', '5', 'analysis', null, '', '', 1, 0, 'M', '0', '0', '', 'chart', 'admin', sysdate(), '', null, '模块五目录');
insert into sys_menu values('2114', '故障频次统计', '2004', '1', 'frequency', 'analysis/frequency/index', '', '', 1, 0, 'C', '0', '0', 'analysis:frequency:list', 'chart', 'admin', sysdate(), '', null, '故障频次统计菜单');
insert into sys_menu values('2115', '超期预警监控', '2004', '2', 'warning', 'analysis/warning/index', '', '', 1, 0, 'C', '0', '0', 'analysis:warning:list', 'bell', 'admin', sysdate(), '', null, '超期预警监控菜单');
insert into sys_menu values('2116', '电梯健康档案生成', '2004', '3', 'health', 'analysis/health/index', '', '', 1, 0, 'C', '0', '0', 'analysis:health:list', 'monitor', 'admin', sysdate(), '', null, '电梯健康档案生成菜单');

-- ---------- 按钮权限 ----------
-- 模块一
insert into sys_menu values('2208', '小区楼栋电梯查询', '2102', '1', '', '', '', '', 1, 0, 'F', '0', '0', 'basic:info:query', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2209', '基础信息新增', '2102', '2', '', '', '', '', 1, 0, 'F', '0', '0', 'basic:info:add', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2210', '基础信息修改', '2102', '3', '', '', '', '', 1, 0, 'F', '0', '0', 'basic:info:edit', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2211', '基础信息删除', '2102', '4', '', '', '', '', 1, 0, 'F', '0', '0', 'basic:info:remove', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2212', '基础信息导出', '2102', '5', '', '', '', '', 1, 0, 'F', '0', '0', 'basic:info:export', '#', 'admin', sysdate(), '', null, '');

-- 模块二
insert into sys_menu values('2213', '报修单查询', '2103', '1', '', '', '', '', 1, 0, 'F', '0', '0', 'repair:order:query', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2214', '报修单驳回', '2103', '2', '', '', '', '', 1, 0, 'F', '0', '0', 'repair:order:reject', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2215', '报修单导出', '2103', '3', '', '', '', '', 1, 0, 'F', '0', '0', 'repair:order:export', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2216', '故障等级查询', '2104', '1', '', '', '', '', 1, 0, 'F', '0', '0', 'repair:level:query', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2217', '调整故障等级', '2104', '2', '', '', '', '', 1, 0, 'F', '0', '0', 'repair:order:changeLevel', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2218', '证据查询', '2105', '1', '', '', '', '', 1, 0, 'F', '0', '0', 'repair:evidence:query', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2219', '证据删除', '2105', '2', '', '', '', '', 1, 0, 'F', '0', '0', 'repair:evidence:remove', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2220', '进度查询', '2106', '1', '', '', '', '', 1, 0, 'F', '0', '0', 'repair:track:query', '#', 'admin', sysdate(), '', null, '');

-- 模块三
insert into sys_menu values('2221', '待派单查询', '2107', '1', '', '', '', '', 1, 0, 'F', '0', '0', 'order:dispatch:query', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2222', '执行派单', '2107', '2', '', '', '', '', 1, 0, 'F', '0', '0', 'order:dispatch:assign', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2223', '接单查询', '2108', '1', '', '', '', '', 1, 0, 'F', '0', '0', 'order:accept:query', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2224', '确认接单', '2108', '2', '', '', '', '', 1, 0, 'F', '0', '0', 'order:accept:confirm', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2225', '维修过程查询', '2109', '1', '', '', '', '', 1, 0, 'F', '0', '0', 'order:process:query', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2226', '推进维修状态', '2109', '2', '', '', '', '', 1, 0, 'F', '0', '0', 'order:process:edit', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2227', '异常工单查询', '2110', '1', '', '', '', '', 1, 0, 'F', '0', '0', 'order:exception:query', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2228', '异常工单处理', '2110', '2', '', '', '', '', 1, 0, 'F', '0', '0', 'order:exception:edit', '#', 'admin', sysdate(), '', null, '');

-- 模块四
insert into sys_menu values('2229', '维保计划查询', '2111', '1', '', '', '', '', 1, 0, 'F', '0', '0', 'maintain:plan:query', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2230', '维保计划新增', '2111', '2', '', '', '', '', 1, 0, 'F', '0', '0', 'maintain:plan:add', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2231', '维保计划修改', '2111', '3', '', '', '', '', 1, 0, 'F', '0', '0', 'maintain:plan:edit', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2232', '维保计划删除', '2111', '4', '', '', '', '', 1, 0, 'F', '0', '0', 'maintain:plan:remove', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2233', '巡检任务查询', '2112', '1', '', '', '', '', 1, 0, 'F', '0', '0', 'maintain:inspection:query', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2234', '巡检打卡执行', '2112', '2', '', '', '', '', 1, 0, 'F', '0', '0', 'maintain:inspection:execute', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2235', '巡检记录导出', '2112', '3', '', '', '', '', 1, 0, 'F', '0', '0', 'maintain:inspection:export', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2236', '维保档案查询', '2113', '1', '', '', '', '', 1, 0, 'F', '0', '0', 'maintain:archive:query', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2237', '维保档案导出', '2113', '2', '', '', '', '', 1, 0, 'F', '0', '0', 'maintain:archive:export', '#', 'admin', sysdate(), '', null, '');

-- 模块五
insert into sys_menu values('2238', '频次统计查询', '2114', '1', '', '', '', '', 1, 0, 'F', '0', '0', 'analysis:frequency:query', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2239', '频次统计导出', '2114', '2', '', '', '', '', 1, 0, 'F', '0', '0', 'analysis:frequency:export', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2240', '预警查询', '2115', '1', '', '', '', '', 1, 0, 'F', '0', '0', 'analysis:warning:query', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2241', '预警规则配置', '2115', '2', '', '', '', '', 1, 0, 'F', '0', '0', 'analysis:warning:rule', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2242', '健康档案查询', '2116', '1', '', '', '', '', 1, 0, 'F', '0', '0', 'analysis:health:query', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2243', '健康档案导出', '2116', '2', '', '', '', '', 1, 0, 'F', '0', '0', 'analysis:health:export', '#', 'admin', sysdate(), '', null, '');

-- ---------- 角色菜单授权 ----------
-- 超级管理员：全部菜单
insert into sys_role_menu select 1, menu_id from sys_menu where menu_id >= 2000;

-- 物业：全部业务菜单（用户与角色管理用若依自带的 /system 菜单，不在此模块内）
insert into sys_role_menu select 3, menu_id from sys_menu where menu_id >= 2000;

-- 维修员：接单、维修过程、巡检执行、报修进度查询
insert into sys_role_menu values(4, 2001),(4, 2002),(4, 2003),(4, 2106),(4, 2108),(4, 2109),(4, 2112),(4, 2220),(4, 2223),(4, 2224),(4, 2225),(4, 2226),(4, 2233),(4, 2234);

-- 业主：仅报修进度查询（业主主要使用用户端）
insert into sys_role_menu values(5, 2001),(5, 2106),(5, 2220);

-- ============================================================
-- 三、字典
-- ============================================================
delete from sys_dict_data where dict_type in ('repair_order_status','fault_level','fault_type','maintain_type','elevator_status','order_operation','health_level','warning_type');
delete from sys_dict_type where dict_type in ('repair_order_status','fault_level','fault_type','maintain_type','elevator_status','order_operation','health_level','warning_type');

insert into sys_dict_type values(100, '工单状态', 'repair_order_status', '0', 'admin', sysdate(), '', null, '报修工单状态列表');
insert into sys_dict_type values(101, '故障等级', 'fault_level', '0', 'admin', sysdate(), '', null, '故障等级列表');
insert into sys_dict_type values(102, '故障类型', 'fault_type', '0', 'admin', sysdate(), '', null, '故障现象类型列表');
insert into sys_dict_type values(103, '维保类型', 'maintain_type', '0', 'admin', sysdate(), '', null, '维保类型列表');
insert into sys_dict_type values(104, '电梯状态', 'elevator_status', '0', 'admin', sysdate(), '', null, '电梯状态列表');
insert into sys_dict_type values(105, '工单操作类型', 'order_operation', '0', 'admin', sysdate(), '', null, '工单状态流转操作类型');
insert into sys_dict_type values(106, '健康等级', 'health_level', '0', 'admin', sysdate(), '', null, '电梯健康等级列表');
insert into sys_dict_type values(107, '预警类型', 'warning_type', '0', 'admin', sysdate(), '', null, '预警类型列表');

insert into sys_dict_data values(100, 1, '待处理', 'pending', 'repair_order_status', '', 'warning', 'Y', '0', 'admin', sysdate(), '', null, '报修已提交，等待物业审核');
insert into sys_dict_data values(101, 2, '已派单', 'assigned', 'repair_order_status', '', 'primary', 'N', '0', 'admin', sysdate(), '', null, '物业已指派维修员');
insert into sys_dict_data values(102, 3, '已接单', 'accepted', 'repair_order_status', '', 'info', 'N', '0', 'admin', sysdate(), '', null, '维修员已确认接单');
insert into sys_dict_data values(103, 4, '已到场', 'arrived', 'repair_order_status', '', 'info', 'N', '0', 'admin', sysdate(), '', null, '维修员已到达现场');
insert into sys_dict_data values(104, 5, '维修中', 'repairing', 'repair_order_status', '', 'info', 'N', '0', 'admin', sysdate(), '', null, '正在排查与维修');
insert into sys_dict_data values(105, 6, '已修复', 'repaired', 'repair_order_status', '', 'success', 'N', '0', 'admin', sysdate(), '', null, '维修完成，等待业主确认');
insert into sys_dict_data values(106, 7, '已完成', 'confirmed', 'repair_order_status', '', 'success', 'N', '0', 'admin', sysdate(), '', null, '业主已确认，工单闭环');
insert into sys_dict_data values(107, 8, '已驳回', 'rejected', 'repair_order_status', '', 'danger', 'N', '0', 'admin', sysdate(), '', null, '物业驳回，待业主补充');
insert into sys_dict_data values(108, 9, '已申诉', 'appealed', 'repair_order_status', '', 'danger', 'N', '0', 'admin', sysdate(), '', null, '业主对结果不满意，转物业处理');

insert into sys_dict_data values(110, 1, '紧急', '0', 'fault_level', '', 'danger', 'N', '0', 'admin', sysdate(), '', null, '困人、停梯、溜梯等危及人身安全的情形');
insert into sys_dict_data values(111, 2, '一般', '1', 'fault_level', '', 'warning', 'N', '0', 'admin', sysdate(), '', null, '异响、按键失灵、照明故障等不影响安全的情形');

insert into sys_dict_data values(120, 1, '异响', 'abnormal_noise', 'fault_type', '', '', 'N', '0', 'admin', sysdate(), '', null, '');
insert into sys_dict_data values(121, 2, '停梯', 'stop', 'fault_type', '', '', 'N', '0', 'admin', sysdate(), '', null, '');
insert into sys_dict_data values(122, 3, '困人', 'trapped', 'fault_type', '', '', 'N', '0', 'admin', sysdate(), '', null, '');
insert into sys_dict_data values(123, 4, '门故障', 'door', 'fault_type', '', '', 'N', '0', 'admin', sysdate(), '', null, '');
insert into sys_dict_data values(124, 5, '按钮失灵', 'button', 'fault_type', '', '', 'N', '0', 'admin', sysdate(), '', null, '');
insert into sys_dict_data values(125, 6, '其他', 'other', 'fault_type', '', '', 'N', '0', 'admin', sysdate(), '', null, '');

insert into sys_dict_data values(130, 1, '半月保', 'half_month', 'maintain_type', '', '', 'N', '0', 'admin', sysdate(), '', null, '每15天一次');
insert into sys_dict_data values(131, 2, '季度检', 'quarter', 'maintain_type', '', '', 'N', '0', 'admin', sysdate(), '', null, '每90天一次');
insert into sys_dict_data values(132, 3, '半年保', 'half_year', 'maintain_type', '', '', 'N', '0', 'admin', sysdate(), '', null, '每180天一次');
insert into sys_dict_data values(133, 4, '年检', 'annual', 'maintain_type', '', '', 'N', '0', 'admin', sysdate(), '', null, '每365天一次');

insert into sys_dict_data values(140, 1, '正常运行', '0', 'elevator_status', '', 'success', 'N', '0', 'admin', sysdate(), '', null, '');
insert into sys_dict_data values(141, 2, '停梯检修', '1', 'elevator_status', '', 'warning', 'N', '0', 'admin', sysdate(), '', null, '');
insert into sys_dict_data values(142, 3, '已报废', '2', 'elevator_status', '', 'danger', 'N', '0', 'admin', sysdate(), '', null, '');

insert into sys_dict_data values(150, 1, '提交报修', 'report', 'order_operation', '', '', 'N', '0', 'admin', sysdate(), '', null, '');
insert into sys_dict_data values(151, 2, '驳回', 'reject', 'order_operation', '', '', 'N', '0', 'admin', sysdate(), '', null, '');
insert into sys_dict_data values(152, 3, '派单', 'assign', 'order_operation', '', '', 'N', '0', 'admin', sysdate(), '', null, '');
insert into sys_dict_data values(153, 4, '接单', 'accept', 'order_operation', '', '', 'N', '0', 'admin', sysdate(), '', null, '');
insert into sys_dict_data values(154, 5, '到场', 'arrive', 'order_operation', '', '', 'N', '0', 'admin', sysdate(), '', null, '');
insert into sys_dict_data values(155, 6, '排查', 'investigate', 'order_operation', '', '', 'N', '0', 'admin', sysdate(), '', null, '');
insert into sys_dict_data values(156, 7, '维修完成', 'finish', 'order_operation', '', '', 'N', '0', 'admin', sysdate(), '', null, '');
insert into sys_dict_data values(157, 8, '业主确认', 'confirm', 'order_operation', '', '', 'N', '0', 'admin', sysdate(), '', null, '');
insert into sys_dict_data values(158, 9, '申诉', 'appeal', 'order_operation', '', '', 'N', '0', 'admin', sysdate(), '', null, '');
insert into sys_dict_data values(159, 10, '重新指派', 'reassign', 'order_operation', '', '', 'N', '0', 'admin', sysdate(), '', null, '');
insert into sys_dict_data values(160, 11, '升级处理', 'escalate', 'order_operation', '', '', 'N', '0', 'admin', sysdate(), '', null, '');

insert into sys_dict_data values(170, 1, '优秀', 'excellent', 'health_level', '', 'success', 'N', '0', 'admin', sysdate(), '', null, '90分及以上');
insert into sys_dict_data values(171, 2, '良好', 'good', 'health_level', '', 'success', 'N', '0', 'admin', sysdate(), '', null, '80-89分');
insert into sys_dict_data values(172, 3, '一般', 'fair', 'health_level', '', 'warning', 'N', '0', 'admin', sysdate(), '', null, '70-79分');
insert into sys_dict_data values(173, 4, '较差', 'poor', 'health_level', '', 'warning', 'N', '0', 'admin', sysdate(), '', null, '60-69分');
insert into sys_dict_data values(174, 5, '危险', 'danger', 'health_level', '', 'danger', 'N', '0', 'admin', sysdate(), '', null, '60分以下');

insert into sys_dict_data values(180, 1, '工单超时', 'order_timeout', 'warning_type', '', 'warning', 'N', '0', 'admin', sysdate(), '', null, '');
insert into sys_dict_data values(181, 2, '维保临期', 'maintain_due', 'warning_type', '', 'warning', 'N', '0', 'admin', sysdate(), '', null, '');

-- ============================================================
-- 四、演示账号
-- 统一密码 admin123，BCrypt 加密存储
-- 采用显式列名插入，避免 sys_user 增列后按位置插入错位
-- community_id 为论文表3-1 要求的所属小区字段
-- ============================================================
delete from sys_user_role where user_id in (100, 101, 102, 103, 104);
delete from sys_user where user_id in (100, 101, 102, 103, 104);

insert into sys_user
  (user_id, community_id, user_name, nick_name, user_type, email, phonenumber, sex, avatar, password,
   status, del_flag, login_ip, login_date, pwd_update_date, create_by, create_time, remark)
values
  (100, 1, 'wuye01', '物业管理员', '00', 'wuye01@elevator.com', '13800000001', '1', '',
   '$2a$10$gyEgAsudVRZUUksP49d6geVDVNz6W5gWBdzlJ7ssKxdf07z1XwRIi',
   '0', '0', '127.0.0.1', sysdate(), sysdate(), 'admin', sysdate(), '阳光家园小区物业管理员');

insert into sys_user
  (user_id, community_id, user_name, nick_name, user_type, email, phonenumber, sex, avatar, password,
   status, del_flag, login_ip, login_date, pwd_update_date, create_by, create_time, remark)
values
  (101, 1, 'weixiu01', '维修员王师傅', '00', 'weixiu01@elevator.com', '13800000002', '1', '',
   '$2a$10$gyEgAsudVRZUUksP49d6geVDVNz6W5gWBdzlJ7ssKxdf07z1XwRIi',
   '0', '0', '127.0.0.1', sysdate(), sysdate(), 'admin', sysdate(), '黑龙江安捷电梯维保有限公司，负责阳光家园小区');

insert into sys_user
  (user_id, community_id, user_name, nick_name, user_type, email, phonenumber, sex, avatar, password,
   status, del_flag, login_ip, login_date, pwd_update_date, create_by, create_time, remark)
values
  (102, 1, 'yezhu01', '业主张阿姨', '00', 'yezhu01@elevator.com', '13800000003', '1', '',
   '$2a$10$gyEgAsudVRZUUksP49d6geVDVNz6W5gWBdzlJ7ssKxdf07z1XwRIi',
   '0', '0', '127.0.0.1', sysdate(), sysdate(), 'admin', sysdate(), '阳光家园小区1号楼1单元业主');

insert into sys_user
  (user_id, community_id, user_name, nick_name, user_type, email, phonenumber, sex, avatar, password,
   status, del_flag, login_ip, login_date, pwd_update_date, create_by, create_time, remark)
values
  (103, 2, 'weixiu02', '维修员李师傅', '00', 'weixiu02@elevator.com', '13800000004', '1', '',
   '$2a$10$gyEgAsudVRZUUksP49d6geVDVNz6W5gWBdzlJ7ssKxdf07z1XwRIi',
   '0', '0', '127.0.0.1', sysdate(), sysdate(), 'admin', sysdate(), '哈尔滨华信机电设备有限公司，负责和平里小区');

insert into sys_user
  (user_id, community_id, user_name, nick_name, user_type, email, phonenumber, sex, avatar, password,
   status, del_flag, login_ip, login_date, pwd_update_date, create_by, create_time, remark)
values
  (104, 3, 'weixiu03', '维修员赵师傅', '00', 'weixiu03@elevator.com', '13800000005', '1', '',
   '$2a$10$gyEgAsudVRZUUksP49d6geVDVNz6W5gWBdzlJ7ssKxdf07z1XwRIi',
   '0', '0', '127.0.0.1', sysdate(), sysdate(), 'admin', sysdate(), '黑龙江广日电梯工程有限公司，负责铁路新村小区');
insert into sys_user_role values(100, 3);
insert into sys_user_role values(101, 4);
insert into sys_user_role values(102, 5);
insert into sys_user_role values(103, 4);
insert into sys_user_role values(104, 4);

-- ============================================================
-- 五、业务基础数据（可重复执行，先清空）
-- ============================================================
delete from inspection_item_result;
delete from inspection_record;
delete from maintain_archive;
delete from maintain_plan;
delete from maintain_item;
delete from warning_info;
delete from warning_rule;
delete from elevator_health;
delete from elevator_notice;
delete from order_status_log;
delete from repair_record;
delete from repair_evidence;
delete from repair_order;
delete from worker_skill;
delete from sys_file;
delete from elevator;
delete from building;
delete from community;

-- ---------- 小区 ----------
insert into community values(1, '阳光家园小区', '哈尔滨市南岗区学府路128号', '2003', '张建国', '0451-86001122', '0', '0', 'admin', sysdate(), '', null, '典型老旧小区，无电梯加装于2021年');
insert into community values(2, '和平里小区', '哈尔滨市道里区和平路56号', '1998', '李秀兰', '0451-86003344', '0', '0', 'admin', sysdate(), '', null, '老旧小区，老年居民占比高');
insert into community values(3, '铁路新村小区', '哈尔滨市香坊区红旗大街211号', '2001', '王海涛', '0451-86005566', '0', '0', 'admin', sysdate(), '', null, '原铁路系统职工住宅');

-- ---------- 楼栋 ----------
insert into building values(1, 1, '1号楼', '1单元', 7, '0', '0', 'admin', sysdate(), '', null, null);
insert into building values(2, 1, '1号楼', '2单元', 7, '0', '0', 'admin', sysdate(), '', null, null);
insert into building values(3, 1, '2号楼', '1单元', 6, '0', '0', 'admin', sysdate(), '', null, null);
insert into building values(4, 2, '3号楼', '1单元', 6, '0', '0', 'admin', sysdate(), '', null, null);
insert into building values(5, 2, '4号楼', '1单元', 8, '0', '0', 'admin', sysdate(), '', null, null);
insert into building values(6, 3, 'A座', '1单元', 11, '0', '0', 'admin', sysdate(), '', null, null);

-- ---------- 电梯 ----------
insert into elevator values(1, 'DT-A-001', '日立', 'HGE-1000', 1, '1单元', '黑龙江安捷电梯维保有限公司', '2010-06-01', 15, null, '0', '0', 'admin', sysdate(), '', null, '运行平稳，钢丝绳有轻微磨损');
insert into elevator values(2, 'DT-A-002', '日立', 'HGE-1000', 2, '2单元', '黑龙江安捷电梯维保有限公司', '2010-06-01', 15, null, '0', '0', 'admin', sysdate(), '', null, '门系统偶有异响');
insert into elevator values(3, 'DT-B-001', '三菱', 'LEHY-III', 3, '1单元', '哈尔滨华信机电设备有限公司', '2012-09-15', 13, null, '0', '0', 'admin', sysdate(), '', null, '');
insert into elevator values(4, 'DT-C-001', '通力', 'KONE-3000', 4, '1单元', '哈尔滨华信机电设备有限公司', '2008-03-20', 18, null, '1', '0', 'admin', sysdate(), '', null, '使用年限长，已停梯待大修');
insert into elevator values(5, 'DT-C-002', '奥的斯', 'OTIS-3200', 5, '1单元', '黑龙江安捷电梯维保有限公司', '2015-11-08', 10, null, '0', '0', 'admin', sysdate(), '', null, '');
insert into elevator values(6, 'DT-D-001', '迅达', 'Schindler-3300', 6, '1单元', '黑龙江广日电梯工程有限公司', '2006-05-12', 20, null, '0', '0', 'admin', sysdate(), '', null, '老旧电梯，故障率偏高，重点监控');

-- ---------- 维修员技能与区域 ----------
insert into worker_skill values(1, 101, 1, '曳引机,门系统,控制系统', '0', 0, 0, 0, 'admin', sysdate(), '', null);
insert into worker_skill values(2, 103, 2, '门系统,轿厢,安全装置', '0', 0, 0, 0, 'admin', sysdate(), '', null);
insert into worker_skill values(3, 104, 3, '控制系统,曳引机,电气', '0', 0, 0, 0, 'admin', sysdate(), '', null);

-- ---------- 维保检查项模板 ----------
insert into maintain_item values(1, '半月保标准模板', 'half_month', '曳引机运行状态检查', 'traction', '运行平稳无异响，无异常振动', 1, '0', 'admin', sysdate(), '', null);
insert into maintain_item values(2, '半月保标准模板', 'half_month', '钢丝绳磨损与断丝检查', 'traction', '断丝数不超过标准要求，无锈蚀', 2, '0', 'admin', sysdate(), '', null);
insert into maintain_item values(3, '半月保标准模板', 'half_month', '层门与轿门开合检查', 'door_system', '开合顺畅，无卡阻，闭合到位', 3, '0', 'admin', sysdate(), '', null);
insert into maintain_item values(4, '半月保标准模板', 'half_month', '门锁电气触点检查', 'door_system', '触点接触良好，无烧蚀', 4, '0', 'admin', sysdate(), '', null);
insert into maintain_item values(5, '半月保标准模板', 'half_month', '限速器与安全钳检查', 'safety', '动作可靠，无卡阻', 5, '0', 'admin', sysdate(), '', null);
insert into maintain_item values(6, '半月保标准模板', 'half_month', '制动器动作检查', 'safety', '制动可靠，间隙符合要求', 6, '0', 'admin', sysdate(), '', null);
insert into maintain_item values(7, '半月保标准模板', 'half_month', '控制柜运行状态检查', 'control', '无异味，接触器动作正常', 7, '0', 'admin', sysdate(), '', null);
insert into maintain_item values(8, '半月保标准模板', 'half_month', '轿厢照明与通风检查', 'car', '照明正常，通风良好', 8, '0', 'admin', sysdate(), '', null);
insert into maintain_item values(9, '半月保标准模板', 'half_month', '报警装置与对讲检查', 'car', '报警按钮有效，对讲清晰', 9, '0', 'admin', sysdate(), '', null);
insert into maintain_item values(10, '半月保标准模板', 'half_month', '轿厢内应急照明检查', 'car', '断电后应急照明自动点亮', 10, '0', 'admin', sysdate(), '', null);

insert into maintain_item values(11, '季度检标准模板', 'quarter', '曳引机减速箱油质检查', 'traction', '油位正常，无乳化变质', 1, '0', 'admin', sysdate(), '', null);
insert into maintain_item values(12, '季度检标准模板', 'quarter', '钢丝绳张力均衡检查', 'traction', '各绳张力偏差不超过5%', 2, '0', 'admin', sysdate(), '', null);
insert into maintain_item values(13, '季度检标准模板', 'quarter', '导轨与导靴磨损检查', 'traction', '导靴磨损量在允许范围内', 3, '0', 'admin', sysdate(), '', null);
insert into maintain_item values(14, '季度检标准模板', 'quarter', '平层准确度检查', 'control', '平层误差不超过正负5毫米', 4, '0', 'admin', sysdate(), '', null);
insert into maintain_item values(15, '季度检标准模板', 'quarter', '超载装置动作检查', 'safety', '超载报警与保护动作可靠', 5, '0', 'admin', sysdate(), '', null);
insert into maintain_item values(16, '季度检标准模板', 'quarter', '接地保护与绝缘检查', 'control', '接地良好，绝缘电阻符合标准', 6, '0', 'admin', sysdate(), '', null);
insert into maintain_item values(17, '季度检标准模板', 'quarter', '井道照明与底坑检查', 'other', '照明正常，底坑无积水杂物', 7, '0', 'admin', sysdate(), '', null);
insert into maintain_item values(18, '季度检标准模板', 'quarter', '补偿链与随行电缆检查', 'other', '无破损，固定牢靠', 8, '0', 'admin', sysdate(), '', null);

-- ---------- 预警规则 ----------
insert into warning_rule values(1, '派单超时预警', 'order_timeout', 'assign', 30, 'minute', 'property', '0', 0, 'admin', sysdate(), '', null, '工单报修后30分钟未派单');
insert into warning_rule values(2, '接单超时预警', 'order_timeout', 'accept', 30, 'minute', 'worker,property', '0', 0, 'admin', sysdate(), '', null, '派单后30分钟未接单');
insert into warning_rule values(3, '到场超时预警', 'order_timeout', 'arrive', 120, 'minute', 'worker,property', '0', 0, 'admin', sysdate(), '', null, '接单后2小时未到场');
insert into warning_rule values(4, '维修超时预警', 'order_timeout', 'repair', 24, 'hour', 'worker,property', '0', 0, 'admin', sysdate(), '', null, '到场后24小时未完成维修');
insert into warning_rule values(5, '维保临期预警', 'maintain_due', 'due_soon', 3, 'day', 'property,worker', '0', 0, 'admin', sysdate(), '', null, '距离计划维保日期不足3天');
insert into warning_rule values(6, '维保超期预警', 'maintain_due', 'overdue', 0, 'day', 'property,worker', '0', 0, 'admin', sysdate(), '', null, '已超过计划维保日期未执行');

-- ---------- 维保计划 ----------
-- 依据电梯实际状况差异化配置，使健康评分的维保完成率有区分度：
--   1、2、5 号电梯按半月保周期正常执行，完成率为 100%
--   3 号电梯有 1 次未执行，6 号电梯老旧且故障率高，漏保较多
--   4 号电梯已停梯待大修，维保基本停滞
insert into maintain_plan values(1, '1号楼1单元半月保', 1, 'half_month', 15, '半月保标准模板',
  '2026-07-01', '2027-06-30', '2026-10-16', '2026-10-01', 100, '0', 6, 6, '0', 'admin', sysdate(), '', null, '业主反馈运行平稳，按周期正常维保');
insert into maintain_plan values(2, '1号楼2单元半月保', 2, 'half_month', 15, '半月保标准模板',
  '2026-07-01', '2027-06-30', '2026-10-16', '2026-10-01', 100, '0', 6, 6, '0', 'admin', sysdate(), '', null, '门系统有异响，维保时重点关注');
insert into maintain_plan values(3, '2号楼1单元半月保', 3, 'half_month', 15, '半月保标准模板',
  '2026-07-01', '2027-06-30', '2026-10-16', '2026-09-16', 100, '0', 6, 5, '0', 'admin', sysdate(), '', null, '有一次因配件到货延迟未按期执行，已补做');
insert into maintain_plan values(4, '3号楼1单元半月保', 4, 'half_month', 15, '半月保标准模板',
  '2026-07-01', '2027-06-30', '2026-07-16', '2026-08-01', 100, '0', 6, 2, '0', 'admin', sysdate(), '', null, '已停梯待大修，维保暂停，待大修完成恢复');
insert into maintain_plan values(5, '4号楼1单元半月保', 5, 'half_month', 15, '半月保标准模板',
  '2026-07-01', '2027-06-30', '2026-10-16', '2026-10-01', 100, '0', 6, 6, '0', 'admin', sysdate(), '', null, '投用年限较短，运行状况良好');
insert into maintain_plan values(6, 'A座1单元半月保', 6, 'half_month', 7, '半月保标准模板',
  '2026-07-01', '2027-06-30', '2026-10-09', '2026-09-11', 100, '0', 12, 6, '0', 'admin', sysdate(), '', null, '老旧电梯故障率高，已缩短维保周期，但仍多次漏保');

insert into maintain_plan values(7, '1号楼1单元季度检', 1, 'quarter', 90, '季度检标准模板',
  '2026-07-01', '2027-06-30', '2026-10-01', '2026-07-01', 100, '0', 2, 2, '0', 'admin', sysdate(), '', null, '季度检正常执行');
insert into maintain_plan values(8, '1号楼2单元季度检', 2, 'quarter', 90, '季度检标准模板',
  '2026-07-01', '2027-06-30', '2026-10-01', '2026-07-01', 100, '0', 2, 2, '0', 'admin', sysdate(), '', null, '季度检正常执行');
insert into maintain_plan values(9, '2号楼1单元季度检', 3, 'quarter', 90, '季度检标准模板',
  '2026-07-01', '2027-06-30', '2026-10-01', '2026-07-01', 100, '0', 2, 2, '0', 'admin', sysdate(), '', null, '季度检正常执行');
insert into maintain_plan values(10, '4号楼1单元季度检', 5, 'quarter', 90, '季度检标准模板',
  '2026-07-01', '2027-06-30', '2026-10-01', '2026-07-01', 100, '0', 2, 2, '0', 'admin', sysdate(), '', null, '季度检正常执行');

-- ---------- 巡检记录 ----------
-- 只种已完成（record_status='finished'）的记录，健康评分的巡检合格率只统计已完成记录。
-- 计划日期均落在近 90 天统计周期内。
-- 记录 1：1 号楼 1 单元，4 次半月保 + 1 次季度检，检查项 50 项，异常 2 项
insert into inspection_record values(1, 'XJ20260716100001', 1, 1, 'half_month', '2026-07-16', 101, '2026-07-16 09:12:00', '阳光家园小区1号楼1单元电梯机房', '2026-07-16', 'normal', '', 10, 0, 0, 'finished', '0', 'admin', sysdate(), '', null);
insert into inspection_record values(2, 'XJ20260801090002', 1, 1, 'half_month', '2026-08-01', 101, '2026-08-01 09:05:00', '阳光家园小区1号楼1单元电梯机房', '2026-08-01', 'normal', '', 10, 0, 0, 'finished', '0', 'admin', sysdate(), '', null);
insert into inspection_record values(3, 'XJ20260816091003', 1, 1, 'half_month', '2026-08-16', 101, '2026-08-16 09:20:00', '阳光家园小区1号楼1单元电梯机房', '2026-08-16', 'abnormal', '钢丝绳有轻微磨损，未达换绳标准，已记录观察', 9, 1, 0, 'finished', '0', 'admin', sysdate(), '', null);
insert into inspection_record values(4, 'XJ20260901090504', 1, 1, 'half_month', '2026-09-01', 101, '2026-09-01 09:02:00', '阳光家园小区1号楼1单元电梯机房', '2026-09-01', 'normal', '', 10, 0, 0, 'finished', '0', 'admin', sysdate(), '', null);
insert into inspection_record values(5, 'XJ20260916091505', 1, 1, 'quarter', '2026-09-16', 101, '2026-09-16 09:35:00', '阳光家园小区1号楼1单元电梯机房', '2026-09-16', 'abnormal', '轿厢内应急照明电池电量偏低，已更换', 9, 1, 0, 'finished', '0', 'admin', sysdate(), '', null);

-- 记录 2：1 号楼 2 单元，门系统异响，异常项较多，检查项 50 项，异常 5 项
insert into inspection_record values(6, 'XJ20260716103006', 2, 2, 'half_month', '2026-07-16', 101, '2026-07-16 10:30:00', '阳光家园小区1号楼2单元电梯机房', '2026-07-16', 'abnormal', '层门开合有卡阻，已调整门机', 9, 1, 0, 'finished', '0', 'admin', sysdate(), '', null);
insert into inspection_record values(7, 'XJ20260801102007', 2, 2, 'half_month', '2026-08-01', 101, '2026-08-01 10:22:00', '阳光家园小区1号楼2单元电梯机房', '2026-08-01', 'abnormal', '门锁电气触点有轻微烧蚀，已打磨处理', 9, 1, 0, 'finished', '0', 'admin', sysdate(), '', null);
insert into inspection_record values(8, 'XJ20260816104508', 2, 2, 'half_month', '2026-08-16', 101, '2026-08-16 10:45:00', '阳光家园小区1号楼2单元电梯机房', '2026-08-16', 'abnormal', '层门闭合到位但仍有异响', 9, 1, 0, 'finished', '0', 'admin', sysdate(), '', null);
insert into inspection_record values(9, 'XJ20260901103209', 2, 2, 'half_month', '2026-09-01', 101, '2026-09-01 10:32:00', '阳光家园小区1号楼2单元电梯机房', '2026-09-01', 'abnormal', '门机皮带磨损，建议下次维保更换', 9, 1, 0, 'finished', '0', 'admin', sysdate(), '', null);
insert into inspection_record values(10, 'XJ20260916110010', 2, 2, 'quarter', '2026-09-16', 101, '2026-09-16 11:00:00', '阳光家园小区1号楼2单元电梯机房', '2026-09-16', 'abnormal', '平层准确度偏差接近上限，已重新校准', 9, 1, 0, 'finished', '0', 'admin', sysdate(), '', null);

-- 记录 3：2 号楼 1 单元，检查项 40 项，异常 2 项
insert into inspection_record values(11, 'XJ20260720140011', 3, 3, 'half_month', '2026-07-20', 103, '2026-07-20 14:10:00', '阳光家园小区2号楼1单元电梯机房', '2026-07-20', 'normal', '', 10, 0, 0, 'finished', '0', 'admin', sysdate(), '', null);
insert into inspection_record values(12, 'XJ20260805141012', 3, 3, 'half_month', '2026-08-05', 103, '2026-08-05 14:12:00', '阳光家园小区2号楼1单元电梯机房', '2026-08-05', 'normal', '', 10, 0, 0, 'finished', '0', 'admin', sysdate(), '', null);
insert into inspection_record values(13, 'XJ20260820142013', 3, 3, 'half_month', '2026-08-20', 103, '2026-08-20 14:20:00', '阳光家园小区2号楼1单元电梯机房', '2026-08-20', 'abnormal', '控制柜接触器动作有轻微异响', 9, 1, 0, 'finished', '0', 'admin', sysdate(), '', null);
insert into inspection_record values(14, 'XJ20260920143014', 3, 3, 'quarter', '2026-09-20', 103, '2026-09-20 14:30:00', '阳光家园小区2号楼1单元电梯机房', '2026-09-20', 'abnormal', '底坑有少量积水，已清理并疏通排水', 9, 1, 0, 'finished', '0', 'admin', sysdate(), '', null);

-- 记录 4：3 号楼 1 单元，已停梯待大修，仅 2 次记录，检查项 20 项，异常 6 项
insert into inspection_record values(15, 'XJ20260710150015', 4, 4, 'half_month', '2026-07-10', 103, '2026-07-10 15:05:00', '和平里小区3号楼1单元电梯机房', '2026-07-10', 'abnormal', '曳引机减速箱油质乳化，钢丝绳锈蚀，已上报大修', 7, 3, 0, 'finished', '0', 'admin', sysdate(), '', null);
insert into inspection_record values(16, 'XJ20260725151016', 4, 4, 'half_month', '2026-07-25', 103, '2026-07-25 15:10:00', '和平里小区3号楼1单元电梯机房', '2026-07-25', 'abnormal', '制动器间隙超标，限速器动作不灵活，已停梯', 7, 3, 0, 'finished', '0', 'admin', sysdate(), '', null);

-- 记录 5：4 号楼 1 单元，投用年限较短，检查项 60 项，异常 0 项
insert into inspection_record values(17, 'XJ20260715160017', 5, 5, 'half_month', '2026-07-15', 104, '2026-07-15 16:00:00', '和平里小区4号楼1单元电梯机房', '2026-07-15', 'normal', '', 10, 0, 0, 'finished', '0', 'admin', sysdate(), '', null);
insert into inspection_record values(18, 'XJ20260730160518', 5, 5, 'half_month', '2026-07-30', 104, '2026-07-30 16:05:00', '和平里小区4号楼1单元电梯机房', '2026-07-30', 'normal', '', 10, 0, 0, 'finished', '0', 'admin', sysdate(), '', null);
insert into inspection_record values(19, 'XJ20260814161019', 5, 5, 'half_month', '2026-08-14', 104, '2026-08-14 16:10:00', '和平里小区4号楼1单元电梯机房', '2026-08-14', 'normal', '', 10, 0, 0, 'finished', '0', 'admin', sysdate(), '', null);
insert into inspection_record values(20, 'XJ20260829161520', 5, 5, 'half_month', '2026-08-29', 104, '2026-08-29 16:15:00', '和平里小区4号楼1单元电梯机房', '2026-08-29', 'normal', '', 10, 0, 0, 'finished', '0', 'admin', sysdate(), '', null);
insert into inspection_record values(21, 'XJ20260913162021', 5, 5, 'half_month', '2026-09-13', 104, '2026-09-13 16:20:00', '和平里小区4号楼1单元电梯机房', '2026-09-13', 'normal', '', 10, 0, 0, 'finished', '0', 'admin', sysdate(), '', null);
insert into inspection_record values(22, 'XJ20260928162522', 5, 5, 'quarter', '2026-09-28', 104, '2026-09-28 16:25:00', '和平里小区4号楼1单元电梯机房', '2026-09-28', 'normal', '', 10, 0, 0, 'finished', '0', 'admin', sysdate(), '', null);

-- 记录 6：A 座 1 单元，老旧且故障率高，检查项 80 项，异常 16 项
insert into inspection_record values(23, 'XJ20260708170023', 6, 6, 'half_month', '2026-07-08', 104, '2026-07-08 17:00:00', '铁路新村小区A座1单元电梯机房', '2026-07-08', 'abnormal', '曳引机运行振动偏大，钢丝绳断丝 3 根', 8, 2, 0, 'finished', '0', 'admin', sysdate(), '', null);
insert into inspection_record values(24, 'XJ20260722170524', 6, 6, 'half_month', '2026-07-22', 104, '2026-07-22 17:05:00', '铁路新村小区A座1单元电梯机房', '2026-07-22', 'abnormal', '制动器动作迟缓，平层偏差超标', 8, 2, 0, 'finished', '0', 'admin', sysdate(), '', null);
insert into inspection_record values(25, 'XJ20260805171025', 6, 6, 'half_month', '2026-08-05', 104, '2026-08-05 17:10:00', '铁路新村小区A座1单元电梯机房', '2026-08-05', 'abnormal', '层门卡阻，门锁触点烧蚀，已临时处理', 8, 2, 0, 'finished', '0', 'admin', sysdate(), '', null);
insert into inspection_record values(26, 'XJ20260819171526', 6, 6, 'half_month', '2026-08-19', 104, '2026-08-19 17:15:00', '铁路新村小区A座1单元电梯机房', '2026-08-19', 'abnormal', '控制柜接触器频繁动作，触点磨损明显', 8, 2, 0, 'finished', '0', 'admin', sysdate(), '', null);
insert into inspection_record values(27, 'XJ20260902172027', 6, 6, 'half_month', '2026-09-02', 104, '2026-09-02 17:20:00', '铁路新村小区A座1单元电梯机房', '2026-09-02', 'abnormal', '导轨润滑不足，导靴磨损量接近上限', 8, 2, 0, 'finished', '0', 'admin', sysdate(), '', null);
insert into inspection_record values(28, 'XJ20260916172528', 6, 6, 'quarter', '2026-09-16', 104, '2026-09-16 17:25:00', '铁路新村小区A座1单元电梯机房', '2026-09-16', 'abnormal', '补偿链磨损，随行电缆保护层破损', 8, 2, 0, 'finished', '0', 'admin', sysdate(), '', null);

-- ---------- 故障工单 ----------
-- 健康评分的故障率统计周期为近 90 天，按 report_time 过滤，故报修时间均落在 2026-07 之后。
-- 1、5 号电梯本周期无故障；2 号 2 次一般故障；3 号 1 次一般故障；
-- 4 号 4 次（含 2 次紧急）；6 号 5 次（含 3 次紧急）。故障等级：0 紧急、1 一般。
insert into repair_order values(1, 'BX20260722101501', 102, 6, '电梯运行中突然停梯，轿厢困人，需紧急救援', 'stop', '0', 'confirmed',
  '13800000003', '2026-07-22 10:15:00', '2026-07-22 10:22:00', '2026-07-22 10:25:00', '2026-07-22 10:48:00', '2026-07-22 12:30:00', '2026-07-22 14:00:00',
  104, 100, null, '2026-07-22 10:35:00', '0', 'admin', sysdate(), '', null, '困人事故，紧急救援后恢复运行');
insert into repair_order values(2, 'BX20260803142002', 102, 6, '电梯门关不上，反复开合', 'door', '1', 'confirmed',
  '13800000003', '2026-08-03 14:20:00', '2026-08-03 14:40:00', '2026-08-03 14:45:00', '2026-08-03 15:30:00', '2026-08-03 17:00:00', '2026-08-03 18:00:00',
  104, 100, null, '2026-08-03 15:00:00', '0', 'admin', sysdate(), '', null, '层门卡阻，调整后恢复');
insert into repair_order values(3, 'BX20260818093003', 102, 6, '电梯运行时异响明显，轿厢晃动', 'noise', '1', 'confirmed',
  '13800000003', '2026-08-18 09:30:00', '2026-08-18 09:50:00', '2026-08-18 10:00:00', '2026-08-18 11:20:00', '2026-08-18 15:00:00', '2026-08-18 16:00:00',
  104, 100, null, '2026-08-18 10:10:00', '0', 'admin', sysdate(), '', null, '导靴磨损，更换后异响消除');
insert into repair_order values(4, 'BX20260905161004', 102, 6, '电梯急停后无法再启动，楼层显示异常', 'stop', '0', 'confirmed',
  '13800000003', '2026-09-05 16:10:00', '2026-09-05 16:18:00', '2026-09-05 16:20:00', '2026-09-05 16:50:00', '2026-09-05 21:00:00', '2026-09-06 09:00:00',
  104, 100, null, '2026-09-05 16:30:00', '0', 'admin', sysdate(), '', null, '控制柜接触器故障，更换接触器');
insert into repair_order values(5, 'BX20260922110505', 102, 6, '电梯溜梯，轿厢下坠半层后停住', 'slip', '0', 'repaired',
  '13800000003', '2026-09-22 11:05:00', '2026-09-22 11:12:00', '2026-09-22 11:15:00', '2026-09-22 11:40:00', '2026-09-22 18:00:00', null,
  104, 100, null, '2026-09-22 11:25:00', '0', 'admin', sysdate(), '', null, '制动器间隙超标，已调整，待业主确认');

insert into repair_order values(6, 'BX20260712103006', 102, 4, '电梯运行中突然停梯，乘客被困', 'stop', '0', 'confirmed',
  '13800000003', '2026-07-12 10:30:00', '2026-07-12 10:36:00', '2026-07-12 10:40:00', '2026-07-12 11:05:00', '2026-07-12 13:00:00', '2026-07-12 15:00:00',
  103, 100, null, '2026-07-12 10:50:00', '0', 'admin', sysdate(), '', null, '钢丝绳锈蚀卡阻，已停梯');
insert into repair_order values(7, 'BX20260724150007', 102, 4, '电梯门无法关闭，多次反复', 'door', '1', 'confirmed',
  '13800000003', '2026-07-24 15:00:00', '2026-07-24 15:20:00', '2026-07-24 15:25:00', '2026-07-24 16:10:00', '2026-07-24 18:00:00', '2026-07-25 09:00:00',
  103, 100, null, '2026-07-24 15:40:00', '0', 'admin', sysdate(), '', null, '门锁触点烧蚀，更换后恢复');
insert into repair_order values(8, 'BX20260811101508', 102, 4, '电梯制动时异响，停层不准', 'noise', '1', 'confirmed',
  '13800000003', '2026-08-11 10:15:00', '2026-08-11 10:30:00', '2026-08-11 10:35:00', '2026-08-11 11:30:00', '2026-08-11 16:00:00', '2026-08-12 09:00:00',
  103, 100, null, '2026-08-11 10:45:00', '0', 'admin', sysdate(), '', null, '制动器间隙超标，已调整');
insert into repair_order values(9, 'BX20260915142009', 102, 4, '电梯困人，轿厢停在两层之间', 'stop', '0', 'confirmed',
  '13800000003', '2026-09-15 14:20:00', '2026-09-15 14:26:00', '2026-09-15 14:30:00', '2026-09-15 15:00:00', '2026-09-15 17:30:00', '2026-09-16 09:00:00',
  103, 100, null, '2026-09-15 14:40:00', '0', 'admin', sysdate(), '', null, '限速器动作异常，已检修，电梯停用待大修');

insert into repair_order values(10, 'BX20260826103010', 102, 2, '电梯门开合时有异响', 'noise', '1', 'confirmed',
  '13800000003', '2026-08-26 10:30:00', '2026-08-26 10:50:00', '2026-08-26 11:00:00', '2026-08-26 11:40:00', '2026-08-26 14:00:00', '2026-08-26 16:00:00',
  101, 100, null, '2026-08-26 11:10:00', '0', 'admin', sysdate(), '', null, '层门滑道缺油，润滑后异响减轻');
insert into repair_order values(11, 'BX20260919153011', 102, 2, '电梯按钮失灵，按了没反应', 'button', '1', 'confirmed',
  '13800000003', '2026-09-19 15:30:00', '2026-09-19 15:45:00', '2026-09-19 15:50:00', '2026-09-19 16:30:00', '2026-09-19 18:00:00', '2026-09-20 09:00:00',
  101, 100, null, '2026-09-19 16:00:00', '0', 'admin', sysdate(), '', null, '按钮触点氧化，更换按钮');

insert into repair_order values(12, 'BX20260908110012', 102, 3, '电梯运行中有轻微异响', 'noise', '1', 'confirmed',
  '13800000003', '2026-09-08 11:00:00', '2026-09-08 11:20:00', '2026-09-08 11:30:00', '2026-09-08 14:00:00', '2026-09-08 16:00:00', '2026-09-09 09:00:00',
  103, 100, null, '2026-09-08 11:40:00', '0', 'admin', sysdate(), '', null, '控制柜接触器异响，已更换');


-- ============================================================
-- 六、定时任务
-- 论文要求：系统按周期自动生成巡检工单并派发、工单超时自动触发提醒、健康评分定时重算
-- cron 为 Quartz 格式，RuoYi 启动时由 sys_job 表装载
-- ============================================================
delete from sys_job where invoke_target in
  ('inspectionGenerateTask.execute()', 'warningScanTask.execute()', 'healthScoreTask.execute()');

insert into sys_job
  (job_name, job_group, invoke_target, cron_expression, misfire_policy, concurrent, status, create_by, create_time, remark)
values
  ('巡检工单自动生成', 'DEFAULT', 'inspectionGenerateTask.execute()', '0 0 1 * * ?', '3', '1', '0', 'admin', sysdate(), '每日 01:00 扫描到期维保计划，自动生成巡检工单并标记超期任务'),
  ('超期预警扫描', 'DEFAULT', 'warningScanTask.execute()', '0 0/30 * * * ?', '3', '1', '0', 'admin', sysdate(), '每 30 分钟扫描工单超时与维保临期，按启用规则生成预警并推送'),
  ('电梯健康评分重算', 'DEFAULT', 'healthScoreTask.execute()', '0 0 2 * * ?', '3', '1', '0', 'admin', sysdate(), '每日 02:00 按统计周期重算全部电梯的健康评分');

