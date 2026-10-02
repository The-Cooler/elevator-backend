package com.ruoyi.elevator.util;

import com.ruoyi.common.utils.StringUtils;

/**
 * 报修工单状态常量与流转规则
 * 状态流转需保证合法性，禁止跳转与非法回退，对应论文表2-5的实现约束
 *
 * @author 董泽晟
 */
public class OrderStatusUtil
{
    /** 待处理 */
    public static final String PENDING = "pending";

    /** 已派单 */
    public static final String ASSIGNED = "assigned";

    /** 已接单 */
    public static final String ACCEPTED = "accepted";

    /** 已到场 */
    public static final String ARRIVED = "arrived";

    /** 维修中 */
    public static final String REPAIRING = "repairing";

    /** 已修复，等待业主确认 */
    public static final String REPAIRED = "repaired";

    /** 已完成，业主确认闭环 */
    public static final String CONFIRMED = "confirmed";

    /** 已驳回 */
    public static final String REJECTED = "rejected";

    /** 已申诉 */
    public static final String APPEALED = "appealed";

    /**
     * 判断状态流转是否合法
     *
     * @param from 原状态
     * @param to 目标状态
     * @return 合法返回 true
     */
    public static boolean isLegalTransition(String from, String to)
    {
        if (StringUtils.isEmpty(from) || StringUtils.isEmpty(to))
        {
            return false;
        }
        switch (from)
        {
            case PENDING:
                // 待处理 -> 已派单（物业派单）或 已驳回（物业驳回）
                return ASSIGNED.equals(to) || REJECTED.equals(to);
            case REJECTED:
                // 已驳回 -> 待处理（业主补充后重新提交）或 已派单（物业直接派单）
                return PENDING.equals(to) || ASSIGNED.equals(to);
            case ASSIGNED:
                // 已派单 -> 已接单 或 回到待处理（拒单/重新指派）
                return ACCEPTED.equals(to) || PENDING.equals(to);
            case ACCEPTED:
                // 已接单 -> 已到场 或 回到待处理（拒单/重新指派）
                return ARRIVED.equals(to) || PENDING.equals(to);
            case ARRIVED:
                // 已到场 -> 维修中
                return REPAIRING.equals(to);
            case REPAIRING:
                // 维修中 -> 已修复
                return REPAIRED.equals(to);
            case REPAIRED:
                // 已修复 -> 已完成（业主确认）或 已申诉（业主不满意）
                return CONFIRMED.equals(to) || APPEALED.equals(to);
            case APPEALED:
                // 已申诉 -> 维修中（物业安排返工）
                return REPAIRING.equals(to);
            case CONFIRMED:
                // 已完成是终态
                return false;
            default:
                return false;
        }
    }

    /**
     * 获取状态的中文名称
     */
    public static String getStatusName(String status)
    {
        if (status == null)
        {
            return "";
        }
        switch (status)
        {
            case PENDING:
                return "待处理";
            case ASSIGNED:
                return "已派单";
            case ACCEPTED:
                return "已接单";
            case ARRIVED:
                return "已到场";
            case REPAIRING:
                return "维修中";
            case REPAIRED:
                return "已修复";
            case CONFIRMED:
                return "已完成";
            case REJECTED:
                return "已驳回";
            case APPEALED:
                return "已申诉";
            default:
                return status;
        }
    }

    /**
     * 判断是否为终态
     */
    public static boolean isFinalStatus(String status)
    {
        return CONFIRMED.equals(status);
    }

    /**
     * 判断是否为未结工单状态，用于重复报修校验
     */
    public static boolean isOpenStatus(String status)
    {
        return PENDING.equals(status) || ASSIGNED.equals(status) || ACCEPTED.equals(status)
                || ARRIVED.equals(status) || REPAIRING.equals(status) || REPAIRED.equals(status)
                || APPEALED.equals(status);
    }
}
