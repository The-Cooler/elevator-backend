package com.ruoyi.elevator.exception;

/**
 * 电梯业务异常
 * 用于业务规则校验失败时抛出，由 ElevatorExceptionHandler 统一转换为响应体
 *
 * @author 董泽晟
 */
public class ElevatorException extends RuntimeException
{
    private static final long serialVersionUID = 1L;

    /** 错误码 */
    private Integer code;

    public ElevatorException(String message)
    {
        super(message);
    }

    public ElevatorException(String message, Integer code)
    {
        super(message);
        this.code = code;
    }

    public Integer getCode()
    {
        return code;
    }
}
