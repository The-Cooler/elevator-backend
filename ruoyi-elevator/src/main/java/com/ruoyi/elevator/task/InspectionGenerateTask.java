package com.ruoyi.elevator.task;

import com.ruoyi.elevator.service.InspectionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * 巡检工单自动生成任务
 * 每日扫描到期的维保计划，按周期自动生成巡检工单并派发给负责人
 * 对应论文模块四定期巡检执行子功能中的「系统按周期自动生成巡检工单并派发」
 *
 * Quartz 调用目标串：inspectionGenerateTask.execute()
 *
 * @author 董泽晟
 */
@Component("inspectionGenerateTask")
public class InspectionGenerateTask extends BaseElevatorTask
{
    @Autowired
    private InspectionService inspectionService;

    @Override
    protected String getTaskName()
    {
        return "巡检工单自动生成";
    }

    @Override
    protected int doExecute()
    {
        int generated = inspectionService.generateInspectionTasks();
        int overdue = inspectionService.markOverdue();
        logger.info("本次新生成巡检工单 {} 条，标记超期 {} 条", generated, overdue);
        return generated;
    }
}
