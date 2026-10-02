package com.ruoyi.elevator.domain;

import com.fasterxml.jackson.annotation.JsonFormat;

import java.io.Serializable;
import java.util.Date;

/**
 * 维修员技能与负责区域对象 worker_skill
 * 供智能派单按区域与技能匹配使用
 *
 * @author 董泽晟
 */
public class WorkerSkill implements Serializable
{
    private static final long serialVersionUID = 1L;

    /** 技能ID */
    private Long skillId;

    /** 维修员ID */
    private Long workerId;

    /** 负责小区ID */
    private Long communityId;

    /** 技能标签，多个用逗号分隔 */
    private String skillTags;

    /** 在岗状态（0在岗 1休息 2请假） */
    private String workStatus;

    /** 当前在手工单数 */
    private Integer currentLoad;

    /** 累计完成工单数 */
    private Integer totalFinished;

    /** 平均响应时长（分钟） */
    private Integer avgResponse;

    /** 创建者 */
    private String createBy;

    /** 创建时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date createTime;

    /** 更新者 */
    private String updateBy;

    /** 更新时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date updateTime;

    // ==================== 联表展示字段 ====================

    /** 维修员姓名 */
    private String workerName;

    /** 维修员电话 */
    private String workerPhone;

    /** 负责小区名称 */
    private String communityName;

    /** 派单推荐用：技能匹配度得分 */
    private Integer matchScore;

    /** 派单推荐用：技能是否匹配 */
    private Boolean skillMatched;

    public Long getSkillId()
    {
        return skillId;
    }

    public void setSkillId(Long skillId)
    {
        this.skillId = skillId;
    }

    public Long getWorkerId()
    {
        return workerId;
    }

    public void setWorkerId(Long workerId)
    {
        this.workerId = workerId;
    }

    public Long getCommunityId()
    {
        return communityId;
    }

    public void setCommunityId(Long communityId)
    {
        this.communityId = communityId;
    }

    public String getSkillTags()
    {
        return skillTags;
    }

    public void setSkillTags(String skillTags)
    {
        this.skillTags = skillTags;
    }

    public String getWorkStatus()
    {
        return workStatus;
    }

    public void setWorkStatus(String workStatus)
    {
        this.workStatus = workStatus;
    }

    public Integer getCurrentLoad()
    {
        return currentLoad;
    }

    public void setCurrentLoad(Integer currentLoad)
    {
        this.currentLoad = currentLoad;
    }

    public Integer getTotalFinished()
    {
        return totalFinished;
    }

    public void setTotalFinished(Integer totalFinished)
    {
        this.totalFinished = totalFinished;
    }

    public Integer getAvgResponse()
    {
        return avgResponse;
    }

    public void setAvgResponse(Integer avgResponse)
    {
        this.avgResponse = avgResponse;
    }

    public String getCreateBy()
    {
        return createBy;
    }

    public void setCreateBy(String createBy)
    {
        this.createBy = createBy;
    }

    public Date getCreateTime()
    {
        return createTime;
    }

    public void setCreateTime(Date createTime)
    {
        this.createTime = createTime;
    }

    public String getUpdateBy()
    {
        return updateBy;
    }

    public void setUpdateBy(String updateBy)
    {
        this.updateBy = updateBy;
    }

    public Date getUpdateTime()
    {
        return updateTime;
    }

    public void setUpdateTime(Date updateTime)
    {
        this.updateTime = updateTime;
    }

    public String getWorkerName()
    {
        return workerName;
    }

    public void setWorkerName(String workerName)
    {
        this.workerName = workerName;
    }

    public String getWorkerPhone()
    {
        return workerPhone;
    }

    public void setWorkerPhone(String workerPhone)
    {
        this.workerPhone = workerPhone;
    }

    public String getCommunityName()
    {
        return communityName;
    }

    public void setCommunityName(String communityName)
    {
        this.communityName = communityName;
    }

    public Integer getMatchScore()
    {
        return matchScore;
    }

    public void setMatchScore(Integer matchScore)
    {
        this.matchScore = matchScore;
    }

    public Boolean getSkillMatched()
    {
        return skillMatched;
    }

    public void setSkillMatched(Boolean skillMatched)
    {
        this.skillMatched = skillMatched;
    }
}
