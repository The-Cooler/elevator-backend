package com.ruoyi.elevator.controller;

import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.domain.entity.SysDictData;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.elevator.domain.RepairOrder;
import com.ruoyi.elevator.service.RepairOrderService;
import com.ruoyi.system.service.ISysDictTypeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * 故障分级管理
 * 对应论文模块二的故障分级管理子功能
 * 系统预设紧急与一般两级，物业可根据实际情况手动调整优先级
 *
 * @author 董泽晟
 */
@RestController
@RequestMapping("/repair/level")
public class FaultLevelController extends BaseController
{
    /** 故障等级字典类型 */
    private static final String DICT_TYPE = "fault_level";

    /** 故障类型字典类型 */
    private static final String FAULT_TYPE_DICT = "fault_type";

    @Autowired
    private ISysDictTypeService dictTypeService;

    @Autowired
    private RepairOrderService repairOrderService;

    /**
     * 查询故障等级字典项
     */
    @PreAuthorize("@ss.hasPermi('repair:level:query')")
    @GetMapping("/list")
    public AjaxResult list()
    {
        List<SysDictData> dictDatas = dictTypeService.selectDictDataByType(DICT_TYPE);
        return success(dictDatas);
    }

    /**
     * 查询故障类型字典项，供报修表单与统计使用
     */
    @GetMapping("/faultTypes")
    public AjaxResult faultTypes()
    {
        return success(dictTypeService.selectDictDataByType(FAULT_TYPE_DICT));
    }

    /**
     * 物业调整工单的故障等级
     */
    @PreAuthorize("@ss.hasPermi('repair:order:changeLevel')")
    @PutMapping("/changeLevel")
    public AjaxResult changeLevel(@RequestBody RepairOrder repairOrder)
    {
        return toAjax(repairOrderService.changeLevel(repairOrder.getOrderId(), repairOrder.getFaultLevel()));
    }

    /**
     * 按故障等级统计工单数量，供分级管理页展示
     */
    @PreAuthorize("@ss.hasPermi('repair:level:query')")
    @GetMapping("/statistics")
    public AjaxResult statistics()
    {
        List<SysDictData> levels = dictTypeService.selectDictDataByType(DICT_TYPE);
        List<java.util.Map<String, Object>> result = new java.util.ArrayList<>();
        for (SysDictData level : levels)
        {
            java.util.Map<String, Object> item = new java.util.LinkedHashMap<>();
            item.put("dictValue", level.getDictValue());
            item.put("dictLabel", level.getDictLabel());
            item.put("listClass", level.getListClass());
            item.put("orderCount", repairOrderService.countByLevel(level.getDictValue()));
            result.add(item);
        }
        return success(result);
    }
}
