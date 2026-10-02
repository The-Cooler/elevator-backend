package com.ruoyi.elevator.controller;

import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.elevator.domain.RepairOrder;
import com.ruoyi.elevator.service.RepairOrderService;
import com.ruoyi.elevator.util.LoginUserUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * 业主端报修与进度跟踪
 * 对应论文模块二的故障一键报修与报修进度跟踪子功能，面向业主与管理端共用
 *
 * @author 董泽晟
 */
@RestController
@RequestMapping("/repair/track")
public class RepairTrackController extends BaseController
{
    @Autowired
    private RepairOrderService repairOrderService;

    /**
     * 业主提交故障报修
     * 请求体可携带 evidenceList 字段，把已上传的证据一并绑定到新工单
     */
    @PostMapping("/report")
    public AjaxResult report(@RequestBody RepairOrder repairOrder)
    {
        LoginUserUtil.checkOwner();
        RepairOrder order = repairOrderService.report(repairOrder);
        AjaxResult ajax = AjaxResult.success("报修提交成功");
        ajax.put("orderId", order.getOrderId());
        ajax.put("orderNo", order.getOrderNo());
        ajax.put("orderStatus", order.getOrderStatus());
        return ajax;
    }

    /**
     * 业主查询本人的报修记录
     */
    @GetMapping("/myList")
    public TableDataInfo myList(RepairOrder repairOrder)
    {
        startPage();
        repairOrder.setQueryUserId(LoginUserUtil.getUserId());
        List<RepairOrder> list = repairOrderService.selectRepairOrderList(repairOrder);
        return getDataTable(list);
    }

    /**
     * 查询工单进度详情，含证据、状态时间轴与维修记录
     */
    @GetMapping("/{orderId}")
    public AjaxResult detail(@PathVariable("orderId") Long orderId)
    {
        return success(repairOrderService.selectOrderTimeline(orderId));
    }

    /**
     * 业主确认故障消除，工单闭环
     */
    @PostMapping("/confirm")
    public AjaxResult confirm(@RequestBody RepairOrder repairOrder)
    {
        return toAjax(repairOrderService.confirm(repairOrder.getOrderId()));
    }

    /**
     * 业主对维修结果提交申诉
     */
    @PostMapping("/appeal")
    public AjaxResult appeal(@RequestBody RepairOrder repairOrder)
    {
        return toAjax(repairOrderService.appeal(repairOrder.getOrderId(), repairOrder.getRemark()));
    }

    /**
     * 查询工单全流程时间轴，管理端报修进度跟踪页使用
     */
    @GetMapping("/timeline/{orderId}")
    public AjaxResult timeline(@PathVariable("orderId") Long orderId)
    {
        return success(repairOrderService.selectOrderTimeline(orderId));
    }

    /**
     * 查询全部工单进度，管理端报修进度跟踪页使用
     */
    @GetMapping("/list")
    public TableDataInfo list(RepairOrder repairOrder)
    {
        startPage();
        List<RepairOrder> list = repairOrderService.selectRepairOrderList(repairOrder);
        return getDataTable(list);
    }

    /**
     * 校验指定电梯是否存在未结工单，供业主端报修前预校验
     */
    @GetMapping("/checkOpen/{elevatorId}")
    public AjaxResult checkOpen(@PathVariable("elevatorId") Long elevatorId)
    {
        int count = repairOrderService.countOpenOrderByElevator(elevatorId);
        AjaxResult ajax = AjaxResult.success();
        ajax.put("openCount", count);
        ajax.put("allowReport", count == 0);
        return ajax;
    }
}
