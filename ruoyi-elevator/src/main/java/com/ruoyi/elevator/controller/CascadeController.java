package com.ruoyi.elevator.controller;

import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.elevator.domain.Building;
import com.ruoyi.elevator.domain.Community;
import com.ruoyi.elevator.service.CommunityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

/**
 * 基础数据级联查询接口
 * 供小程序端的注册页、报修页选择所属小区与楼栋使用
 * 需要登录后访问
 *
 * @author 董泽晟
 */
@RestController
@RequestMapping("/common/cascade")
public class CascadeController extends BaseController
{
    @Autowired
    private CommunityService communityService;

    /**
     * 小区列表，供注册与报修时选择所属小区
     */
    @GetMapping("/community/list")
    public AjaxResult communityList()
    {
        return success(communityService.selectCommunityList(new Community()));
    }

    /**
     * 楼栋列表，按小区筛选，供级联选择使用
     */
    @GetMapping("/building/list")
    public AjaxResult buildingList(@RequestParam(value = "communityId", required = false) Long communityId)
    {
        Building query = new Building();
        query.setCommunityId(communityId);
        return success(communityService.selectBuildingList(query));
    }
}
