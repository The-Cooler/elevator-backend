package com.ruoyi.elevator.service;

import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.elevator.domain.Elevator;
import com.ruoyi.elevator.domain.RepairOrder;
import com.ruoyi.elevator.domain.WorkerSkill;
import com.ruoyi.elevator.exception.ElevatorErrorCode;
import com.ruoyi.elevator.exception.ElevatorException;
import com.ruoyi.elevator.mapper.ElevatorMapper;
import com.ruoyi.elevator.mapper.RepairOrderMapper;
import com.ruoyi.elevator.mapper.WorkerSkillMapper;
import com.ruoyi.elevator.util.LoginUserUtil;
import com.ruoyi.elevator.util.OrderStatusUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.Date;
import java.util.List;

/**
 * 智能派单服务
 * 对应论文模块三的智能派单子功能
 * 按电梯所在小区与维修员负责区域匹配，并结合技能标签推荐候选维修员
 *
 * @author 董泽晟
 */
@Service
public class DispatchService
{
    @Autowired
    private RepairOrderMapper repairOrderMapper;

    @Autowired
    private WorkerSkillMapper workerSkillMapper;

    @Autowired
    private ElevatorMapper elevatorMapper;

    @Autowired
    private RepairOrderService repairOrderService;

    @Autowired
    private NoticeService noticeService;

    /**
     * 故障类型与维修员技能标签的对应关系，用于技能匹配打分
     */
    private static final String[][] FAULT_SKILL_MAPPING = {
            { "abnormal_noise", "曳引机" },
            { "stop", "控制系统" },
            { "trapped", "安全装置" },
            { "door", "门系统" },
            { "button", "控制系统" }
    };

    /**
     * 查询待派单工单池，紧急工单在前
     */
    public List<RepairOrder> pendingList(RepairOrder query)
    {
        query.setOrderStatus(OrderStatusUtil.PENDING);
        return repairOrderMapper.selectRepairOrderList(query);
    }

    /**
     * 为指定工单推荐维修员
     * 匹配规则：同一小区优先，技能标签匹配加分，在手工单数少优先，平均响应时长短优先
     *
     * @param orderId 工单ID
     * @return 按匹配度排序的候选维修员列表
     */
    public List<WorkerSkill> recommend(Long orderId)
    {
        RepairOrder order = repairOrderService.mustGetOrder(orderId);
        Elevator elevator = elevatorMapper.selectElevatorById(order.getElevatorId());
        Long communityId = elevator == null ? null : elevator.getCommunityId();

        List<WorkerSkill> candidates = workerSkillMapper.selectCandidates(communityId);
        if (candidates.isEmpty())
        {
            // 本小区无在岗维修员时放宽到全部在岗维修员
            candidates = workerSkillMapper.selectCandidates(null);
        }

        String needSkill = mapSkill(order.getFaultType());
        List<WorkerSkill> result = new ArrayList<>();
        for (WorkerSkill worker : candidates)
        {
            int score = 0;
            boolean skillMatched = false;
            if (communityId != null && communityId.equals(worker.getCommunityId()))
            {
                // 负责区域匹配，权重最高
                score += 50;
            }
            if (StringUtils.isNotEmpty(needSkill) && StringUtils.isNotEmpty(worker.getSkillTags())
                    && worker.getSkillTags().contains(needSkill))
            {
                score += 30;
                skillMatched = true;
            }
            // 在手工单越少得分越高
            int load = worker.getCurrentLoad() == null ? 0 : worker.getCurrentLoad();
            score += Math.max(0, 20 - load * 5);
            // 平均响应时长越短得分越高
            int avg = worker.getAvgResponse() == null ? 0 : worker.getAvgResponse();
            score += avg == 0 ? 10 : Math.max(0, 10 - avg / 10);

            worker.setMatchScore(score);
            worker.setSkillMatched(skillMatched);
            result.add(worker);
        }
        result.sort(Comparator.comparing(WorkerSkill::getMatchScore).reversed());
        return result;
    }

    /**
     * 确认派单
     *
     * @param orderId 工单ID
     * @param assigneeId 维修员ID
     */
    @Transactional(rollbackFor = Exception.class)
    public int assign(Long orderId, Long assigneeId)
    {
        LoginUserUtil.checkPropertyOrAdmin();
        if (assigneeId == null)
        {
            throw new ElevatorException("请选择维修员");
        }
        WorkerSkill worker = workerSkillMapper.selectByWorkerId(assigneeId);
        if (worker == null)
        {
            throw new ElevatorException(ElevatorErrorCode.WORKER_UNAVAILABLE.getMessage(),
                    ElevatorErrorCode.WORKER_UNAVAILABLE.getCode());
        }
        if ("1".equals(worker.getWorkStatus()) || "2".equals(worker.getWorkStatus()))
        {
            throw new ElevatorException(ElevatorErrorCode.WORKER_UNAVAILABLE.getMessage(),
                    ElevatorErrorCode.WORKER_UNAVAILABLE.getCode());
        }

        RepairOrder order = repairOrderService.mustGetOrder(orderId);
        // 从待处理或已驳回状态派单是合法的
        String fromStatus = order.getOrderStatus();
        if (!OrderStatusUtil.PENDING.equals(fromStatus) && !OrderStatusUtil.REJECTED.equals(fromStatus))
        {
            repairOrderService.assertTransition(fromStatus, OrderStatusUtil.ASSIGNED);
        }

        RepairOrder update = new RepairOrder();
        update.setOrderId(orderId);
        update.setOrderStatus(OrderStatusUtil.ASSIGNED);
        update.setAssigneeId(assigneeId);
        update.setAssignerId(LoginUserUtil.getUserId());
        update.setAssignTime(new Date());
        update.setUpdateBy(LoginUserUtil.getUsername());
        int rows = repairOrderMapper.updateRepairOrder(update);

        repairOrderService.recordStatus(orderId, fromStatus, OrderStatusUtil.ASSIGNED, "assign",
                "派单给维修员【" + worker.getWorkerName() + "】");

        // 更新维修员在手工单数
        workerSkillMapper.updateCurrentLoad(assigneeId);

        // 通知维修员
        noticeService.sendToUser(assigneeId, "新的工单派给您",
                String.format("工单【%s】已派给您，请及时接单", order.getOrderNo()), orderId);
        return rows;
    }

    /**
     * 批量派单
     *
     * @param orderIds 工单ID数组
     * @param assigneeId 维修员ID
     */
    @Transactional(rollbackFor = Exception.class)
    public int batchAssign(Long[] orderIds, Long assigneeId)
    {
        int count = 0;
        for (Long orderId : orderIds)
        {
            count += assign(orderId, assigneeId);
        }
        return count;
    }

    /**
     * 把故障类型映射到所需技能标签
     */
    private String mapSkill(String faultType)
    {
        if (StringUtils.isEmpty(faultType))
        {
            return "";
        }
        for (String[] mapping : FAULT_SKILL_MAPPING)
        {
            if (mapping[0].equals(faultType))
            {
                return mapping[1];
            }
        }
        return "";
    }
}
