package com.ruoyi.elevator.service;

import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.elevator.domain.Elevator;
import com.ruoyi.elevator.domain.ElevatorFile;
import com.ruoyi.elevator.mapper.ElevatorMapper;
import com.ruoyi.elevator.mapper.ElevatorFileMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 电梯信息服务
 * 对应论文模块一的基础信息管理子功能，管理电梯台账与年检证件附件
 *
 * @author 董泽晟
 */
@Service
public class ElevatorService
{
    @Autowired
    private ElevatorMapper elevatorMapper;

    @Autowired
    private ElevatorFileMapper sysFileMapper;

    public List<Elevator> selectElevatorList(Elevator elevator)
    {
        return elevatorMapper.selectElevatorList(elevator);
    }

    public Elevator selectElevatorById(Long elevatorId)
    {
        Elevator elevator = elevatorMapper.selectElevatorById(elevatorId);
        if (elevator == null)
        {
            throw new ServiceException("电梯不存在");
        }
        if (elevator.getCertFileId() != null)
        {
            ElevatorFile certFile = sysFileMapper.selectSysFileById(elevator.getCertFileId());
            if (certFile != null)
            {
                elevator.setCertFileName(certFile.getFileName());
            }
        }
        return elevator;
    }

    /**
     * 新增电梯
     */
    @Transactional(rollbackFor = Exception.class)
    public int insertElevator(Elevator elevator)
    {
        checkElevator(elevator, true);
        elevator.setCreateBy(SecurityUtils.getUsername());
        return elevatorMapper.insertElevator(elevator);
    }

    /**
     * 修改电梯
     */
    @Transactional(rollbackFor = Exception.class)
    public int updateElevator(Elevator elevator)
    {
        if (elevator.getElevatorId() == null)
        {
            throw new ServiceException("电梯ID不能为空");
        }
        checkElevator(elevator, false);
        elevator.setUpdateBy(SecurityUtils.getUsername());
        return elevatorMapper.updateElevator(elevator);
    }

    /**
     * 批量删除电梯
     */
    @Transactional(rollbackFor = Exception.class)
    public int deleteElevatorByIds(Long[] elevatorIds)
    {
        return elevatorMapper.deleteElevatorByIds(elevatorIds);
    }

    /**
     * 变更电梯状态
     */
    @Transactional(rollbackFor = Exception.class)
    public int updateElevatorStatus(Long elevatorId, String status)
    {
        if (StringUtils.isEmpty(status))
        {
            throw new ServiceException("电梯状态不能为空");
        }
        return elevatorMapper.updateElevatorStatus(elevatorId, status);
    }

    /**
     * 绑定年检报告附件到电梯
     */
    @Transactional(rollbackFor = Exception.class)
    public int bindCertFile(Long elevatorId, Long fileId)
    {
        Elevator elevator = new Elevator();
        elevator.setElevatorId(elevatorId);
        elevator.setCertFileId(fileId);
        elevator.setUpdateBy(SecurityUtils.getUsername());
        return elevatorMapper.updateElevator(elevator);
    }

    /**
     * 查询电梯所在位置信息，供报修页级联选择
     */
    public List<Elevator> selectElevatorWithLocation(Elevator elevator)
    {
        return elevatorMapper.selectElevatorWithLocation(elevator);
    }

    /**
     * 校验电梯数据合法性
     *
     * @param elevator 电梯信息
     * @param isInsert 是否为新增
     */
    private void checkElevator(Elevator elevator, boolean isInsert)
    {
        if (StringUtils.isEmpty(elevator.getElevatorCode()))
        {
            throw new ServiceException("电梯编号不能为空");
        }
        if (elevator.getBuildingId() == null)
        {
            throw new ServiceException("请选择所在楼栋");
        }
        int count = elevatorMapper.checkElevatorCodeUnique(elevator.getElevatorCode(), elevator.getElevatorId());
        if (count > 0)
        {
            throw new ServiceException("电梯编号【" + elevator.getElevatorCode() + "】已存在");
        }
        if (isInsert && StringUtils.isEmpty(elevator.getStatus()))
        {
            // 新增电梯默认正常状态
            elevator.setStatus("0");
        }
    }
}
