package com.ruoyi.elevator.service;

import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.elevator.domain.Elevator;
import com.ruoyi.elevator.domain.RepairOrder;
import com.ruoyi.elevator.domain.RepairRecord;
import com.ruoyi.elevator.exception.ElevatorErrorCode;
import com.ruoyi.elevator.exception.ElevatorException;
import com.ruoyi.elevator.mapper.RepairOrderMapper;
import com.ruoyi.elevator.mapper.WorkerSkillMapper;
import com.ruoyi.elevator.util.GeoUtil;
import com.ruoyi.elevator.util.LoginUserUtil;
import com.ruoyi.elevator.util.OrderStatusUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Calendar;
import java.util.Date;
import java.util.List;

/**
 * 维修作业服务
 * 对应论文模块三的维保人员接单与维修过程管理子功能
 * 维修员依次推进状态：已接单 -> 已到场 -> 维修中 -> 已修复
 * 状态流转做合法性校验，禁止跳转与非法回退
 *
 * @author 董泽晟
 */
@Service
public class WorkOrderService
{
    @Autowired
    private RepairOrderMapper repairOrderMapper;

    @Autowired
    private WorkerSkillMapper workerSkillMapper;

    @Autowired
    private RepairOrderService repairOrderService;

    @Autowired
    private InspectionService inspectionService;

    @Autowired
    private ElevatorService elevatorService;

    @Autowired
    private NoticeService noticeService;

    /**
     * 查询指派给当前维修员的工单
     *
     * @param query 查询条件
     * @param onlyPending 是否只查待接单的工单
     */
    public List<RepairOrder> myList(RepairOrder query, boolean onlyPending)
    {
        query.setQueryAssigneeId(LoginUserUtil.getUserId());
        if (onlyPending)
        {
            query.setOrderStatus(OrderStatusUtil.ASSIGNED);
        }
        List<RepairOrder> list = repairOrderMapper.selectRepairOrderList(query);
        repairOrderService.attachRepairRecords(list);
        // 待接单要能先看到业主拍的现场照片再决定接不接，所以证据随列表一起返回
        repairOrderService.attachEvidences(list);
        return list;
    }

    /**
     * 查询全部接单情况，供物业查看
     * 走 RepairOrderService 的列表方法，让角色数据范围（小区、指派归属）生效
     */
    public List<RepairOrder> acceptList(RepairOrder query)
    {
        return repairOrderService.selectRepairOrderListWithRecords(query);
    }

    /**
     * 查询维修过程，供物业查看
     * 只列已派单的工单，待审核与已驳回的还谈不上维修过程
     */
    public List<RepairOrder> processList(RepairOrder query)
    {
        query.setQueryAssignedOnly(Boolean.TRUE);
        return repairOrderService.selectRepairOrderListWithRecords(query);
    }

    /**
     * 维修员确认接单，并反馈预计到场时间
     *
     * @param orderId 工单ID
     * @param arriveMinutes 预计到场分钟数
     */
    @Transactional(rollbackFor = Exception.class)
    public int accept(Long orderId, Integer arriveMinutes)
    {
        RepairOrder order = mustBeMyOrder(orderId);
        repairOrderService.assertTransition(order.getOrderStatus(), OrderStatusUtil.ACCEPTED);

        RepairOrder update = new RepairOrder();
        update.setOrderId(orderId);
        update.setOrderStatus(OrderStatusUtil.ACCEPTED);
        update.setAcceptTime(new Date());
        update.setUpdateBy(LoginUserUtil.getUsername());
        // 接单后按预计到场时间更新处理时限
        if (arriveMinutes != null && arriveMinutes > 0)
        {
            Calendar calendar = Calendar.getInstance();
            calendar.add(Calendar.MINUTE, arriveMinutes);
            update.setDeadlineTime(calendar.getTime());
        }
        int rows = repairOrderMapper.updateRepairOrder(update);

        String remark = arriveMinutes != null && arriveMinutes > 0
                ? String.format("维修员已接单，预计 %d 分钟到场", arriveMinutes)
                : "维修员已接单";
        repairOrderService.recordStatus(orderId, order.getOrderStatus(), OrderStatusUtil.ACCEPTED, "accept", remark);

        workerSkillMapper.updateCurrentLoad(LoginUserUtil.getUserId());

        noticeService.sendToUser(order.getUserId(), "维修员已接单",
                String.format("您的报修单【%s】%s", order.getOrderNo(), remark), orderId,
                NoticeService.BIZ_ORDER);
        return rows;
    }

    /**
     * 维修员拒绝接单，工单回到待派单池
     */
    @Transactional(rollbackFor = Exception.class)
    public int refuse(Long orderId, String reason)
    {
        RepairOrder order = mustBeMyOrder(orderId);
        repairOrderService.assertTransition(order.getOrderStatus(), OrderStatusUtil.PENDING);

        RepairOrder update = new RepairOrder();
        update.setOrderId(orderId);
        update.setOrderStatus(OrderStatusUtil.PENDING);
        // 清空派单信息，回到待派单池
        update.setAssigneeId(0L);
        update.setAssignerId(0L);
        update.setUpdateBy(LoginUserUtil.getUsername());
        int rows = repairOrderMapper.updateRepairOrder(update);

        repairOrderService.recordStatus(orderId, order.getOrderStatus(), OrderStatusUtil.PENDING, "reassign",
                StringUtils.isEmpty(reason) ? "维修员拒绝接单，工单回到待派单池" : "维修员拒绝接单：" + reason);

        noticeService.sendToRole(LoginUserUtil.ROLE_PROPERTY, "工单被拒单",
                String.format("工单【%s】被维修员拒绝，请重新指派", order.getOrderNo()), orderId,
                NoticeService.BIZ_ORDER);
        return rows;
    }

    /**
     * 维修员到达现场，记录到场时间与定位
     *
     * 到场位置是「人确实到了这台电梯跟前」的凭据，所以位置由前端定位直出、
     * 不许手填，后端再按坐标与电梯台账比对，超出范围直接拒绝。
     * 演示模式（demo=true）跳过校验，仅在演示场合使用，落库时打标记。
     *
     * @param orderId 工单ID
     * @param record  到场信息，含位置文字、经纬度、是否演示
     */
    @Transactional(rollbackFor = Exception.class)
    public int arrive(Long orderId, RepairRecord record)
    {
        RepairOrder order = mustBeMyOrder(orderId);
        repairOrderService.assertTransition(order.getOrderStatus(), OrderStatusUtil.ARRIVED);

        boolean demo = "1".equals(record.getDemoFlag());
        String location = record.getArriveLocation();
        if (StringUtils.isEmpty(location))
        {
            throw new ElevatorException("请先获取当前位置");
        }

        Integer distance = null;
        if (!demo)
        {
            if (record.getArriveLongitude() == null || record.getArriveLatitude() == null)
            {
                throw new ElevatorException("未取到定位坐标，请允许浏览器获取位置后重试");
            }
            distance = checkDistance(order.getElevatorId(),
                    record.getArriveLongitude().doubleValue(), record.getArriveLatitude().doubleValue());
        }

        Date now = new Date();
        RepairOrder update = new RepairOrder();
        update.setOrderId(orderId);
        update.setOrderStatus(OrderStatusUtil.ARRIVED);
        update.setArriveTime(now);
        update.setUpdateBy(LoginUserUtil.getUsername());
        int rows = repairOrderMapper.updateRepairOrder(update);

        // 维修记录里同步到场信息
        RepairRecord save = new RepairRecord();
        save.setOrderId(orderId);
        save.setWorkerId(LoginUserUtil.getUserId());
        save.setArriveTime(now);
        save.setArriveLocation(location);
        save.setArriveLongitude(record.getArriveLongitude());
        save.setArriveLatitude(record.getArriveLatitude());
        save.setArriveDistance(distance);
        save.setDemoFlag(demo ? "1" : "0");
        repairOrderService.saveRepairRecord(save);

        repairOrderService.recordStatus(orderId, order.getOrderStatus(), OrderStatusUtil.ARRIVED, "arrive",
                buildArriveRemark(location, record, distance, demo));

        noticeService.sendToUser(order.getUserId(), "维修员已到场",
                String.format("您的报修单【%s】维修员已到达现场", order.getOrderNo()), orderId,
                NoticeService.BIZ_ORDER);
        return rows;
    }

    /**
     * 维修员开始排查，填写排查记录，工单进入维修中
     */
    @Transactional(rollbackFor = Exception.class)
    public int investigate(Long orderId, String investigateNote)
    {
        RepairOrder order = mustBeMyOrder(orderId);
        String fromStatus = order.getOrderStatus();
        // 已到场或已申诉（返工）都可以进入维修中
        if (!OrderStatusUtil.ARRIVED.equals(fromStatus) && !OrderStatusUtil.APPEALED.equals(fromStatus))
        {
            repairOrderService.assertTransition(fromStatus, OrderStatusUtil.REPAIRING);
        }

        RepairOrder update = new RepairOrder();
        update.setOrderId(orderId);
        update.setOrderStatus(OrderStatusUtil.REPAIRING);
        update.setUpdateBy(LoginUserUtil.getUsername());
        int rows = repairOrderMapper.updateRepairOrder(update);

        RepairRecord record = new RepairRecord();
        record.setOrderId(orderId);
        record.setWorkerId(LoginUserUtil.getUserId());
        record.setInvestigateNote(investigateNote);
        // 从「已申诉」进入是返工，另起一轮维修记录，避免覆盖首次的处理说明
        repairOrderService.saveRepairRecord(record, OrderStatusUtil.APPEALED.equals(fromStatus));

        repairOrderService.recordStatus(orderId, fromStatus, OrderStatusUtil.REPAIRING, "investigate",
                StringUtils.isEmpty(investigateNote) ? "维修员开始排查" : investigateNote);
        return rows;
    }

    /**
     * 维修完成，提交处理说明与更换配件，工单进入已修复等待业主确认
     */
    @Transactional(rollbackFor = Exception.class)
    public int finish(Long orderId, RepairRecord finishInfo)
    {
        RepairOrder order = mustBeMyOrder(orderId);
        repairOrderService.assertTransition(order.getOrderStatus(), OrderStatusUtil.REPAIRED);
        if (StringUtils.isEmpty(finishInfo.getRepairDesc()))
        {
            throw new ElevatorException("请填写维修处理说明");
        }

        Date now = new Date();
        RepairOrder update = new RepairOrder();
        update.setOrderId(orderId);
        update.setOrderStatus(OrderStatusUtil.REPAIRED);
        update.setFinishTime(now);
        update.setUpdateBy(LoginUserUtil.getUsername());
        int rows = repairOrderMapper.updateRepairOrder(update);

        finishInfo.setOrderId(orderId);
        finishInfo.setWorkerId(LoginUserUtil.getUserId());
        finishInfo.setFinishTime(now);
        // 更新本轮那条记录。返工时 investigate 已另起一轮并插入了新记录，
        // selectByOrderId 取的是最新一条，所以这里自然落在本轮上，不会覆盖上一轮
        repairOrderService.saveRepairRecord(finishInfo);

        repairOrderService.recordStatus(orderId, order.getOrderStatus(), OrderStatusUtil.REPAIRED, "finish",
                "维修完成：" + finishInfo.getRepairDesc());

        // 维修完成后写入维保档案，形成电梯全生命周期记录
        inspectionService.createRepairArchive(order, finishInfo.getRepairDesc(),
                finishInfo.getReplaceParts(), LoginUserUtil.getNickName(), now);

        // 累计维修员完成数与响应时长
        Integer responseMinutes = null;
        if (order.getAssignTime() != null)
        {
            responseMinutes = (int) ((now.getTime() - order.getAssignTime().getTime()) / 60000);
        }
        workerSkillMapper.increaseFinished(LoginUserUtil.getUserId(), responseMinutes);
        workerSkillMapper.updateCurrentLoad(LoginUserUtil.getUserId());

        noticeService.sendToUser(order.getUserId(), "维修已完成，请确认",
                String.format("您的报修单【%s】维修已完成：%s，请确认故障是否消除", order.getOrderNo(), finishInfo.getRepairDesc()),
                orderId, NoticeService.BIZ_ORDER);
        return rows;
    }

    /**
     * 查询工单的维修记录
     */
    public RepairRecord getRecord(Long orderId)
    {
        return repairOrderService.getRepairRecord(orderId);
    }

    /**
     * 比对打卡点与该工单电梯台账坐标的距离，超出允许范围直接拒绝
     *
     * @return 实际距离（米）
     */
    private int checkDistance(Long elevatorId, double lng, double lat)
    {
        Elevator elevator = elevatorService.selectElevatorById(elevatorId);
        if (elevator == null || elevator.getLongitude() == null || elevator.getLatitude() == null)
        {
            throw new ElevatorException("该电梯未登记位置坐标，无法校验到场位置，请联系物业补充");
        }
        int distance = GeoUtil.distance(lng, lat,
                elevator.getLongitude().doubleValue(), elevator.getLatitude().doubleValue());
        if (distance > GeoUtil.ALLOW_DISTANCE_METERS)
        {
            throw new ElevatorException(String.format(
                    "当前位置距离该电梯约 %d 米，超出 %d 米范围，请到达电梯现场后再打卡",
                    distance, GeoUtil.ALLOW_DISTANCE_METERS));
        }
        return distance;
    }

    /**
     * 组装到场流转记录的说明文字
     * 把坐标与距离一并写进去，便于事后核对到场真实性
     */
    private String buildArriveRemark(String location, RepairRecord record, Integer distance, boolean demo)
    {
        StringBuilder sb = new StringBuilder("维修员已到达现场，定位：").append(location);
        if (record.getArriveLongitude() != null && record.getArriveLatitude() != null)
        {
            sb.append("，坐标：")
              .append(String.format("%.6f,%.6f",
                      record.getArriveLongitude().doubleValue(), record.getArriveLatitude().doubleValue()));
        }
        if (distance != null)
        {
            sb.append("，距电梯 ").append(distance).append(" 米");
        }
        if (demo)
        {
            sb.append("（演示打卡，未做位置校验）");
        }
        return sb.toString();
    }

    /**
     * 校验工单是否为当前维修员负责，防止越权操作
     */
    private RepairOrder mustBeMyOrder(Long orderId)
    {
        RepairOrder order = repairOrderService.mustGetOrder(orderId);
        if (LoginUserUtil.isAdmin() || LoginUserUtil.isProperty())
        {
            return order;
        }
        if (!LoginUserUtil.getUserId().equals(order.getAssigneeId()))
        {
            throw new ElevatorException(ElevatorErrorCode.NO_DATA_PERMISSION.getMessage(),
                    ElevatorErrorCode.NO_DATA_PERMISSION.getCode());
        }
        return order;
    }
}
