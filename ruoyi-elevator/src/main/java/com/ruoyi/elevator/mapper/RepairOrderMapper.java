package com.ruoyi.elevator.mapper;

import com.ruoyi.elevator.domain.RepairOrder;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

/**
 * 报修工单 数据层
 *
 * @author 董泽晟
 */
public interface RepairOrderMapper
{
    /**
     * 查询工单列表（含报修人、电梯、小区、维修员联表信息）
     */
    List<RepairOrder> selectRepairOrderList(RepairOrder repairOrder);

    /**
     * 查询工单详情
     */
    RepairOrder selectRepairOrderById(Long orderId);

    /**
     * 新增工单
     */
    int insertRepairOrder(RepairOrder repairOrder);

    /**
     * 修改工单
     */
    int updateRepairOrder(RepairOrder repairOrder);

    /**
     * 批量删除工单
     */
    int deleteRepairOrderByIds(Long[] orderIds);

    /**
     * 统计指定电梯的未结工单数量，用于重复报修校验
     */
    int countOpenOrderByElevator(@Param("elevatorId") Long elevatorId);

    /**
     * 按状态统计工单数量
     */
    int countByStatus(@Param("orderStatus") String orderStatus);

    /**
     * 统计本月报修工单数量
     */
    int countCurrentMonth();

    /**
     * 统计超期工单数量（处理时限已过且未闭环）
     */
    int countOverdue();

    /**
     * 查询超期未处理的工单，供预警扫描使用
     *
     * @param ruleType 规则子类型（assign/accept/arrive/repair）
     * @param thresholdMinutes 阈值分钟数
     */
    List<RepairOrder> selectOverdueOrders(@Param("ruleType") String ruleType,
                                          @Param("thresholdMinutes") int thresholdMinutes);

    /**
     * 按电梯统计故障次数
     */
    List<Map<String, Object>> countByElevator(@Param("communityId") Long communityId,
                                              @Param("beginTime") String beginTime,
                                              @Param("endTime") String endTime);

    /**
     * 按楼栋统计故障次数
     */
    List<Map<String, Object>> countByBuilding(@Param("communityId") Long communityId,
                                              @Param("beginTime") String beginTime,
                                              @Param("endTime") String endTime);

    /**
     * 按时间段统计故障趋势
     *
     * @param granularity day 按日 / week 按周 / month 按月
     */
    List<Map<String, Object>> countByTrend(@Param("communityId") Long communityId,
                                           @Param("beginTime") String beginTime,
                                           @Param("endTime") String endTime,
                                           @Param("granularity") String granularity);

    /**
     * 按故障等级统计
     */
    List<Map<String, Object>> countByLevel(@Param("communityId") Long communityId,
                                           @Param("beginTime") String beginTime,
                                           @Param("endTime") String endTime);

    /**
     * 按故障类型统计
     */
    List<Map<String, Object>> countByFaultType(@Param("communityId") Long communityId,
                                               @Param("beginTime") String beginTime,
                                               @Param("endTime") String endTime);

    /**
     * 统计平均响应时长（报修到派单，单位分钟）
     */
    Double avgAssignMinutes(@Param("communityId") Long communityId,
                            @Param("beginTime") String beginTime,
                            @Param("endTime") String endTime);

    /**
     * 统计平均维修时长（到场到完工，单位分钟）
     */
    Double avgRepairMinutes(@Param("communityId") Long communityId,
                            @Param("beginTime") String beginTime,
                            @Param("endTime") String endTime);

    /**
     * 查询指定电梯在统计周期内的故障次数
     */
    int countByElevatorAndPeriod(@Param("elevatorId") Long elevatorId,
                                 @Param("beginTime") String beginTime,
                                 @Param("endTime") String endTime);

    /**
     * 查询最近报修工单，供首页展示
     */
    List<RepairOrder> selectRecentOrders(@Param("limit") int limit);
}
