package com.ruoyi.elevator.service;

import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.elevator.domain.Elevator;
import com.ruoyi.elevator.domain.RepairEvidence;
import com.ruoyi.elevator.domain.RepairOrder;
import com.ruoyi.elevator.domain.RepairRecord;
import com.ruoyi.elevator.exception.ElevatorErrorCode;
import com.ruoyi.elevator.exception.ElevatorException;
import com.ruoyi.elevator.mapper.ElevatorMapper;
import com.ruoyi.elevator.mapper.RepairEvidenceMapper;
import com.ruoyi.elevator.mapper.RepairOrderMapper;
import com.ruoyi.elevator.mapper.RepairRecordMapper;
import com.ruoyi.elevator.util.LoginUserUtil;
import com.ruoyi.elevator.util.OrderStatusUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Calendar;
import java.util.Date;
import java.util.List;

/**
 * 报修工单服务
 * 覆盖论文模块二的故障一键报修、多媒体证据上传、报修进度跟踪，以及模块三的派单与维修过程
 *
 * @author 董泽晟
 */
@Service
public class RepairOrderService
{
    /** 默认处理时限：报修后 24 小时 */
    private static final int DEFAULT_DEADLINE_HOURS = 24;

    @Autowired
    private RepairOrderMapper repairOrderMapper;

    @Autowired
    private RepairEvidenceMapper repairEvidenceMapper;

    @Autowired
    private RepairRecordMapper repairRecordMapper;

    @Autowired
    private ElevatorMapper elevatorMapper;

    @Autowired
    private OrderStatusLogService orderStatusLogService;

    @Autowired
    private NoticeService noticeService;

    // ==================== 查询 ====================

    /**
     * 查询工单列表，按当前登录角色做数据范围过滤
     * 业主只能看本人的报修，维修员只能看指派给本人的工单，物业与管理员可看全部
     */
    public List<RepairOrder> selectRepairOrderList(RepairOrder repairOrder)
    {
        applyDataScope(repairOrder);
        return repairOrderMapper.selectRepairOrderList(repairOrder);
    }

    /**
     * 查询工单详情，含证据、状态流转记录、维修记录
     */
    public RepairOrder selectRepairOrderById(Long orderId)
    {
        RepairOrder order = repairOrderMapper.selectRepairOrderById(orderId);
        if (order == null)
        {
            throw new ElevatorException(ElevatorErrorCode.ORDER_NOT_EXIST.getMessage(),
                    ElevatorErrorCode.ORDER_NOT_EXIST.getCode());
        }
        // 业主只能查看本人的工单
        if (LoginUserUtil.isOwner() && !LoginUserUtil.getUserId().equals(order.getUserId()))
        {
            throw new ElevatorException(ElevatorErrorCode.NO_DATA_PERMISSION.getMessage(),
                    ElevatorErrorCode.NO_DATA_PERMISSION.getCode());
        }
        order.setEvidenceList(repairEvidenceMapper.selectByOrderId(orderId));
        order.setStatusLogs(orderStatusLogService.selectByOrderId(orderId));
        order.setRepairRecord(repairRecordMapper.selectByOrderId(orderId));
        return order;
    }

    /**
     * 查询工单进度时间轴数据，业主端与物业端共用
     */
    public RepairOrder selectOrderTimeline(Long orderId)
    {
        return selectRepairOrderById(orderId);
    }

    /**
     * 查询指定电梯的未结工单数量
     */
    public int countOpenOrderByElevator(Long elevatorId)
    {
        return repairOrderMapper.countOpenOrderByElevator(elevatorId);
    }

    /**
     * 按故障等级统计工单数量
     */
    public int countByLevel(String faultLevel)
    {
        RepairOrder query = new RepairOrder();
        query.setFaultLevel(faultLevel);
        return repairOrderMapper.selectRepairOrderList(query).size();
    }

    /**
     * 查询最近报修工单
     */
    public List<RepairOrder> selectRecentOrders(int limit)
    {
        return repairOrderMapper.selectRecentOrders(limit);
    }

    // ==================== 报修提交 ====================

    /**
     * 业主提交故障报修
     * 生成工单，初始状态为待处理，记录报修时间与处理时限
     * 同一电梯已有未结工单时拒绝重复报修
     */
    @Transactional(rollbackFor = Exception.class)
    public RepairOrder report(RepairOrder repairOrder)
    {
        if (repairOrder.getElevatorId() == null)
        {
            throw new ElevatorException("请选择故障电梯");
        }
        if (StringUtils.isEmpty(repairOrder.getFaultDesc()))
        {
            throw new ElevatorException("请填写故障现象描述");
        }

        Elevator elevator = elevatorMapper.selectElevatorById(repairOrder.getElevatorId());
        if (elevator == null)
        {
            throw new ElevatorException("所选电梯不存在");
        }
        if ("2".equals(elevator.getStatus()))
        {
            throw new ElevatorException(ElevatorErrorCode.ELEVATOR_DISABLED.getMessage(),
                    ElevatorErrorCode.ELEVATOR_DISABLED.getCode());
        }

        // 重复报修校验：同一电梯存在未结工单时不允许再次报修
        int openCount = repairOrderMapper.countOpenOrderByElevator(repairOrder.getElevatorId());
        if (openCount > 0)
        {
            throw new ElevatorException(ElevatorErrorCode.ORDER_DUPLICATE.getMessage(),
                    ElevatorErrorCode.ORDER_DUPLICATE.getCode());
        }

        repairOrder.setOrderNo(OrderStatusLogService.buildOrderNo());
        repairOrder.setUserId(LoginUserUtil.getUserId());
        repairOrder.setOrderStatus(OrderStatusUtil.PENDING);
        repairOrder.setCreateBy(LoginUserUtil.getUsername());
        if (StringUtils.isEmpty(repairOrder.getFaultLevel()))
        {
            // 未指定等级时按故障类型推断：困人、停梯默认紧急
            repairOrder.setFaultLevel(defaultLevel(repairOrder.getFaultType()));
        }
        if (StringUtils.isEmpty(repairOrder.getReporterPhone()))
        {
            repairOrder.setReporterPhone(LoginUserUtil.getLoginUser().getUser().getPhonenumber());
        }
        // 设置处理时限
        Calendar calendar = Calendar.getInstance();
        calendar.add(Calendar.HOUR_OF_DAY, DEFAULT_DEADLINE_HOURS);
        repairOrder.setDeadlineTime(calendar.getTime());

        repairOrderMapper.insertRepairOrder(repairOrder);

        // 记录首条状态流转
        orderStatusLogService.record(repairOrder.getOrderId(), "", OrderStatusUtil.PENDING,
                "report", "业主提交故障报修");

        // 通知物业
        noticeService.sendToRole(LoginUserUtil.ROLE_PROPERTY, "新的故障报修",
                String.format("电梯【%s】报修：%s", elevator.getElevatorCode(), repairOrder.getFaultDesc()),
                repairOrder.getOrderId());

        // 把已上传的证据绑定到工单
        if (repairOrder.getEvidenceList() != null && !repairOrder.getEvidenceList().isEmpty())
        {
            for (RepairEvidence evidence : repairOrder.getEvidenceList())
            {
                evidence.setOrderId(repairOrder.getOrderId());
                evidence.setCreateBy(LoginUserUtil.getUsername());
                repairEvidenceMapper.insertRepairEvidence(evidence);
            }
        }
        return repairOrder;
    }

    /**
     * 根据故障类型推断默认故障等级
     */
    private String defaultLevel(String faultType)
    {
        if ("trapped".equals(faultType) || "stop".equals(faultType))
        {
            return "0";
        }
        return "1";
    }

    // ==================== 审核与驳回 ====================

    /**
     * 物业驳回报修单，工单回到业主处待补充
     */
    @Transactional(rollbackFor = Exception.class)
    public int reject(Long orderId, String rejectReason)
    {
        LoginUserUtil.checkPropertyOrAdmin();
        if (StringUtils.isEmpty(rejectReason))
        {
            throw new ElevatorException("驳回原因不能为空");
        }
        RepairOrder order = mustGetOrder(orderId);
        orderStatusLogService.assertTransition(order.getOrderStatus(), OrderStatusUtil.REJECTED);

        RepairOrder update = new RepairOrder();
        update.setOrderId(orderId);
        update.setOrderStatus(OrderStatusUtil.REJECTED);
        update.setRejectReason(rejectReason);
        update.setUpdateBy(LoginUserUtil.getUsername());
        int rows = repairOrderMapper.updateRepairOrder(update);

        orderStatusLogService.record(orderId, order.getOrderStatus(), OrderStatusUtil.REJECTED,
                "reject", rejectReason);
        noticeService.sendToUser(order.getUserId(), "报修被驳回",
                "您的报修单【" + order.getOrderNo() + "】被驳回：" + rejectReason, orderId);
        return rows;
    }

    // ==================== 故障等级调整 ====================

    /**
     * 物业调整故障等级，变更写入状态流转记录
     */
    @Transactional(rollbackFor = Exception.class)
    public int changeLevel(Long orderId, String faultLevel)
    {
        LoginUserUtil.checkPropertyOrAdmin();
        if (StringUtils.isEmpty(faultLevel))
        {
            throw new ElevatorException("故障等级不能为空");
        }
        RepairOrder order = mustGetOrder(orderId);

        RepairOrder update = new RepairOrder();
        update.setOrderId(orderId);
        update.setFaultLevel(faultLevel);
        update.setUpdateBy(LoginUserUtil.getUsername());
        int rows = repairOrderMapper.updateRepairOrder(update);

        String levelName = "0".equals(faultLevel) ? "紧急" : "一般";
        orderStatusLogService.record(orderId, order.getOrderStatus(), order.getOrderStatus(),
                "changeLevel", "故障等级调整为【" + levelName + "】");
        return rows;
    }

    // ==================== 业主确认与申诉 ====================

    /**
     * 业主确认故障消除，工单闭环
     */
    @Transactional(rollbackFor = Exception.class)
    public int confirm(Long orderId)
    {
        RepairOrder order = mustGetOrder(orderId);
        checkOwnerOfOrder(order);
        orderStatusLogService.assertTransition(order.getOrderStatus(), OrderStatusUtil.CONFIRMED);

        RepairOrder update = new RepairOrder();
        update.setOrderId(orderId);
        update.setOrderStatus(OrderStatusUtil.CONFIRMED);
        update.setConfirmTime(new Date());
        update.setUpdateBy(LoginUserUtil.getUsername());
        int rows = repairOrderMapper.updateRepairOrder(update);

        orderStatusLogService.record(orderId, order.getOrderStatus(), OrderStatusUtil.CONFIRMED,
                "confirm", "业主确认故障已消除，工单闭环");
        noticeService.sendToUser(order.getAssigneeId(), "工单已确认完成",
                "工单【" + order.getOrderNo() + "】业主已确认完成", orderId);
        return rows;
    }

    /**
     * 业主对维修结果不满意，提交申诉，工单转物业处理
     */
    @Transactional(rollbackFor = Exception.class)
    public int appeal(Long orderId, String reason)
    {
        RepairOrder order = mustGetOrder(orderId);
        checkOwnerOfOrder(order);
        orderStatusLogService.assertTransition(order.getOrderStatus(), OrderStatusUtil.APPEALED);

        RepairOrder update = new RepairOrder();
        update.setOrderId(orderId);
        update.setOrderStatus(OrderStatusUtil.APPEALED);
        update.setUpdateBy(LoginUserUtil.getUsername());
        int rows = repairOrderMapper.updateRepairOrder(update);

        orderStatusLogService.record(orderId, order.getOrderStatus(), OrderStatusUtil.APPEALED,
                "appeal", StringUtils.isEmpty(reason) ? "业主提交申诉" : reason);
        noticeService.sendToRole(LoginUserUtil.ROLE_PROPERTY, "业主申诉待处理",
                "工单【" + order.getOrderNo() + "】业主提交申诉，请处理", orderId);
        return rows;
    }

    // ==================== 内部工具 ====================

    /**
     * 获取工单，不存在时抛出业务异常
     */
    public RepairOrder mustGetOrder(Long orderId)
    {
        RepairOrder order = repairOrderMapper.selectRepairOrderById(orderId);
        if (order == null)
        {
            throw new ElevatorException(ElevatorErrorCode.ORDER_NOT_EXIST.getMessage(),
                    ElevatorErrorCode.ORDER_NOT_EXIST.getCode());
        }
        return order;
    }

    /**
     * 校验当前用户是否为该工单的报修人
     */
    private void checkOwnerOfOrder(RepairOrder order)
    {
        if (LoginUserUtil.isAdmin())
        {
            return;
        }
        if (!LoginUserUtil.getUserId().equals(order.getUserId()))
        {
            throw new ElevatorException(ElevatorErrorCode.NO_DATA_PERMISSION.getMessage(),
                    ElevatorErrorCode.NO_DATA_PERMISSION.getCode());
        }
    }

    /**
     * 按当前登录角色设置数据范围条件
     * 业主只能看本人的报修，维修员只能看指派给本人的工单；
     * 物业与维修员按其所属小区过滤，管理员不限制。对应论文表2-1 中角色职责与数据隔离要求。
     */
    private void applyDataScope(RepairOrder repairOrder)
    {
        if (LoginUserUtil.isOwner())
        {
            repairOrder.setQueryUserId(LoginUserUtil.getUserId());
            return;
        }
        if (LoginUserUtil.isWorker() && !LoginUserUtil.isProperty() && !LoginUserUtil.isAdmin())
        {
            repairOrder.setQueryAssigneeId(LoginUserUtil.getUserId());
        }
        // 物业与维修员限定在所属小区内，管理员不限制
        Long communityId = LoginUserUtil.getCommunityId();
        if (communityId != null && repairOrder.getCommunityId() == null)
        {
            repairOrder.setCommunityId(communityId);
        }
    }

    /**
     * 判断工单是否存在，供其它模块调用
     */
    public boolean exists(Long orderId)
    {
        return repairOrderMapper.selectRepairOrderById(orderId) != null;
    }

    /**
     * 更新工单，供模块三调用
     */
    public int updateRepairOrder(RepairOrder repairOrder)
    {
        return repairOrderMapper.updateRepairOrder(repairOrder);
    }

    /**
     * 保存维修记录，供模块三调用
     */
    public int saveRepairRecord(RepairRecord record)
    {
        RepairRecord exist = repairRecordMapper.selectByOrderId(record.getOrderId());
        if (exist == null)
        {
            record.setCreateBy(LoginUserUtil.getUsername());
            return repairRecordMapper.insertRepairRecord(record);
        }
        record.setRecordId(exist.getRecordId());
        record.setUpdateBy(LoginUserUtil.getUsername());
        return repairRecordMapper.updateRepairRecord(record);
    }

    /**
     * 获取维修记录
     */
    public RepairRecord getRepairRecord(Long orderId)
    {
        return repairRecordMapper.selectByOrderId(orderId);
    }

    /**
     * 记录状态流转，供模块三调用
     */
    public void recordStatus(Long orderId, String fromStatus, String toStatus, String operateType, String remark)
    {
        orderStatusLogService.record(orderId, fromStatus, toStatus, operateType, remark);
    }

    /**
     * 校验状态流转，供模块三调用
     */
    public void assertTransition(String fromStatus, String toStatus)
    {
        orderStatusLogService.assertTransition(fromStatus, toStatus);
    }
}
