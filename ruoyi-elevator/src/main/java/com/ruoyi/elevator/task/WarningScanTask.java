package com.ruoyi.elevator.task;

import com.ruoyi.elevator.service.HealthService;
import com.ruoyi.elevator.service.WarningService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * 超期预警扫描任务
 * 定时扫描工单与维保计划，识别超期与临期情形并生成预警
 * 对应论文模块五超期预警监控子功能中的「系统定时检查工单和维保计划」
 *
 * Quartz 调用目标串：warningScanTask.execute()
 *
 * @author 董泽晟
 */
@Component("warningScanTask")
public class WarningScanTask extends BaseElevatorTask
{
    @Autowired
    private WarningService warningService;

    @Override
    protected String getTaskName()
    {
        return "超期预警扫描";
    }

    @Override
    protected int doExecute()
    {
        return warningService.scanAndGenerate();
    }
}
