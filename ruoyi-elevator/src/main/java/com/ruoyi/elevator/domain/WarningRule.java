package com.ruoyi.elevator.domain;

import com.fasterxml.jackson.annotation.JsonFormat;

import java.io.Serializable;
import java.util.Date;

/**
 * 预警规则对象 warning_rule
 * 对应论文模块五超期预警监控子功能中「预警时限可配置」的实现约束
 *
 * @author 董泽晟
 */
public class WarningRule implements Serializable
{
    private static final long serialVersionUID = 1L;

    /** 规则ID */
    private Long ruleId;

    /** 规则名称 */
    private String ruleName;

    /** 规则类型（order_timeout工单超时 maintain_due维保临期） */
    private String ruleType;

    /** 业务子类型 */
    private String bizSubType;

    /** 阈值 */
    private Integer thresholdValue;

    /** 阈值单位（minute分钟 hour小时 day天） */
    private String thresholdUnit;

    /** 通知对象角色，多个用逗号分隔 */
    private String notifyRoles;

    /** 是否启用（0启用 1停用） */
    private String enabled;

    /** 重复推送间隔（分钟），0表示同周期不重复推送 */
    private Integer repeatInterval;

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

    /** 规则类型中文名，列表展示用 */
    private String ruleTypeName;

    /** 业务子类型中文名，列表展示用 */
    private String bizSubTypeName;

    public Long getRuleId()
    {
        return ruleId;
    }

    public void setRuleId(Long ruleId)
    {
        this.ruleId = ruleId;
    }

    public String getRuleName()
    {
        return ruleName;
    }

    public void setRuleName(String ruleName)
    {
        this.ruleName = ruleName;
    }

    public String getRuleType()
    {
        return ruleType;
    }

    public void setRuleType(String ruleType)
    {
        this.ruleType = ruleType;
    }

    public String getBizSubType()
    {
        return bizSubType;
    }

    public void setBizSubType(String bizSubType)
    {
        this.bizSubType = bizSubType;
    }

    public Integer getThresholdValue()
    {
        return thresholdValue;
    }

    public void setThresholdValue(Integer thresholdValue)
    {
        this.thresholdValue = thresholdValue;
    }

    public String getThresholdUnit()
    {
        return thresholdUnit;
    }

    public void setThresholdUnit(String thresholdUnit)
    {
        this.thresholdUnit = thresholdUnit;
    }

    public String getNotifyRoles()
    {
        return notifyRoles;
    }

    public void setNotifyRoles(String notifyRoles)
    {
        this.notifyRoles = notifyRoles;
    }

    public String getEnabled()
    {
        return enabled;
    }

    public void setEnabled(String enabled)
    {
        this.enabled = enabled;
    }

    public Integer getRepeatInterval()
    {
        return repeatInterval;
    }

    public void setRepeatInterval(Integer repeatInterval)
    {
        this.repeatInterval = repeatInterval;
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

    public String getRuleTypeName()
    {
        return ruleTypeName;
    }

    public void setRuleTypeName(String ruleTypeName)
    {
        this.ruleTypeName = ruleTypeName;
    }

    public String getBizSubTypeName()
    {
        return bizSubTypeName;
    }

    public void setBizSubTypeName(String bizSubTypeName)
    {
        this.bizSubTypeName = bizSubTypeName;
    }
}
