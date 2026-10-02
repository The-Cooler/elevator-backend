package com.ruoyi.elevator.domain;

import com.fasterxml.jackson.annotation.JsonFormat;

import java.io.Serializable;
import java.util.Date;

/**
 * 维保计划对象 maintain_plan
 *
 * @author 董泽晟
 */
public class MaintainPlan implements Serializable
{
    private static final long serialVersionUID = 1L;

    /** 计划ID */
    private Long planId;

    /** 计划名称 */
    private String planName;

    /** 电梯ID */
    private Long elevatorId;

    /** 维保类型 */
    private String maintainType;

    /** 周期天数 */
    private Integer cycleDays;

    /** 检查项模板名称 */
    private String templateName;

    /** 生效日期 */
    @JsonFormat(pattern = "yyyy-MM-dd")
    private Date startDate;

    /** 失效日期 */
    @JsonFormat(pattern = "yyyy-MM-dd")
    private Date endDate;

    /** 下次维保日期 */
    @JsonFormat(pattern = "yyyy-MM-dd")
    private Date nextDate;

    /** 上次维保日期 */
    @JsonFormat(pattern = "yyyy-MM-dd")
    private Date lastDate;

    /** 负责人ID */
    private Long ownerId;

    /** 计划状态（0启用 1停用） */
    private String planStatus;

    /** 应执行次数 */
    private Integer expectCount;

    /** 已执行次数 */
    private Integer finishCount;

    /** 删除标志 */
    private String delFlag;

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

    /** 备注 */
    private String remark;

    // ==================== 联表展示字段 ====================

    /** 电梯编号 */
    private String elevatorCode;

    /** 楼栋号 */
    private String buildingNo;

    /** 单元号 */
    private String unitNo;

    /** 小区名称 */
    private String communityName;

    /** 小区ID */
    private Long communityId;

    /** 负责人姓名 */
    private String ownerName;

    /** 完成率（百分比） */
    private java.math.BigDecimal completeRate;

    /** 是否临期（下次维保日期在当前日期之后且距今天数小于阈值） */
    private Boolean dueSoon;

    /** 距下次维保日期的天数，负数表示已超期 */
    private Integer remainingDays;

    /** 查询用：距到期天数小于该值时视为临期 */
    private Integer dueSoonDays;

    /** 批量创建计划用：电梯ID数组 */
    private Long[] elevatorIds;

    public Long getPlanId()
    {
        return planId;
    }

    public void setPlanId(Long planId)
    {
        this.planId = planId;
    }

    public String getPlanName()
    {
        return planName;
    }

    public void setPlanName(String planName)
    {
        this.planName = planName;
    }

    public Long getElevatorId()
    {
        return elevatorId;
    }

    public void setElevatorId(Long elevatorId)
    {
        this.elevatorId = elevatorId;
    }

    public String getMaintainType()
    {
        return maintainType;
    }

    public void setMaintainType(String maintainType)
    {
        this.maintainType = maintainType;
    }

    public Integer getCycleDays()
    {
        return cycleDays;
    }

    public void setCycleDays(Integer cycleDays)
    {
        this.cycleDays = cycleDays;
    }

    public String getTemplateName()
    {
        return templateName;
    }

    public void setTemplateName(String templateName)
    {
        this.templateName = templateName;
    }

    public Date getStartDate()
    {
        return startDate;
    }

    public void setStartDate(Date startDate)
    {
        this.startDate = startDate;
    }

    public Date getEndDate()
    {
        return endDate;
    }

    public void setEndDate(Date endDate)
    {
        this.endDate = endDate;
    }

    public Date getNextDate()
    {
        return nextDate;
    }

    public void setNextDate(Date nextDate)
    {
        this.nextDate = nextDate;
    }

    public Date getLastDate()
    {
        return lastDate;
    }

    public void setLastDate(Date lastDate)
    {
        this.lastDate = lastDate;
    }

    public Long getOwnerId()
    {
        return ownerId;
    }

    public void setOwnerId(Long ownerId)
    {
        this.ownerId = ownerId;
    }

    public String getPlanStatus()
    {
        return planStatus;
    }

    public void setPlanStatus(String planStatus)
    {
        this.planStatus = planStatus;
    }

    public Integer getExpectCount()
    {
        return expectCount;
    }

    public void setExpectCount(Integer expectCount)
    {
        this.expectCount = expectCount;
    }

    public Integer getFinishCount()
    {
        return finishCount;
    }

    public void setFinishCount(Integer finishCount)
    {
        this.finishCount = finishCount;
    }

    public String getDelFlag()
    {
        return delFlag;
    }

    public void setDelFlag(String delFlag)
    {
        this.delFlag = delFlag;
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

    public String getRemark()
    {
        return remark;
    }

    public void setRemark(String remark)
    {
        this.remark = remark;
    }

    public String getElevatorCode()
    {
        return elevatorCode;
    }

    public void setElevatorCode(String elevatorCode)
    {
        this.elevatorCode = elevatorCode;
    }

    public String getBuildingNo()
    {
        return buildingNo;
    }

    public void setBuildingNo(String buildingNo)
    {
        this.buildingNo = buildingNo;
    }

    public String getUnitNo()
    {
        return unitNo;
    }

    public void setUnitNo(String unitNo)
    {
        this.unitNo = unitNo;
    }

    public String getCommunityName()
    {
        return communityName;
    }

    public void setCommunityName(String communityName)
    {
        this.communityName = communityName;
    }

    public Long getCommunityId()
    {
        return communityId;
    }

    public void setCommunityId(Long communityId)
    {
        this.communityId = communityId;
    }

    public String getOwnerName()
    {
        return ownerName;
    }

    public void setOwnerName(String ownerName)
    {
        this.ownerName = ownerName;
    }

    public java.math.BigDecimal getCompleteRate()
    {
        return completeRate;
    }

    public void setCompleteRate(java.math.BigDecimal completeRate)
    {
        this.completeRate = completeRate;
    }

    public Boolean getDueSoon()
    {
        return dueSoon;
    }

    public void setDueSoon(Boolean dueSoon)
    {
        this.dueSoon = dueSoon;
    }

    public Integer getRemainingDays()
    {
        return remainingDays;
    }

    public void setRemainingDays(Integer remainingDays)
    {
        this.remainingDays = remainingDays;
    }

    public Integer getDueSoonDays()
    {
        return dueSoonDays;
    }

    public void setDueSoonDays(Integer dueSoonDays)
    {
        this.dueSoonDays = dueSoonDays;
    }

    public Long[] getElevatorIds()
    {
        return elevatorIds;
    }

    public void setElevatorIds(Long[] elevatorIds)
    {
        this.elevatorIds = elevatorIds;
    }
}
