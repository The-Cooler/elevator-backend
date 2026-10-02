package com.ruoyi.elevator.service;

import com.ruoyi.common.utils.DateUtils;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.elevator.domain.InspectionItemResult;
import com.ruoyi.elevator.domain.InspectionRecord;
import com.ruoyi.elevator.domain.MaintainArchive;
import com.ruoyi.elevator.domain.MaintainItem;
import com.ruoyi.elevator.domain.MaintainPlan;
import com.ruoyi.elevator.exception.ElevatorErrorCode;
import com.ruoyi.elevator.exception.ElevatorException;
import com.ruoyi.elevator.mapper.ElevatorMapper;
import com.ruoyi.elevator.mapper.InspectionMapper;
import com.ruoyi.elevator.mapper.MaintainPlanMapper;
import com.ruoyi.elevator.util.LoginUserUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * 巡检执行服务
 * 对应论文模块四的定期巡检执行与维保档案归档子功能
 * 系统按周期自动生成巡检工单并派发，维修员现场打卡、勾选检查项、上传结果，系统归档形成维保记录
 *
 * @author 董泽晟
 */
@Service
public class InspectionService
{
    private static final Logger log = LoggerFactory.getLogger(InspectionService.class);

    @Autowired
    private InspectionMapper inspectionMapper;

    @Autowired
    private MaintainPlanMapper maintainPlanMapper;

    @Autowired
    private MaintainPlanService maintainPlanService;

    @Autowired
    private ElevatorMapper elevatorMapper;

    @Autowired
    private NoticeService noticeService;

    // ==================== 巡检任务查询 ====================

    /**
     * 查询巡检记录列表
     */
    public List<InspectionRecord> selectInspectionRecordList(InspectionRecord query)
    {
        return inspectionMapper.selectInspectionRecordList(query);
    }

    /**
     * 查询指派给当前维修员的巡检任务
     */
    public List<InspectionRecord> myList(InspectionRecord query)
    {
        query.setQueryExecutorId(LoginUserUtil.getUserId());
        return inspectionMapper.selectInspectionRecordList(query);
    }

    /**
     * 查询巡检记录详情，含检查项结果明细
     */
    public InspectionRecord selectInspectionRecordById(Long recordId)
    {
        InspectionRecord record = inspectionMapper.selectInspectionRecordById(recordId);
        if (record == null)
        {
            throw new ElevatorException(ElevatorErrorCode.INSPECTION_NOT_EXIST.getMessage(),
                    ElevatorErrorCode.INSPECTION_NOT_EXIST.getCode());
        }
        record.setItemResults(inspectionMapper.selectItemResultsByRecordId(recordId));
        return record;
    }

    /**
     * 查询指定电梯应执行的检查项清单，供巡检执行页加载
     * 优先按计划绑定的模板加载，计划未绑定模板时按维保类型加载默认模板
     */
    public List<MaintainItem> selectItemsForRecord(Long recordId)
    {
        InspectionRecord record = inspectionMapper.selectInspectionRecordById(recordId);
        if (record == null)
        {
            throw new ElevatorException(ElevatorErrorCode.INSPECTION_NOT_EXIST.getMessage(),
                    ElevatorErrorCode.INSPECTION_NOT_EXIST.getCode());
        }
        String templateName = null;
        if (record.getPlanId() != null)
        {
            MaintainPlan plan = maintainPlanMapper.selectMaintainPlanById(record.getPlanId());
            if (plan != null)
            {
                templateName = plan.getTemplateName();
            }
        }
        if (StringUtils.isEmpty(templateName))
        {
            templateName = MaintainPlanService.defaultTemplateOf(record.getMaintainType());
        }
        return maintainPlanMapper.selectItemsByTemplate(record.getMaintainType(), templateName);
    }

    /**
     * 查询指定电梯的检查项清单，供无巡检工单时预览检查项使用
     */
    public List<MaintainItem> selectItemsByElevator(Long elevatorId, String maintainType)
    {
        com.ruoyi.elevator.domain.Elevator elevator = elevatorMapper.selectElevatorById(elevatorId);
        if (elevator == null)
        {
            throw new ElevatorException("电梯不存在");
        }
        String templateName = MaintainPlanService.defaultTemplateOf(maintainType);
        return maintainPlanMapper.selectItemsByTemplate(maintainType, templateName);
    }

    // ==================== 巡检执行 ====================

    /**
     * 现场打卡，记录打卡时间与定位
     */
    @Transactional(rollbackFor = Exception.class)
    public int clockIn(Long recordId, String location)
    {
        InspectionRecord record = mustGetRecord(recordId);
        if ("finished".equals(record.getRecordStatus()))
        {
            throw new ElevatorException(ElevatorErrorCode.INSPECTION_FINISHED.getMessage(),
                    ElevatorErrorCode.INSPECTION_FINISHED.getCode());
        }
        InspectionRecord update = new InspectionRecord();
        update.setRecordId(recordId);
        update.setClockInTime(new Date());
        update.setClockInLocation(location);
        // 未指定执行人时，把打卡人设为执行人
        if (record.getExecutorId() == null)
        {
            update.setExecutorId(LoginUserUtil.getUserId());
        }
        update.setUpdateBy(LoginUserUtil.getUsername());
        return inspectionMapper.updateInspectionRecord(update);
    }

    /**
     * 提交巡检结果，逐项记录检查结果，统计正常与异常项数，并生成维保档案
     *
     * @param record 携带 recordId 与 submitItems 的巡检记录
     */
    @Transactional(rollbackFor = Exception.class)
    public int submit(InspectionRecord record)
    {
        InspectionRecord exist = mustGetRecord(record.getRecordId());
        if ("finished".equals(exist.getRecordStatus()))
        {
            throw new ElevatorException(ElevatorErrorCode.INSPECTION_FINISHED.getMessage(),
                    ElevatorErrorCode.INSPECTION_FINISHED.getCode());
        }
        List<InspectionItemResult> items = record.getSubmitItems();
        if (items == null || items.isEmpty())
        {
            throw new ElevatorException("请至少填写一项检查结果");
        }

        // 统计各结果数量
        int normalCount = 0;
        int abnormalCount = 0;
        int naCount = 0;
        StringBuilder abnormalSb = new StringBuilder();
        int order = 1;
        for (InspectionItemResult item : items)
        {
            item.setRecordId(record.getRecordId());
            item.setOrderNum(order++);
            if (StringUtils.isEmpty(item.getCheckResult()))
            {
                item.setCheckResult("normal");
            }
            switch (item.getCheckResult())
            {
                case "abnormal":
                    abnormalCount++;
                    if (StringUtils.isNotEmpty(item.getAbnormalDesc()))
                    {
                        if (abnormalSb.length() > 0)
                        {
                            abnormalSb.append("；");
                        }
                        abnormalSb.append(item.getItemName()).append("：").append(item.getAbnormalDesc());
                    }
                    break;
                case "na":
                    naCount++;
                    break;
                default:
                    normalCount++;
                    break;
            }
        }

        // 重新提交时先清理旧结果
        inspectionMapper.deleteItemResultsByRecordId(record.getRecordId());
        inspectionMapper.batchInsertItemResults(items);

        String executeResult = abnormalCount > 0 ? "abnormal" : "normal";
        InspectionRecord update = new InspectionRecord();
        update.setRecordId(record.getRecordId());
        update.setExecuteDate(new Date());
        update.setExecuteResult(executeResult);
        update.setAbnormalDesc(abnormalSb.length() > 0 ? abnormalSb.toString() : record.getAbnormalDesc());
        update.setNormalCount(normalCount);
        update.setAbnormalCount(abnormalCount);
        update.setNaCount(naCount);
        update.setRecordStatus("finished");
        if (exist.getExecutorId() == null)
        {
            update.setExecutorId(LoginUserUtil.getUserId());
        }
        update.setUpdateBy(LoginUserUtil.getUsername());
        int rows = inspectionMapper.updateInspectionRecord(update);

        // 关联的维保计划顺延下次维保日期
        if (exist.getPlanId() != null)
        {
            maintainPlanService.updatePlanAfterExecute(exist.getPlanId());
        }

        // 生成维保档案
        createArchive(exist, executeResult, normalCount, abnormalCount, naCount, abnormalSb.toString());

        // 有异常项时通知物业
        if (abnormalCount > 0)
        {
            noticeService.sendToRole(LoginUserUtil.ROLE_PROPERTY, "巡检发现异常",
                    String.format("电梯【%s】巡检发现 %d 项异常：%s",
                            exist.getElevatorCode(), abnormalCount, abnormalSb.toString()), record.getRecordId());
        }
        return rows;
    }

    /**
     * 生成维修档案
     * 维修完工后调用，把本次维修记入电梯全生命周期维保记录
     * 对应论文模块四「自动汇总每次维保与巡检的详情」中的维修部分
     *
     * @param order 维修工单
     * @param repairDesc 处理说明
     * @param replaceParts 更换配件
     * @param executorName 执行人姓名
     * @param finishTime 完工时间
     */
    @Transactional(rollbackFor = Exception.class)
    public void createRepairArchive(com.ruoyi.elevator.domain.RepairOrder order, String repairDesc,
                                    String replaceParts, String executorName, Date finishTime)
    {
        if (order == null || order.getOrderId() == null)
        {
            return;
        }
        // 同一工单只归档一次
        int exists = inspectionMapper.checkArchiveExists("repair", order.getOrderId());
        if (exists > 0)
        {
            return;
        }
        MaintainArchive archive = new MaintainArchive();
        archive.setElevatorId(order.getElevatorId());
        archive.setArchiveType("repair");
        archive.setMaintainType("");
        archive.setBizId(order.getOrderId());
        archive.setExecuteDate(finishTime == null ? new Date() : finishTime);
        archive.setExecutorName(executorName);
        archive.setIsAbnormal("0");
        StringBuilder summary = new StringBuilder();
        summary.append("报修工单").append(order.getOrderNo())
                .append("，电梯【").append(order.getElevatorCode() == null ? "" : order.getElevatorCode()).append("】")
                .append("故障现象：").append(order.getFaultDesc());
        if (StringUtils.isNotEmpty(repairDesc))
        {
            summary.append("。处理说明：").append(repairDesc);
        }
        if (StringUtils.isNotEmpty(replaceParts))
        {
            summary.append("。更换配件：").append(replaceParts);
        }
        archive.setSummary(summary.toString());
        inspectionMapper.insertArchive(archive);
    }

    /**
     * 生成维保档案，避免重复归档
     */
    private void createArchive(InspectionRecord record, String executeResult, int normalCount,
                               int abnormalCount, int naCount, String abnormalDesc)
    {
        int exists = inspectionMapper.checkArchiveExists("inspection", record.getRecordId());
        if (exists > 0)
        {
            return;
        }
        MaintainArchive archive = new MaintainArchive();
        archive.setElevatorId(record.getElevatorId());
        archive.setArchiveType("inspection");
        archive.setMaintainType(record.getMaintainType());
        archive.setBizId(record.getRecordId());
        archive.setExecuteDate(new Date());
        archive.setExecutorName(LoginUserUtil.getNickName());
        archive.setIsAbnormal(abnormalCount > 0 ? "1" : "0");
        StringBuilder summary = new StringBuilder();
        summary.append("巡检工单").append(record.getRecordNo())
                .append("，检查项共").append(normalCount + abnormalCount + naCount).append("项")
                .append("，正常").append(normalCount).append("项")
                .append("，异常").append(abnormalCount).append("项");
        if (naCount > 0)
        {
            summary.append("，不适用").append(naCount).append("项");
        }
        if (StringUtils.isNotEmpty(abnormalDesc))
        {
            summary.append("。异常说明：").append(abnormalDesc);
        }
        archive.setSummary(summary.toString());
        inspectionMapper.insertArchive(archive);
    }

    /**
     * 按周期自动生成巡检工单并派发给计划负责人
     * 由定时任务每日调用，同一计划同一计划日期只生成一次
     *
     * @return 本次生成的巡检工单数量
     */
    @Transactional(rollbackFor = Exception.class)
    public int generateInspectionTasks()
    {
        List<MaintainPlan> duePlans = maintainPlanMapper.selectDuePlans();
        int count = 0;
        String today = DateUtils.getDate();
        for (MaintainPlan plan : duePlans)
        {
            // 同一计划同一计划日期不重复生成
            int exists = inspectionMapper.checkRecordExists(plan.getPlanId(), today);
            if (exists > 0)
            {
                continue;
            }
            InspectionRecord record = new InspectionRecord();
            record.setRecordNo(buildRecordNo());
            record.setPlanId(plan.getPlanId());
            record.setElevatorId(plan.getElevatorId());
            record.setMaintainType(plan.getMaintainType());
            record.setPlanDate(plan.getNextDate());
            record.setExecutorId(plan.getOwnerId());
            record.setRecordStatus("pending");
            record.setExecuteResult("pending");
            record.setCreateBy("system");
            inspectionMapper.insertInspectionRecord(record);

            // 通知负责人
            if (plan.getOwnerId() != null)
            {
                noticeService.sendToUser(plan.getOwnerId(), "新的巡检任务",
                        String.format("电梯【%s】的%s任务已生成，请按时执行",
                                plan.getElevatorCode() == null ? String.valueOf(plan.getElevatorId()) : plan.getElevatorCode(),
                                MaintainPlanService.defaultTemplateOf(plan.getMaintainType())),
                        record.getRecordId());
            }
            count++;
        }
        if (count > 0)
        {
            log.info("自动生成巡检工单 {} 条", count);
        }
        return count;
    }

    /**
     * 把超过计划日期仍未执行的巡检任务标记为超期
     *
     * @return 本次标记的数量
     */
    @Transactional(rollbackFor = Exception.class)
    public int markOverdue()
    {
        InspectionRecord query = new InspectionRecord();
        query.setRecordStatus("pending");
        List<InspectionRecord> pending = inspectionMapper.selectInspectionRecordList(query);
        int count = 0;
        Date today = new Date();
        for (InspectionRecord record : pending)
        {
            if (record.getPlanDate() != null && record.getPlanDate().before(today))
            {
                InspectionRecord update = new InspectionRecord();
                update.setRecordId(record.getRecordId());
                update.setRecordStatus("overdue");
                update.setUpdateBy("system");
                inspectionMapper.updateInspectionRecord(update);
                count++;
            }
        }
        return count;
    }

    /**
     * 查询指定电梯的巡检统计，供健康评分使用
     */
    public Map<String, Object> selectInspectionStat(Long elevatorId, String beginTime, String endTime)
    {
        return inspectionMapper.selectInspectionStatByElevator(elevatorId, beginTime, endTime);
    }

    /**
     * 计算巡检合格率
     */
    public BigDecimal calcPassRate(Map<String, Object> stat)
    {
        if (stat == null)
        {
            return BigDecimal.ZERO;
        }
        long normalSum = toLong(stat.get("normalSum"));
        long itemSum = toLong(stat.get("itemSum"));
        if (itemSum == 0)
        {
            return BigDecimal.ZERO;
        }
        return BigDecimal.valueOf(normalSum * 100L)
                .divide(BigDecimal.valueOf(itemSum), 2, RoundingMode.HALF_UP);
    }

    private long toLong(Object value)
    {
        if (value == null)
        {
            return 0L;
        }
        if (value instanceof Number)
        {
            return ((Number) value).longValue();
        }
        try
        {
            return Long.parseLong(value.toString());
        }
        catch (NumberFormatException e)
        {
            return 0L;
        }
    }

    private InspectionRecord mustGetRecord(Long recordId)
    {
        InspectionRecord record = inspectionMapper.selectInspectionRecordById(recordId);
        if (record == null)
        {
            throw new ElevatorException(ElevatorErrorCode.INSPECTION_NOT_EXIST.getMessage(),
                    ElevatorErrorCode.INSPECTION_NOT_EXIST.getCode());
        }
        return record;
    }

    /**
     * 生成巡检工单编号，格式 XJ + yyyyMMddHHmmss
     */
    private String buildRecordNo()
    {
        return "XJ" + DateUtils.dateTimeNow("yyyyMMddHHmmss");
    }

    /**
     * 查询巡检任务数量，供首页看板使用
     */
    public int selectInspectionCount()
    {
        return inspectionMapper.selectInspectionCount();
    }

    // ==================== 档案归档 ====================

    /**
     * 查询维保档案列表
     */
    public List<MaintainArchive> selectArchiveList(MaintainArchive archive)
    {
        return inspectionMapper.selectArchiveList(archive);
    }

    /**
     * 查询指定电梯的完整维保履历
     */
    public List<MaintainArchive> selectArchiveByElevator(Long elevatorId)
    {
        return inspectionMapper.selectArchiveByElevator(elevatorId);
    }

    /**
     * 查询档案详情
     */
    public MaintainArchive selectArchiveById(Long archiveId)
    {
        return inspectionMapper.selectArchiveById(archiveId);
    }

    /**
     * 查询指定电梯的维保完成率与巡检合格率，供健康评分使用
     */
    public List<BigDecimal> selectElevatorRates(Long elevatorId, String beginTime, String endTime)
    {
        List<BigDecimal> rates = new ArrayList<>();
        Map<String, Object> planStat = maintainPlanMapper.selectPlanStatByElevator(elevatorId);
        long expect = toLong(planStat == null ? null : planStat.get("expectCount"));
        long finish = toLong(planStat == null ? null : planStat.get("finishCount"));
        BigDecimal maintainRate = expect == 0 ? BigDecimal.ZERO
                : BigDecimal.valueOf(finish * 100L).divide(BigDecimal.valueOf(expect), 2, RoundingMode.HALF_UP);
        rates.add(maintainRate);

        Map<String, Object> inspectStat = inspectionMapper.selectInspectionStatByElevator(elevatorId, beginTime, endTime);
        rates.add(calcPassRate(inspectStat));
        return rates;
    }
}
