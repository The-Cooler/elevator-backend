package com.ruoyi.elevator.domain;

import com.fasterxml.jackson.annotation.JsonFormat;

import java.io.Serializable;
import java.util.Date;

/**
 * 维保档案对象 maintain_archive
 * 汇总每次维保与巡检详情，形成电梯全生命周期历史维保记录
 *
 * @author 董泽晟
 */
public class MaintainArchive implements Serializable
{
    private static final long serialVersionUID = 1L;

    /** 档案ID */
    private Long archiveId;

    /** 电梯ID */
    private Long elevatorId;

    /** 归档类型（inspection巡检 maintain维保 repair维修） */
    private String archiveType;

    /** 维保类型 */
    private String maintainType;

    /** 关联业务ID */
    private Long bizId;

    /** 归档时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date archiveTime;

    /** 记录摘要 */
    private String summary;

    /** 执行人姓名 */
    private String executorName;

    /** 执行日期 */
    @JsonFormat(pattern = "yyyy-MM-dd")
    private Date executeDate;

    /** 是否含异常（0正常 1异常） */
    private String isAbnormal;

    /** 创建时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date createTime;

    // ==================== 联表展示字段 ====================

    /** 电梯编号 */
    private String elevatorCode;

    /** 小区名称 */
    private String communityName;

    /** 楼栋号 */
    private String buildingNo;

    /** 单元号 */
    private String unitNo;

    /** 查询用：执行日期范围起 */
    private String beginTime;

    /** 查询用：执行日期范围止 */
    private String endTime;

    /** 查询用：小区ID */
    private Long communityId;

    public Long getArchiveId()
    {
        return archiveId;
    }

    public void setArchiveId(Long archiveId)
    {
        this.archiveId = archiveId;
    }

    public Long getElevatorId()
    {
        return elevatorId;
    }

    public void setElevatorId(Long elevatorId)
    {
        this.elevatorId = elevatorId;
    }

    public String getArchiveType()
    {
        return archiveType;
    }

    public void setArchiveType(String archiveType)
    {
        this.archiveType = archiveType;
    }

    public String getMaintainType()
    {
        return maintainType;
    }

    public void setMaintainType(String maintainType)
    {
        this.maintainType = maintainType;
    }

    public Long getBizId()
    {
        return bizId;
    }

    public void setBizId(Long bizId)
    {
        this.bizId = bizId;
    }

    public Date getArchiveTime()
    {
        return archiveTime;
    }

    public void setArchiveTime(Date archiveTime)
    {
        this.archiveTime = archiveTime;
    }

    public String getSummary()
    {
        return summary;
    }

    public void setSummary(String summary)
    {
        this.summary = summary;
    }

    public String getExecutorName()
    {
        return executorName;
    }

    public void setExecutorName(String executorName)
    {
        this.executorName = executorName;
    }

    public Date getExecuteDate()
    {
        return executeDate;
    }

    public void setExecuteDate(Date executeDate)
    {
        this.executeDate = executeDate;
    }

    public String getIsAbnormal()
    {
        return isAbnormal;
    }

    public void setIsAbnormal(String isAbnormal)
    {
        this.isAbnormal = isAbnormal;
    }

    public Date getCreateTime()
    {
        return createTime;
    }

    public void setCreateTime(Date createTime)
    {
        this.createTime = createTime;
    }

    public String getElevatorCode()
    {
        return elevatorCode;
    }

    public void setElevatorCode(String elevatorCode)
    {
        this.elevatorCode = elevatorCode;
    }

    public String getCommunityName()
    {
        return communityName;
    }

    public void setCommunityName(String communityName)
    {
        this.communityName = communityName;
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

    public String getBeginTime()
    {
        return beginTime;
    }

    public void setBeginTime(String beginTime)
    {
        this.beginTime = beginTime;
    }

    public String getEndTime()
    {
        return endTime;
    }

    public void setEndTime(String endTime)
    {
        this.endTime = endTime;
    }

    public Long getCommunityId()
    {
        return communityId;
    }

    public void setCommunityId(Long communityId)
    {
        this.communityId = communityId;
    }
}
