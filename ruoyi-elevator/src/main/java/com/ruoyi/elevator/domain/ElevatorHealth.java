package com.ruoyi.elevator.domain;

import com.fasterxml.jackson.annotation.JsonFormat;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;

/**
 * 电梯健康评分对象 elevator_health
 * 综合故障率、维保完成率、巡检合格率三项指标为每台电梯生成健康评分
 *
 * @author 董泽晟
 */
public class ElevatorHealth implements Serializable
{
    private static final long serialVersionUID = 1L;

    /** 健康记录ID */
    private Long healthId;

    /** 电梯ID */
    private Long elevatorId;

    /** 统计周期 */
    private String statPeriod;

    /** 统计开始日期 */
    @JsonFormat(pattern = "yyyy-MM-dd")
    private Date statStartDate;

    /** 统计结束日期 */
    @JsonFormat(pattern = "yyyy-MM-dd")
    private Date statEndDate;

    /** 统计周期内故障次数 */
    private Integer faultCount;

    /** 故障率（百分比） */
    private BigDecimal faultRate;

    /** 故障率得分 */
    private BigDecimal faultScore;

    /** 应执行维保次数 */
    private Integer maintainDone;

    /** 实际执行维保次数 */
    private Integer maintainFinish;

    /** 维保完成率（百分比） */
    private BigDecimal maintainRate;

    /** 维保完成率得分 */
    private BigDecimal maintainScore;

    /** 巡检检查项总数 */
    private Integer inspectTotal;

    /** 巡检正常项数 */
    private Integer inspectNormal;

    /** 巡检合格率（百分比） */
    private BigDecimal inspectRate;

    /** 巡检合格率得分 */
    private BigDecimal inspectScore;

    /** 健康评分 */
    private BigDecimal healthScore;

    /**
     * 维保完成率是否参与评分
     * 统计周期内该电梯没有任何维保计划时，维保项无数据，不参与加权
     */
    private Boolean maintainApplicable;

    /**
     * 巡检合格率是否参与评分
     * 统计周期内该电梯没有任何已完成的巡检记录时，巡检项无数据，不参与加权
     */
    private Boolean inspectApplicable;

    /** 健康等级（excellent优秀 good良好 fair一般 poor较差 danger危险） */
    private String healthLevel;

    /** 计算时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date calcTime;

    // ==================== 联表展示字段 ====================

    /** 电梯编号 */
    private String elevatorCode;

    /** 电梯品牌 */
    private String brand;

    /** 小区名称 */
    private String communityName;

    /** 楼栋号 */
    private String buildingNo;

    /** 单元号 */
    private String unitNo;

    /** 小区ID */
    private Long communityId;

    /** 健康等级中文名 */
    private String healthLevelName;

    /** 维护建议 */
    private String suggestion;

    /** 查询用：小区ID */
    private Long queryCommunityId;

    public Long getHealthId()
    {
        return healthId;
    }

    public void setHealthId(Long healthId)
    {
        this.healthId = healthId;
    }

    public Long getElevatorId()
    {
        return elevatorId;
    }

    public void setElevatorId(Long elevatorId)
    {
        this.elevatorId = elevatorId;
    }

    public String getStatPeriod()
    {
        return statPeriod;
    }

    public void setStatPeriod(String statPeriod)
    {
        this.statPeriod = statPeriod;
    }

    public Date getStatStartDate()
    {
        return statStartDate;
    }

    public void setStatStartDate(Date statStartDate)
    {
        this.statStartDate = statStartDate;
    }

    public Date getStatEndDate()
    {
        return statEndDate;
    }

    public void setStatEndDate(Date statEndDate)
    {
        this.statEndDate = statEndDate;
    }

    public Integer getFaultCount()
    {
        return faultCount;
    }

    public void setFaultCount(Integer faultCount)
    {
        this.faultCount = faultCount;
    }

    public BigDecimal getFaultRate()
    {
        return faultRate;
    }

    public void setFaultRate(BigDecimal faultRate)
    {
        this.faultRate = faultRate;
    }

    public BigDecimal getFaultScore()
    {
        return faultScore;
    }

    public void setFaultScore(BigDecimal faultScore)
    {
        this.faultScore = faultScore;
    }

    public Integer getMaintainDone()
    {
        return maintainDone;
    }

    public void setMaintainDone(Integer maintainDone)
    {
        this.maintainDone = maintainDone;
    }

    public Integer getMaintainFinish()
    {
        return maintainFinish;
    }

    public void setMaintainFinish(Integer maintainFinish)
    {
        this.maintainFinish = maintainFinish;
    }

    public BigDecimal getMaintainRate()
    {
        return maintainRate;
    }

    public void setMaintainRate(BigDecimal maintainRate)
    {
        this.maintainRate = maintainRate;
    }

    public BigDecimal getMaintainScore()
    {
        return maintainScore;
    }

    public void setMaintainScore(BigDecimal maintainScore)
    {
        this.maintainScore = maintainScore;
    }

    public Integer getInspectTotal()
    {
        return inspectTotal;
    }

    public void setInspectTotal(Integer inspectTotal)
    {
        this.inspectTotal = inspectTotal;
    }

    public Integer getInspectNormal()
    {
        return inspectNormal;
    }

    public void setInspectNormal(Integer inspectNormal)
    {
        this.inspectNormal = inspectNormal;
    }

    public BigDecimal getInspectRate()
    {
        return inspectRate;
    }

    public void setInspectRate(BigDecimal inspectRate)
    {
        this.inspectRate = inspectRate;
    }

    public BigDecimal getInspectScore()
    {
        return inspectScore;
    }

    public void setInspectScore(BigDecimal inspectScore)
    {
        this.inspectScore = inspectScore;
    }

    public BigDecimal getHealthScore()
    {
        return healthScore;
    }

    public void setHealthScore(BigDecimal healthScore)
    {
        this.healthScore = healthScore;
    }

    public Boolean getMaintainApplicable()
    {
        return maintainApplicable;
    }

    public void setMaintainApplicable(Boolean maintainApplicable)
    {
        this.maintainApplicable = maintainApplicable;
    }

    public Boolean getInspectApplicable()
    {
        return inspectApplicable;
    }

    public void setInspectApplicable(Boolean inspectApplicable)
    {
        this.inspectApplicable = inspectApplicable;
    }

    public String getHealthLevel()
    {
        return healthLevel;
    }

    public void setHealthLevel(String healthLevel)
    {
        this.healthLevel = healthLevel;
    }

    public Date getCalcTime()
    {
        return calcTime;
    }

    public void setCalcTime(Date calcTime)
    {
        this.calcTime = calcTime;
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

    public Long getCommunityId()
    {
        return communityId;
    }

    public void setCommunityId(Long communityId)
    {
        this.communityId = communityId;
    }

    public String getHealthLevelName()
    {
        return healthLevelName;
    }

    public void setHealthLevelName(String healthLevelName)
    {
        this.healthLevelName = healthLevelName;
    }

    public String getSuggestion()
    {
        return suggestion;
    }

    public void setSuggestion(String suggestion)
    {
        this.suggestion = suggestion;
    }

    public Long getQueryCommunityId()
    {
        return queryCommunityId;
    }

    public void setQueryCommunityId(Long queryCommunityId)
    {
        this.queryCommunityId = queryCommunityId;
    }
}
