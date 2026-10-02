package com.ruoyi.elevator.service;

import com.ruoyi.elevator.mapper.ElevatorMapper;
import com.ruoyi.elevator.mapper.InspectionMapper;
import com.ruoyi.elevator.mapper.MaintainPlanMapper;
import com.ruoyi.elevator.mapper.RepairOrderMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * 故障频次统计服务
 * 对应论文模块五的故障频次统计子功能
 * 按电梯、楼栋、时间段统计故障次数，生成柱状图与趋势图数据
 *
 * @author 董泽晟
 */
@Service
public class AnalysisService
{
    @Autowired
    private RepairOrderMapper repairOrderMapper;

    @Autowired
    private ElevatorMapper elevatorMapper;

    @Autowired
    private MaintainPlanMapper maintainPlanMapper;

    @Autowired
    private InspectionMapper inspectionMapper;

    /**
     * 按电梯统计故障次数
     */
    public List<Map<String, Object>> byElevator(Long communityId, String beginTime, String endTime)
    {
        return repairOrderMapper.countByElevator(communityId, beginTime, endTime);
    }

    /**
     * 按楼栋统计故障次数
     */
    public List<Map<String, Object>> byBuilding(Long communityId, String beginTime, String endTime)
    {
        return repairOrderMapper.countByBuilding(communityId, beginTime, endTime);
    }

    /**
     * 按时间段统计故障趋势
     *
     * @param granularity day 按日 / week 按周 / month 按月
     */
    public List<Map<String, Object>> trend(Long communityId, String beginTime, String endTime, String granularity)
    {
        return repairOrderMapper.countByTrend(communityId, beginTime, endTime, granularity);
    }

    /**
     * 按故障等级统计
     */
    public List<Map<String, Object>> byLevel(Long communityId, String beginTime, String endTime)
    {
        return repairOrderMapper.countByLevel(communityId, beginTime, endTime);
    }

    /**
     * 按故障类型统计
     */
    public List<Map<String, Object>> byFaultType(Long communityId, String beginTime, String endTime)
    {
        return repairOrderMapper.countByFaultType(communityId, beginTime, endTime);
    }

    /**
     * 汇总统计指标
     */
    public Map<String, Object> summary(Long communityId, String beginTime, String endTime)
    {
        Map<String, Object> data = new LinkedHashMap<>();
        List<Map<String, Object>> byLevel = repairOrderMapper.countByLevel(communityId, beginTime, endTime);
        int total = 0;
        int urgent = 0;
        for (Map<String, Object> row : byLevel)
        {
            int count = toInt(row.get("faultCount"));
            total += count;
            if ("0".equals(String.valueOf(row.get("faultLevel"))))
            {
                urgent = count;
            }
        }
        Double avgAssign = repairOrderMapper.avgAssignMinutes(communityId, beginTime, endTime);
        Double avgRepair = repairOrderMapper.avgRepairMinutes(communityId, beginTime, endTime);

        data.put("totalFault", total);
        data.put("urgentFault", urgent);
        data.put("normalFault", total - urgent);
        data.put("avgAssignMinutes", avgAssign == null ? BigDecimal.ZERO
                : BigDecimal.valueOf(avgAssign).setScale(1, RoundingMode.HALF_UP));
        data.put("avgRepairMinutes", avgRepair == null ? BigDecimal.ZERO
                : BigDecimal.valueOf(avgRepair).setScale(1, RoundingMode.HALF_UP));
        return data;
    }

    /**
     * 管理端首页数据概览
     * 电梯总数、本月报修数、待处理工单数、超期工单数，另附维保完成率
     */
    public Map<String, Object> overview()
    {
        Map<String, Object> data = new LinkedHashMap<>();
        data.put("elevatorCount", elevatorMapper.selectElevatorCount());
        data.put("monthRepairCount", repairOrderMapper.countCurrentMonth());
        data.put("pendingCount", repairOrderMapper.countByStatus("pending"));
        data.put("overdueCount", repairOrderMapper.countOverdue());
        data.put("planCount", maintainPlanMapper.selectMaintainPlanCount());
        data.put("inspectionCount", inspectionMapper.selectInspectionCount());

        // 平均响应时长：全部工单从报修到派单的平均间隔（分钟）
        Double avgAssign = repairOrderMapper.avgAssignMinutes(null, null, null);
        data.put("avgAssignMinutes", avgAssign == null ? BigDecimal.ZERO
                : BigDecimal.valueOf(avgAssign).setScale(1, RoundingMode.HALF_UP));

        // 维保完成率：全部电梯的计划已执行次数合计 / 应执行次数合计
        int expect = 0;
        int finish = 0;
        List<com.ruoyi.elevator.domain.Elevator> elevators = elevatorMapper.selectElevatorList(
                new com.ruoyi.elevator.domain.Elevator());
        for (com.ruoyi.elevator.domain.Elevator elevator : elevators)
        {
            Map<String, Object> stat = maintainPlanMapper.selectPlanStatByElevator(elevator.getElevatorId());
            if (stat != null)
            {
                expect += toInt(stat.get("expectCount"));
                finish += toInt(stat.get("finishCount"));
            }
        }
        BigDecimal rate = expect == 0 ? BigDecimal.ZERO
                : BigDecimal.valueOf(finish * 100L).divide(BigDecimal.valueOf(expect), 1, RoundingMode.HALF_UP);
        data.put("maintainCompleteRate", rate);
        return data;
    }

    private int toInt(Object value)
    {
        if (value == null)
        {
            return 0;
        }
        if (value instanceof Number)
        {
            return ((Number) value).intValue();
        }
        try
        {
            return Integer.parseInt(value.toString());
        }
        catch (NumberFormatException e)
        {
            return 0;
        }
    }
}
