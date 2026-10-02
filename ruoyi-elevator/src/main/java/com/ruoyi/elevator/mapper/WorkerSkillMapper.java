package com.ruoyi.elevator.mapper;

import com.ruoyi.elevator.domain.WorkerSkill;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 维修员技能与区域 数据层
 *
 * @author 董泽晟
 */
public interface WorkerSkillMapper
{
    /**
     * 查询维修员技能列表，含姓名与负责小区名称
     */
    List<WorkerSkill> selectWorkerSkillList(WorkerSkill workerSkill);

    /**
     * 查询指定维修员的技能记录
     */
    WorkerSkill selectByWorkerId(Long workerId);

    /**
     * 查询可派单候选维修员
     * 条件：角色为维修员、账号启用、在岗状态为在岗
     *
     * @param communityId 故障电梯所属小区，可为空表示不限区域
     */
    List<WorkerSkill> selectCandidates(@Param("communityId") Long communityId);

    int insertWorkerSkill(WorkerSkill workerSkill);

    int updateWorkerSkill(WorkerSkill workerSkill);

    int deleteWorkerSkillByIds(Long[] skillIds);

    /**
     * 更新维修员当前在手工单数
     */
    int updateCurrentLoad(@Param("workerId") Long workerId);

    /**
     * 工单完成时累计完成数与平均响应时长，供派单排序参考
     */
    int increaseFinished(@Param("workerId") Long workerId, @Param("responseMinutes") Integer responseMinutes);
}
