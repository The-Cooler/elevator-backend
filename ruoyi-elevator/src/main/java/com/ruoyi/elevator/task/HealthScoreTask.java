package com.ruoyi.elevator.task;

import com.ruoyi.elevator.service.HealthService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * 电梯健康评分重算任务
 * 按统计周期重算全部电梯的健康评分
 * 对应论文模块五电梯健康档案生成子功能中的「健康评分定时重算」
 *
 * Quartz 调用目标串：healthScoreTask.execute()
 *
 * @author 董泽晟
 */
@Component("healthScoreTask")
public class HealthScoreTask extends BaseElevatorTask
{
    @Autowired
    private HealthService healthService;

    @Override
    protected String getTaskName()
    {
        return "电梯健康评分重算";
    }

    @Override
    protected int doExecute()
    {
        return healthService.recalculateAll();
    }
}
