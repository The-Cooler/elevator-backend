package com.ruoyi.elevator.domain;

import com.fasterxml.jackson.annotation.JsonFormat;

import java.io.Serializable;
import java.util.Date;

/**
 * 文件信息对象 sys_file
 * 统一存储电梯证件附件、报修证据、巡检结果、导出文件
 *
 * 类名使用 ElevatorFile 而非 SysFile，避免与 RuoYi 框架自带的
 * com.ruoyi.framework.web.domain.server.SysFile 在 MyBatis 类型别名上冲突。
 *
 * @author 董泽晟
 */
public class ElevatorFile implements Serializable
{
    private static final long serialVersionUID = 1L;

    /** 文件ID */
    private Long fileId;

    /** 原文件名 */
    private String fileName;

    /** 存储路径 */
    private String filePath;

    /** 访问地址 */
    private String fileUrl;

    /** 文件类型（image图片 video视频 doc文档 excel表格 pdf文档） */
    private String fileType;

    /** 文件后缀 */
    private String fileSuffix;

    /** 文件大小（字节） */
    private Long fileSize;

    /** 业务类型 */
    private String bizType;

    /** 关联业务ID */
    private Long bizId;

    /** 上传人 */
    private String uploadBy;

    /** 上传时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date uploadTime;

    /** 删除标志 */
    private String delFlag;

    public Long getFileId()
    {
        return fileId;
    }

    public void setFileId(Long fileId)
    {
        this.fileId = fileId;
    }

    public String getFileName()
    {
        return fileName;
    }

    public void setFileName(String fileName)
    {
        this.fileName = fileName;
    }

    public String getFilePath()
    {
        return filePath;
    }

    public void setFilePath(String filePath)
    {
        this.filePath = filePath;
    }

    public String getFileUrl()
    {
        return fileUrl;
    }

    public void setFileUrl(String fileUrl)
    {
        this.fileUrl = fileUrl;
    }

    public String getFileType()
    {
        return fileType;
    }

    public void setFileType(String fileType)
    {
        this.fileType = fileType;
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

    public String getBizType()
    {
        return bizType;
    }

    public void setBizType(String bizType)
    {
        this.bizType = bizType;
    }

    public Long getBizId()
    {
        return bizId;
    }

    public void setBizId(Long bizId)
    {
        this.bizId = bizId;
    }

    public String getUploadBy()
    {
        return uploadBy;
    }

    public void setUploadBy(String uploadBy)
    {
        this.uploadBy = uploadBy;
    }

    public Date getUploadTime()
    {
        return uploadTime;
    }

    public void setUploadTime(Date uploadTime)
    {
        this.uploadTime = uploadTime;
    }

    public String getDelFlag()
    {
        return delFlag;
    }

    public void setDelFlag(String delFlag)
    {
        this.delFlag = delFlag;
    }
}
