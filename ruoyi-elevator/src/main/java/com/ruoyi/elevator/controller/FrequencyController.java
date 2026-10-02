package com.ruoyi.elevator.controller;

import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.elevator.domain.FaultFrequencyExport;
import com.ruoyi.elevator.service.AnalysisService;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * 故障频次统计
 * 对应论文模块五的故障频次统计子功能
 * 按电梯、楼栋、时间段统计故障次数，生成柱状图与趋势图数据
 *
 * @author 董泽晟
 */
@RestController
@RequestMapping("/analysis/frequency")
public class FrequencyController extends BaseController
{
    @Autowired
    private AnalysisService analysisService;

    /**
     * 按电梯统计故障次数
     */
    @PreAuthorize("@ss.hasPermi('analysis:frequency:list')")
    @GetMapping("/byElevator")
    public AjaxResult byElevator(@RequestParam(value = "communityId", required = false) Long communityId,
                                 @RequestParam(value = "beginTime", required = false) String beginTime,
                                 @RequestParam(value = "endTime", required = false) String endTime)
    {
        return success(analysisService.byElevator(communityId, beginTime, endTime));
    }

    /**
     * 按楼栋统计故障次数
     */
    @PreAuthorize("@ss.hasPermi('analysis:frequency:list')")
    @GetMapping("/byBuilding")
    public AjaxResult byBuilding(@RequestParam(value = "communityId", required = false) Long communityId,
                                 @RequestParam(value = "beginTime", required = false) String beginTime,
                                 @RequestParam(value = "endTime", required = false) String endTime)
    {
        return success(analysisService.byBuilding(communityId, beginTime, endTime));
    }

    /**
     * 按时间段统计故障趋势
     *
     * @param granularity day 按日 / week 按周 / month 按月
     */
    @PreAuthorize("@ss.hasPermi('analysis:frequency:list')")
    @GetMapping("/trend")
    public AjaxResult trend(@RequestParam(value = "communityId", required = false) Long communityId,
                            @RequestParam(value = "beginTime", required = false) String beginTime,
                            @RequestParam(value = "endTime", required = false) String endTime,
                            @RequestParam(value = "granularity", defaultValue = "day") String granularity)
    {
        return success(analysisService.trend(communityId, beginTime, endTime, granularity));
    }

    /**
     * 按故障等级统计
     */
    @PreAuthorize("@ss.hasPermi('analysis:frequency:list')")
    @GetMapping("/byLevel")
    public AjaxResult byLevel(@RequestParam(value = "communityId", required = false) Long communityId,
                              @RequestParam(value = "beginTime", required = false) String beginTime,
                              @RequestParam(value = "endTime", required = false) String endTime)
    {
        return success(analysisService.byLevel(communityId, beginTime, endTime));
    }

    /**
     * 按故障类型统计
     */
    @PreAuthorize("@ss.hasPermi('analysis:frequency:list')")
    @GetMapping("/byFaultType")
    public AjaxResult byFaultType(@RequestParam(value = "communityId", required = false) Long communityId,
                                  @RequestParam(value = "beginTime", required = false) String beginTime,
                                  @RequestParam(value = "endTime", required = false) String endTime)
    {
        return success(analysisService.byFaultType(communityId, beginTime, endTime));
    }

    /**
     * 汇总统计指标
     */
    @PreAuthorize("@ss.hasPermi('analysis:frequency:list')")
    @GetMapping("/summary")
    public AjaxResult summary(@RequestParam(value = "communityId", required = false) Long communityId,
                              @RequestParam(value = "beginTime", required = false) String beginTime,
                              @RequestParam(value = "endTime", required = false) String endTime)
    {
        return success(analysisService.summary(communityId, beginTime, endTime));
    }

    /**
     * 导出故障统计数据为 Excel
     * 按电梯维度输出故障次数，对应论文模块五「统计结果可导出」
     */
    @PreAuthorize("@ss.hasPermi('analysis:frequency:export')")
    @Log(title = "故障频次统计", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response,
                       @RequestParam(value = "communityId", required = false) Long communityId,
                       @RequestParam(value = "beginTime", required = false) String beginTime,
                       @RequestParam(value = "endTime", required = false) String endTime)
    {
        List<Map<String, Object>> rows = analysisService.byElevator(communityId, beginTime, endTime);
        List<FaultFrequencyExport> list = new ArrayList<>();
        for (Map<String, Object> row : rows)
        {
            FaultFrequencyExport item = new FaultFrequencyExport();
            item.setElevatorCode(str(row.get("elevatorCode")));
            item.setCommunityName(str(row.get("communityName")));
            item.setBuildingNo(str(row.get("buildingNo")));
            item.setFaultCount(toInt(row.get("faultCount")));
            list.add(item);
        }
        ExcelUtil<FaultFrequencyExport> util = new ExcelUtil<>(FaultFrequencyExport.class);
        util.exportExcel(response, list, "故障频次统计");
    }

    private String str(Object value)
    {
        return value == null ? "" : String.valueOf(value);
    }

    private Integer toInt(Object value)
    {
        if (value == null)
        {
            return 0;
        }
        if (value instanceof Number)
        {
            return ((Number) value).intValue();
        }
        try
        {
            return Integer.parseInt(String.valueOf(value));
        }
        catch (NumberFormatException e)
        {
            return 0;
        }
    }

    /**
     * 管理端首页数据概览
     * 电梯总数、本月报修数、待处理工单数、超期工单数
     */
    @GetMapping("/overview")
    public AjaxResult overview()
    {
        return success(analysisService.overview());
    }
}
