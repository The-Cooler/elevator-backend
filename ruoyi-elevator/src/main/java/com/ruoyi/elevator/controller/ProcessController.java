package com.ruoyi.elevator.controller;

import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.elevator.domain.RepairOrder;
import com.ruoyi.elevator.domain.RepairRecord;
import com.ruoyi.elevator.service.WorkOrderService;
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
 * 维修过程管理
 * 对应论文模块三的维修过程管理子功能
 * 维修员记录到达现场、排查中、已修复等状态，维修完成后提交处理说明，等待业主确认闭环
 *
 * @author 董泽晟
 */
@RestController
@RequestMapping("/order/process")
public class ProcessController extends BaseController
{
    @Autowired
    private WorkOrderService workOrderService;

    /**
     * 查询指派给当前维修员的在办工单
     */
    @PreAuthorize("@ss.hasPermi('order:process:list')")
    @GetMapping("/myList")
    public TableDataInfo myList(RepairOrder repairOrder)
    {
        startPage();
        List<RepairOrder> list = workOrderService.myList(repairOrder, false);
        return getDataTable(list);
    }

    /**
     * 记录到达现场，可携带定位信息
     */
    @PreAuthorize("@ss.hasPermi('order:process:edit')")
    @Log(title = "维修到场", businessType = BusinessType.UPDATE)
    @PostMapping("/arrive")
    public AjaxResult arrive(@RequestBody RepairOrder repairOrder)
    {
        return toAjax(workOrderService.arrive(repairOrder.getOrderId(), repairOrder.getArriveLocation()));
    }

    /**
     * 记录排查情况，工单进入维修中
     */
    @PreAuthorize("@ss.hasPermi('order:process:edit')")
    @Log(title = "维修排查", businessType = BusinessType.UPDATE)
    @PostMapping("/investigate")
    public AjaxResult investigate(@RequestBody RepairRecord repairRecord)
    {
        return toAjax(workOrderService.investigate(repairRecord.getOrderId(), repairRecord.getInvestigateNote()));
    }

    /**
     * 维修完成，提交处理说明与更换配件
     */
    @PreAuthorize("@ss.hasPermi('order:process:edit')")
    @Log(title = "维修完成", businessType = BusinessType.UPDATE)
    @PostMapping("/finish")
    public AjaxResult finish(@RequestBody RepairRecord repairRecord)
    {
        return toAjax(workOrderService.finish(repairRecord.getOrderId(), repairRecord));
    }

    /**
     * 查询指定工单的维修记录
     */
    @PreAuthorize("@ss.hasPermi('order:process:query')")
    @GetMapping("/record/{orderId}")
    public AjaxResult record(@PathVariable("orderId") Long orderId)
    {
        return success(workOrderService.getRecord(orderId));
    }
}
