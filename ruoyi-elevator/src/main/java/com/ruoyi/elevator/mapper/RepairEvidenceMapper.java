package com.ruoyi.elevator.mapper;

import com.ruoyi.elevator.domain.RepairEvidence;

import java.util.List;

/**
 * 报修证据附件 数据层
 *
 * @author 董泽晟
 */
public interface RepairEvidenceMapper
{
    /**
     * 查询证据列表（含文件名与工单信息）
     */
    List<RepairEvidence> selectRepairEvidenceList(RepairEvidence repairEvidence);

    /**
     * 查询指定工单下的证据
     */
    List<RepairEvidence> selectByOrderId(Long orderId);

    /**
     * 新增证据
     */
    int insertRepairEvidence(RepairEvidence repairEvidence);

    /**
     * 逻辑删除证据
     */
    int deleteRepairEvidenceById(Long evidenceId);

    /**
     * 统计指定工单的证据数量，用于数量上限校验
     */
    int countByOrderIdAndType(Long orderId, String evidenceType);
}
