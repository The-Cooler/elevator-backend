package com.ruoyi.elevator.mapper;

import com.ruoyi.elevator.domain.InspectionItemResult;
import com.ruoyi.elevator.domain.InspectionRecord;
import com.ruoyi.elevator.domain.MaintainArchive;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

/**
 * 巡检记录与维保档案 数据层
 *
 * @author 董泽晟
 */
public interface InspectionMapper
{
    // ==================== 巡检记录 ====================

    /**
     * 查询巡检记录列表，含电梯位置与执行人信息
     */
    List<InspectionRecord> selectInspectionRecordList(InspectionRecord inspectionRecord);

    /**
     * 查询巡检记录详情
     */
    InspectionRecord selectInspectionRecordById(Long recordId);

    /**
     * 新增巡检记录
     */
    int insertInspectionRecord(InspectionRecord inspectionRecord);

    /**
     * 修改巡检记录
     */
    int updateInspectionRecord(InspectionRecord inspectionRecord);

    /**
     * 校验同一计划同一计划日期是否已生成巡检工单，避免重复派发
     */
    int checkRecordExists(@Param("planId") Long planId, @Param("planDate") String planDate);

    /**
     * 统计指定电梯在周期内的巡检情况，供健康评分使用
     *
     * @return {totalCount, normalSum, itemSum}
     */
    Map<String, Object> selectInspectionStatByElevator(@Param("elevatorId") Long elevatorId,
                                                       @Param("beginTime") String beginTime,
                                                       @Param("endTime") String endTime);

    /**
     * 统计巡检记录总数
     */
    int selectInspectionCount();

    // ==================== 检查项结果 ====================

    /**
     * 查询指定巡检记录的检查项结果
     */
    List<InspectionItemResult> selectItemResultsByRecordId(Long recordId);

    /**
     * 批量新增检查项结果
     */
    int batchInsertItemResults(List<InspectionItemResult> itemResults);

    /**
     * 删除指定巡检记录的检查项结果，重新提交时使用
     */
    int deleteItemResultsByRecordId(Long recordId);

    // ==================== 维保档案 ====================

    /**
     * 查询维保档案列表
     */
    List<MaintainArchive> selectArchiveList(MaintainArchive archive);

    /**
     * 查询指定电梯的完整维保履历
     */
    List<MaintainArchive> selectArchiveByElevator(Long elevatorId);

    /**
     * 查询档案详情
     */
    MaintainArchive selectArchiveById(Long archiveId);

    /**
     * 新增档案
     */
    int insertArchive(MaintainArchive archive);

    /**
     * 校验档案是否已存在，避免重复归档
     */
    int checkArchiveExists(@Param("archiveType") String archiveType, @Param("bizId") Long bizId);
}
