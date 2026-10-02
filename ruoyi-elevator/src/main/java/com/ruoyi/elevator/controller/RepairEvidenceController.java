package com.ruoyi.elevator.controller;

import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.elevator.domain.RepairEvidence;
import com.ruoyi.elevator.domain.ElevatorFile;
import com.ruoyi.elevator.exception.ElevatorErrorCode;
import com.ruoyi.elevator.exception.ElevatorException;
import com.ruoyi.elevator.mapper.RepairEvidenceMapper;
import com.ruoyi.elevator.service.FileService;
import com.ruoyi.elevator.util.LoginUserUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

/**
 * 报修多媒体证据管理
 * 对应论文模块二的多媒体证据上传子功能
 * 业主上传现场照片或短视频作为故障凭证，物业与管理员可查看全量证据库
 *
 * @author 董泽晟
 */
@RestController
@RequestMapping("/repair/evidence")
public class RepairEvidenceController extends BaseController
{
    @Autowired
    private FileService fileService;

    @Autowired
    private RepairEvidenceMapper repairEvidenceMapper;

    /**
     * 上传报修证据
     * 支持图片与视频，图片上限 10MB，视频上限 50MB
     *
     * @param file 文件
     * @param orderId 关联工单ID，报修提交前可为空
     */
    @PostMapping("/upload")
    public AjaxResult upload(@RequestParam("file") MultipartFile file,
                             @RequestParam(value = "orderId", required = false) Long orderId)
    {
        ElevatorFile sysFile = fileService.upload(file, FileService.BIZ_REPAIR_EVIDENCE, orderId);
        AjaxResult ajax = AjaxResult.success("上传成功");
        ajax.put("fileId", sysFile.getFileId());
        ajax.put("fileName", sysFile.getFileName());
        ajax.put("fileType", sysFile.getFileType());
        ajax.put("fileSize", sysFile.getFileSize());
        // 若已有关联工单，直接建立证据关联，并校验数量上限
        if (orderId != null)
        {
            String evidenceType = sysFile.getFileType();
            int exist = repairEvidenceMapper.countByOrderIdAndType(orderId, evidenceType);
            if (exist >= 5)
            {
                fileService.delete(sysFile.getFileId());
                throw new ElevatorException("同一工单下" + ("image".equals(evidenceType) ? "图片" : "视频") + "最多上传 5 个");
            }
            RepairEvidence evidence = new RepairEvidence();
            evidence.setOrderId(orderId);
            evidence.setFileId(sysFile.getFileId());
            evidence.setEvidenceType(evidenceType);
            evidence.setCreateBy(LoginUserUtil.getUsername());
            repairEvidenceMapper.insertRepairEvidence(evidence);
            ajax.put("evidenceId", evidence.getEvidenceId());
        }
        return ajax;
    }

    /**
     * 查询证据列表，管理端证据库使用
     */
    @PreAuthorize("@ss.hasPermi('repair:evidence:list')")
    @GetMapping("/list")
    public TableDataInfo list(RepairEvidence repairEvidence)
    {
        startPage();
        return getDataTable(repairEvidenceMapper.selectRepairEvidenceList(repairEvidence));
    }

    /**
     * 查询指定工单下的证据，业主端与物业端共用
     */
    @GetMapping("/byOrder/{orderId}")
    public AjaxResult byOrder(@PathVariable("orderId") Long orderId)
    {
        return success(repairEvidenceMapper.selectByOrderId(orderId));
    }

    /**
     * 删除证据
     */
    @PreAuthorize("@ss.hasPermi('repair:evidence:remove')")
    @DeleteMapping("/{evidenceId}")
    public AjaxResult remove(@PathVariable("evidenceId") Long evidenceId)
    {
        return toAjax(repairEvidenceMapper.deleteRepairEvidenceById(evidenceId));
    }

    /**
     * 校验证据上传数量上限，供前端在提交前预校验
     */
    @GetMapping("/checkLimit")
    public AjaxResult checkLimit(@RequestParam("orderId") Long orderId,
                                 @RequestParam("evidenceType") String evidenceType)
    {
        if (StringUtils.isEmpty(evidenceType))
        {
            throw new ElevatorException(ElevatorErrorCode.FILE_TYPE_UNSUPPORTED.getMessage());
        }
        int count = repairEvidenceMapper.countByOrderIdAndType(orderId, evidenceType);
        AjaxResult ajax = AjaxResult.success();
        ajax.put("count", count);
        ajax.put("limit", 5);
        ajax.put("allowUpload", count < 5);
        return ajax;
    }
}
