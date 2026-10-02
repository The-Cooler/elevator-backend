package com.ruoyi.elevator.domain;

import com.ruoyi.common.annotation.Excel;
import java.io.Serializable;

/**
 * 故障频次统计导出对象
 * 用于把按电梯统计的故障次数导出为 Excel，对应论文模块五「统计结果可导出」的要求
 *
 * @author 董泽晟
 */
public class FaultFrequencyExport implements Serializable
{
    private static final long serialVersionUID = 1L;

    /** 电梯编号 */
    @Excel(name = "电梯编号")
    private String elevatorCode;

    /** 所在小区 */
    @Excel(name = "所在小区")
    private String communityName;

    /** 所在楼栋 */
    @Excel(name = "所在楼栋")
    private String buildingNo;

    /** 故障次数 */
    @Excel(name = "故障次数")
    private Integer faultCount;

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

    public Integer getFaultCount()
    {
        return faultCount;
    }

    public void setFaultCount(Integer faultCount)
    {
        this.faultCount = faultCount;
    }
}
