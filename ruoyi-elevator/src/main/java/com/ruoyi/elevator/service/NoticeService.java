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
    @Autowired
    private ElevatorNoticeMapper elevatorNoticeMapper;

    @Autowired
    private UserQueryMapper userQueryMapper;

    /**
     * 向单个用户发送通知
     */
    public void sendToUser(Long receiverId, String title, String content, Long bizId)
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
        notice.setReceiverId(receiverId);
        elevatorNoticeMapper.insertElevatorNotice(notice);
    }

    /**
     * 向指定角色的全部用户发送通知
     *
     * @param roleKey 角色标识，见 LoginUserUtil 的角色常量
     */
    public void sendToRole(String roleKey, String title, String content, Long bizId)
    {
        List<Long> userIds = userQueryMapper.selectUserIdsByRoleKey(roleKey);
        for (Long userId : userIds)
        {
            sendToUser(userId, title, content, bizId);
        }
    }

    /**
     * 向多个角色发送通知
     */
    public void sendToRoles(String[] roleKeys, String title, String content, Long bizId)
    {
        for (String roleKey : roleKeys)
        {
            sendToRole(roleKey, title, content, bizId);
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
