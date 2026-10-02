package com.ruoyi.elevator.domain;

import com.fasterxml.jackson.annotation.JsonFormat;

import java.io.Serializable;
import java.util.Date;

/**
 * 电梯信息对象 elevator
 *
 * @author 董泽晟
 */
public class Elevator implements Serializable
{
    private static final long serialVersionUID = 1L;

    /** 电梯ID */
    private Long elevatorId;

    /** 电梯编号 */
    private String elevatorCode;

    /** 品牌 */
    private String brand;

    /** 型号 */
    private String model;

    /** 所在楼栋ID */
    private Long buildingId;

    /** 单元号 */
    private String unitNo;

    /** 维保单位 */
    private String maintainUnit;

    /** 投用日期 */
    @JsonFormat(pattern = "yyyy-MM-dd")
    private Date installDate;

    /** 使用年限 */
    private Integer serviceYears;

    /** 年检报告附件ID */
    private Long certFileId;

    /** 状态（0正常运行 1停梯检修 2已报废） */
    private String status;

    /** 删除标志 */
    private String delFlag;

    /** 所属小区ID，联表查询返回，用于前端级联展示 */
    private Long communityId;

    /** 所属小区名称，联表查询返回 */
    private String communityName;

    /** 所在楼栋号，联表查询返回 */
    private String buildingNo;

    /** 年检报告文件名，联表查询返回 */
    private String certFileName;

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

    public Long getElevatorId()
    {
        return elevatorId;
    }

    public void setElevatorId(Long elevatorId)
    {
        this.elevatorId = elevatorId;
    }

    public String getElevatorCode()
    {
        return elevatorCode;
    }

    public void setElevatorCode(String elevatorCode)
    {
        this.elevatorCode = elevatorCode;
    }

    public String getBrand()
    {
        return brand;
    }

    public void setBrand(String brand)
    {
        this.brand = brand;
    }

    public String getModel()
    {
        return model;
    }

    public void setModel(String model)
    {
        this.model = model;
    }

    public Long getBuildingId()
    {
        return buildingId;
    }

    public void setBuildingId(Long buildingId)
    {
        this.buildingId = buildingId;
    }

    public String getUnitNo()
    {
        return unitNo;
    }

    public void setUnitNo(String unitNo)
    {
        this.unitNo = unitNo;
    }

    public String getMaintainUnit()
    {
        return maintainUnit;
    }

    public void setMaintainUnit(String maintainUnit)
    {
        this.maintainUnit = maintainUnit;
    }

    public Date getInstallDate()
    {
        return installDate;
    }

    public void setInstallDate(Date installDate)
    {
        this.installDate = installDate;
    }

    public Integer getServiceYears()
    {
        return serviceYears;
    }

    public void setServiceYears(Integer serviceYears)
    {
        this.serviceYears = serviceYears;
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

    public String getCertFileName()
    {
        return certFileName;
    }

    public void setCertFileName(String certFileName)
    {
        this.certFileName = certFileName;
    }

    public Long getCertFileId()
    {
        return certFileId;
    }

    public void setCertFileId(Long certFileId)
    {
        this.certFileId = certFileId;
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
}
