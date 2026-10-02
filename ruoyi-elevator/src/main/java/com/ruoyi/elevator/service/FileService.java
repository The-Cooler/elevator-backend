package com.ruoyi.elevator.service;

import com.ruoyi.common.config.RuoYiConfig;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.common.utils.file.FileUploadUtils;
import com.ruoyi.elevator.domain.ElevatorFile;
import com.ruoyi.elevator.exception.ElevatorErrorCode;
import com.ruoyi.elevator.exception.ElevatorException;
import com.ruoyi.elevator.mapper.ElevatorFileMapper;
import com.ruoyi.elevator.util.LoginUserUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.util.Arrays;
import java.util.List;

/**
 * 文件服务
 * 负责文件上传校验、落库、业务绑定与删除
 * 被模块一的电梯证件上传、模块二的报修证据上传、模块四的巡检结果上传复用
 *
 * @author 董泽晟
 */
@Service
public class FileService
{
    private static final Logger log = LoggerFactory.getLogger(FileService.class);

    /** 图片允许的扩展名 */
    public static final String[] IMAGE_EXTENSION = { "jpg", "jpeg", "png", "webp", "bmp" };

    /** 视频允许的扩展名 */
    public static final String[] VIDEO_EXTENSION = { "mp4", "mov", "avi", "webm" };

    /** 文档允许的扩展名 */
    public static final String[] DOC_EXTENSION = { "doc", "docx", "xls", "xlsx", "pdf" };

    /** 图片大小上限：10MB */
    public static final long IMAGE_MAX_SIZE = 10 * 1024 * 1024L;

    /** 视频大小上限：50MB */
    public static final long VIDEO_MAX_SIZE = 50 * 1024 * 1024L;

    /** 文档大小上限：20MB */
    public static final long DOC_MAX_SIZE = 20 * 1024 * 1024L;

    /** 业务类型：电梯证件 */
    public static final String BIZ_ELEVATOR_CERT = "elevator_cert";

    /** 业务类型：报修证据 */
    public static final String BIZ_REPAIR_EVIDENCE = "repair_evidence";

    /** 业务类型：巡检结果 */
    public static final String BIZ_INSPECTION = "inspection";

    /** 业务类型：导出报表 */
    public static final String BIZ_REPORT = "report";

    @Autowired
    private ElevatorFileMapper sysFileMapper;

    /**
     * 上传文件并写入 sys_file 表
     *
     * @param file 上传的文件
     * @param bizType 业务类型
     * @param bizId 关联业务ID，可为空，后续通过 bindBiz 绑定
     * @return 文件信息
     */
    public ElevatorFile upload(MultipartFile file, String bizType, Long bizId)
    {
        if (file == null || file.isEmpty())
        {
            throw new ElevatorException("上传文件不能为空");
        }

        String originalName = file.getOriginalFilename();
        String suffix = getSuffix(originalName);
        String fileType = resolveFileType(suffix);
        assertAllowed(fileType, suffix, file.getSize());

        String storagePath;
        try
        {
            // 按业务类型分目录存储
            String baseDir = RuoYiConfig.getUploadPath() + "/" + bizType;
            String[] allowed = concatAll();
            storagePath = FileUploadUtils.upload(baseDir, file, allowed);
        }
        catch (Exception e)
        {
            log.error("文件上传失败", e);
            throw new ElevatorException("文件上传失败：" + e.getMessage());
        }

        ElevatorFile sysFile = new ElevatorFile();
        sysFile.setFileName(originalName);
        sysFile.setFilePath(storagePath);
        sysFile.setFileUrl(RuoYiConfig.getProfile() + StringUtils.substringAfter(storagePath, RuoYiConfig.getProfile()));
        sysFile.setFileType(fileType);
        sysFile.setFileSuffix(suffix);
        sysFile.setFileSize(file.getSize());
        sysFile.setBizType(bizType);
        sysFile.setBizId(bizId);
        sysFile.setUploadBy(LoginUserUtil.getUsername());
        sysFileMapper.insertSysFile(sysFile);
        return sysFile;
    }

    /**
     * 批量上传
     */
    public List<ElevatorFile> uploadBatch(List<MultipartFile> files, String bizType, Long bizId)
    {
        if (files == null || files.isEmpty())
        {
            throw new ElevatorException("上传文件不能为空");
        }
        return files.stream().map(f -> upload(f, bizType, bizId)).collect(java.util.stream.Collectors.toList());
    }

    /**
     * 查询文件
     */
    public ElevatorFile getById(Long fileId)
    {
        ElevatorFile sysFile = sysFileMapper.selectSysFileById(fileId);
        if (sysFile == null)
        {
            throw new ElevatorException(ElevatorErrorCode.FILE_NOT_EXIST.getMessage(),
                    ElevatorErrorCode.FILE_NOT_EXIST.getCode());
        }
        return sysFile;
    }

    /**
     * 查询某业务对象下的文件列表
     */
    public List<ElevatorFile> listByBiz(String bizType, Long bizId)
    {
        return sysFileMapper.selectByBiz(bizType, bizId);
    }

    /**
     * 将已上传的文件绑定到业务对象
     */
    public void bindBiz(Long[] fileIds, String bizType, Long bizId)
    {
        if (fileIds == null || fileIds.length == 0)
        {
            return;
        }
        sysFileMapper.bindBiz(fileIds, bizType, bizId);
    }

    /**
     * 删除文件（逻辑删除）
     */
    public int delete(Long fileId)
    {
        return sysFileMapper.deleteSysFileById(fileId);
    }

    /**
     * 校验文件类型与大小
     */
    private void assertAllowed(String fileType, String suffix, long size)
    {
        if ("unknown".equals(fileType))
        {
            throw new ElevatorException("不支持的文件类型：" + suffix,
                    ElevatorErrorCode.FILE_TYPE_UNSUPPORTED.getCode());
        }
        long maxSize;
        switch (fileType)
        {
            case "image":
                maxSize = IMAGE_MAX_SIZE;
                break;
            case "video":
                maxSize = VIDEO_MAX_SIZE;
                break;
            default:
                maxSize = DOC_MAX_SIZE;
                break;
        }
        if (size > maxSize)
        {
            throw new ElevatorException(
                    String.format("%s文件大小超出限制，最大允许 %dMB", typeName(fileType), maxSize / 1024 / 1024),
                    ElevatorErrorCode.FILE_SIZE_EXCEEDED.getCode());
        }
    }

    private String typeName(String fileType)
    {
        switch (fileType)
        {
            case "image":
                return "图片";
            case "video":
                return "视频";
            default:
                return "文档";
        }
    }

    /**
     * 根据后缀判定文件类型
     */
    private String resolveFileType(String suffix)
    {
        if (contains(IMAGE_EXTENSION, suffix))
        {
            return "image";
        }
        if (contains(VIDEO_EXTENSION, suffix))
        {
            return "video";
        }
        if (contains(DOC_EXTENSION, suffix))
        {
            return "doc";
        }
        return "unknown";
    }

    private boolean contains(String[] arr, String value)
    {
        return Arrays.stream(arr).anyMatch(v -> v.equalsIgnoreCase(value));
    }

    private String getSuffix(String filename)
    {
        if (StringUtils.isEmpty(filename) || !filename.contains("."))
        {
            return "";
        }
        return filename.substring(filename.lastIndexOf(".") + 1).toLowerCase();
    }

    private String[] concatAll()
    {
        String[] all = new String[IMAGE_EXTENSION.length + VIDEO_EXTENSION.length + DOC_EXTENSION.length];
        System.arraycopy(IMAGE_EXTENSION, 0, all, 0, IMAGE_EXTENSION.length);
        System.arraycopy(VIDEO_EXTENSION, 0, all, IMAGE_EXTENSION.length, VIDEO_EXTENSION.length);
        System.arraycopy(DOC_EXTENSION, 0, all, IMAGE_EXTENSION.length + VIDEO_EXTENSION.length, DOC_EXTENSION.length);
        return all;
    }
}
