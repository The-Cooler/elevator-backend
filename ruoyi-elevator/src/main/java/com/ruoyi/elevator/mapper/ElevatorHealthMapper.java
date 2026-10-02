package com.ruoyi.elevator.mapper;

import com.ruoyi.elevator.domain.ElevatorHealth;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 电梯健康评分 数据层
 *
 * @author 董泽晟
 */
public interface ElevatorHealthMapper
{
    /**
     * 查询健康评分列表，含电梯位置信息
     */
    List<ElevatorHealth> selectElevatorHealthList(ElevatorHealth elevatorHealth);

    /**
     * 查询指定电梯在统计周期内的健康评分
     */
    ElevatorHealth selectByElevatorAndPeriod(@Param("elevatorId") Long elevatorId,
                                             @Param("statPeriod") String statPeriod);

    /**
     * 查询指定电梯的历史评分趋势
     */
    List<ElevatorHealth> selectTrend(@Param("elevatorId") Long elevatorId,
                                     @Param("limit") int limit);

    /**
     * 新增健康评分
     */
    int insertElevatorHealth(ElevatorHealth elevatorHealth);

    /**
     * 修改健康评分
     */
    int updateElevatorHealth(ElevatorHealth elevatorHealth);

    /**
     * 查询全部电梯ID，供健康评分批量重算使用
     */
    List<Long> selectAllElevatorIds();

    /**
     * 逻辑删除指定电梯在统计周期的旧评分，重算前清理
     */
    int deleteByElevatorAndPeriod(@Param("elevatorId") Long elevatorId,
                                  @Param("statPeriod") String statPeriod);
}
