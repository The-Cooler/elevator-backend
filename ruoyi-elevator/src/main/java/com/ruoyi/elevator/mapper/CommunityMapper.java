package com.ruoyi.elevator.mapper;

import com.ruoyi.elevator.domain.Community;

import java.util.List;

/**
 * 小区信息 数据层
 *
 * @author 董泽晟
 */
public interface CommunityMapper
{
    List<Community> selectCommunityList(Community community);

    Community selectCommunityById(Long communityId);

    int insertCommunity(Community community);

    int updateCommunity(Community community);

    int deleteCommunityByIds(Long[] communityIds);

    int selectCommunityCount();
}
