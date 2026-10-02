package com.ruoyi.elevator.controller;

import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.elevator.domain.WarningInfo;
import com.ruoyi.elevator.domain.WarningRule;
import com.ruoyi.elevator.service.WarningService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * 超期预警监控
 * 对应论文模块五的超期预警监控子功能
 * 工单超时与维保临期自动触发预警，推送给相关责任人，预警规则可配置
 *
 * @author 董泽晟
 */
@RestController
@RequestMapping("/analysis/warning")
public class WarningController extends BaseController
{
    @Autowired
    private WarningService warningService;

    // ==================== 预警信息 ====================

    /**
     * 查询预警信息列表
     */
    @PreAuthorize("@ss.hasPermi('analysis:warning:list')")
    @GetMapping("/list")
    public TableDataInfo list(WarningInfo warningInfo)
    {
        startPage();
        List<WarningInfo> list = warningService.selectWarningInfoList(warningInfo);
        return getDataTable(list);
    }

    /**
     * 查询当前登录用户的预警信息
     */
    @GetMapping("/myList")
    public TableDataInfo myList(WarningInfo warningInfo)
    {
        startPage();
        List<WarningInfo> list = warningService.myWarnings(warningInfo);
        return getDataTable(list);
    }

    /**
     * 统计当前用户未读预警数量，供顶栏角标展示
     */
    @GetMapping("/unreadCount")
    public AjaxResult unreadCount()
    {
        return success(warningService.unreadCount());
    }

    /**
     * 标记指定预警已读
     */
    @PutMapping("/read/{warningIds}")
    public AjaxResult read(@PathVariable("warningIds") Long[] warningIds)
    {
        return toAjax(warningService.markRead(warningIds));
    }

    /**
     * 全部标记已读
     */
    @PutMapping("/readAll")
    public AjaxResult readAll()
    {
        return toAjax(warningService.markAllRead());
    }

    /**
     * 手动触发预警扫描，供演示与管理员手动补扫使用
     */
    @PreAuthorize("@ss.hasPermi('analysis:warning:rule')")
    @Log(title = "预警扫描", businessType = BusinessType.INSERT)
    @PostMapping("/scan")
    public AjaxResult scan()
    {
        int count = warningService.scanAndGenerate();
        return AjaxResult.success("本次生成预警 " + count + " 条");
    }

    // ==================== 预警规则 ====================

    /**
     * 查询预警规则列表
     */
    @PreAuthorize("@ss.hasPermi('analysis:warning:rule')")
    @GetMapping("/rule/list")
    public TableDataInfo ruleList(WarningRule warningRule)
    {
        startPage();
        List<WarningRule> list = warningService.selectWarningRuleList(warningRule);
        return getDataTable(list);
    }

    /**
     * 查询预警规则详情
     */
    @PreAuthorize("@ss.hasPermi('analysis:warning:rule')")
    @GetMapping("/rule/{ruleId}")
    public AjaxResult ruleInfo(@PathVariable("ruleId") Long ruleId)
    {
        return success(warningService.selectWarningRuleById(ruleId));
    }

    /**
     * 新增预警规则
     */
    @PreAuthorize("@ss.hasPermi('analysis:warning:rule')")
    @Log(title = "预警规则", businessType = BusinessType.INSERT)
    @PostMapping("/rule")
    public AjaxResult addRule(@RequestBody WarningRule warningRule)
    {
        return toAjax(warningService.insertWarningRule(warningRule));
    }

    /**
     * 修改预警规则
     */
    @PreAuthorize("@ss.hasPermi('analysis:warning:rule')")
    @Log(title = "预警规则", businessType = BusinessType.UPDATE)
    @PutMapping("/rule")
    public AjaxResult editRule(@RequestBody WarningRule warningRule)
    {
        return toAjax(warningService.updateWarningRule(warningRule));
    }

    /**
     * 启用或停用预警规则
     */
    @PreAuthorize("@ss.hasPermi('analysis:warning:rule')")
    @Log(title = "预警规则状态", businessType = BusinessType.UPDATE)
    @PutMapping("/rule/changeStatus")
    public AjaxResult changeRuleStatus(@RequestBody WarningRule warningRule)
    {
        return toAjax(warningService.changeRuleEnabled(warningRule.getRuleId(), warningRule.getEnabled()));
    }

    /**
     * 删除预警规则
     */
    @PreAuthorize("@ss.hasPermi('analysis:warning:rule')")
    @Log(title = "预警规则", businessType = BusinessType.DELETE)
    @DeleteMapping("/rule/{ruleIds}")
    public AjaxResult removeRule(@PathVariable("ruleIds") Long[] ruleIds)
    {
        return toAjax(warningService.deleteWarningRuleByIds(ruleIds));
    }
}
