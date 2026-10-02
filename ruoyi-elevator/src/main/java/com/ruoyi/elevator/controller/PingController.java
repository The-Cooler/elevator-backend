package com.ruoyi.elevator.controller;

import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.elevator.mapper.ElevatorMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.LinkedHashMap;
import java.util.Map;

/**
 * 工程联通性验证接口，用于确认 ruoyi-elevator 模块、Mapper、数据源三层打通
 *
 * @author 董泽晟
 */
@RestController
@RequestMapping("/elevator")
public class PingController
{
    @Autowired
    private ElevatorMapper elevatorMapper;

    /**
     * 读取电梯表记录条数，验证模块被扫描且数据源可用
     */
    @GetMapping("/ping")
    public AjaxResult ping()
    {
        Map<String, Object> data = new LinkedHashMap<>();
        data.put("module", "ruoyi-elevator");
        data.put("elevatorCount", elevatorMapper.selectElevatorCount());
        return AjaxResult.success("工程联通正常", data);
    }
}
