package com.ruoyi.elevator.controller;

import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.elevator.domain.ElevatorHealth;
import com.ruoyi.elevator.service.HealthReportPdfService;
import com.ruoyi.elevator.service.HealthService;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * 电梯健康档案生成
 * 对应论文模块五的电梯健康档案生成子功能
 * 综合故障率、维保完成率、巡检合格率三项指标为每台电梯生成健康评分报告
 *
 * @author 董泽晟
 */
@RestController
@RequestMapping("/analysis/health")
public class HealthController extends BaseController
{
    @Autowired
    private HealthService healthService;

    @Autowired
    private HealthReportPdfService healthReportPdfService;

    /**
     * 查询电梯健康评分列表，按评分升序，问题电梯前置
     */
    @PreAuthorize("@ss.hasPermi('analysis:health:list')")
    @GetMapping("/list")
    public TableDataInfo list(ElevatorHealth query)
    {
        startPage();
        List<ElevatorHealth> list = healthService.selectHealthList(query);
        return getDataTable(list);
    }

    /**
     * 查询指定电梯的健康评分报告，含指标构成明细
     */
    @PreAuthorize("@ss.hasPermi('analysis:health:query')")
    @GetMapping("/{elevatorId}")
    public AjaxResult getInfo(@PathVariable("elevatorId") Long elevatorId)
    {
        return success(healthService.selectLatestByElevator(elevatorId));
    }

    /**
     * 查询指定电梯的历史评分趋势
     */
    @PreAuthorize("@ss.hasPermi('analysis:health:query')")
    @GetMapping("/trend/{elevatorId}")
    public AjaxResult trend(@PathVariable("elevatorId") Long elevatorId,
                            @RequestParam(value = "limit", required = false) Integer limit)
    {
        return success(healthService.selectTrend(elevatorId, limit));
    }

    /**
     * 查询健康评分的权重配置
     */
    @PreAuthorize("@ss.hasPermi('analysis:health:query')")
    @GetMapping("/config")
    public AjaxResult config()
    {
        AjaxResult ajax = AjaxResult.success();
        ajax.put("faultWeight", HealthService.WEIGHT_FAULT);
        ajax.put("maintainWeight", HealthService.WEIGHT_MAINTAIN);
        ajax.put("inspectWeight", HealthService.WEIGHT_INSPECT);
        ajax.put("periodDays", 90);
        ajax.put("levelRule", "90分及以上优秀，80-89良好，70-79一般，60-69较差，60分以下危险");
        ajax.put("scoreModel", "健康评分 = 故障率得分×40% + 维保完成率得分×30% + 巡检合格率得分×30%");
        return ajax;
    }

    /**
     * 重算全部电梯的健康评分
     */
    @PreAuthorize("@ss.hasPermi('analysis:health:export')")
    @Log(title = "健康评分重算", businessType = BusinessType.UPDATE)
    @PostMapping("/recalculate")
    public AjaxResult recalculate()
    {
        int count = healthService.recalculateAll();
        return AjaxResult.success("已重算 " + count + " 台电梯的健康评分");
    }

    /**
     * 重算指定电梯的健康评分
     */
    @PreAuthorize("@ss.hasPermi('analysis:health:query')")
    @PostMapping("/recalculate/{elevatorId}")
    public AjaxResult recalculateOne(@PathVariable("elevatorId") Long elevatorId)
    {
        return success(healthService.selectLatestByElevator(elevatorId));
    }

    /**
     * 导出健康评分报告为 PDF
     */
    @PreAuthorize("@ss.hasPermi('analysis:health:export')")
    @Log(title = "健康评分报告", businessType = BusinessType.EXPORT)
    @PostMapping("/exportPdf")
    public void exportPdf(HttpServletResponse response,
                          @RequestParam("elevatorId") Long elevatorId)
    {
        ElevatorHealth health = healthService.selectLatestByElevator(elevatorId);
        String fileName = String.format("电梯健康评分报告_%s_%s",
                health.getElevatorCode() == null ? elevatorId : health.getElevatorCode(),
                health.getStatPeriod());
        healthReportPdfService.export(health, response, fileName);
    }

    /**
     * 导出健康评分明细为 Excel
     */
    @PreAuthorize("@ss.hasPermi('analysis:health:export')")
    @Log(title = "健康评分明细", businessType = BusinessType.EXPORT)
    @PostMapping("/exportExcel")
    public void exportExcel(HttpServletResponse response,
                            @RequestParam("elevatorId") Long elevatorId)
    {
        List<ElevatorHealth> list = healthService.selectTrend(elevatorId, 24);
        ExcelUtil<ElevatorHealth> util = new ExcelUtil<>(ElevatorHealth.class);
        util.exportExcel(response, list, "电梯健康评分明细");
    }
}
