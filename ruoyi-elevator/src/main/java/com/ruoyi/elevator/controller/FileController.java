package com.ruoyi.elevator.controller;

import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.utils.file.FileUtils;
import com.ruoyi.elevator.domain.ElevatorFile;
import com.ruoyi.elevator.service.FileService;
import jakarta.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
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
 * 文件上传与预览
 * 供模块一的电梯证件、模块二的报修证据、模块四的巡检结果复用
 *
 * @author 董泽晟
 */
@RestController
@RequestMapping("/common/file")
public class FileController extends BaseController
{
    private static final Logger log = LoggerFactory.getLogger(FileController.class);

    @Autowired
    private FileService fileService;

    /**
     * 上传单个文件
     *
     * @param file 文件
     * @param bizType 业务类型（elevator_cert / repair_evidence / inspection / report）
     * @param bizId 业务ID，可为空
     */
    @PostMapping("/upload")
    public AjaxResult upload(@RequestParam("file") MultipartFile file,
                             @RequestParam("bizType") String bizType,
                             @RequestParam(value = "bizId", required = false) Long bizId)
    {
        ElevatorFile sysFile = fileService.upload(file, bizType, bizId);
        AjaxResult ajax = AjaxResult.success("上传成功");
        ajax.put("fileId", sysFile.getFileId());
        ajax.put("fileName", sysFile.getFileName());
        ajax.put("fileUrl", sysFile.getFileUrl());
        ajax.put("fileType", sysFile.getFileType());
        ajax.put("fileSize", sysFile.getFileSize());
        return ajax;
    }

    /**
     * 批量上传文件，最多 5 个
     */
    @PostMapping("/uploadBatch")
    public AjaxResult uploadBatch(@RequestParam("files") List<MultipartFile> files,
                                  @RequestParam("bizType") String bizType,
                                  @RequestParam(value = "bizId", required = false) Long bizId)
    {
        if (files.size() > 5)
        {
            return AjaxResult.error("单次上传文件数量不能超过 5 个");
        }
        List<ElevatorFile> list = fileService.uploadBatch(files, bizType, bizId);
        return AjaxResult.success("上传成功", list);
    }

    /**
     * 查询文件列表
     */
    @GetMapping("/list")
    public TableDataInfo list(ElevatorFile sysFile)
    {
        startPage();
        return getDataTable(fileService.listByBiz(sysFile.getBizType(), sysFile.getBizId()));
    }

    /**
     * 文件预览，图片与视频支持浏览器直接打开
     */
    @GetMapping("/preview/{fileId}")
    public void preview(@PathVariable("fileId") Long fileId, HttpServletResponse response)
    {
        ElevatorFile sysFile = fileService.getById(fileId);
        try
        {
            response.setContentType(resolveContentType(sysFile.getFileType(), sysFile.getFileSuffix()));
            FileUtils.writeBytes(sysFile.getFilePath(), response.getOutputStream());
        }
        catch (Exception e)
        {
            log.error("文件预览失败，fileId={}", fileId, e);
        }
    }

    /**
     * 文件下载
     */
    @GetMapping("/download/{fileId}")
    public void download(@PathVariable("fileId") Long fileId, HttpServletResponse response)
    {
        ElevatorFile sysFile = fileService.getById(fileId);
        try
        {
            response.setContentType(MediaType.APPLICATION_OCTET_STREAM_VALUE);
            FileUtils.setAttachmentResponseHeader(response, sysFile.getFileName());
            FileUtils.writeBytes(sysFile.getFilePath(), response.getOutputStream());
        }
        catch (Exception e)
        {
            log.error("文件下载失败，fileId={}", fileId, e);
        }
    }

    /**
     * 删除文件
     */
    @DeleteMapping("/{fileId}")
    public AjaxResult remove(@PathVariable("fileId") Long fileId)
    {
        return toAjax(fileService.delete(fileId));
    }

    private String resolveContentType(String fileType, String suffix)
    {
        if ("image".equals(fileType))
        {
            return "image/" + ("jpg".equals(suffix) ? "jpeg" : suffix);
        }
        if ("video".equals(fileType))
        {
            return "video/" + suffix;
        }
        if ("pdf".equals(suffix))
        {
            return MediaType.APPLICATION_PDF_VALUE;
        }
        return MediaType.APPLICATION_OCTET_STREAM_VALUE;
    }
}
