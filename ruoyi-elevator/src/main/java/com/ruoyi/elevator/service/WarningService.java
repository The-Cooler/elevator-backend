package com.ruoyi.elevator.service;

import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.elevator.domain.MaintainPlan;
import com.ruoyi.elevator.domain.RepairOrder;
import com.ruoyi.elevator.domain.WarningInfo;
import com.ruoyi.elevator.domain.WarningRule;
import com.ruoyi.elevator.exception.ElevatorErrorCode;
import com.ruoyi.elevator.exception.ElevatorException;
import com.ruoyi.elevator.mapper.ElevatorNoticeMapper;
import com.ruoyi.elevator.mapper.RepairOrderMapper;
import com.ruoyi.elevator.mapper.UserQueryMapper;
import com.ruoyi.elevator.mapper.WarningMapper;
import com.ruoyi.elevator.util.LoginUserUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 超期预警监控服务
 * 对应论文模块五的超期预警监控子功能
 * 定时扫描工单与维保计划，识别超期与临期情形，生成预警信息推送给相关责任人
 * 同一业务对象在同一预警周期内不重复推送，避免频繁打扰
 *
 * @author 董泽晟
 */
@Service
public class WarningService
{
    private static final Logger log = LoggerFactory.getLogger(WarningService.class);

    @Autowired
    private WarningMapper warningMapper;

    @Autowired
    private RepairOrderMapper repairOrderMapper;

    @Autowired
    private MaintainPlanService maintainPlanService;

    @Autowired
    private UserQueryMapper userQueryMapper;

    @Autowired
    private NoticeService noticeService;

    @Autowired
    private ElevatorNoticeMapper elevatorNoticeMapper;

    // ==================== 预警规则管理 ====================

    public List<WarningRule> selectWarningRuleList(WarningRule warningRule)
    {
        List<WarningRule> list = warningMapper.selectWarningRuleList(warningRule);
        for (WarningRule rule : list)
        {
            rule.setRuleTypeName(ruleTypeName(rule.getRuleType()));
            rule.setBizSubTypeName(subTypeName(rule.getBizSubType()));
        }
        return list;
    }

    public WarningRule selectWarningRuleById(Long ruleId)
    {
        WarningRule rule = warningMapper.selectWarningRuleById(ruleId);
        if (rule == null)
        {
            throw new ElevatorException(ElevatorErrorCode.WARNING_RULE_NOT_EXIST.getMessage(),
                    ElevatorErrorCode.WARNING_RULE_NOT_EXIST.getCode());
        }
        return rule;
    }

    @Transactional(rollbackFor = Exception.class)
    public int insertWarningRule(WarningRule rule)
    {
        validateRule(rule);
        rule.setCreateBy(SecurityUtils.getUsername());
        return warningMapper.insertWarningRule(rule);
    }

    @Transactional(rollbackFor = Exception.class)
    public int updateWarningRule(WarningRule rule)
    {
        if (rule.getRuleId() == null)
        {
            throw new ServiceException("规则ID不能为空");
        }
        validateRule(rule);
        rule.setUpdateBy(SecurityUtils.getUsername());
        return warningMapper.updateWarningRule(rule);
    }

    @Transactional(rollbackFor = Exception.class)
    public int changeRuleEnabled(Long ruleId, String enabled)
    {
        if (StringUtils.isEmpty(enabled))
        {
            throw new ServiceException("启用状态不能为空");
        }
        return warningMapper.updateRuleEnabled(ruleId, enabled);
    }

    @Transactional(rollbackFor = Exception.class)
    public int deleteWarningRuleByIds(Long[] ruleIds)
    {
        return warningMapper.deleteWarningRuleByIds(ruleIds);
    }

    // ==================== 预警信息查询 ====================

    public List<WarningInfo> selectWarningInfoList(WarningInfo warningInfo)
    {
        List<WarningInfo> list = warningMapper.selectWarningInfoList(warningInfo);
        for (WarningInfo info : list)
        {
            info.setWarningTypeName(ruleTypeName(info.getWarningType()));
        }
        return list;
    }

    /**
     * 查询当前登录用户的预警信息
     */
    public List<WarningInfo> myWarnings(WarningInfo warningInfo)
    {
        warningInfo.setQueryReceiverId(LoginUserUtil.getUserId());
        return selectWarningInfoList(warningInfo);
    }

    /**
     * 统计当前用户未读预警数量
     */
    public int unreadCount()
    {
        return warningMapper.countUnread(LoginUserUtil.getUserId());
    }

    /**
     * 标记指定预警已读
     */
    public int markRead(Long[] warningIds)
    {
        return warningMapper.updateRead(LoginUserUtil.getUserId(), warningIds);
    }

    /**
     * 全部标记已读
     */
    public int markAllRead()
    {
        return warningMapper.updateAllRead(LoginUserUtil.getUserId());
    }

    // ==================== 预警扫描 ====================

    /**
     * 扫描工单与维保计划，生成预警信息
     * 由定时任务调用
     *
     * @return 本次生成的预警条数
     */
    @Transactional(rollbackFor = Exception.class)
    public int scanAndGenerate()
    {
        List<WarningRule> rules = warningMapper.selectEnabledRules();
        int count = 0;
        for (WarningRule rule : rules)
        {
            if ("order_timeout".equals(rule.getRuleType()))
            {
                count += scanOrderTimeout(rule);
            }
            else if ("maintain_due".equals(rule.getRuleType()))
            {
                count += scanMaintainDue(rule);
            }
        }
        if (count > 0)
        {
            log.info("本次生成预警 {} 条", count);
        }
        return count;
    }

    /**
     * 扫描工单超时
     * 按规则子类型分别处理派单超时、接单超时、到场超时、维修超时
     */
    private int scanOrderTimeout(WarningRule rule)
    {
        int thresholdMinutes = convertToMinutes(rule.getThresholdValue(), rule.getThresholdUnit());
        List<RepairOrder> orders = repairOrderMapper.selectOverdueOrders(rule.getBizSubType(), thresholdMinutes);
        int count = 0;
        for (RepairOrder order : orders)
        {
            if (alreadyPushed(rule, order.getOrderId()))
            {
                continue;
            }
            String content = String.format("工单【%s】%s，电梯【%s】，报修人【%s】",
                    order.getOrderNo(), subTypeName(rule.getBizSubType()),
                    order.getElevatorCode() == null ? "" : order.getElevatorCode(),
                    order.getReporterName() == null ? "" : order.getReporterName());
            count += pushWarning(rule, "order_timeout", order.getOrderId(), order.getOrderNo(),
                    content, order.getElevatorId());
        }
        return count;
    }

    /**
     * 扫描维保临期与超期
     */
    private int scanMaintainDue(WarningRule rule)
    {
        int dueSoonDays = "due_soon".equals(rule.getBizSubType())
                ? (rule.getThresholdValue() == null ? 3 : rule.getThresholdValue())
                : 0;
        List<MaintainPlan> plans = maintainPlanService.selectDueSoonPlans(dueSoonDays);
        int count = 0;
        for (MaintainPlan plan : plans)
        {
            // 超期规则只处理已过期的，临期规则只处理尚未到期的
            int remaining = plan.getRemainingDays() == null ? 0 : plan.getRemainingDays();
            if ("overdue".equals(rule.getBizSubType()) && remaining >= 0)
            {
                continue;
            }
            if ("due_soon".equals(rule.getBizSubType()) && remaining < 0)
            {
                continue;
            }
            if (alreadyPushed(rule, plan.getPlanId()))
            {
                continue;
            }
            String timeDesc = remaining < 0
                    ? String.format("已超期 %d 天", -remaining)
                    : String.format("距维保日期还有 %d 天", remaining);
            String content = String.format("电梯【%s】%s的维保计划【%s】%s",
                    plan.getElevatorCode() == null ? String.valueOf(plan.getElevatorId()) : plan.getElevatorCode(),
                    MaintainPlanService.defaultTemplateOf(plan.getMaintainType()),
                    plan.getPlanName(), timeDesc);
            count += pushWarning(rule, "maintain_due", plan.getPlanId(),
                    String.valueOf(plan.getPlanId()), content, plan.getElevatorId());
        }
        return count;
    }

    /**
     * 判断同一业务对象在同一规则下是否已推送过
     * repeatInterval 为 0 表示同一业务对象只推送一次，大于 0 表示在间隔内不重复推送
     */
    private boolean alreadyPushed(WarningRule rule, Long bizId)
    {
        if (bizId == null)
        {
            return false;
        }
        Integer interval = rule.getRepeatInterval();
        if (interval == null || interval <= 0)
        {
            return warningMapper.countByBizAndRule(rule.getRuleId(), bizId) > 0;
        }
        return warningMapper.countByBizAndRuleWithin(rule.getRuleId(), bizId, interval) > 0;
    }

    /**
     * 生成预警记录并推送给规则指定的角色
     */
    private int pushWarning(WarningRule rule, String warningType, Long bizId, String bizNo,
                            String content, Long elevatorId)
    {
        String notifyRoles = rule.getNotifyRoles();
        if (StringUtils.isEmpty(notifyRoles))
        {
            notifyRoles = LoginUserUtil.ROLE_PROPERTY;
        }
        int count = 0;
        for (String roleKey : notifyRoles.split(","))
        {
            String role = roleKey.trim();
            if (StringUtils.isEmpty(role))
            {
                continue;
            }
            List<Long> receivers = userQueryMapper.selectUserIdsByRoleKey(role);
            for (Long receiverId : receivers)
            {
                WarningInfo info = new WarningInfo();
                info.setRuleId(rule.getRuleId());
                info.setWarningType(warningType);
                info.setBizSubType(rule.getBizSubType());
                info.setBizId(bizId);
                info.setBizNo(bizNo);
                info.setWarningContent(content);
                info.setElevatorId(elevatorId);
                info.setReceiverId(receiverId);
                info.setReceiverRole(role);
                warningMapper.insertWarningInfo(info);

                // 站内通知同步推一条
                noticeService.sendToUser(receiverId, rule.getRuleName(), content, bizId);
                count++;
            }
        }
        return count;
    }

    /**
     * 把阈值统一换算为分钟
     */
    private int convertToMinutes(Integer value, String unit)
    {
        if (value == null)
        {
            return 60;
        }
        if (StringUtils.isEmpty(unit))
        {
            return value;
        }
        switch (unit)
        {
            case "hour":
                return value * 60;
            case "day":
                return value * 24 * 60;
            default:
                return value;
        }
    }

    /**
     * 规则类型中文名
     */
    public static String ruleTypeName(String ruleType)
    {
        if (ruleType == null)
        {
            return "";
        }
        switch (ruleType)
        {
            case "order_timeout":
                return "工单超时";
            case "maintain_due":
                return "维保临期";
            default:
                return ruleType;
        }
    }

    /**
     * 业务子类型中文名
     */
    public static String subTypeName(String subType)
    {
        if (subType == null)
        {
            return "";
        }
        switch (subType)
        {
            case "assign":
                return "派单超时";
            case "accept":
                return "接单超时";
            case "arrive":
                return "到场超时";
            case "repair":
                return "维修超时";
            case "confirm":
                return "业主确认超时";
            case "due_soon":
                return "维保临期";
            case "overdue":
                return "维保超期";
            default:
                return subType;
        }
    }

    /**
     * 校验规则数据
     */
    private void validateRule(WarningRule rule)
    {
        if (StringUtils.isEmpty(rule.getRuleName()))
        {
            throw new ServiceException("规则名称不能为空");
        }
        if (StringUtils.isEmpty(rule.getRuleType()))
        {
            throw new ServiceException("规则类型不能为空");
        }
        if (rule.getThresholdValue() == null)
        {
            throw new ServiceException("阈值不能为空");
        }
        if (rule.getThresholdValue() < 0)
        {
            throw new ServiceException("阈值不能为负数");
        }
    }
}
