package com.ruoyi.elevator.service;

import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.elevator.domain.Building;
import com.ruoyi.elevator.domain.Community;
import com.ruoyi.elevator.mapper.BuildingMapper;
import com.ruoyi.elevator.mapper.CommunityMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 小区与楼栋服务
 * 对应论文模块一的基础信息管理子功能
 *
 * @author 董泽晟
 */
@Service
public class CommunityService
{
    @Autowired
    private CommunityMapper communityMapper;

    @Autowired
    private BuildingMapper buildingMapper;

    // ==================== 小区 ====================

    public List<Community> selectCommunityList(Community community)
    {
        return communityMapper.selectCommunityList(community);
    }

    public Community selectCommunityById(Long communityId)
    {
        return communityMapper.selectCommunityById(communityId);
    }

    /**
     * 新增小区
     */
    @Transactional(rollbackFor = Exception.class)
    public int insertCommunity(Community community)
    {
        if (StringUtils.isEmpty(community.getCommunityName()))
        {
            throw new ServiceException("小区名称不能为空");
        }
        community.setCreateBy(SecurityUtils.getUsername());
        return communityMapper.insertCommunity(community);
    }

    /**
     * 修改小区
     */
    @Transactional(rollbackFor = Exception.class)
    public int updateCommunity(Community community)
    {
        if (community.getCommunityId() == null)
        {
            throw new ServiceException("小区ID不能为空");
        }
        community.setUpdateBy(SecurityUtils.getUsername());
        return communityMapper.updateCommunity(community);
    }

    /**
     * 删除小区，存在关联楼栋时禁止删除
     */
    @Transactional(rollbackFor = Exception.class)
    public int deleteCommunityByIds(Long[] communityIds)
    {
        for (Long communityId : communityIds)
        {
            int buildingCount = buildingMapper.countByCommunityId(communityId);
            if (buildingCount > 0)
            {
                Community community = communityMapper.selectCommunityById(communityId);
                String name = community != null ? community.getCommunityName() : String.valueOf(communityId);
                throw new ServiceException(String.format("小区【%s】下还有 %d 个楼栋，无法删除", name, buildingCount));
            }
        }
        return communityMapper.deleteCommunityByIds(communityIds);
    }

    // ==================== 楼栋 ====================

    public List<Building> selectBuildingList(Building building)
    {
        return buildingMapper.selectBuildingList(building);
    }

    public Building selectBuildingById(Long buildingId)
    {
        return buildingMapper.selectBuildingById(buildingId);
    }

    /**
     * 新增楼栋
     */
    @Transactional(rollbackFor = Exception.class)
    public int insertBuilding(Building building)
    {
        if (building.getCommunityId() == null)
        {
            throw new ServiceException("请选择所属小区");
        }
        if (StringUtils.isEmpty(building.getBuildingNo()))
        {
            throw new ServiceException("楼栋号不能为空");
        }
        building.setCreateBy(SecurityUtils.getUsername());
        return buildingMapper.insertBuilding(building);
    }

    /**
     * 修改楼栋
     */
    @Transactional(rollbackFor = Exception.class)
    public int updateBuilding(Building building)
    {
        if (building.getBuildingId() == null)
        {
            throw new ServiceException("楼栋ID不能为空");
        }
        building.setUpdateBy(SecurityUtils.getUsername());
        return buildingMapper.updateBuilding(building);
    }

    /**
     * 删除楼栋，存在关联电梯时禁止删除
     */
    @Transactional(rollbackFor = Exception.class)
    public int deleteBuildingByIds(Long[] buildingIds)
    {
        for (Long buildingId : buildingIds)
        {
            Building building = buildingMapper.selectBuildingById(buildingId);
            if (building != null && building.getElevatorCount() != null && building.getElevatorCount() > 0)
            {
                throw new ServiceException(String.format("楼栋【%s %s】下还有 %d 台电梯，无法删除",
                        building.getBuildingNo(), building.getUnitNo(), building.getElevatorCount()));
            }
        }
        return buildingMapper.deleteBuildingByIds(buildingIds);
    }
}
