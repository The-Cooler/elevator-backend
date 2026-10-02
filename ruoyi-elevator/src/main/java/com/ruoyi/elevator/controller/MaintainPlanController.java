package com.ruoyi.elevator.controller;

import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.elevator.domain.MaintainItem;
import com.ruoyi.elevator.domain.MaintainPlan;
import com.ruoyi.elevator.service.MaintainPlanService;
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
 * 维保计划管理
 * 对应论文模块四的维保计划管理子功能
 * 制定半月保、季度检等周期性维保任务，支持按电梯类型自定义计划模板
 *
 * @author 董泽晟
 */
@RestController
@RequestMapping("/maintain/plan")
public class MaintainPlanController extends BaseController
{
    @Autowired
    private MaintainPlanService maintainPlanService;

    /**
     * 查询维保计划列表
     */
    @PreAuthorize("@ss.hasPermi('maintain:plan:list')")
    @GetMapping("/list")
    public TableDataInfo list(MaintainPlan maintainPlan)
    {
        startPage();
        List<MaintainPlan> list = maintainPlanService.selectMaintainPlanList(maintainPlan);
        return getDataTable(list);
    }

    /**
     * 查询维保计划详情
     */
    @PreAuthorize("@ss.hasPermi('maintain:plan:query')")
    @GetMapping("/{planId}")
    public AjaxResult getInfo(@PathVariable("planId") Long planId)
    {
        return success(maintainPlanService.selectMaintainPlanById(planId));
    }

    /**
     * 新增维保计划
     */
    @PreAuthorize("@ss.hasPermi('maintain:plan:add')")
    @Log(title = "维保计划", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody MaintainPlan maintainPlan)
    {
        return toAjax(maintainPlanService.insertMaintainPlan(maintainPlan));
    }

    /**
     * 批量新增维保计划，为多台电梯一次性建立计划
     */
    @PreAuthorize("@ss.hasPermi('maintain:plan:add')")
    @Log(title = "维保计划批量创建", businessType = BusinessType.INSERT)
    @PostMapping("/batch")
    public AjaxResult batchAdd(@RequestBody MaintainPlan maintainPlan)
    {
        return toAjax(maintainPlanService.batchInsertMaintainPlan(maintainPlan));
    }

    /**
     * 修改维保计划
     */
    @PreAuthorize("@ss.hasPermi('maintain:plan:edit')")
    @Log(title = "维保计划", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody MaintainPlan maintainPlan)
    {
        return toAjax(maintainPlanService.updateMaintainPlan(maintainPlan));
    }

    /**
     * 启用或停用维保计划
     */
    @PreAuthorize("@ss.hasPermi('maintain:plan:edit')")
    @Log(title = "维保计划状态", businessType = BusinessType.UPDATE)
    @PutMapping("/changeStatus")
    public AjaxResult changeStatus(@RequestBody MaintainPlan maintainPlan)
    {
        return toAjax(maintainPlanService.changePlanStatus(maintainPlan.getPlanId(), maintainPlan.getPlanStatus()));
    }

    /**
     * 删除维保计划
     */
    @PreAuthorize("@ss.hasPermi('maintain:plan:remove')")
    @Log(title = "维保计划", businessType = BusinessType.DELETE)
    @DeleteMapping("/{planIds}")
    public AjaxResult remove(@PathVariable("planIds") Long[] planIds)
    {
        return toAjax(maintainPlanService.deleteMaintainPlanByIds(planIds));
    }

    // ==================== 检查项模板 ====================

    /**
     * 查询检查项模板列表
     */
    @PreAuthorize("@ss.hasPermi('maintain:plan:query')")
    @GetMapping("/template/list")
    public TableDataInfo templateList(MaintainItem maintainItem)
    {
        startPage();
        return getDataTable(maintainPlanService.selectMaintainItemList(maintainItem));
    }

    /**
     * 按维保类型查询检查项，供计划配置时预览检查项清单
     */
    @PreAuthorize("@ss.hasPermi('maintain:plan:query')")
    @GetMapping("/template/items")
    public AjaxResult templateItems(MaintainItem maintainItem)
    {
        return success(maintainPlanService.selectItemsByTemplate(maintainItem.getMaintainType(),
                maintainItem.getTemplateName()));
    }

    /**
     * 新增检查项模板
     */
    @PreAuthorize("@ss.hasPermi('maintain:plan:add')")
    @Log(title = "维保检查项", businessType = BusinessType.INSERT)
    @PostMapping("/template")
    public AjaxResult addTemplate(@RequestBody MaintainItem maintainItem)
    {
        return toAjax(maintainPlanService.insertMaintainItem(maintainItem));
    }

    /**
     * 修改检查项模板
     */
    @PreAuthorize("@ss.hasPermi('maintain:plan:edit')")
    @Log(title = "维保检查项", businessType = BusinessType.UPDATE)
    @PutMapping("/template")
    public AjaxResult editTemplate(@RequestBody MaintainItem maintainItem)
    {
        return toAjax(maintainPlanService.updateMaintainItem(maintainItem));
    }

    /**
     * 删除检查项模板
     */
    @PreAuthorize("@ss.hasPermi('maintain:plan:remove')")
    @Log(title = "维保检查项", businessType = BusinessType.DELETE)
    @DeleteMapping("/template/{itemIds}")
    public AjaxResult removeTemplate(@PathVariable("itemIds") Long[] itemIds)
    {
        return toAjax(maintainPlanService.deleteMaintainItemByIds(itemIds));
    }
}
