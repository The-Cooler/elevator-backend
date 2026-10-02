package com.ruoyi.elevator.mapper;

import com.ruoyi.elevator.domain.Elevator;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

/**
 * 电梯信息 数据层
 *
 * @author 董泽晟
 */
public interface ElevatorMapper
{
    /**
     * 查询电梯信息列表
     */
    List<Elevator> selectElevatorList(Elevator elevator);

    /**
     * 查询电梯信息
     */
    Elevator selectElevatorById(Long elevatorId);

    /**
     * 查询电梯总数
     */
    int selectElevatorCount();

    /**
     * 按小区统计电梯数量
     *
     * @return 每个 {communityId, communityName, elevatorCount} 一组
     */
    List<Map<String, Object>> countByCommunity();

    /**
     * 按楼栋统计电梯数量
     */
    List<Map<String, Object>> countByBuilding(Long communityId);

    /**
     * 新增电梯
     */
    int insertElevator(Elevator elevator);

    /**
     * 修改电梯
     */
    int updateElevator(Elevator elevator);

    /**
     * 批量删除电梯
     */
    int deleteElevatorByIds(Long[] elevatorIds);

    /**
     * 校验电梯编号是否唯一
     *
     * @param elevatorCode 电梯编号
     * @param elevatorId 排除的电梯ID，新增时传 null
     * @return 已存在的数量
     */
    int checkElevatorCodeUnique(@Param("elevatorCode") String elevatorCode, @Param("elevatorId") Long elevatorId);

    /**
     * 更新电梯状态
     */
    int updateElevatorStatus(@Param("elevatorId") Long elevatorId, @Param("status") String status);

    /**
     * 查询电梯及其所在楼栋、小区信息，供报修页级联展示
     */
    List<Elevator> selectElevatorWithLocation(Elevator elevator);
}
