package com.ruoyi.elevator.controller;

import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.elevator.domain.Building;
import com.ruoyi.elevator.domain.Community;
import com.ruoyi.elevator.service.CommunityService;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * 小区与楼栋管理
 * 对应论文模块一基础数据与权限管理中的基础信息管理子功能
 *
 * @author 董泽晟
 */
@RestController
@RequestMapping("/basic")
public class CommunityController extends BaseController
{
    @Autowired
    private CommunityService communityService;

    // ==================== 小区 ====================

    /**
     * 查询小区列表
     */
    @PreAuthorize("@ss.hasPermi('basic:info:list')")
    @GetMapping("/community/list")
    public TableDataInfo communityList(Community community)
    {
        startPage();
        List<Community> list = communityService.selectCommunityList(community);
        return getDataTable(list);
    }

    /**
     * 查询全部小区，供级联选择使用，不分页
     */
    @GetMapping("/community/all")
    public AjaxResult communityAll(Community community)
    {
        return success(communityService.selectCommunityList(community));
    }

    /**
     * 查询小区详情
     */
    @PreAuthorize("@ss.hasPermi('basic:info:query')")
    @GetMapping("/community/{communityId}")
    public AjaxResult getCommunity(@PathVariable("communityId") Long communityId)
    {
        return success(communityService.selectCommunityById(communityId));
    }

    /**
     * 新增小区
     */
    @PreAuthorize("@ss.hasPermi('basic:info:add')")
    @Log(title = "小区信息", businessType = BusinessType.INSERT)
    @PostMapping("/community")
    public AjaxResult addCommunity(@RequestBody Community community)
    {
        return toAjax(communityService.insertCommunity(community));
    }

    /**
     * 修改小区
     */
    @PreAuthorize("@ss.hasPermi('basic:info:edit')")
    @Log(title = "小区信息", businessType = BusinessType.UPDATE)
    @PutMapping("/community")
    public AjaxResult editCommunity(@RequestBody Community community)
    {
        return toAjax(communityService.updateCommunity(community));
    }

    /**
     * 删除小区
     */
    @PreAuthorize("@ss.hasPermi('basic:info:remove')")
    @Log(title = "小区信息", businessType = BusinessType.DELETE)
    @DeleteMapping("/community/{communityIds}")
    public AjaxResult removeCommunity(@PathVariable("communityIds") Long[] communityIds)
    {
        return toAjax(communityService.deleteCommunityByIds(communityIds));
    }

    /**
     * 导出小区列表
     */
    @PreAuthorize("@ss.hasPermi('basic:info:export')")
    @Log(title = "小区信息", businessType = BusinessType.EXPORT)
    @PostMapping("/community/export")
    public void exportCommunity(HttpServletResponse response, Community community)
    {
        List<Community> list = communityService.selectCommunityList(community);
        ExcelUtil<Community> util = new ExcelUtil<>(Community.class);
        util.exportExcel(response, list, "小区信息");
    }

    // ==================== 楼栋 ====================

    /**
     * 查询楼栋列表
     */
    @PreAuthorize("@ss.hasPermi('basic:info:list')")
    @GetMapping("/building/list")
    public TableDataInfo buildingList(Building building)
    {
        startPage();
        List<Building> list = communityService.selectBuildingList(building);
        return getDataTable(list);
    }

    /**
     * 查询全部楼栋，供级联选择使用，不分页
     */
    @GetMapping("/building/all")
    public AjaxResult buildingAll(Building building)
    {
        return success(communityService.selectBuildingList(building));
    }

    /**
     * 查询楼栋详情
     */
    @PreAuthorize("@ss.hasPermi('basic:info:query')")
    @GetMapping("/building/{buildingId}")
    public AjaxResult getBuilding(@PathVariable("buildingId") Long buildingId)
    {
        return success(communityService.selectBuildingById(buildingId));
    }

    /**
     * 新增楼栋
     */
    @PreAuthorize("@ss.hasPermi('basic:info:add')")
    @Log(title = "楼栋信息", businessType = BusinessType.INSERT)
    @PostMapping("/building")
    public AjaxResult addBuilding(@RequestBody Building building)
    {
        return toAjax(communityService.insertBuilding(building));
    }

    /**
     * 修改楼栋
     */
    @PreAuthorize("@ss.hasPermi('basic:info:edit')")
    @Log(title = "楼栋信息", businessType = BusinessType.UPDATE)
    @PutMapping("/building")
    public AjaxResult editBuilding(@RequestBody Building building)
    {
        return toAjax(communityService.updateBuilding(building));
    }

    /**
     * 删除楼栋
     */
    @PreAuthorize("@ss.hasPermi('basic:info:remove')")
    @Log(title = "楼栋信息", businessType = BusinessType.DELETE)
    @DeleteMapping("/building/{buildingIds}")
    public AjaxResult removeBuilding(@PathVariable("buildingIds") Long[] buildingIds)
    {
        return toAjax(communityService.deleteBuildingByIds(buildingIds));
    }

    /**
     * 导出楼栋列表
     */
    @PreAuthorize("@ss.hasPermi('basic:info:export')")
    @Log(title = "楼栋信息", businessType = BusinessType.EXPORT)
    @PostMapping("/building/export")
    public void exportBuilding(HttpServletResponse response, Building building)
    {
        List<Building> list = communityService.selectBuildingList(building);
        ExcelUtil<Building> util = new ExcelUtil<>(Building.class);
        util.exportExcel(response, list, "楼栋信息");
    }
}
