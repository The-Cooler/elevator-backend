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
     *
     * 物业要在池子里挑单、判断紧急程度，得先看到业主拍的现场照片，
     * 所以证据随列表一次取回，不用点进派单页才有。
     */
    public List<RepairOrder> pendingList(RepairOrder query)
    {
        query.setOrderStatus(OrderStatusUtil.PENDING);
        List<RepairOrder> list = repairOrderMapper.selectRepairOrderList(query);
        repairOrderService.attachEvidences(list);
        return list;
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
            // 候选池本身已按"在岗 + 账号启用"筛过，这里补上状态字段，
            // 让前端两个列表用同一套字段渲染
            worker.setUserEnabled("0");
            worker.setAssignable(true);
            worker.setUnavailableReason("");
            result.add(worker);
        }
        result.sort(Comparator.comparing(WorkerSkill::getMatchScore).reversed());
        return result;
    }

    /**
     * 确认派单
     *
     * 推荐列表只放当前能接单的人；但人不在岗位上不等于这一单派不出去，
     * 物业可以手动指定任何人。指定的人不在推荐范围内时返回错误码 4016，
     * 前端弹确认框，物业点了确认再带 confirmNotRecommended=true 重发一次。
     *
     * @param orderId 工单ID
     * @param assigneeId 维修员ID
     * @param remark 派单备注，物业填写后写入流转记录并随通知发给维修员，可为空
     * @param confirmNotRecommended 已确认"该维修员不在推荐范围仍要指派"
     */
    @Transactional(rollbackFor = Exception.class)
    public int assign(Long orderId, Long assigneeId, String remark, boolean confirmNotRecommended)
    {
        LoginUserUtil.checkPropertyOrAdmin();
        if (assigneeId == null)
        {
            throw new ElevatorException("请选择维修员");
        }
        // 手动指定用全量口径查：不要求在岗、不要求账号启用，人必须能找到
        WorkerSkill worker = workerSkillMapper.selectByWorkerId(assigneeId);
        if (worker == null)
        {
            throw new ElevatorException(ElevatorErrorCode.WORKER_UNAVAILABLE.getMessage(),
                    ElevatorErrorCode.WORKER_UNAVAILABLE.getCode());
        }
        // 休息、请假、账号停用的都还能派，但必须让物业先确认一次
        if (!isAssignable(worker) && !confirmNotRecommended)
        {
            throw new ElevatorException(ElevatorErrorCode.WORKER_NOT_RECOMMENDED.getMessage(),
                    ElevatorErrorCode.WORKER_NOT_RECOMMENDED.getCode());
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

        // 派单备注写入流转记录，未填写时不追加
        String logRemark = "派单给维修员【" + worker.getWorkerName() + "】";
        if (StringUtils.isNotEmpty(remark))
        {
            logRemark = logRemark + "，备注：" + remark;
        }
        // 指定了不在推荐范围内的人，留个痕，事后能看清当时的情况
        String unavailable = unavailableReason(worker);
        if (StringUtils.isNotEmpty(unavailable))
        {
            logRemark = logRemark + "（指定派单，该维修员" + unavailable + "）";
        }
        repairOrderService.recordStatus(orderId, fromStatus, OrderStatusUtil.ASSIGNED, "assign", logRemark);

        // 更新维修员在手工单数
        workerSkillMapper.updateCurrentLoad(assigneeId);

        // 通知维修员，备注一并带上
        String noticeContent = String.format("工单【%s】已派给您，请及时接单", order.getOrderNo());
        if (StringUtils.isNotEmpty(remark))
        {
            noticeContent = noticeContent + "。物业备注：" + remark;
        }
        noticeService.sendToUser(assigneeId, "新的工单派给您", noticeContent, orderId,
                NoticeService.BIZ_ORDER);
        return rows;
    }

    /**
     * 判断维修员此刻是否可接单：账号启用且在岗
     */
    private boolean isAssignable(WorkerSkill worker)
    {
        return "0".equals(worker.getUserEnabled())
                && (worker.getWorkStatus() == null || "0".equals(worker.getWorkStatus()));
    }

    /**
     * 不可接单的原因，可接单时返回空串
     */
    private String unavailableReason(WorkerSkill worker)
    {
        if (isAssignable(worker))
        {
            return "";
        }
        boolean disabled = !"0".equals(worker.getUserEnabled());
        if ("1".equals(worker.getWorkStatus()))
        {
            return disabled ? "账号已停用、休息中" : "休息中";
        }
        if ("2".equals(worker.getWorkStatus()))
        {
            return disabled ? "账号已停用、请假中" : "请假中";
        }
        return disabled ? "账号已停用" : "当前不在岗";
    }

    /**
     * 批量派单
     *
     * @param orderIds 工单ID数组
     * @param assigneeId 维修员ID
     * @param remark 派单备注，可为空
     * @param confirmNotRecommended 已确认"该维修员不在推荐范围仍要指派"
     */
    @Transactional(rollbackFor = Exception.class)
    public int batchAssign(Long[] orderIds, Long assigneeId, String remark, boolean confirmNotRecommended)
    {
        int count = 0;
        for (Long orderId : orderIds)
        {
            count += assign(orderId, assigneeId, remark, confirmNotRecommended);
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
