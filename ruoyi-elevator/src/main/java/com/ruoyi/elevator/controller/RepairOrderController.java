package com.ruoyi.elevator.controller;

import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.elevator.domain.RepairOrder;
import com.ruoyi.elevator.service.RepairOrderService;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * 故障报修工单管理
 * 对应论文模块二的故障一键报修与报修进度跟踪子功能
 * 业主的报修提交在 /repair/track/report 提供，本控制器面向管理端的查询与审核
 *
 * @author 董泽晟
 */
@RestController
@RequestMapping("/repair/order")
public class RepairOrderController extends BaseController
{
    @Autowired
    private RepairOrderService repairOrderService;

    /**
     * 查询报修工单列表
     */
    @PreAuthorize("@ss.hasPermi('repair:order:list')")
    @GetMapping("/list")
    public TableDataInfo list(RepairOrder repairOrder)
    {
        startPage();
        List<RepairOrder> list = repairOrderService.selectRepairOrderList(repairOrder);
        return getDataTable(list);
    }

    /**
     * 查询工单详情
     */
    @PreAuthorize("@ss.hasPermi('repair:order:query')")
    @GetMapping("/{orderId}")
    public AjaxResult getInfo(@PathVariable("orderId") Long orderId)
    {
        return success(repairOrderService.selectRepairOrderById(orderId));
    }

    /**
     * 驳回报修单
     */
    @PreAuthorize("@ss.hasPermi('repair:order:reject')")
    @Log(title = "报修工单", businessType = BusinessType.UPDATE)
    @PutMapping("/reject")
    public AjaxResult reject(@RequestBody RepairOrder repairOrder)
    {
        return toAjax(repairOrderService.reject(repairOrder.getOrderId(), repairOrder.getRejectReason()));
    }

    /**
     * 查询最近报修工单，供首页展示
     *
     * @param limit 返回条数，默认 10
     */
    @GetMapping("/recent")
    public AjaxResult recent(@org.springframework.web.bind.annotation.RequestParam(value = "limit", required = false, defaultValue = "10") Integer limit)
    {
        return success(repairOrderService.selectRecentOrders(limit == null || limit <= 0 ? 10 : limit));
    }

    /**
     * 导出报修工单
     */
    @PreAuthorize("@ss.hasPermi('repair:order:export')")
    @Log(title = "报修工单", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, RepairOrder repairOrder)
    {
        List<RepairOrder> list = repairOrderService.selectRepairOrderList(repairOrder);
        ExcelUtil<RepairOrder> util = new ExcelUtil<>(RepairOrder.class);
        util.exportExcel(response, list, "报修工单");
    }
}
