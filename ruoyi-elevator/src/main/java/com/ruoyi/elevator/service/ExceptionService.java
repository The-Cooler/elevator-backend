package com.ruoyi.elevator.service;

import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.elevator.domain.RepairOrder;
import com.ruoyi.elevator.exception.ElevatorException;
import com.ruoyi.elevator.mapper.RepairOrderMapper;
import com.ruoyi.elevator.mapper.WorkerSkillMapper;
import com.ruoyi.elevator.util.LoginUserUtil;
import com.ruoyi.elevator.util.OrderStatusUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.Date;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * 工单异常处理服务
 * 对应论文模块三的工单异常处理子功能
 * 覆盖派单超时、接单超时、到场超时、维修超时四类异常，支持重新指派、驳回重审、异常上报与升级处理
 *
 * @author 董泽晟
 */
@Service
public class ExceptionService
{
    /** 各环节超时阈值（分钟） */
    private static final int ASSIGN_TIMEOUT_MINUTES = 30;

    private static final int ACCEPT_TIMEOUT_MINUTES = 30;

    private static final int ARRIVE_TIMEOUT_MINUTES = 120;

    private static final int REPAIR_TIMEOUT_MINUTES = 24 * 60;

    @Autowired
    private RepairOrderMapper repairOrderMapper;

    @Autowired
    private WorkerSkillMapper workerSkillMapper;

    @Autowired
    private RepairOrderService repairOrderService;

    @Autowired
    private NoticeService noticeService;

    /**
     * 异常类型定义：key 为规则子类型，value 为中文名称
     */
    private static final String[][] EXCEPTION_TYPES = {
            { "assign", "派单超时" },
            { "accept", "接单超时" },
            { "arrive", "到场超时" },
            { "repair", "维修超时" }
    };

    /**
     * 查询异常工单列表
     * 按四类超时规则分别扫描，合并后返回，并标注异常类型与超时时长
     *
     * @param query 查询条件，支持按小区、电梯编号过滤
     * @param exceptionType 异常类型过滤，为空时返回全部类型
     */
    public List<Map<String, Object>> selectExceptionList(RepairOrder query, String exceptionType)
    {
        List<Map<String, Object>> result = new ArrayList<>();
        for (String[] type : EXCEPTION_TYPES)
        {
            if (StringUtils.isNotEmpty(exceptionType) && !exceptionType.equals(type[0]))
            {
                continue;
            }
            int threshold = timeoutOf(type[0]);
            List<RepairOrder> orders = repairOrderMapper.selectOverdueOrders(type[0], threshold);
            for (RepairOrder order : orders)
            {
                // 按查询条件过滤
                if (query.getCommunityId() != null && !query.getCommunityId().equals(order.getCommunityId()))
                {
                    continue;
                }
                if (StringUtils.isNotEmpty(query.getElevatorCode())
                        && (order.getElevatorCode() == null || !order.getElevatorCode().contains(query.getElevatorCode())))
                {
                    continue;
                }
                Map<String, Object> item = new LinkedHashMap<>();
                item.put("orderId", order.getOrderId());
                item.put("orderNo", order.getOrderNo());
                item.put("orderStatus", order.getOrderStatus());
                item.put("orderStatusName", OrderStatusUtil.getStatusName(order.getOrderStatus()));
                item.put("faultLevel", order.getFaultLevel());
                item.put("faultDesc", order.getFaultDesc());
                item.put("elevatorCode", order.getElevatorCode());
                item.put("communityName", order.getCommunityName());
                item.put("buildingNo", order.getBuildingNo());
                item.put("unitNo", order.getUnitNo());
                item.put("reporterName", order.getReporterName());
                item.put("assigneeName", order.getAssigneeName());
                item.put("assigneeId", order.getAssigneeId());
                item.put("reportTime", order.getReportTime());
                item.put("exceptionType", type[0]);
                item.put("exceptionTypeName", type[1]);
                item.put("timeoutMinutes", exceededMinutes(order, type[0]));
                result.add(item);
            }
        }
        result.sort((a, b) -> Integer.compare((Integer) b.get("timeoutMinutes"), (Integer) a.get("timeoutMinutes")));
        return result;
    }

    /**
     * 按异常类型统计，供异常统计图表使用
     */
    public List<Map<String, Object>> statistics()
    {
        List<Map<String, Object>> result = new ArrayList<>();
        for (String[] type : EXCEPTION_TYPES)
        {
            int threshold = timeoutOf(type[0]);
            int count = repairOrderMapper.selectOverdueOrders(type[0], threshold).size();
            Map<String, Object> item = new LinkedHashMap<>();
            item.put("exceptionType", type[0]);
            item.put("exceptionTypeName", type[1]);
            item.put("count", count);
            result.add(item);
        }
        return result;
    }

    /**
     * 重新指派超时工单给其他维修员
     */
    @Transactional(rollbackFor = Exception.class)
    public int reassign(Long orderId, Long newAssigneeId, String reason)
    {
        LoginUserUtil.checkPropertyOrAdmin();
        if (newAssigneeId == null)
        {
            throw new ElevatorException("请选择新的维修员");
        }
        RepairOrder order = repairOrderService.mustGetOrder(orderId);
        Long oldAssigneeId = order.getAssigneeId();

        RepairOrder update = new RepairOrder();
        update.setOrderId(orderId);
        update.setOrderStatus(OrderStatusUtil.ASSIGNED);
        update.setAssigneeId(newAssigneeId);
        update.setAssignerId(LoginUserUtil.getUserId());
        update.setAssignTime(new Date());
        update.setUpdateBy(LoginUserUtil.getUsername());
        int rows = repairOrderMapper.updateRepairOrder(update);

        String remark = StringUtils.isEmpty(reason) ? "超时工单重新指派" : "超时工单重新指派：" + reason;
        repairOrderService.recordStatus(orderId, order.getOrderStatus(), OrderStatusUtil.ASSIGNED, "reassign", remark);

        if (oldAssigneeId != null && oldAssigneeId > 0)
        {
            workerSkillMapper.updateCurrentLoad(oldAssigneeId);
            noticeService.sendToUser(oldAssigneeId, "工单已改派",
                    String.format("工单【%s】已改派给其他维修员", order.getOrderNo()), orderId);
        }
        workerSkillMapper.updateCurrentLoad(newAssigneeId);
        noticeService.sendToUser(newAssigneeId, "新的工单派给您",
                String.format("工单【%s】已派给您，请及时接单", order.getOrderNo()), orderId);
        return rows;
    }

    /**
     * 驳回重审超时工单，附驳回原因
     */
    @Transactional(rollbackFor = Exception.class)
    public int reject(Long orderId, String reason)
    {
        LoginUserUtil.checkPropertyOrAdmin();
        if (StringUtils.isEmpty(reason))
        {
            throw new ElevatorException("驳回原因不能为空");
        }
        RepairOrder order = repairOrderService.mustGetOrder(orderId);
        repairOrderService.assertTransition(order.getOrderStatus(), OrderStatusUtil.REJECTED);

        RepairOrder update = new RepairOrder();
        update.setOrderId(orderId);
        update.setOrderStatus(OrderStatusUtil.REJECTED);
        update.setRejectReason(reason);
        update.setUpdateBy(LoginUserUtil.getUsername());
        int rows = repairOrderMapper.updateRepairOrder(update);

        repairOrderService.recordStatus(orderId, order.getOrderStatus(), OrderStatusUtil.REJECTED, "reject", reason);
        noticeService.sendToUser(order.getUserId(), "报修被驳回",
                String.format("您的报修单【%s】被驳回：%s", order.getOrderNo(), reason), orderId);
        return rows;
    }

    /**
     * 维修员上报异常，表示现场无法修复，工单转物业处理
     */
    @Transactional(rollbackFor = Exception.class)
    public int reportException(Long orderId, String reason)
    {
        if (StringUtils.isEmpty(reason))
        {
            throw new ElevatorException("异常说明不能为空");
        }
        RepairOrder order = repairOrderService.mustGetOrder(orderId);
        if (!LoginUserUtil.isAdmin() && !LoginUserUtil.isProperty()
                && !LoginUserUtil.getUserId().equals(order.getAssigneeId()))
        {
            throw new ElevatorException("只能上报指派给本人的工单");
        }

        RepairOrder update = new RepairOrder();
        update.setOrderId(orderId);
        update.setOrderStatus(OrderStatusUtil.PENDING);
        update.setAssigneeId(0L);
        update.setUpdateBy(LoginUserUtil.getUsername());
        update.setRemark("异常上报：" + reason);
        int rows = repairOrderMapper.updateRepairOrder(update);

        repairOrderService.recordStatus(orderId, order.getOrderStatus(), OrderStatusUtil.PENDING,
                "escalate", "维修员上报异常：" + reason);
        noticeService.sendToRole(LoginUserUtil.ROLE_PROPERTY, "工单异常上报",
                String.format("工单【%s】维修员上报异常：%s", order.getOrderNo(), reason), orderId);
        return rows;
    }

    /**
     * 升级处理：提升故障等级为紧急，并保持工单流转
     */
    @Transactional(rollbackFor = Exception.class)
    public int escalate(Long orderId, String remark)
    {
        LoginUserUtil.checkPropertyOrAdmin();
        RepairOrder order = repairOrderService.mustGetOrder(orderId);

        RepairOrder update = new RepairOrder();
        update.setOrderId(orderId);
        update.setFaultLevel("0");
        update.setUpdateBy(LoginUserUtil.getUsername());
        update.setRemark(StringUtils.isEmpty(remark) ? "异常工单升级为紧急处理" : "异常工单升级：" + remark);
        int rows = repairOrderMapper.updateRepairOrder(update);

        repairOrderService.recordStatus(orderId, order.getOrderStatus(), order.getOrderStatus(),
                "escalate", StringUtils.isEmpty(remark) ? "异常工单升级为紧急处理" : remark);
        return rows;
    }

    /**
     * 获取指定异常类型对应的超时阈值
     */
    private int timeoutOf(String ruleType)
    {
        switch (ruleType)
        {
            case "assign":
                return ASSIGN_TIMEOUT_MINUTES;
            case "accept":
                return ACCEPT_TIMEOUT_MINUTES;
            case "arrive":
                return ARRIVE_TIMEOUT_MINUTES;
            case "repair":
                return REPAIR_TIMEOUT_MINUTES;
            default:
                return 60;
        }
    }

    /**
     * 计算工单在当前环节已超时的分钟数
     */
    private int exceededMinutes(RepairOrder order, String ruleType)
    {
        Date baseTime;
        switch (ruleType)
        {
            case "assign":
                baseTime = order.getReportTime();
                break;
            case "accept":
                baseTime = order.getAssignTime();
                break;
            case "arrive":
                baseTime = order.getAcceptTime();
                break;
            case "repair":
                baseTime = order.getArriveTime();
                break;
            default:
                baseTime = order.getReportTime();
                break;
        }
        if (baseTime == null)
        {
            return 0;
        }
        long minutes = (System.currentTimeMillis() - baseTime.getTime()) / 60000;
        return (int) Math.max(0, minutes - timeoutOf(ruleType));
    }
}
