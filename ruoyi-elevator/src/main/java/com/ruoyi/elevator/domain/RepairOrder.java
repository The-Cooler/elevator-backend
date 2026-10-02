package com.ruoyi.elevator.domain;

import com.fasterxml.jackson.annotation.JsonFormat;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

/**
 * 报修工单对象 repair_order
 *
 * @author 董泽晟
 */
public class RepairOrder implements Serializable
{
    private static final long serialVersionUID = 1L;

    /** 工单ID */
    private Long orderId;

    /** 工单编号 */
    private String orderNo;

    /** 报修人ID */
    private Long userId;

    /** 故障电梯ID */
    private Long elevatorId;

    /** 故障现象描述 */
    private String faultDesc;

    /** 故障类型 */
    private String faultType;

    /** 故障等级（0紧急 1一般） */
    private String faultLevel;

    /** 工单状态 */
    private String orderStatus;

    /** 报修人联系电话 */
    private String reporterPhone;

    /** 报修时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date reportTime;

    /** 派单时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date assignTime;

    /** 接单时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date acceptTime;

    /** 到场时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date arriveTime;

    /** 维修完成时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date finishTime;

    /** 业主确认时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date confirmTime;

    /** 维修员ID */
    private Long assigneeId;

    /** 派单人ID */
    private Long assignerId;

    /** 驳回原因 */
    private String rejectReason;

    /** 处理时限 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date deadlineTime;

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

    /** 报修人姓名 */
    private String reporterName;

    /** 报修人电话，联表查询返回 */
    private String reporterPhoneNo;

    /** 电梯编号 */
    private String elevatorCode;

    /** 电梯品牌 */
    private String elevatorBrand;

    /** 小区ID */
    private Long communityId;

    /** 小区名称 */
    private String communityName;

    /** 楼栋号 */
    private String buildingNo;

    /** 单元号 */
    private String unitNo;

    /** 维修员姓名 */
    private String assigneeName;

    /** 维修员电话 */
    private String assigneePhone;

    /** 派单人姓名 */
    private String assignerName;

    /** 证据附件列表 */
    private List<RepairEvidence> evidenceList;

    /** 状态流转记录，进度跟踪用 */
    private List<OrderStatusLog> statusLogs;

    /** 维修记录，进度跟踪用 */
    private RepairRecord repairRecord;

    /** 查询用：报修时间范围起 */
    private String beginTime;

    /** 查询用：报修时间范围止 */
    private String endTime;

    /** 查询用：仅查询本人报修 */
    private Long queryUserId;

    /** 查询用：仅查询指派给本人的工单 */
    private Long queryAssigneeId;

    /** 批量操作用：工单ID数组 */
    private Long[] orderIds;

    /** 接单时填写的预计到场分钟数 */
    private Integer arriveMinutes;

    /** 到场时填写的定位信息 */
    private String arriveLocation;

    /** 查询用：所在楼栋ID */
    private Long buildingId;

    public Long getOrderId()
    {
        return orderId;
    }

    public void setOrderId(Long orderId)
    {
        this.orderId = orderId;
    }

    public String getOrderNo()
    {
        return orderNo;
    }

    public void setOrderNo(String orderNo)
    {
        this.orderNo = orderNo;
    }

    public Long getUserId()
    {
        return userId;
    }

    public void setUserId(Long userId)
    {
        this.userId = userId;
    }

    public Long getElevatorId()
    {
        return elevatorId;
    }

    public void setElevatorId(Long elevatorId)
    {
        this.elevatorId = elevatorId;
    }

    public String getFaultDesc()
    {
        return faultDesc;
    }

    public void setFaultDesc(String faultDesc)
    {
        this.faultDesc = faultDesc;
    }

    public String getFaultType()
    {
        return faultType;
    }

    public void setFaultType(String faultType)
    {
        this.faultType = faultType;
    }

    public String getFaultLevel()
    {
        return faultLevel;
    }

    public void setFaultLevel(String faultLevel)
    {
        this.faultLevel = faultLevel;
    }

    public String getOrderStatus()
    {
        return orderStatus;
    }

    public void setOrderStatus(String orderStatus)
    {
        this.orderStatus = orderStatus;
    }

    public String getReporterPhone()
    {
        return reporterPhone;
    }

    public void setReporterPhone(String reporterPhone)
    {
        this.reporterPhone = reporterPhone;
    }

    public Date getReportTime()
    {
        return reportTime;
    }

    public void setReportTime(Date reportTime)
    {
        this.reportTime = reportTime;
    }

    public Date getAssignTime()
    {
        return assignTime;
    }

    public void setAssignTime(Date assignTime)
    {
        this.assignTime = assignTime;
    }

    public Date getAcceptTime()
    {
        return acceptTime;
    }

    public void setAcceptTime(Date acceptTime)
    {
        this.acceptTime = acceptTime;
    }

    public Date getArriveTime()
    {
        return arriveTime;
    }

    public void setArriveTime(Date arriveTime)
    {
        this.arriveTime = arriveTime;
    }

    public Date getFinishTime()
    {
        return finishTime;
    }

    public void setFinishTime(Date finishTime)
    {
        this.finishTime = finishTime;
    }

    public Date getConfirmTime()
    {
        return confirmTime;
    }

    public void setConfirmTime(Date confirmTime)
    {
        this.confirmTime = confirmTime;
    }

    public Long getAssigneeId()
    {
        return assigneeId;
    }

    public void setAssigneeId(Long assigneeId)
    {
        this.assigneeId = assigneeId;
    }

    public Long getAssignerId()
    {
        return assignerId;
    }

    public void setAssignerId(Long assignerId)
    {
        this.assignerId = assignerId;
    }

    public String getRejectReason()
    {
        return rejectReason;
    }

    public void setRejectReason(String rejectReason)
    {
        this.rejectReason = rejectReason;
    }

    public Date getDeadlineTime()
    {
        return deadlineTime;
    }

    public void setDeadlineTime(Date deadlineTime)
    {
        this.deadlineTime = deadlineTime;
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

    public String getReporterName()
    {
        return reporterName;
    }

    public void setReporterName(String reporterName)
    {
        this.reporterName = reporterName;
    }

    public String getReporterPhoneNo()
    {
        return reporterPhoneNo;
    }

    public void setReporterPhoneNo(String reporterPhoneNo)
    {
        this.reporterPhoneNo = reporterPhoneNo;
    }

    public String getElevatorCode()
    {
        return elevatorCode;
    }

    public void setElevatorCode(String elevatorCode)
    {
        this.elevatorCode = elevatorCode;
    }

    public String getElevatorBrand()
    {
        return elevatorBrand;
    }

    public void setElevatorBrand(String elevatorBrand)
    {
        this.elevatorBrand = elevatorBrand;
    }

    public Long getCommunityId()
    {
        return communityId;
    }

    public void setCommunityId(Long communityId)
    {
        this.communityId = communityId;
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

    public String getAssigneeName()
    {
        return assigneeName;
    }

    public void setAssigneeName(String assigneeName)
    {
        this.assigneeName = assigneeName;
    }

    public String getAssigneePhone()
    {
        return assigneePhone;
    }

    public void setAssigneePhone(String assigneePhone)
    {
        this.assigneePhone = assigneePhone;
    }

    public String getAssignerName()
    {
        return assignerName;
    }

    public void setAssignerName(String assignerName)
    {
        this.assignerName = assignerName;
    }

    public List<RepairEvidence> getEvidenceList()
    {
        return evidenceList;
    }

    public void setEvidenceList(List<RepairEvidence> evidenceList)
    {
        this.evidenceList = evidenceList;
    }

    public List<OrderStatusLog> getStatusLogs()
    {
        return statusLogs;
    }

    public void setStatusLogs(List<OrderStatusLog> statusLogs)
    {
        this.statusLogs = statusLogs;
    }

    public RepairRecord getRepairRecord()
    {
        return repairRecord;
    }

    public void setRepairRecord(RepairRecord repairRecord)
    {
        this.repairRecord = repairRecord;
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

    public Long getQueryUserId()
    {
        return queryUserId;
    }

    public void setQueryUserId(Long queryUserId)
    {
        this.queryUserId = queryUserId;
    }

    public Long getQueryAssigneeId()
    {
        return queryAssigneeId;
    }

    public void setQueryAssigneeId(Long queryAssigneeId)
    {
        this.queryAssigneeId = queryAssigneeId;
    }

    public Long[] getOrderIds()
    {
        return orderIds;
    }

    public void setOrderIds(Long[] orderIds)
    {
        this.orderIds = orderIds;
    }

    public Integer getArriveMinutes()
    {
        return arriveMinutes;
    }

    public void setArriveMinutes(Integer arriveMinutes)
    {
        this.arriveMinutes = arriveMinutes;
    }

    public String getArriveLocation()
    {
        return arriveLocation;
    }

    public void setArriveLocation(String arriveLocation)
    {
        this.arriveLocation = arriveLocation;
    }

    public Long getBuildingId()
    {
        return buildingId;
    }

    public void setBuildingId(Long buildingId)
    {
        this.buildingId = buildingId;
    }
}
