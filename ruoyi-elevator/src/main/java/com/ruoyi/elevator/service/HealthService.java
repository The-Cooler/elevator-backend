package com.ruoyi.elevator.service;

import com.ruoyi.common.utils.DateUtils;
import com.ruoyi.elevator.domain.ElevatorHealth;
import com.ruoyi.elevator.mapper.ElevatorHealthMapper;
import com.ruoyi.elevator.mapper.MaintainPlanMapper;
import com.ruoyi.elevator.mapper.RepairOrderMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.Calendar;
import java.util.List;
import java.util.Map;

/**
 * 电梯健康档案服务
 * 对应论文模块五的电梯健康档案生成子功能
 * 综合故障率、维保完成率、巡检合格率三项指标按权重加权计算健康评分
 *
 * 评分模型：
 *   健康评分 = (故障率得分×40% + 维保完成率得分×30% + 巡检合格率得分×30%) / 参与项权重之和
 *   三项指标各自折算为百分制得分后按权重加权，总分百分制
 *
 *   故障率得分：统计周期内无故障得 100 分，每发生 1 次故障扣 10 分，紧急故障额外扣 5 分，下限 0 分
 *   维保完成率得分：直接取维保完成率（百分比）
 *   巡检合格率得分：直接取巡检合格率（百分比）
 *
 *   无数据处理：统计周期内该电梯没有维保计划时，维保项无数据，不参与加权；
 *   没有已完成的巡检记录时，巡检项无数据，不参与加权；剩余权重归一化。
 *   故障项以「周期内故障次数」统计，无故障即为真实的 0 次，始终参与评分。
 *   这样处理是为了避免把「暂无数据」当成「表现最差」，导致新装电梯被判为危险。
 *
 *   健康等级：90 分及以上优秀，80-89 良好，70-79 一般，60-69 较差，60 分以下危险
 *
 * @author 董泽晟
 */
@Service
public class HealthService
{
    private static final Logger log = LoggerFactory.getLogger(HealthService.class);

    /** 故障率权重 */
    public static final BigDecimal WEIGHT_FAULT = new BigDecimal("0.40");

    /** 维保完成率权重 */
    public static final BigDecimal WEIGHT_MAINTAIN = new BigDecimal("0.30");

    /** 巡检合格率权重 */
    public static final BigDecimal WEIGHT_INSPECT = new BigDecimal("0.30");

    /** 统计周期天数：默认 90 天，即一个季度 */
    private static final int DEFAULT_PERIOD_DAYS = 90;

    @Autowired
    private ElevatorHealthMapper elevatorHealthMapper;

    @Autowired
    private RepairOrderMapper repairOrderMapper;

    @Autowired
    private MaintainPlanMapper maintainPlanMapper;

    @Autowired
    private InspectionService inspectionService;

    /**
     * 查询健康评分列表，并补充等级中文名与维护建议
     */
    public List<ElevatorHealth> selectHealthList(ElevatorHealth query)
    {
        List<ElevatorHealth> list = elevatorHealthMapper.selectElevatorHealthList(query);
        for (ElevatorHealth health : list)
        {
            fillDerivedFields(health);
        }
        return list;
    }

    /**
     * 查询指定电梯的健康评分详情，无记录时实时计算返回
     */
    public ElevatorHealth selectLatestByElevator(Long elevatorId)
    {
        String period = currentPeriod();
        ElevatorHealth health = elevatorHealthMapper.selectByElevatorAndPeriod(elevatorId, period);
        if (health == null)
        {
            health = calculate(elevatorId, period);
            elevatorHealthMapper.insertElevatorHealth(health);
        }
        fillDerivedFields(health);
        return health;
    }

    /**
     * 查询指定电梯的历史评分趋势
     */
    public List<ElevatorHealth> selectTrend(Long elevatorId, Integer limit)
    {
        List<ElevatorHealth> list = elevatorHealthMapper.selectTrend(elevatorId,
                limit == null || limit <= 0 ? 12 : limit);
        for (ElevatorHealth health : list)
        {
            fillDerivedFields(health);
        }
        java.util.Collections.reverse(list);
        return list;
    }

    /**
     * 重算全部电梯在当前统计周期的健康评分
     * 由定时任务调用，也可由管理端手动触发
     *
     * @return 本次重算的电梯数量
     */
    @Transactional(rollbackFor = Exception.class)
    public int recalculateAll()
    {
        List<Long> elevatorIds = elevatorHealthMapper.selectAllElevatorIds();
        String period = currentPeriod();
        int count = 0;
        for (Long elevatorId : elevatorIds)
        {
            ElevatorHealth health = calculate(elevatorId, period);
            // 同一周期已有记录则更新，否则新增
            ElevatorHealth exist = elevatorHealthMapper.selectByElevatorAndPeriod(elevatorId, period);
            if (exist == null)
            {
                elevatorHealthMapper.insertElevatorHealth(health);
            }
            else
            {
                health.setHealthId(exist.getHealthId());
                elevatorHealthMapper.updateElevatorHealth(health);
            }
            count++;
        }
        log.info("重算 {} 台电梯的健康评分，统计周期 {}", count, period);
        return count;
    }

    /**
     * 计算指定电梯在指定周期的健康评分
     */
    public ElevatorHealth calculate(Long elevatorId, String period)
    {
        Calendar calendar = Calendar.getInstance();
        String endTime = DateUtils.getDate();
        calendar.add(Calendar.DAY_OF_YEAR, -DEFAULT_PERIOD_DAYS);
        String beginTime = DateUtils.parseDateToStr(DateUtils.YYYY_MM_DD, calendar.getTime());

        // 指标一：故障率
        int faultCount = repairOrderMapper.countByElevatorAndPeriod(elevatorId, beginTime, endTime);
        int urgentCount = countUrgentFault(elevatorId, beginTime, endTime);
        BigDecimal faultScore = calcFaultScore(faultCount, urgentCount);

        // 指标二与三：维保完成率、巡检合格率
        List<BigDecimal> rates = inspectionService.selectElevatorRates(elevatorId, beginTime, endTime);
        BigDecimal maintainRate = rates.get(0);
        BigDecimal inspectRate = rates.get(1);

        // 统计周期内没有维保计划、没有已完成巡检记录时，该指标属于「无数据」而非「得 0 分」。
        // 此时该权重项不参与加权，剩余权重归一化，否则一台零故障的新电梯会被判成危险。
        boolean maintainApplicable = hasMaintainPlan(elevatorId);
        boolean inspectApplicable = hasFinishedInspection(elevatorId, beginTime, endTime);

        BigDecimal weighted = faultScore.multiply(WEIGHT_FAULT);
        BigDecimal totalWeight = WEIGHT_FAULT;
        if (maintainApplicable)
        {
            weighted = weighted.add(maintainRate.multiply(WEIGHT_MAINTAIN));
            totalWeight = totalWeight.add(WEIGHT_MAINTAIN);
        }
        if (inspectApplicable)
        {
            weighted = weighted.add(inspectRate.multiply(WEIGHT_INSPECT));
            totalWeight = totalWeight.add(WEIGHT_INSPECT);
        }
        BigDecimal healthScore = weighted.divide(totalWeight, 2, RoundingMode.HALF_UP);

        Map<String, Object> planStat = maintainPlanMapper.selectPlanStatByElevator(elevatorId);
        Map<String, Object> inspectStat = inspectionService.selectInspectionStat(elevatorId, beginTime, endTime);

        ElevatorHealth health = new ElevatorHealth();
        health.setElevatorId(elevatorId);
        health.setStatPeriod(period);
        health.setStatStartDate(calendar.getTime());
        health.setStatEndDate(new java.util.Date());
        health.setFaultCount(faultCount);
        health.setFaultRate(BigDecimal.valueOf(faultCount));
        health.setFaultScore(faultScore);
        health.setMaintainDone(toInt(planStat == null ? null : planStat.get("expectCount")));
        health.setMaintainFinish(toInt(planStat == null ? null : planStat.get("finishCount")));
        health.setMaintainRate(maintainRate);
        health.setMaintainScore(maintainRate);
        health.setMaintainApplicable(maintainApplicable);
        health.setInspectTotal(toInt(inspectStat == null ? null : inspectStat.get("itemSum")));
        health.setInspectNormal(toInt(inspectStat == null ? null : inspectStat.get("normalSum")));
        health.setInspectRate(inspectRate);
        health.setInspectScore(inspectRate);
        health.setInspectApplicable(inspectApplicable);
        health.setHealthScore(healthScore);
        health.setHealthLevel(levelOf(healthScore));
        return health;
    }

    /**
     * 统计周期内该电梯是否存在维保计划
     */
    private boolean hasMaintainPlan(Long elevatorId)
    {
        Map<String, Object> planStat = maintainPlanMapper.selectPlanStatByElevator(elevatorId);
        return toInt(planStat == null ? null : planStat.get("expectCount")) > 0;
    }

    /**
     * 统计周期内该电梯是否存在已完成的巡检记录
     */
    private boolean hasFinishedInspection(Long elevatorId, String beginTime, String endTime)
    {
        Map<String, Object> inspectStat = inspectionService.selectInspectionStat(elevatorId, beginTime, endTime);
        return toInt(inspectStat == null ? null : inspectStat.get("itemSum")) > 0;
    }

    /**
     * 故障率得分：满分 100，每次故障扣 10 分，紧急故障额外扣 5 分，下限 0 分
     */
    private BigDecimal calcFaultScore(int faultCount, int urgentCount)
    {
        BigDecimal score = BigDecimal.valueOf(100 - faultCount * 10L - urgentCount * 5L);
        if (score.compareTo(BigDecimal.ZERO) < 0)
        {
            score = BigDecimal.ZERO;
        }
        return score.setScale(2, RoundingMode.HALF_UP);
    }

    /**
     * 统计指定电梯在周期内的紧急故障次数
     */
    private int countUrgentFault(Long elevatorId, String beginTime, String endTime)
    {
        com.ruoyi.elevator.domain.RepairOrder query = new com.ruoyi.elevator.domain.RepairOrder();
        query.setElevatorId(elevatorId);
        query.setFaultLevel("0");
        query.setBeginTime(beginTime);
        query.setEndTime(endTime);
        return repairOrderMapper.selectRepairOrderList(query).size();
    }

    /**
     * 按健康评分判定等级
     */
    public static String levelOf(BigDecimal score)
    {
        if (score == null)
        {
            return "danger";
        }
        if (score.compareTo(BigDecimal.valueOf(90)) >= 0)
        {
            return "excellent";
        }
        if (score.compareTo(BigDecimal.valueOf(80)) >= 0)
        {
            return "good";
        }
        if (score.compareTo(BigDecimal.valueOf(70)) >= 0)
        {
            return "fair";
        }
        if (score.compareTo(BigDecimal.valueOf(60)) >= 0)
        {
            return "poor";
        }
        return "danger";
    }

    /**
     * 健康等级中文名
     */
    public static String levelName(String level)
    {
        if (level == null)
        {
            return "";
        }
        switch (level)
        {
            case "excellent":
                return "优秀";
            case "good":
                return "良好";
            case "fair":
                return "一般";
            case "poor":
                return "较差";
            case "danger":
                return "危险";
            default:
                return level;
        }
    }

    /**
     * 生成维护建议
     */
    private String buildSuggestion(ElevatorHealth health)
    {
        String level = health.getHealthLevel();
        StringBuilder sb = new StringBuilder();
        if ("excellent".equals(level) || "good".equals(level))
        {
            sb.append("电梯运行状态良好。");
        }
        else if ("fair".equals(level))
        {
            sb.append("电梯健康状况一般，建议加强日常巡检。");
        }
        else if ("poor".equals(level))
        {
            sb.append("电梯健康状况较差，建议缩短维保周期并安排专项检查。");
        }
        else
        {
            sb.append("电梯健康状况危险，建议立即安排安全评估，必要时停止使用。");
        }
        if (health.getFaultCount() != null && health.getFaultCount() >= 3)
        {
            sb.append("该电梯统计周期内故障").append(health.getFaultCount()).append("次，故障频次偏高。");
        }
        // 无数据的指标不计入评分，也不给扣分建议，但要提示尚未开展
        if (Boolean.FALSE.equals(health.getMaintainApplicable()))
        {
            sb.append("该电梯尚未制定维保计划，维保完成率未纳入本次评分，请尽快制定维保计划。");
        }
        else if (health.getMaintainRate() != null && health.getMaintainRate().compareTo(BigDecimal.valueOf(80)) < 0)
        {
            sb.append("维保完成率不足 80%，存在漏保风险。");
        }
        if (Boolean.FALSE.equals(health.getInspectApplicable()))
        {
            sb.append("该电梯统计周期内无巡检记录，巡检合格率未纳入本次评分。");
        }
        else if (health.getInspectRate() != null && health.getInspectRate().compareTo(BigDecimal.valueOf(80)) < 0)
        {
            sb.append("巡检合格率不足 80%，检查项异常较多。");
        }
        return sb.toString();
    }

    /**
     * 填充派生展示字段
     */
    private void fillDerivedFields(ElevatorHealth health)
    {
        health.setHealthLevelName(levelName(health.getHealthLevel()));
        health.setSuggestion(buildSuggestion(health));
    }

    /**
     * 当前统计周期标识，格式 yyyy-MM
     */
    private String currentPeriod()
    {
        return DateUtils.dateTimeNow("yyyy-MM");
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
