package com.ruoyi.elevator.controller;

import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.elevator.domain.RepairOrder;
import com.ruoyi.elevator.service.RepairOrderService;
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
 * 维保人员接单
 * 对应论文模块三的维保人员接单子功能
 * 维修员接收工单通知，确认接单并反馈预计到场时间，或拒绝接单让工单回到待派单池
 *
 * @author 董泽晟
 */
@RestController
@RequestMapping("/order/accept")
public class AcceptController extends BaseController
{
    @Autowired
    private WorkOrderService workOrderService;

    @Autowired
    private RepairOrderService repairOrderService;

    /**
     * 查询指派给当前维修员的待接单列表
     */
    @PreAuthorize("@ss.hasPermi('order:accept:list')")
    @GetMapping("/myList")
    public TableDataInfo myList(RepairOrder repairOrder)
    {
        startPage();
        List<RepairOrder> list = workOrderService.myList(repairOrder, true);
        return getDataTable(list);
    }

    /**
     * 查询指派给当前维修员的全部工单
     */
    @PreAuthorize("@ss.hasPermi('order:accept:list')")
    @GetMapping("/myAll")
    public TableDataInfo myAll(RepairOrder repairOrder)
    {
        startPage();
        List<RepairOrder> list = workOrderService.myList(repairOrder, false);
        return getDataTable(list);
    }

    /**
     * 查询全部工单的接单情况，物业查看用
     */
    @PreAuthorize("@ss.hasPermi('order:accept:query')")
    @GetMapping("/list")
    public TableDataInfo list(RepairOrder repairOrder)
    {
        startPage();
        List<RepairOrder> list = workOrderService.acceptList(repairOrder);
        return getDataTable(list);
    }

    /**
     * 查询工单详情
     */
    @PreAuthorize("@ss.hasPermi('order:accept:query')")
    @GetMapping("/{orderId}")
    public AjaxResult getInfo(@PathVariable("orderId") Long orderId)
    {
        return success(repairOrderService.selectRepairOrderById(orderId));
    }

    /**
     * 确认接单并反馈预计到场时间
     *
     * @param repairOrder 请求体需携带 orderId，可选 arriveMinutes 表示预计到场分钟数
     */
    @PreAuthorize("@ss.hasPermi('order:accept:confirm')")
    @Log(title = "维修接单", businessType = BusinessType.UPDATE)
    @PostMapping("/confirm")
    public AjaxResult confirm(@RequestBody RepairOrder repairOrder)
    {
        return toAjax(workOrderService.accept(repairOrder.getOrderId(), repairOrder.getArriveMinutes()));
    }

    /**
     * 拒绝接单
     */
    @PreAuthorize("@ss.hasPermi('order:accept:confirm')")
    @Log(title = "拒绝接单", businessType = BusinessType.UPDATE)
    @PostMapping("/refuse")
    public AjaxResult refuse(@RequestBody RepairOrder repairOrder)
    {
        return toAjax(workOrderService.refuse(repairOrder.getOrderId(), repairOrder.getRemark()));
    }
}
