package com.ruoyi.elevator.domain;

import com.fasterxml.jackson.annotation.JsonFormat;

import java.io.Serializable;
import java.util.Date;

/**
 * 预警信息对象 warning_info
 *
 * @author 董泽晟
 */
public class WarningInfo implements Serializable
{
    private static final long serialVersionUID = 1L;

    /** 预警ID */
    private Long warningId;

    /** 触发规则ID */
    private Long ruleId;

    /** 预警类型（order_timeout工单超时 maintain_due维保临期） */
    private String warningType;

    /** 业务子类型 */
    private String bizSubType;

    /** 关联业务ID */
    private Long bizId;

    /** 关联业务编号 */
    private String bizNo;

    /** 预警内容 */
    private String warningContent;

    /** 关联电梯ID */
    private Long elevatorId;

    /** 接收人ID */
    private Long receiverId;

    /** 接收人角色 */
    private String receiverRole;

    /** 是否已读（0未读 1已读） */
    private String isRead;

    /** 阅读时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date readTime;

    /** 预警生成时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date warningTime;

    /** 创建时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date createTime;

    // ==================== 联表展示字段 ====================

    /** 电梯编号 */
    private String elevatorCode;

    /** 小区名称 */
    private String communityName;

    /** 接收人姓名 */
    private String receiverName;

    /** 预警类型中文名 */
    private String warningTypeName;

    /** 查询用：预警时间范围起 */
    private String beginTime;

    /** 查询用：预警时间范围止 */
    private String endTime;

    /** 查询用：仅查询本人的预警 */
    private Long queryReceiverId;

    public Long getWarningId()
    {
        return warningId;
    }

    public void setWarningId(Long warningId)
    {
        this.warningId = warningId;
    }

    public Long getRuleId()
    {
        return ruleId;
    }

    public void setRuleId(Long ruleId)
    {
        this.ruleId = ruleId;
    }

    public String getWarningType()
    {
        return warningType;
    }

    public void setWarningType(String warningType)
    {
        this.warningType = warningType;
    }

    public String getBizSubType()
    {
        return bizSubType;
    }

    public void setBizSubType(String bizSubType)
    {
        this.bizSubType = bizSubType;
    }

    public Long getBizId()
    {
        return bizId;
    }

    public void setBizId(Long bizId)
    {
        this.bizId = bizId;
    }

    public String getBizNo()
    {
        return bizNo;
    }

    public void setBizNo(String bizNo)
    {
        this.bizNo = bizNo;
    }

    public String getWarningContent()
    {
        return warningContent;
    }

    public void setWarningContent(String warningContent)
    {
        this.warningContent = warningContent;
    }

    public Long getElevatorId()
    {
        return elevatorId;
    }

    public void setElevatorId(Long elevatorId)
    {
        this.elevatorId = elevatorId;
    }

    public Long getReceiverId()
    {
        return receiverId;
    }

    public void setReceiverId(Long receiverId)
    {
        this.receiverId = receiverId;
    }

    public String getReceiverRole()
    {
        return receiverRole;
    }

    public void setReceiverRole(String receiverRole)
    {
        this.receiverRole = receiverRole;
    }

    public String getIsRead()
    {
        return isRead;
    }

    public void setIsRead(String isRead)
    {
        this.isRead = isRead;
    }

    public Date getReadTime()
    {
        return readTime;
    }

    public void setReadTime(Date readTime)
    {
        this.readTime = readTime;
    }

    public Date getWarningTime()
    {
        return warningTime;
    }

    public void setWarningTime(Date warningTime)
    {
        this.warningTime = warningTime;
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

    public String getReceiverName()
    {
        return receiverName;
    }

    public void setReceiverName(String receiverName)
    {
        this.receiverName = receiverName;
    }

    public String getWarningTypeName()
    {
        return warningTypeName;
    }

    public void setWarningTypeName(String warningTypeName)
    {
        this.warningTypeName = warningTypeName;
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

    public Long getQueryReceiverId()
    {
        return queryReceiverId;
    }

    public void setQueryReceiverId(Long queryReceiverId)
    {
        this.queryReceiverId = queryReceiverId;
    }
}
