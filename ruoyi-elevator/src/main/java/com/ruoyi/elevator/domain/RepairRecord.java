package com.ruoyi.elevator.domain;

import com.fasterxml.jackson.annotation.JsonFormat;

import java.io.Serializable;
import java.util.Date;

/**
 * 维修记录对象 repair_record
 *
 * @author 董泽晟
 */
public class RepairRecord implements Serializable
{
    private static final long serialVersionUID = 1L;

    /** 记录ID */
    private Long recordId;

    /** 关联工单ID */
    private Long orderId;

    /** 维修员ID */
    private Long workerId;

    /** 到场时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date arriveTime;

    /** 到场定位 */
    private String arriveLocation;

    /** 排查记录 */
    private String investigateNote;

    /** 维修说明 */
    private String repairDesc;

    /** 故障原因 */
    private String faultReason;

    /** 更换配件 */
    private String replaceParts;

    /** 完工时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date finishTime;

    /** 完工凭证文件ID */
    private Long resultFileId;

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

    /** 维修员姓名，联表查询返回 */
    private String workerName;

    /** 完工凭证文件名，联表查询返回 */
    private String resultFileName;

    public Long getRecordId()
    {
        return recordId;
    }

    public void setRecordId(Long recordId)
    {
        this.recordId = recordId;
    }

    public Long getOrderId()
    {
        return orderId;
    }

    public void setOrderId(Long orderId)
    {
        this.orderId = orderId;
    }

    public Long getWorkerId()
    {
        return workerId;
    }

    public void setWorkerId(Long workerId)
    {
        this.workerId = workerId;
    }

    public Date getArriveTime()
    {
        return arriveTime;
    }

    public void setArriveTime(Date arriveTime)
    {
        this.arriveTime = arriveTime;
    }

    public String getArriveLocation()
    {
        return arriveLocation;
    }

    public void setArriveLocation(String arriveLocation)
    {
        this.arriveLocation = arriveLocation;
    }

    public String getInvestigateNote()
    {
        return investigateNote;
    }

    public void setInvestigateNote(String investigateNote)
    {
        this.investigateNote = investigateNote;
    }

    public String getRepairDesc()
    {
        return repairDesc;
    }

    public void setRepairDesc(String repairDesc)
    {
        this.repairDesc = repairDesc;
    }

    public String getFaultReason()
    {
        return faultReason;
    }

    public void setFaultReason(String faultReason)
    {
        this.faultReason = faultReason;
    }

    public String getReplaceParts()
    {
        return replaceParts;
    }

    public void setReplaceParts(String replaceParts)
    {
        this.replaceParts = replaceParts;
    }

    public Date getFinishTime()
    {
        return finishTime;
    }

    public void setFinishTime(Date finishTime)
    {
        this.finishTime = finishTime;
    }

    public Long getResultFileId()
    {
        return resultFileId;
    }

    public void setResultFileId(Long resultFileId)
    {
        this.resultFileId = resultFileId;
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

    public String getWorkerName()
    {
        return workerName;
    }

    public void setWorkerName(String workerName)
    {
        this.workerName = workerName;
    }

    public String getResultFileName()
    {
        return resultFileName;
    }

    public void setResultFileName(String resultFileName)
    {
        this.resultFileName = resultFileName;
    }
}
