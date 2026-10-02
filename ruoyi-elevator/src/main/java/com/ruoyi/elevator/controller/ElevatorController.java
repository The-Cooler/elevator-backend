package com.ruoyi.elevator.controller;

import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.elevator.domain.Elevator;
import com.ruoyi.elevator.service.ElevatorService;
import com.ruoyi.elevator.service.FileService;
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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

/**
 * 电梯台账管理
 * 对应论文模块一基础信息管理子功能中的电梯信息维护与证件附件上传
 *
 * @author 董泽晟
 */
@RestController
@RequestMapping("/basic/elevator")
public class ElevatorController extends BaseController
{
    @Autowired
    private ElevatorService elevatorService;

    @Autowired
    private FileService fileService;

    /**
     * 查询电梯列表
     */
    @PreAuthorize("@ss.hasPermi('basic:info:list')")
    @GetMapping("/list")
    public TableDataInfo list(Elevator elevator)
    {
        startPage();
        List<Elevator> list = elevatorService.selectElevatorList(elevator);
        return getDataTable(list);
    }

    /**
     * 查询电梯详情
     */
    @PreAuthorize("@ss.hasPermi('basic:info:query')")
    @GetMapping("/{elevatorId}")
    public AjaxResult getInfo(@PathVariable("elevatorId") Long elevatorId)
    {
        return success(elevatorService.selectElevatorById(elevatorId));
    }

    /**
     * 查询电梯位置信息，供报修页级联选择，不分页
     */
    @GetMapping("/location")
    public AjaxResult location(Elevator elevator)
    {
        return success(elevatorService.selectElevatorWithLocation(elevator));
    }

    /**
     * 新增电梯
     */
    @PreAuthorize("@ss.hasPermi('basic:info:add')")
    @Log(title = "电梯信息", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody Elevator elevator)
    {
        return toAjax(elevatorService.insertElevator(elevator));
    }

    /**
     * 修改电梯
     */
    @PreAuthorize("@ss.hasPermi('basic:info:edit')")
    @Log(title = "电梯信息", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody Elevator elevator)
    {
        return toAjax(elevatorService.updateElevator(elevator));
    }

    /**
     * 变更电梯状态
     */
    @PreAuthorize("@ss.hasPermi('basic:info:edit')")
    @Log(title = "电梯状态", businessType = BusinessType.UPDATE)
    @PutMapping("/changeStatus")
    public AjaxResult changeStatus(@RequestBody Elevator elevator)
    {
        return toAjax(elevatorService.updateElevatorStatus(elevator.getElevatorId(), elevator.getStatus()));
    }

    /**
     * 上传电梯年检报告等证件附件
     */
    @PreAuthorize("@ss.hasPermi('basic:info:edit')")
    @Log(title = "电梯证件", businessType = BusinessType.UPDATE)
    @PostMapping("/uploadCert")
    public AjaxResult uploadCert(@RequestParam("file") MultipartFile file,
                                 @RequestParam("elevatorId") Long elevatorId)
    {
        var sysFile = fileService.upload(file, FileService.BIZ_ELEVATOR_CERT, elevatorId);
        elevatorService.bindCertFile(elevatorId, sysFile.getFileId());
        AjaxResult ajax = AjaxResult.success("证件上传成功");
        ajax.put("fileId", sysFile.getFileId());
        ajax.put("fileName", sysFile.getFileName());
        return ajax;
    }

    /**
     * 删除电梯
     */
    @PreAuthorize("@ss.hasPermi('basic:info:remove')")
    @Log(title = "电梯信息", businessType = BusinessType.DELETE)
    @DeleteMapping("/{elevatorIds}")
    public AjaxResult remove(@PathVariable("elevatorIds") Long[] elevatorIds)
    {
        return toAjax(elevatorService.deleteElevatorByIds(elevatorIds));
    }

    /**
     * 导出电梯台账
     */
    @PreAuthorize("@ss.hasPermi('basic:info:export')")
    @Log(title = "电梯信息", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, Elevator elevator)
    {
        List<Elevator> list = elevatorService.selectElevatorList(elevator);
        ExcelUtil<Elevator> util = new ExcelUtil<>(Elevator.class);
        util.exportExcel(response, list, "电梯台账");
    }
}
