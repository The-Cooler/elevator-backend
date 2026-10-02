package com.ruoyi.elevator.service;

import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.elevator.domain.RepairOrder;
import com.ruoyi.elevator.domain.RepairRecord;
import com.ruoyi.elevator.exception.ElevatorErrorCode;
import com.ruoyi.elevator.exception.ElevatorException;
import com.ruoyi.elevator.mapper.RepairOrderMapper;
import com.ruoyi.elevator.mapper.WorkerSkillMapper;
import com.ruoyi.elevator.util.LoginUserUtil;
import com.ruoyi.elevator.util.OrderStatusUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Calendar;
import java.util.Date;
import java.util.List;

/**
 * 维修作业服务
 * 对应论文模块三的维保人员接单与维修过程管理子功能
 * 维修员依次推进状态：已接单 -> 已到场 -> 维修中 -> 已修复
 * 状态流转做合法性校验，禁止跳转与非法回退
 *
 * @author 董泽晟
 */
@Service
public class WorkOrderService
{
    @Autowired
    private RepairOrderMapper repairOrderMapper;

    @Autowired
    private WorkerSkillMapper workerSkillMapper;

    @Autowired
    private RepairOrderService repairOrderService;

    @Autowired
    private InspectionService inspectionService;

    @Autowired
    private NoticeService noticeService;

    /**
     * 查询指派给当前维修员的工单
     *
     * @param query 查询条件
     * @param onlyPending 是否只查待接单的工单
     */
    public List<RepairOrder> myList(RepairOrder query, boolean onlyPending)
    {
        query.setQueryAssigneeId(LoginUserUtil.getUserId());
        if (onlyPending)
        {
            query.setOrderStatus(OrderStatusUtil.ASSIGNED);
        }
        return repairOrderMapper.selectRepairOrderList(query);
    }

    /**
     * 查询全部接单情况，供物业查看
     */
    public List<RepairOrder> acceptList(RepairOrder query)
    {
        return repairOrderMapper.selectRepairOrderList(query);
    }

    /**
     * 维修员确认接单，并反馈预计到场时间
     *
     * @param orderId 工单ID
     * @param arriveMinutes 预计到场分钟数
     */
    @Transactional(rollbackFor = Exception.class)
    public int accept(Long orderId, Integer arriveMinutes)
    {
        RepairOrder order = mustBeMyOrder(orderId);
        repairOrderService.assertTransition(order.getOrderStatus(), OrderStatusUtil.ACCEPTED);

        RepairOrder update = new RepairOrder();
        update.setOrderId(orderId);
        update.setOrderStatus(OrderStatusUtil.ACCEPTED);
        update.setAcceptTime(new Date());
        update.setUpdateBy(LoginUserUtil.getUsername());
        // 接单后按预计到场时间更新处理时限
        if (arriveMinutes != null && arriveMinutes > 0)
        {
            Calendar calendar = Calendar.getInstance();
            calendar.add(Calendar.MINUTE, arriveMinutes);
            update.setDeadlineTime(calendar.getTime());
        }
        int rows = repairOrderMapper.updateRepairOrder(update);

        String remark = arriveMinutes != null && arriveMinutes > 0
                ? String.format("维修员已接单，预计 %d 分钟到场", arriveMinutes)
                : "维修员已接单";
        repairOrderService.recordStatus(orderId, order.getOrderStatus(), OrderStatusUtil.ACCEPTED, "accept", remark);

        workerSkillMapper.updateCurrentLoad(LoginUserUtil.getUserId());

        noticeService.sendToUser(order.getUserId(), "维修员已接单",
                String.format("您的报修单【%s】%s", order.getOrderNo(), remark), orderId);
        return rows;
    }

    /**
     * 维修员拒绝接单，工单回到待派单池
     */
    @Transactional(rollbackFor = Exception.class)
    public int refuse(Long orderId, String reason)
    {
        RepairOrder order = mustBeMyOrder(orderId);
        repairOrderService.assertTransition(order.getOrderStatus(), OrderStatusUtil.PENDING);

        RepairOrder update = new RepairOrder();
        update.setOrderId(orderId);
        update.setOrderStatus(OrderStatusUtil.PENDING);
        // 清空派单信息，回到待派单池
        update.setAssigneeId(0L);
        update.setAssignerId(0L);
        update.setUpdateBy(LoginUserUtil.getUsername());
        int rows = repairOrderMapper.updateRepairOrder(update);

        repairOrderService.recordStatus(orderId, order.getOrderStatus(), OrderStatusUtil.PENDING, "reassign",
                StringUtils.isEmpty(reason) ? "维修员拒绝接单，工单回到待派单池" : "维修员拒绝接单：" + reason);

        noticeService.sendToRole(LoginUserUtil.ROLE_PROPERTY, "工单被拒单",
                String.format("工单【%s】被维修员拒绝，请重新指派", order.getOrderNo()), orderId);
        return rows;
    }

    /**
     * 维修员到达现场，记录到场时间与定位
     */
    @Transactional(rollbackFor = Exception.class)
    public int arrive(Long orderId, String location)
    {
        RepairOrder order = mustBeMyOrder(orderId);
        repairOrderService.assertTransition(order.getOrderStatus(), OrderStatusUtil.ARRIVED);

        Date now = new Date();
        RepairOrder update = new RepairOrder();
        update.setOrderId(orderId);
        update.setOrderStatus(OrderStatusUtil.ARRIVED);
        update.setArriveTime(now);
        update.setUpdateBy(LoginUserUtil.getUsername());
        int rows = repairOrderMapper.updateRepairOrder(update);

        // 维修记录里同步到场信息
        RepairRecord record = new RepairRecord();
        record.setOrderId(orderId);
        record.setWorkerId(LoginUserUtil.getUserId());
        record.setArriveTime(now);
        record.setArriveLocation(location);
        repairOrderService.saveRepairRecord(record);

        repairOrderService.recordStatus(orderId, order.getOrderStatus(), OrderStatusUtil.ARRIVED, "arrive",
                StringUtils.isEmpty(location) ? "维修员已到达现场" : "维修员已到达现场，定位：" + location);

        noticeService.sendToUser(order.getUserId(), "维修员已到场",
                String.format("您的报修单【%s】维修员已到达现场", order.getOrderNo()), orderId);
        return rows;
    }

    /**
     * 维修员开始排查，填写排查记录，工单进入维修中
     */
    @Transactional(rollbackFor = Exception.class)
    public int investigate(Long orderId, String investigateNote)
    {
        RepairOrder order = mustBeMyOrder(orderId);
        String fromStatus = order.getOrderStatus();
        // 已到场或已申诉（返工）都可以进入维修中
        if (!OrderStatusUtil.ARRIVED.equals(fromStatus) && !OrderStatusUtil.APPEALED.equals(fromStatus))
        {
            repairOrderService.assertTransition(fromStatus, OrderStatusUtil.REPAIRING);
        }

        RepairOrder update = new RepairOrder();
        update.setOrderId(orderId);
        update.setOrderStatus(OrderStatusUtil.REPAIRING);
        update.setUpdateBy(LoginUserUtil.getUsername());
        int rows = repairOrderMapper.updateRepairOrder(update);

        RepairRecord record = new RepairRecord();
        record.setOrderId(orderId);
        record.setWorkerId(LoginUserUtil.getUserId());
        record.setInvestigateNote(investigateNote);
        repairOrderService.saveRepairRecord(record);

        repairOrderService.recordStatus(orderId, fromStatus, OrderStatusUtil.REPAIRING, "investigate",
                StringUtils.isEmpty(investigateNote) ? "维修员开始排查" : investigateNote);
        return rows;
    }

    /**
     * 维修完成，提交处理说明与更换配件，工单进入已修复等待业主确认
     */
    @Transactional(rollbackFor = Exception.class)
    public int finish(Long orderId, RepairRecord finishInfo)
    {
        RepairOrder order = mustBeMyOrder(orderId);
        repairOrderService.assertTransition(order.getOrderStatus(), OrderStatusUtil.REPAIRED);
        if (StringUtils.isEmpty(finishInfo.getRepairDesc()))
        {
            throw new ElevatorException("请填写维修处理说明");
        }

        Date now = new Date();
        RepairOrder update = new RepairOrder();
        update.setOrderId(orderId);
        update.setOrderStatus(OrderStatusUtil.REPAIRED);
        update.setFinishTime(now);
        update.setUpdateBy(LoginUserUtil.getUsername());
        int rows = repairOrderMapper.updateRepairOrder(update);

        finishInfo.setOrderId(orderId);
        finishInfo.setWorkerId(LoginUserUtil.getUserId());
        finishInfo.setFinishTime(now);
        repairOrderService.saveRepairRecord(finishInfo);

        repairOrderService.recordStatus(orderId, order.getOrderStatus(), OrderStatusUtil.REPAIRED, "finish",
                "维修完成：" + finishInfo.getRepairDesc());

        // 维修完成后写入维保档案，形成电梯全生命周期记录
        inspectionService.createRepairArchive(order, finishInfo.getRepairDesc(),
                finishInfo.getReplaceParts(), LoginUserUtil.getNickName(), now);

        // 累计维修员完成数与响应时长
        Integer responseMinutes = null;
        if (order.getAssignTime() != null)
        {
            responseMinutes = (int) ((now.getTime() - order.getAssignTime().getTime()) / 60000);
        }
        workerSkillMapper.increaseFinished(LoginUserUtil.getUserId(), responseMinutes);
        workerSkillMapper.updateCurrentLoad(LoginUserUtil.getUserId());

        noticeService.sendToUser(order.getUserId(), "维修已完成，请确认",
                String.format("您的报修单【%s】维修已完成：%s，请确认故障是否消除", order.getOrderNo(), finishInfo.getRepairDesc()),
                orderId);
        return rows;
    }

    /**
     * 查询工单的维修记录
     */
    public RepairRecord getRecord(Long orderId)
    {
        return repairOrderService.getRepairRecord(orderId);
    }

    /**
     * 校验工单是否为当前维修员负责，防止越权操作
     */
    private RepairOrder mustBeMyOrder(Long orderId)
    {
        RepairOrder order = repairOrderService.mustGetOrder(orderId);
        if (LoginUserUtil.isAdmin() || LoginUserUtil.isProperty())
        {
            return order;
        }
        if (!LoginUserUtil.getUserId().equals(order.getAssigneeId()))
        {
            throw new ElevatorException(ElevatorErrorCode.NO_DATA_PERMISSION.getMessage(),
                    ElevatorErrorCode.NO_DATA_PERMISSION.getCode());
        }
        return order;
    }
}
