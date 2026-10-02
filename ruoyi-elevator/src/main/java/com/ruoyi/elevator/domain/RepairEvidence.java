package com.ruoyi.elevator.domain;

import com.fasterxml.jackson.annotation.JsonFormat;

import java.io.Serializable;
import java.util.Date;

/**
 * 报修证据附件对象 repair_evidence
 *
 * @author 董泽晟
 */
public class RepairEvidence implements Serializable
{
    private static final long serialVersionUID = 1L;

    /** 证据ID */
    private Long evidenceId;

    /** 关联工单ID */
    private Long orderId;

    /** 文件ID */
    private Long fileId;

    /** 证据类型（image图片 video视频） */
    private String evidenceType;

    /** 上传时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date uploadTime;

    /** 创建者 */
    private String createBy;

    /** 删除标志 */
    private String delFlag;

    // ==================== 联表展示字段 ====================

    /** 原文件名 */
    private String fileName;

    /** 文件后缀 */
    private String fileSuffix;

    /** 文件大小 */
    private Long fileSize;

    /** 工单编号，证据库列表展示用 */
    private String orderNo;

    /** 电梯编号，证据库列表展示用 */
    private String elevatorCode;

    /** 查询用：上传时间范围起 */
    private String beginTime;

    /** 查询用：上传时间范围止 */
    private String endTime;

    public Long getEvidenceId()
    {
        return evidenceId;
    }

    public void setEvidenceId(Long evidenceId)
    {
        this.evidenceId = evidenceId;
    }

    public Long getOrderId()
    {
        return orderId;
    }

    public void setOrderId(Long orderId)
    {
        this.orderId = orderId;
    }

    public Long getFileId()
    {
        return fileId;
    }

    public void setFileId(Long fileId)
    {
        this.fileId = fileId;
    }

    public String getEvidenceType()
    {
        return evidenceType;
    }

    public void setEvidenceType(String evidenceType)
    {
        this.evidenceType = evidenceType;
    }

    public Date getUploadTime()
    {
        return uploadTime;
    }

    public void setUploadTime(Date uploadTime)
    {
        this.uploadTime = uploadTime;
    }

    public String getCreateBy()
    {
        return createBy;
    }

    public void setCreateBy(String createBy)
    {
        this.createBy = createBy;
    }

    public String getDelFlag()
    {
        return delFlag;
    }

    public void setDelFlag(String delFlag)
    {
        this.delFlag = delFlag;
    }

    public String getFileName()
    {
        return fileName;
    }

    public void setFileName(String fileName)
    {
        this.fileName = fileName;
    }

    public String getFileSuffix()
    {
        return fileSuffix;
    }

    public void setFileSuffix(String fileSuffix)
    {
        this.fileSuffix = fileSuffix;
    }

    public Long getFileSize()
    {
        return fileSize;
    }

    public void setFileSize(Long fileSize)
    {
        this.fileSize = fileSize;
    }

    public String getOrderNo()
    {
        return orderNo;
    }

    public void setOrderNo(String orderNo)
    {
        this.orderNo = orderNo;
    }

    public String getElevatorCode()
    {
        return elevatorCode;
    }

    public void setElevatorCode(String elevatorCode)
    {
        this.elevatorCode = elevatorCode;
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
}
