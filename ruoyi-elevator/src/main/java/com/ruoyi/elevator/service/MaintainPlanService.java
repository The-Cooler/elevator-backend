package com.ruoyi.elevator.service;

import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.DateUtils;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.elevator.domain.MaintainItem;
import com.ruoyi.elevator.domain.MaintainPlan;
import com.ruoyi.elevator.mapper.MaintainPlanMapper;
import com.ruoyi.elevator.util.LoginUserUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * 维保计划服务
 * 对应论文模块四的维保计划管理子功能
 * 制定周期性维保任务，按周期自动推算下次维保日期
 *
 * @author 董泽晟
 */
@Service
public class MaintainPlanService
{
    /** 默认临期天数阈值 */
    private static final int DEFAULT_DUE_SOON_DAYS = 3;

    @Autowired
    private MaintainPlanMapper maintainPlanMapper;

    // ==================== 维保计划 ====================

    /**
     * 查询维保计划列表，并计算完成率与临期标记
     */
    public List<MaintainPlan> selectMaintainPlanList(MaintainPlan maintainPlan)
    {
        List<MaintainPlan> list = maintainPlanMapper.selectMaintainPlanList(maintainPlan);
        for (MaintainPlan plan : list)
        {
            fillDerivedFields(plan);
        }
        return list;
    }

    public MaintainPlan selectMaintainPlanById(Long planId)
    {
        MaintainPlan plan = maintainPlanMapper.selectMaintainPlanById(planId);
        if (plan != null)
        {
            fillDerivedFields(plan);
        }
        return plan;
    }

    /**
     * 新增维保计划
     * 按维保类型确定周期天数，并按生效日期推算下次维保日期
     */
    @Transactional(rollbackFor = Exception.class)
    public int insertMaintainPlan(MaintainPlan plan)
    {
        validate(plan, true);
        if (plan.getCycleDays() == null || plan.getCycleDays() <= 0)
        {
            plan.setCycleDays(cycleDaysOf(plan.getMaintainType()));
        }
        // 下次维保日期 = 生效日期 + 周期天数
        if (plan.getNextDate() == null)
        {
            Date base = plan.getStartDate() != null ? plan.getStartDate() : new Date();
            plan.setNextDate(plusDays(base, plan.getCycleDays()));
        }
        if (StringUtils.isEmpty(plan.getTemplateName()))
        {
            plan.setTemplateName(defaultTemplateOf(plan.getMaintainType()));
        }
        plan.setCreateBy(SecurityUtils.getUsername());
        return maintainPlanMapper.insertMaintainPlan(plan);
    }

    /**
     * 批量新增维保计划，为多台电梯一次性建立相同计划
     */
    @Transactional(rollbackFor = Exception.class)
    public int batchInsertMaintainPlan(MaintainPlan plan)
    {
        if (plan.getElevatorIds() == null || plan.getElevatorIds().length == 0)
        {
            throw new ServiceException("请选择至少一台电梯");
        }
        int count = 0;
        for (Long elevatorId : plan.getElevatorIds())
        {
            MaintainPlan item = new MaintainPlan();
            item.setPlanName(plan.getPlanName());
            item.setElevatorId(elevatorId);
            item.setMaintainType(plan.getMaintainType());
            item.setCycleDays(plan.getCycleDays());
            item.setTemplateName(plan.getTemplateName());
            item.setStartDate(plan.getStartDate());
            item.setEndDate(plan.getEndDate());
            item.setOwnerId(plan.getOwnerId());
            item.setRemark(plan.getRemark());
            // 同一电梯同一维保类型只允许一个启用计划
            int exists = maintainPlanMapper.checkPlanUnique(elevatorId, plan.getMaintainType(), null);
            if (exists > 0)
            {
                continue;
            }
            count += insertMaintainPlan(item);
        }
        return count;
    }

    /**
     * 修改维保计划，修改周期后重新推算后续维保日期
     */
    @Transactional(rollbackFor = Exception.class)
    public int updateMaintainPlan(MaintainPlan plan)
    {
        if (plan.getPlanId() == null)
        {
            throw new ServiceException("计划ID不能为空");
        }
        validate(plan, false);
        if (plan.getCycleDays() != null && plan.getCycleDays() > 0 && plan.getNextDate() == null)
        {
            // 周期变化后，以生效日期为基准重新推算
            MaintainPlan exist = maintainPlanMapper.selectMaintainPlanById(plan.getPlanId());
            Date base = plan.getStartDate() != null ? plan.getStartDate()
                    : (exist != null && exist.getStartDate() != null ? exist.getStartDate() : new Date());
            plan.setNextDate(plusDays(base, plan.getCycleDays()));
        }
        plan.setUpdateBy(SecurityUtils.getUsername());
        return maintainPlanMapper.updateMaintainPlan(plan);
    }

    /**
     * 批量删除维保计划
     */
    @Transactional(rollbackFor = Exception.class)
    public int deleteMaintainPlanByIds(Long[] planIds)
    {
        return maintainPlanMapper.deleteMaintainPlanByIds(planIds);
    }

    /**
     * 启用或停用维保计划
     */
    @Transactional(rollbackFor = Exception.class)
    public int changePlanStatus(Long planId, String planStatus)
    {
        if (StringUtils.isEmpty(planStatus))
        {
            throw new ServiceException("计划状态不能为空");
        }
        MaintainPlan update = new MaintainPlan();
        update.setPlanId(planId);
        update.setPlanStatus(planStatus);
        update.setUpdateBy(SecurityUtils.getUsername());
        return maintainPlanMapper.updateMaintainPlan(update);
    }

    /**
     * 查询到期需要生成巡检工单的计划，供定时任务使用
     */
    public List<MaintainPlan> selectDuePlans()
    {
        return maintainPlanMapper.selectDuePlans();
    }

    /**
     * 查询临期与超期的计划，供预警扫描使用
     */
    public List<MaintainPlan> selectDueSoonPlans(Integer dueSoonDays)
    {
        return maintainPlanMapper.selectDueSoonPlans(dueSoonDays == null ? DEFAULT_DUE_SOON_DAYS : dueSoonDays);
    }

    /**
     * 维保执行完成后更新计划的执行次数与下次维保日期
     */
    public int updatePlanAfterExecute(Long planId)
    {
        MaintainPlan plan = maintainPlanMapper.selectMaintainPlanById(planId);
        if (plan == null)
        {
            return 0;
        }
        String today = DateUtils.getDate();
        String nextDate = DateUtils.parseDateToStr(DateUtils.YYYY_MM_DD,
                plusDays(new Date(), plan.getCycleDays() == null ? 15 : plan.getCycleDays()));
        return maintainPlanMapper.updatePlanAfterExecute(planId, today, nextDate);
    }

    /**
     * 查询指定电梯的维保完成情况
     */
    public Map<String, Object> selectPlanStatByElevator(Long elevatorId)
    {
        return maintainPlanMapper.selectPlanStatByElevator(elevatorId);
    }

    // ==================== 检查项模板 ====================

    public List<MaintainItem> selectMaintainItemList(MaintainItem maintainItem)
    {
        return maintainPlanMapper.selectMaintainItemList(maintainItem);
    }

    /**
     * 按维保类型与模板名称查询检查项，供巡检执行页加载
     */
    public List<MaintainItem> selectItemsByTemplate(String maintainType, String templateName)
    {
        return maintainPlanMapper.selectItemsByTemplate(maintainType, templateName);
    }

    @Transactional(rollbackFor = Exception.class)
    public int insertMaintainItem(MaintainItem maintainItem)
    {
        if (StringUtils.isEmpty(maintainItem.getItemName()))
        {
            throw new ServiceException("检查项名称不能为空");
        }
        maintainItem.setCreateBy(SecurityUtils.getUsername());
        return maintainPlanMapper.insertMaintainItem(maintainItem);
    }

    @Transactional(rollbackFor = Exception.class)
    public int updateMaintainItem(MaintainItem maintainItem)
    {
        maintainItem.setUpdateBy(SecurityUtils.getUsername());
        return maintainPlanMapper.updateMaintainItem(maintainItem);
    }

    @Transactional(rollbackFor = Exception.class)
    public int deleteMaintainItemByIds(Long[] itemIds)
    {
        return maintainPlanMapper.deleteMaintainItemByIds(itemIds);
    }

    // ==================== 内部工具 ====================

    /**
     * 按维保类型返回默认周期天数
     * 依据论文研究背景中「每15天维保一次」的政策要求设定
     */
    public static int cycleDaysOf(String maintainType)
    {
        if (maintainType == null)
        {
            return 15;
        }
        switch (maintainType)
        {
            case "half_month":
                return 15;
            case "quarter":
                return 90;
            case "half_year":
                return 180;
            case "annual":
                return 365;
            default:
                return 15;
        }
    }

    /**
     * 按维保类型返回默认检查项模板名称
     */
    public static String defaultTemplateOf(String maintainType)
    {
        if (maintainType == null)
        {
            return "半月保标准模板";
        }
        switch (maintainType)
        {
            case "half_month":
                return "半月保标准模板";
            case "quarter":
                return "季度检标准模板";
            default:
                return "半月保标准模板";
        }
    }

    /**
     * 日期加天数
     */
    public static Date plusDays(Date date, int days)
    {
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(date);
        calendar.add(Calendar.DAY_OF_YEAR, days);
        return calendar.getTime();
    }

    /**
     * 计算并填充派生字段：完成率、剩余天数、是否临期
     */
    private void fillDerivedFields(MaintainPlan plan)
    {
        int expect = plan.getExpectCount() == null ? 0 : plan.getExpectCount();
        int finish = plan.getFinishCount() == null ? 0 : plan.getFinishCount();
        if (expect > 0)
        {
            plan.setCompleteRate(BigDecimal.valueOf(finish * 100L)
                    .divide(BigDecimal.valueOf(expect), 1, RoundingMode.HALF_UP));
        }
        else
        {
            plan.setCompleteRate(BigDecimal.ZERO);
        }
        if (plan.getNextDate() != null)
        {
            long diff = (plan.getNextDate().getTime() - System.currentTimeMillis()) / 86400000L;
            int remaining = (int) diff;
            plan.setRemainingDays(remaining);
            plan.setDueSoon(remaining <= DEFAULT_DUE_SOON_DAYS);
        }
        else
        {
            plan.setDueSoon(false);
        }
    }

    /**
     * 校验计划数据
     */
    private void validate(MaintainPlan plan, boolean isInsert)
    {
        if (StringUtils.isEmpty(plan.getPlanName()))
        {
            throw new ServiceException("计划名称不能为空");
        }
        if (plan.getElevatorId() == null)
        {
            throw new ServiceException("请选择电梯");
        }
        if (StringUtils.isEmpty(plan.getMaintainType()))
        {
            throw new ServiceException("请选择维保类型");
        }
        if (isInsert)
        {
            int exists = maintainPlanMapper.checkPlanUnique(plan.getElevatorId(), plan.getMaintainType(), null);
            if (exists > 0)
            {
                throw new ServiceException("该电梯在相同维保类型下已存在启用的计划，请勿重复创建");
            }
        }
        else
        {
            int exists = maintainPlanMapper.checkPlanUnique(plan.getElevatorId(), plan.getMaintainType(),
                    plan.getPlanId());
            if (exists > 0)
            {
                throw new ServiceException("该电梯在相同维保类型下已存在启用的计划");
            }
        }
    }
}
