package com.ruoyi.elevator.mapper;

import com.ruoyi.elevator.domain.MaintainItem;
import com.ruoyi.elevator.domain.MaintainPlan;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

/**
 * 维保计划与检查项模板 数据层
 *
 * @author 董泽晟
 */
public interface MaintainPlanMapper
{
    // ==================== 维保计划 ====================

    /**
     * 查询维保计划列表，含电梯位置与负责人信息
     */
    List<MaintainPlan> selectMaintainPlanList(MaintainPlan maintainPlan);

    /**
     * 查询维保计划详情
     */
    MaintainPlan selectMaintainPlanById(Long planId);

    /**
     * 新增维保计划
     */
    int insertMaintainPlan(MaintainPlan maintainPlan);

    /**
     * 修改维保计划
     */
    int updateMaintainPlan(MaintainPlan maintainPlan);

    /**
     * 批量删除维保计划
     */
    int deleteMaintainPlanByIds(Long[] planIds);

    /**
     * 查询到期需要生成巡检工单的计划
     * 条件：已启用、下次维保日期不晚于今天、未超过失效日期
     */
    List<MaintainPlan> selectDuePlans();

    /**
     * 查询临期与超期的维保计划，供预警扫描使用
     *
     * @param dueSoonDays 距到期天数阈值
     */
    List<MaintainPlan> selectDueSoonPlans(@Param("dueSoonDays") int dueSoonDays);

    /**
     * 校验同一电梯在相同维保类型下是否已有启用计划
     *
     * @param elevatorId 电梯ID
     * @param maintainType 维保类型
     * @param planId 排除的计划ID，新增时传 null
     */
    int checkPlanUnique(@Param("elevatorId") Long elevatorId,
                        @Param("maintainType") String maintainType,
                        @Param("planId") Long planId);

    /**
     * 维保完成后更新计划的执行次数与下次维保日期
     */
    int updatePlanAfterExecute(@Param("planId") Long planId,
                               @Param("lastDate") String lastDate,
                               @Param("nextDate") String nextDate);

    /**
     * 查询指定电梯的维保完成情况，供健康评分使用
     *
     * @return {expectCount, finishCount}
     */
    Map<String, Object> selectPlanStatByElevator(@Param("elevatorId") Long elevatorId);

    /**
     * 统计维保计划总数
     */
    int selectMaintainPlanCount();

    // ==================== 检查项模板 ====================

    /**
     * 查询检查项模板列表
     */
    List<MaintainItem> selectMaintainItemList(MaintainItem maintainItem);

    /**
     * 按维保类型与模板名称查询检查项，供巡检执行页加载
     */
    List<MaintainItem> selectItemsByTemplate(@Param("maintainType") String maintainType,
                                             @Param("templateName") String templateName);

    /**
     * 查询检查项详情
     */
    MaintainItem selectMaintainItemById(Long itemId);

    int insertMaintainItem(MaintainItem maintainItem);

    int updateMaintainItem(MaintainItem maintainItem);

    int deleteMaintainItemByIds(Long[] itemIds);
}
