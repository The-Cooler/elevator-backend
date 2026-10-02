package com.ruoyi.elevator.mapper;

import com.ruoyi.elevator.domain.ElevatorFile;

import java.util.List;

/**
 * 文件信息 数据层
 * 对应数据表 sys_file
 * 类名使用 ElevatorFileMapper，避免与 RuoYi 框架自带的 SysFile 类型别名冲突
 *
 * @author 董泽晟
 */
public interface ElevatorFileMapper
{
    /**
     * 查询文件信息
     *
     * @param fileId 文件ID
     * @return 文件信息
     */
    ElevatorFile selectSysFileById(Long fileId);

    /**
     * 查询文件列表
     *
     * @param elevatorFile 文件信息
     * @return 文件集合
     */
    List<ElevatorFile> selectSysFileList(ElevatorFile elevatorFile);

    /**
     * 查询某业务对象下的文件列表
     *
     * @param bizType 业务类型
     * @param bizId 业务ID
     * @return 文件集合
     */
    List<ElevatorFile> selectByBiz(String bizType, Long bizId);

    /**
     * 新增文件信息
     *
     * @param elevatorFile 文件信息
     * @return 结果
     */
    int insertSysFile(ElevatorFile elevatorFile);

    /**
     * 批量绑定文件到业务对象
     *
     * @param fileIds 文件ID数组
     * @param bizType 业务类型
     * @param bizId 业务ID
     * @return 结果
     */
    int bindBiz(Long[] fileIds, String bizType, Long bizId);

    /**
     * 逻辑删除文件
     *
     * @param fileId 文件ID
     * @return 结果
     */
    int deleteSysFileById(Long fileId);
}
