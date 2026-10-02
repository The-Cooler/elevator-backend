package com.ruoyi.elevator.domain;

import com.fasterxml.jackson.annotation.JsonFormat;

import java.io.Serializable;
import java.util.Date;

/**
 * 小区信息对象 community
 *
 * @author 董泽晟
 */
public class Community implements Serializable
{
    private static final long serialVersionUID = 1L;

    /** 小区ID */
    private Long communityId;

    /** 小区名称 */
    private String communityName;

    /** 小区地址 */
    private String address;

    /** 建成时间 */
    private String buildYear;

    /** 物业联系人 */
    private String propertyContact;

    /** 物业联系电话 */
    private String propertyPhone;

    /** 状态（0正常 1停用） */
    private String status;

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

    /** 该小区下楼栋数量，列表展示用 */
    private Integer buildingCount;

    /** 该小区下电梯数量，列表展示用 */
    private Integer elevatorCount;

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

    public String getAddress()
    {
        return address;
    }

    public void setAddress(String address)
    {
        this.address = address;
    }

    public String getBuildYear()
    {
        return buildYear;
    }

    public void setBuildYear(String buildYear)
    {
        this.buildYear = buildYear;
    }

    public String getPropertyContact()
    {
        return propertyContact;
    }

    public void setPropertyContact(String propertyContact)
    {
        this.propertyContact = propertyContact;
    }

    public String getPropertyPhone()
    {
        return propertyPhone;
    }

    public void setPropertyPhone(String propertyPhone)
    {
        this.propertyPhone = propertyPhone;
    }

    public String getStatus()
    {
        return status;
    }

    public void setStatus(String status)
    {
        this.status = status;
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

    public Integer getBuildingCount()
    {
        return buildingCount;
    }

    public void setBuildingCount(Integer buildingCount)
    {
        this.buildingCount = buildingCount;
    }

    public Integer getElevatorCount()
    {
        return elevatorCount;
    }

    public void setElevatorCount(Integer elevatorCount)
    {
        this.elevatorCount = elevatorCount;
    }
}
