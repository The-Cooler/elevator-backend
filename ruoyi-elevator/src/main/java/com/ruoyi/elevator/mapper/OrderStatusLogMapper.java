package com.ruoyi.elevator.mapper;

import com.ruoyi.elevator.domain.OrderStatusLog;

import java.util.List;

/**
 * 工单状态流转记录 数据层
 *
 * @author 董泽晟
 */
public interface OrderStatusLogMapper
{
    /**
     * 查询指定工单的流转记录，按时间正序，用于进度时间轴
     */
    List<OrderStatusLog> selectByOrderId(Long orderId);

    /**
     * 新增流转记录
     */
    int insertOrderStatusLog(OrderStatusLog orderStatusLog);
}
