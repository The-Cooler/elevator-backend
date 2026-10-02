package com.ruoyi.elevator.controller;

import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.elevator.domain.RepairOrder;
import com.ruoyi.elevator.service.ExceptionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

/**
 * 工单异常处理
 * 对应论文模块三的工单异常处理子功能
 * 超时未处理的工单自动进入异常列表，物业可重新指派、驳回重审，维修员可上报异常
 *
 * @author 董泽晟
 */
@RestController
@RequestMapping("/order/exception")
public class ExceptionController extends BaseController
{
    @Autowired
    private ExceptionService exceptionService;

    /**
     * 查询异常工单列表
     *
     * @param exceptionType 异常类型，可为空表示全部：assign 派单超时 / accept 接单超时 / arrive 到场超时 / repair 维修超时
     */
    @PreAuthorize("@ss.hasPermi('order:exception:list')")
    @GetMapping("/list")
    public AjaxResult list(RepairOrder query,
                           @RequestParam(value = "exceptionType", required = false) String exceptionType)
    {
        return success(exceptionService.selectExceptionList(query, exceptionType));
    }

    /**
     * 按异常类型统计，供异常统计图表使用
     */
    @PreAuthorize("@ss.hasPermi('order:exception:query')")
    @GetMapping("/statistics")
    public AjaxResult statistics()
    {
        return success(exceptionService.statistics());
    }

    /**
     * 重新指派超时工单
     */
    @PreAuthorize("@ss.hasPermi('order:exception:edit')")
    @Log(title = "异常工单重新指派", businessType = BusinessType.UPDATE)
    @PostMapping("/reassign")
    public AjaxResult reassign(@RequestBody RepairOrder repairOrder)
    {
        return toAjax(exceptionService.reassign(repairOrder.getOrderId(), repairOrder.getAssigneeId(),
                repairOrder.getRemark()));
    }

    /**
     * 驳回重审
     */
    @PreAuthorize("@ss.hasPermi('order:exception:edit')")
    @Log(title = "异常工单驳回", businessType = BusinessType.UPDATE)
    @PostMapping("/reject")
    public AjaxResult reject(@RequestBody RepairOrder repairOrder)
    {
        return toAjax(exceptionService.reject(repairOrder.getOrderId(), repairOrder.getRejectReason()));
    }

    /**
     * 维修员上报异常，工单转物业处理
     */
    @PreAuthorize("@ss.hasPermi('order:process:edit')")
    @Log(title = "工单异常上报", businessType = BusinessType.UPDATE)
    @PostMapping("/report")
    public AjaxResult report(@RequestBody RepairOrder repairOrder)
    {
        return toAjax(exceptionService.reportException(repairOrder.getOrderId(), repairOrder.getRemark()));
    }

    /**
     * 升级处理，提升为紧急等级
     */
    @PreAuthorize("@ss.hasPermi('order:exception:edit')")
    @Log(title = "异常工单升级", businessType = BusinessType.UPDATE)
    @PostMapping("/escalate")
    public AjaxResult escalate(@RequestBody RepairOrder repairOrder)
    {
        return toAjax(exceptionService.escalate(repairOrder.getOrderId(), repairOrder.getRemark()));
    }
}
