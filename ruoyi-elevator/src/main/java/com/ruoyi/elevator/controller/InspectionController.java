package com.ruoyi.elevator.controller;

import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.elevator.domain.InspectionRecord;
import com.ruoyi.elevator.domain.MaintainItem;
import com.ruoyi.elevator.service.InspectionService;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * 定期巡检执行
 * 对应论文模块四的定期巡检执行子功能
 * 系统按周期自动生成巡检工单并派发，维修员现场打卡、勾选检查项并上传结果
 *
 * @author 董泽晟
 */
@RestController
@RequestMapping("/maintain/inspection")
public class InspectionController extends BaseController
{
    @Autowired
    private InspectionService inspectionService;

    /**
     * 查询巡检记录列表
     */
    @PreAuthorize("@ss.hasPermi('maintain:inspection:list')")
    @GetMapping("/list")
    public TableDataInfo list(InspectionRecord inspectionRecord)
    {
        startPage();
        List<InspectionRecord> list = inspectionService.selectInspectionRecordList(inspectionRecord);
        return getDataTable(list);
    }

    /**
     * 查询指派给当前维修员的巡检任务
     */
    @PreAuthorize("@ss.hasPermi('maintain:inspection:list')")
    @GetMapping("/myList")
    public TableDataInfo myList(InspectionRecord inspectionRecord)
    {
        startPage();
        List<InspectionRecord> list = inspectionService.myList(inspectionRecord);
        return getDataTable(list);
    }

    /**
     * 查询巡检记录详情，含检查项结果明细
     */
    @PreAuthorize("@ss.hasPermi('maintain:inspection:query')")
    @GetMapping("/{recordId}")
    public AjaxResult getInfo(@PathVariable("recordId") Long recordId)
    {
        return success(inspectionService.selectInspectionRecordById(recordId));
    }

    /**
     * 查询巡检任务应执行的检查项清单
     */
    @PreAuthorize("@ss.hasPermi('maintain:inspection:query')")
    @GetMapping("/items/{recordId}")
    public AjaxResult items(@PathVariable("recordId") Long recordId)
    {
        return success(inspectionService.selectItemsForRecord(recordId));
    }

    /**
     * 按电梯查询检查项清单，供无巡检工单时预览
     */
    @PreAuthorize("@ss.hasPermi('maintain:inspection:query')")
    @GetMapping("/itemsByElevator")
    public AjaxResult itemsByElevator(@RequestParam("elevatorId") Long elevatorId,
                                      @RequestParam(value = "maintainType", required = false) String maintainType)
    {
        List<MaintainItem> items = inspectionService.selectItemsByElevator(elevatorId, maintainType);
        return success(items);
    }

    /**
     * 现场打卡
     */
    @PreAuthorize("@ss.hasPermi('maintain:inspection:execute')")
    @Log(title = "巡检打卡", businessType = BusinessType.UPDATE)
    @PostMapping("/clockIn")
    public AjaxResult clockIn(@RequestParam("recordId") Long recordId,
                              @RequestParam(value = "location", required = false) String location)
    {
        return toAjax(inspectionService.clockIn(recordId, location));
    }

    /**
     * 提交巡检结果，逐项记录检查结果并归档
     */
    @PreAuthorize("@ss.hasPermi('maintain:inspection:execute')")
    @Log(title = "巡检提交", businessType = BusinessType.UPDATE)
    @PostMapping("/submit")
    public AjaxResult submit(@RequestBody InspectionRecord record)
    {
        return toAjax(inspectionService.submit(record));
    }

    /**
     * 手动触发巡检工单生成，供演示与管理员手动补录使用
     */
    @PreAuthorize("@ss.hasPermi('maintain:inspection:execute')")
    @Log(title = "手动生成巡检工单", businessType = BusinessType.INSERT)
    @PostMapping("/generate")
    public AjaxResult generate()
    {
        int count = inspectionService.generateInspectionTasks();
        return AjaxResult.success("本次生成巡检工单 " + count + " 条");
    }

    /**
     * 导出巡检记录
     */
    @PreAuthorize("@ss.hasPermi('maintain:inspection:export')")
    @Log(title = "巡检记录", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, InspectionRecord inspectionRecord)
    {
        List<InspectionRecord> list = inspectionService.selectInspectionRecordList(inspectionRecord);
        ExcelUtil<InspectionRecord> util = new ExcelUtil<>(InspectionRecord.class);
        util.exportExcel(response, list, "巡检记录");
    }
}
