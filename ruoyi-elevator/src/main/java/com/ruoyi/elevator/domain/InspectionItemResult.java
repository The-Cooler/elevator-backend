package com.ruoyi.elevator.domain;

import java.io.Serializable;

/**
 * 巡检检查项结果对象 inspection_item_result
 *
 * @author 董泽晟
 */
public class InspectionItemResult implements Serializable
{
    private static final long serialVersionUID = 1L;

    /** 结果ID */
    private Long resultId;

    /** 巡检记录ID */
    private Long recordId;

    /** 检查项ID */
    private Long itemId;

    /** 检查项名称 */
    private String itemName;

    /** 检查项分类 */
    private String itemCategory;

    /** 检查结果（normal正常 abnormal异常 na不适用） */
    private String checkResult;

    /** 异常说明 */
    private String abnormalDesc;

    /** 现场照片文件ID */
    private Long fileId;

    /** 排序号 */
    private Integer orderNum;

    // ==================== 联表展示字段 ====================

    /** 检查标准，从检查项模板带出 */
    private String checkStandard;

    /** 现场照片文件名 */
    private String fileName;

    public Long getResultId()
    {
        return resultId;
    }

    public void setResultId(Long resultId)
    {
        this.resultId = resultId;
    }

    public Long getRecordId()
    {
        return recordId;
    }

    public void setRecordId(Long recordId)
    {
        this.recordId = recordId;
    }

    public Long getItemId()
    {
        return itemId;
    }

    public void setItemId(Long itemId)
    {
        this.itemId = itemId;
    }

    public String getItemName()
    {
        return itemName;
    }

    public void setItemName(String itemName)
    {
        this.itemName = itemName;
    }

    public String getItemCategory()
    {
        return itemCategory;
    }

    public void setItemCategory(String itemCategory)
    {
        this.itemCategory = itemCategory;
    }

    public String getCheckResult()
    {
        return checkResult;
    }

    public void setCheckResult(String checkResult)
    {
        this.checkResult = checkResult;
    }

    public String getAbnormalDesc()
    {
        return abnormalDesc;
    }

    public void setAbnormalDesc(String abnormalDesc)
    {
        this.abnormalDesc = abnormalDesc;
    }

    public Long getFileId()
    {
        return fileId;
    }

    public void setFileId(Long fileId)
    {
        this.fileId = fileId;
    }

    public Integer getOrderNum()
    {
        return orderNum;
    }

    public void setOrderNum(Integer orderNum)
    {
        this.orderNum = orderNum;
    }

    public String getCheckStandard()
    {
        return checkStandard;
    }

    public void setCheckStandard(String checkStandard)
    {
        this.checkStandard = checkStandard;
    }

    public String getFileName()
    {
        return fileName;
    }

    public void setFileName(String fileName)
    {
        this.fileName = fileName;
    }
}
