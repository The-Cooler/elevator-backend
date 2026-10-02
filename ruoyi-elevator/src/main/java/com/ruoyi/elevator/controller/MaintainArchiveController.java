package com.ruoyi.elevator.controller;

import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.elevator.domain.MaintainArchive;
import com.ruoyi.elevator.service.InspectionService;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.math.BigDecimal;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * 维保档案归档
 * 对应论文模块四的维保档案归档子功能
 * 自动汇总每次维保与巡检详情，形成电梯全生命周期历史维保记录
 *
 * @author 董泽晟
 */
@RestController
@RequestMapping("/maintain/archive")
public class MaintainArchiveController extends BaseController
{
    @Autowired
    private InspectionService inspectionService;

    /**
     * 查询维保档案列表
     */
    @PreAuthorize("@ss.hasPermi('maintain:archive:list')")
    @GetMapping("/list")
    public TableDataInfo list(MaintainArchive archive)
    {
        startPage();
        List<MaintainArchive> list = inspectionService.selectArchiveList(archive);
        return getDataTable(list);
    }

    /**
     * 查询指定电梯的完整维保履历
     */
    @PreAuthorize("@ss.hasPermi('maintain:archive:query')")
    @GetMapping("/byElevator/{elevatorId}")
    public AjaxResult byElevator(@PathVariable("elevatorId") Long elevatorId)
    {
        return success(inspectionService.selectArchiveByElevator(elevatorId));
    }

    /**
     * 查询档案详情
     */
    @PreAuthorize("@ss.hasPermi('maintain:archive:query')")
    @GetMapping("/{archiveId}")
    public AjaxResult getInfo(@PathVariable("archiveId") Long archiveId)
    {
        return success(inspectionService.selectArchiveById(archiveId));
    }

    /**
     * 查询指定电梯的维保完成率与巡检合格率统计
     *
     * @param elevatorId 电梯ID
     * @param beginTime 统计开始日期
     * @param endTime 统计结束日期
     */
    @PreAuthorize("@ss.hasPermi('maintain:archive:query')")
    @GetMapping("/statistics/{elevatorId}")
    public AjaxResult statistics(@PathVariable("elevatorId") Long elevatorId,
                                 @org.springframework.web.bind.annotation.RequestParam(value = "beginTime", required = false) String beginTime,
                                 @org.springframework.web.bind.annotation.RequestParam(value = "endTime", required = false) String endTime)
    {
        List<BigDecimal> rates = inspectionService.selectElevatorRates(elevatorId, beginTime, endTime);
        Map<String, Object> data = new LinkedHashMap<>();
        data.put("elevatorId", elevatorId);
        data.put("maintainRate", rates.get(0));
        data.put("inspectPassRate", rates.get(1));
        return success(data);
    }

    /**
     * 导出维保档案
     */
    @PreAuthorize("@ss.hasPermi('maintain:archive:export')")
    @Log(title = "维保档案", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, MaintainArchive archive)
    {
        List<MaintainArchive> list = inspectionService.selectArchiveList(archive);
        ExcelUtil<MaintainArchive> util = new ExcelUtil<>(MaintainArchive.class);
        util.exportExcel(response, list, "维保档案");
    }
}
