package com.ruoyi.elevator.service;

import com.ruoyi.common.utils.DateUtils;
import com.ruoyi.elevator.domain.OrderStatusLog;
import com.ruoyi.elevator.exception.ElevatorErrorCode;
import com.ruoyi.elevator.exception.ElevatorException;
import com.ruoyi.elevator.mapper.OrderStatusLogMapper;
import com.ruoyi.elevator.util.LoginUserUtil;
import com.ruoyi.elevator.util.OrderStatusUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 工单状态流转记录服务
 * 每次状态变更都写入 order_status_log，供报修进度时间轴展示
 *
 * @author 董泽晟
 */
@Service
public class OrderStatusLogService
{
    @Autowired
    private OrderStatusLogMapper orderStatusLogMapper;

    /**
     * 记录一次状态流转
     *
     * @param orderId 工单ID
     * @param fromStatus 原状态
     * @param toStatus 新状态
     * @param operateType 操作类型
     * @param remark 备注
     */
    public void record(Long orderId, String fromStatus, String toStatus, String operateType, String remark)
    {
        OrderStatusLog log = new OrderStatusLog();
        log.setOrderId(orderId);
        log.setFromStatus(fromStatus == null ? "" : fromStatus);
        log.setToStatus(toStatus);
        log.setOperateType(operateType);
        log.setOperatorId(LoginUserUtil.getUserId());
        log.setOperatorName(LoginUserUtil.getNickName());
        log.setOperatorRole(LoginUserUtil.getPrimaryRoleKey());
        log.setRemark(remark);
        orderStatusLogMapper.insertOrderStatusLog(log);
    }

    /**
     * 查询指定工单的流转记录
     */
    public List<OrderStatusLog> selectByOrderId(Long orderId)
    {
        return orderStatusLogMapper.selectByOrderId(orderId);
    }

    /**
     * 校验状态流转是否合法，非法时抛出业务异常
     *
     * @param fromStatus 原状态
     * @param toStatus 目标状态
     */
    public void assertTransition(String fromStatus, String toStatus)
    {
        if (!OrderStatusUtil.isLegalTransition(fromStatus, toStatus))
        {
            throw new ElevatorException(
                    String.format("工单状态不能从【%s】变更为【%s】",
                            OrderStatusUtil.getStatusName(fromStatus), OrderStatusUtil.getStatusName(toStatus)),
                    ElevatorErrorCode.ORDER_STATUS_ILLEGAL.getCode());
        }
    }

    /**
     * 生成工单编号，格式 BX + yyyyMMdd + 6位时间后缀，保证唯一
     */
    public static String buildOrderNo()
    {
        return "BX" + DateUtils.dateTimeNow("yyyyMMddHHmmss");
    }
}

