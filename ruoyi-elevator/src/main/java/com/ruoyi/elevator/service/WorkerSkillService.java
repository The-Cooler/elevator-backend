package com.ruoyi.elevator.service;

import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.elevator.domain.WorkerSkill;
import com.ruoyi.elevator.mapper.WorkerSkillMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 维修员技能与区域服务
 * 供智能派单匹配与派单页手动选择使用
 *
 * @author 董泽晟
 */
@Service
public class WorkerSkillService
{
    @Autowired
    private WorkerSkillMapper workerSkillMapper;

    public List<WorkerSkill> selectWorkerSkillList(WorkerSkill workerSkill)
    {
        return workerSkillMapper.selectWorkerSkillList(workerSkill);
    }

    public WorkerSkill selectByWorkerId(Long workerId)
    {
        return workerSkillMapper.selectByWorkerId(workerId);
    }

    /**
     * 查询可派单候选维修员
     */
    public List<WorkerSkill> selectCandidates(Long communityId)
    {
        return workerSkillMapper.selectCandidates(communityId);
    }

    /**
     * 新增维修员技能
     */
    @Transactional(rollbackFor = Exception.class)
    public int insertWorkerSkill(WorkerSkill workerSkill)
    {
        workerSkill.setCreateBy(SecurityUtils.getUsername());
        return workerSkillMapper.insertWorkerSkill(workerSkill);
    }

    /**
     * 修改维修员技能
     */
    @Transactional(rollbackFor = Exception.class)
    public int updateWorkerSkill(WorkerSkill workerSkill)
    {
        workerSkill.setUpdateBy(SecurityUtils.getUsername());
        return workerSkillMapper.updateWorkerSkill(workerSkill);
    }

    /**
     * 删除维修员技能
     */
    @Transactional(rollbackFor = Exception.class)
    public int deleteWorkerSkillByIds(Long[] skillIds)
    {
        return workerSkillMapper.deleteWorkerSkillByIds(skillIds);
    }

    /**
     * 刷新指定维修员的在手工单数
     */
    public int refreshLoad(Long workerId)
    {
        return workerSkillMapper.updateCurrentLoad(workerId);
    }
}
