package com.ruoyi.elevator.mapper;

import com.ruoyi.elevator.domain.RepairRecord;

import java.util.List;

/**
 * 维修记录 数据层
 *
 * @author 董泽晟
 */
public interface RepairRecordMapper
{
    /**
     * 查询指定工单的维修记录
     */
    RepairRecord selectByOrderId(Long orderId);

    /**
     * 查询维修记录列表
     */
    List<RepairRecord> selectRepairRecordList(RepairRecord repairRecord);

    /**
     * 新增维修记录
     */
    int insertRepairRecord(RepairRecord repairRecord);

    /**
     * 修改维修记录
     */
    int updateRepairRecord(RepairRecord repairRecord);
}
