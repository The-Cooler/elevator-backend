package com.ruoyi.elevator.service;

import com.ruoyi.elevator.domain.ElevatorNotice;
import com.ruoyi.elevator.mapper.ElevatorNoticeMapper;
import com.ruoyi.elevator.mapper.UserQueryMapper;
import com.ruoyi.elevator.util.LoginUserUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 通知消息服务
 * 派单、接单、进度变更、预警等场景向相关角色推送站内通知
 *
 * @author 董泽晟
 */
@Service
public class NoticeService
{
    /** 业务类型：关联的是报修工单 */
    public static final String BIZ_ORDER = "order";

    /** 业务类型：关联的是巡检记录 */
    public static final String BIZ_INSPECTION = "inspection";

    /** 业务类型：关联的是维保计划 */
    public static final String BIZ_PLAN = "plan";

    /** 业务类型：无关联业务，前端不给跳转入口 */
    public static final String BIZ_NONE = "";

    @Autowired
    private ElevatorNoticeMapper elevatorNoticeMapper;

    @Autowired
    private UserQueryMapper userQueryMapper;

    /**
     * 向单个用户发送通知
     *
     * @param bizType 关联业务类型，取 BIZ_ORDER / BIZ_INSPECTION / BIZ_NONE。
     *                前端据此决定「查看关联业务」跳到工单还是巡检。
     *                不能只靠 bizId 判断：工单表与巡检表各自从 1 编号，
     *                同一个 id 可能两张表都能命中。
     */
    public void sendToUser(Long receiverId, String title, String content, Long bizId, String bizType)
    {
        if (receiverId == null)
        {
            return;
        }
        ElevatorNotice notice = new ElevatorNotice();
        notice.setNoticeType("progress");
        notice.setTitle(title);
        notice.setContent(content);
        notice.setBizId(bizId);
        notice.setBizType(bizType == null ? BIZ_NONE : bizType);
        notice.setReceiverId(receiverId);
        elevatorNoticeMapper.insertElevatorNotice(notice);
    }

    /**
     * 向指定角色的全部用户发送通知
     *
     * @param roleKey 角色标识，见 LoginUserUtil 的角色常量
     * @param bizType 关联业务类型，见 sendToUser
     */
    public void sendToRole(String roleKey, String title, String content, Long bizId, String bizType)
    {
        List<Long> userIds = userQueryMapper.selectUserIdsByRoleKey(roleKey);
        for (Long userId : userIds)
        {
            sendToUser(userId, title, content, bizId, bizType);
        }
    }

    /**
     * 向多个角色发送通知
     */
    public void sendToRoles(String[] roleKeys, String title, String content, Long bizId, String bizType)
    {
        for (String roleKey : roleKeys)
        {
            sendToRole(roleKey, title, content, bizId, bizType);
        }
    }

    /**
     * 查询当前用户的通知列表
     */
    public List<ElevatorNotice> myNotices(ElevatorNotice query)
    {
        query.setReceiverId(LoginUserUtil.getUserId());
        return elevatorNoticeMapper.selectElevatorNoticeList(query);
    }

    /**
     * 统计当前用户未读消息数
     */
    public int unreadCount()
    {
        return elevatorNoticeMapper.countUnread(LoginUserUtil.getUserId());
    }

    /**
     * 标记指定消息已读
     */
    public int markRead(Long[] noticeIds)
    {
        return elevatorNoticeMapper.updateRead(LoginUserUtil.getUserId(), noticeIds);
    }

    /**
     * 全部标记已读
     */
    public int markAllRead()
    {
        return elevatorNoticeMapper.updateAllRead(LoginUserUtil.getUserId());
    }
}
