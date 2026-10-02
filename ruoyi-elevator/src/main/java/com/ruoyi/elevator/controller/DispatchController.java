package com.ruoyi.elevator.controller;

import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.elevator.domain.RepairOrder;
import com.ruoyi.elevator.domain.WorkerSkill;
import com.ruoyi.elevator.service.DispatchService;
import com.ruoyi.elevator.service.WorkerSkillService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * 智能派单
 * 对应论文模块三的智能派单子功能
 * 物业审核报修单后，按区域或技能匹配推荐维修员并确认派单
 *
 * @author 董泽晟
 */
@RestController
@RequestMapping("/order/dispatch")
public class DispatchController extends BaseController
{
    @Autowired
    private DispatchService dispatchService;

    @Autowired
    private WorkerSkillService workerSkillService;

    /**
     * 查询待派单工单池
     */
    @PreAuthorize("@ss.hasPermi('order:dispatch:list')")
    @GetMapping("/pendingList")
    public TableDataInfo pendingList(RepairOrder repairOrder)
    {
        startPage();
        List<RepairOrder> list = dispatchService.pendingList(repairOrder);
        return getDataTable(list);
    }

    /**
     * 查询指定工单的推荐维修员列表，按匹配度排序
     */
    @PreAuthorize("@ss.hasPermi('order:dispatch:query')")
    @GetMapping("/recommend/{orderId}")
    public AjaxResult recommend(@PathVariable("orderId") Long orderId)
    {
        return success(dispatchService.recommend(orderId));
    }

    /**
     * 确认派单
     */
    @PreAuthorize("@ss.hasPermi('order:dispatch:assign')")
    @Log(title = "智能派单", businessType = BusinessType.UPDATE)
    @PostMapping("/assign")
    public AjaxResult assign(@RequestBody RepairOrder repairOrder)
    {
        return toAjax(dispatchService.assign(repairOrder.getOrderId(), repairOrder.getAssigneeId()));
    }

    /**
     * 批量派单
     */
    @PreAuthorize("@ss.hasPermi('order:dispatch:assign')")
    @Log(title = "批量派单", businessType = BusinessType.UPDATE)
    @PostMapping("/batchAssign")
    public AjaxResult batchAssign(@RequestBody RepairOrder repairOrder)
    {
        return toAjax(dispatchService.batchAssign(repairOrder.getOrderIds(), repairOrder.getAssigneeId()));
    }

    /**
     * 查询全部维修员及其技能与区域，供派单页手动选择
     */
    @PreAuthorize("@ss.hasPermi('order:dispatch:query')")
    @GetMapping("/workers")
    public AjaxResult workers(WorkerSkill workerSkill)
    {
        return success(workerSkillService.selectWorkerSkillList(workerSkill));
    }
}
