package com.ruoyi.elevator.task;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * 电梯业务定时任务基类
 * 供模块四的巡检工单自动生成、模块五的超期预警扫描与健康评分重算继承
 * 统一任务日志格式，便于排查定时任务是否按时执行
 *
 * @author 董泽晟
 */
public abstract class BaseElevatorTask
{
    protected final Logger logger = LoggerFactory.getLogger(this.getClass());

    /**
     * 任务名称，由子类实现，用于日志输出
     */
    protected abstract String getTaskName();

    /**
     * 任务主逻辑，由子类实现
     *
     * @return 本次任务处理的记录数
     */
    protected abstract int doExecute();

    /**
     * 由 Quartz 调用的入口方法，负责计时与日志
     */
    public void execute()
    {
        long start = System.currentTimeMillis();
        logger.info("【{}】任务开始执行", getTaskName());
        try
        {
            int count = doExecute();
            long cost = System.currentTimeMillis() - start;
            logger.info("【{}】任务执行完成，处理 {} 条记录，耗时 {} 毫秒", getTaskName(), count, cost);
        }
        catch (Exception e)
        {
            logger.error("【{}】任务执行异常", getTaskName(), e);
        }
    }
}
