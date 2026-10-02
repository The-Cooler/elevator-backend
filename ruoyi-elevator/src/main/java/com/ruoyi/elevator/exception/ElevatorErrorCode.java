package com.ruoyi.elevator.exception;

/**
 * 电梯业务异常码
 * 与论文第2章非功能需求中的业务约束一一对应
 *
 * @author 董泽晟
 */
public enum ElevatorErrorCode
{
    /** 工单状态流转非法 */
    ORDER_STATUS_ILLEGAL(4001, "工单状态流转非法"),

    /** 工单不存在 */
    ORDER_NOT_EXIST(4002, "工单不存在"),

    /** 无权操作他人数据 */
    NO_DATA_PERMISSION(4003, "无权操作该数据"),

    /** 同一电梯存在未结工单 */
    ORDER_DUPLICATE(4004, "该电梯已有未处理完的报修工单，请勿重复报修"),

    /** 电梯状态不可报修 */
    ELEVATOR_DISABLED(4005, "该电梯当前不可报修"),

    /** 维保计划重复 */
    PLAN_DUPLICATE(4006, "该电梯在相同周期内已存在启用的维保计划"),

    /** 巡检任务已执行 */
    INSPECTION_FINISHED(4007, "该巡检任务已完成，不能重复提交"),

    /** 巡检任务不存在 */
    INSPECTION_NOT_EXIST(4008, "巡检任务不存在"),

    /** 维修员不可用 */
    WORKER_UNAVAILABLE(4009, "该维修员当前不可接单"),

    /** 维修员与故障不匹配 */
    WORKER_SKILL_MISMATCH(4010, "该维修员技能与故障类型不匹配"),

    /** 文件类型不支持 */
    FILE_TYPE_UNSUPPORTED(4011, "不支持的文件类型"),

    /** 文件超出大小限制 */
    FILE_SIZE_EXCEEDED(4012, "文件大小超出限制"),

    /** 文件不存在 */
    FILE_NOT_EXIST(4013, "文件不存在"),

    /** 健康评分数据不足 */
    HEALTH_DATA_INSUFFICIENT(4014, "该电梯统计周期内数据不足，无法生成健康评分"),

    /** 预警规则不存在 */
    WARNING_RULE_NOT_EXIST(4015, "预警规则不存在");

    private final Integer code;

    private final String message;

    ElevatorErrorCode(Integer code, String message)
    {
        this.code = code;
        this.message = message;
    }

    public Integer getCode()
    {
        return code;
    }

    public String getMessage()
    {
        return message;
    }
}
