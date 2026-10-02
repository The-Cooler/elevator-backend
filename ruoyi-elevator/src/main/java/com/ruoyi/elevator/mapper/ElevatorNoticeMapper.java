package com.ruoyi.elevator.mapper;

import com.ruoyi.elevator.domain.ElevatorNotice;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 通知消息 数据层
 *
 * @author 董泽晟
 */
public interface ElevatorNoticeMapper
{
    List<ElevatorNotice> selectElevatorNoticeList(ElevatorNotice elevatorNotice);

    int countUnread(Long receiverId);

    int insertElevatorNotice(ElevatorNotice elevatorNotice);

    int updateRead(@Param("receiverId") Long receiverId, @Param("noticeIds") Long[] noticeIds);

    int updateAllRead(Long receiverId);
}
