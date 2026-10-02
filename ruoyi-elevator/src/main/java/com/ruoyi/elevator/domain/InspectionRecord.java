package com.ruoyi.elevator.domain;

import com.fasterxml.jackson.annotation.JsonFormat;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

/**
 * 巡检记录对象 inspection_record
 *
 * @author 董泽晟
 */
public class InspectionRecord implements Serializable
{
    private static final long serialVersionUID = 1L;

    /** 巡检记录ID */
    private Long recordId;

    /** 巡检工单编号 */
    private String recordNo;

    /** 关联维保计划ID */
    private Long planId;

    /** 电梯ID */
    private Long elevatorId;

    /** 维保类型 */
    private String maintainType;

    /** 计划维保日期 */
    @JsonFormat(pattern = "yyyy-MM-dd")
    private Date planDate;

    /** 执行人ID */
    private Long executorId;

    /** 打卡时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date clockInTime;

    /** 打卡位置 */
    private String clockInLocation;

    /** 实际执行日期 */
    @JsonFormat(pattern = "yyyy-MM-dd")
    private Date executeDate;

    /** 执行结果（pending待执行 normal正常 abnormal异常） */
    private String executeResult;

    /** 异常说明 */
    private String abnormalDesc;

    /** 正常项数 */
    private Integer normalCount;

    /** 异常项数 */
    private Integer abnormalCount;

    /** 不适用项数 */
    private Integer naCount;

    /** 记录状态（pending待执行 finished已完成 overdue已超期） */
    private String recordStatus;

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

    // ==================== 联表展示字段 ====================

    /** 电梯编号 */
    private String elevatorCode;

    /** 小区名称 */
    private String communityName;

    /** 楼栋号 */
    private String buildingNo;

    /** 单元号 */
    private String unitNo;

    /** 执行人姓名 */
    private String executorName;

    /** 检查项结果列表 */
    private List<InspectionItemResult> itemResults;

    /** 查询用：计划维保日期范围起 */
    private String beginTime;

    /** 查询用：计划维保日期范围止 */
    private String endTime;

    /** 查询用：仅查询指派给本人的巡检任务 */
    private Long queryExecutorId;

    /** 查询用：所属小区ID */
    private Long communityId;

    /** 提交时携带的检查项结果 */
    private List<InspectionItemResult> submitItems;

    // ==================== 统计字段 ====================

    /** 巡检合格率（百分比） */
    private java.math.BigDecimal passRate;

    public Long getRecordId()
    {
        return recordId;
    }

    public void setRecordId(Long recordId)
    {
        this.recordId = recordId;
    }

    public String getRecordNo()
    {
        return recordNo;
    }

    public void setRecordNo(String recordNo)
    {
        this.recordNo = recordNo;
    }

    public Long getPlanId()
    {
        return planId;
    }

    public void setPlanId(Long planId)
    {
        this.planId = planId;
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

    public Date getPlanDate()
    {
        return planDate;
    }

    public void setPlanDate(Date planDate)
    {
        this.planDate = planDate;
    }

    public Long getExecutorId()
    {
        return executorId;
    }

    public void setExecutorId(Long executorId)
    {
        this.executorId = executorId;
    }

    public Date getClockInTime()
    {
        return clockInTime;
    }

    public void setClockInTime(Date clockInTime)
    {
        this.clockInTime = clockInTime;
    }

    public String getClockInLocation()
    {
        return clockInLocation;
    }

    public void setClockInLocation(String clockInLocation)
    {
        this.clockInLocation = clockInLocation;
    }

    public Date getExecuteDate()
    {
        return executeDate;
    }

    public void setExecuteDate(Date executeDate)
    {
        this.executeDate = executeDate;
    }

    public String getExecuteResult()
    {
        return executeResult;
    }

    public void setExecuteResult(String executeResult)
    {
        this.executeResult = executeResult;
    }

    public String getAbnormalDesc()
    {
        return abnormalDesc;
    }

    public void setAbnormalDesc(String abnormalDesc)
    {
        this.abnormalDesc = abnormalDesc;
    }

    public Integer getNormalCount()
    {
        return normalCount;
    }

    public void setNormalCount(Integer normalCount)
    {
        this.normalCount = normalCount;
    }

    public Integer getAbnormalCount()
    {
        return abnormalCount;
    }

    public void setAbnormalCount(Integer abnormalCount)
    {
        this.abnormalCount = abnormalCount;
    }

    public Integer getNaCount()
    {
        return naCount;
    }

    public void setNaCount(Integer naCount)
    {
        this.naCount = naCount;
    }

    public String getRecordStatus()
    {
        return recordStatus;
    }

    public void setRecordStatus(String recordStatus)
    {
        this.recordStatus = recordStatus;
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

    public String getExecutorName()
    {
        return executorName;
    }

    public void setExecutorName(String executorName)
    {
        this.executorName = executorName;
    }

    public List<InspectionItemResult> getItemResults()
    {
        return itemResults;
    }

    public void setItemResults(List<InspectionItemResult> itemResults)
    {
        this.itemResults = itemResults;
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

    public Long getQueryExecutorId()
    {
        return queryExecutorId;
    }

    public void setQueryExecutorId(Long queryExecutorId)
    {
        this.queryExecutorId = queryExecutorId;
    }

    public Long getCommunityId()
    {
        return communityId;
    }

    public void setCommunityId(Long communityId)
    {
        this.communityId = communityId;
    }

    public List<InspectionItemResult> getSubmitItems()
    {
        return submitItems;
    }

    public void setSubmitItems(List<InspectionItemResult> submitItems)
    {
        this.submitItems = submitItems;
    }

    public java.math.BigDecimal getPassRate()
    {
        return passRate;
    }

    public void setPassRate(java.math.BigDecimal passRate)
    {
        this.passRate = passRate;
    }
}
