package com.ruoyi.elevator.controller;

import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.elevator.domain.ElevatorNotice;
import com.ruoyi.elevator.service.NoticeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * 站内通知消息
 * 派单、接单、进度变更、预警等场景向相关角色推送站内通知
 * 对应论文模块三「维修员接收工单通知」的要求
 *
 * @author 董泽晟
 */
@RestController
@RequestMapping("/message/notice")
public class NoticeController extends BaseController
{
    @Autowired
    private NoticeService noticeService;

    /**
     * 查询当前登录用户的通知列表
     */
    @GetMapping("/myList")
    public TableDataInfo myList(ElevatorNotice notice)
    {
        startPage();
        List<ElevatorNotice> list = noticeService.myNotices(notice);
        return getDataTable(list);
    }

    /**
     * 统计当前用户未读通知数量，供角标展示
     */
    @GetMapping("/unreadCount")
    public AjaxResult unreadCount()
    {
        return success(noticeService.unreadCount());
    }

    /**
     * 标记指定通知已读
     */
    @PutMapping("/read/{noticeIds}")
    public AjaxResult read(@PathVariable("noticeIds") Long[] noticeIds)
    {
        return toAjax(noticeService.markRead(noticeIds));
    }

    /**
     * 全部标记已读
     */
    @PutMapping("/readAll")
    public AjaxResult readAll()
    {
        return toAjax(noticeService.markAllRead());
    }
}
