package com.ruoyi.elevator.mapper;

import com.ruoyi.elevator.domain.WarningInfo;
import com.ruoyi.elevator.domain.WarningRule;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 预警规则与预警信息 数据层
 *
 * @author 董泽晟
 */
public interface WarningMapper
{
    // ==================== 预警规则 ====================

    /**
     * 查询预警规则列表
     */
    List<WarningRule> selectWarningRuleList(WarningRule warningRule);

    /**
     * 查询预警规则详情
     */
    WarningRule selectWarningRuleById(Long ruleId);

    /**
     * 查询全部启用的预警规则
     */
    List<WarningRule> selectEnabledRules();

    int insertWarningRule(WarningRule warningRule);

    int updateWarningRule(WarningRule warningRule);

    int deleteWarningRuleByIds(Long[] ruleIds);

    /**
     * 启用或停用规则
     */
    int updateRuleEnabled(@Param("ruleId") Long ruleId, @Param("enabled") String enabled);

    // ==================== 预警信息 ====================

    /**
     * 查询预警信息列表
     */
    List<WarningInfo> selectWarningInfoList(WarningInfo warningInfo);

    /**
     * 查询预警信息详情
     */
    WarningInfo selectWarningInfoById(Long warningId);

    /**
     * 统计未读预警数量
     */
    int countUnread(@Param("receiverId") Long receiverId);

    /**
     * 校验同一业务对象在同一规则下是否已生成过预警，避免重复推送
     */
    int countByBizAndRule(@Param("ruleId") Long ruleId, @Param("bizId") Long bizId);

    /**
     * 校验同一业务对象在同一规则下是否在重复推送间隔内已推送过
     *
     * @param repeatIntervalMinutes 重复推送间隔分钟数
     */
    int countByBizAndRuleWithin(@Param("ruleId") Long ruleId,
                                @Param("bizId") Long bizId,
                                @Param("repeatIntervalMinutes") int repeatIntervalMinutes);

    int insertWarningInfo(WarningInfo warningInfo);

    /**
     * 标记指定预警已读
     */
    int updateRead(@Param("receiverId") Long receiverId, @Param("warningIds") Long[] warningIds);

    /**
     * 全部标记已读
     */
    int updateAllRead(@Param("receiverId") Long receiverId);
}
