package com.ruoyi.elevator.mapper;

import com.ruoyi.elevator.domain.Building;

import java.util.List;

/**
 * 楼栋信息 数据层
 *
 * @author 董泽晟
 */
public interface BuildingMapper
{
    List<Building> selectBuildingList(Building building);

    Building selectBuildingById(Long buildingId);

    int insertBuilding(Building building);

    int updateBuilding(Building building);

    int deleteBuildingByIds(Long[] buildingIds);

    int selectBuildingCount();

    /**
     * 统计指定小区下的楼栋数量，用于删除小区前的关联校验
     */
    int countByCommunityId(Long communityId);
}
