package com.ruoyi.elevator.exception;

import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.StringUtils;
import jakarta.servlet.http.HttpServletRequest;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.validation.BindException;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

/**
 * 电梯业务异常处理器
 * 将电梯业务的领域异常转换为统一响应体，提示信息统一为中文可读文案
 *
 * @author 董泽晟
 */
@RestControllerAdvice
public class ElevatorExceptionHandler
{
    private static final Logger log = LoggerFactory.getLogger(ElevatorExceptionHandler.class);

    /**
     * 业务异常
     */
    @ExceptionHandler(ElevatorException.class)
    public AjaxResult handleElevatorException(ElevatorException e, HttpServletRequest request)
    {
        log.warn("电梯业务异常，请求地址：{}，异常信息：{}", request.getRequestURI(), e.getMessage());
        Integer code = e.getCode();
        return StringUtils.isNotNull(code) ? AjaxResult.error(code, e.getMessage()) : AjaxResult.error(e.getMessage());
    }

    /**
     * 参数校验异常（表单绑定）
     */
    @ExceptionHandler(BindException.class)
    public AjaxResult handleBindException(BindException e)
    {
        String message = e.getAllErrors().get(0).getDefaultMessage();
        log.warn("参数校验失败：{}", message);
        return AjaxResult.error(message);
    }

    /**
     * 参数校验异常（请求体）
     */
    @ExceptionHandler(MethodArgumentNotValidException.class)
    public AjaxResult handleMethodArgumentNotValidException(MethodArgumentNotValidException e)
    {
        String message = e.getBindingResult().getAllErrors().get(0).getDefaultMessage();
        log.warn("参数校验失败：{}", message);
        return AjaxResult.error(message);
    }

    /**
     * 若依业务异常
     */
    @ExceptionHandler(ServiceException.class)
    public AjaxResult handleServiceException(ServiceException e, HttpServletRequest request)
    {
        log.warn("业务异常，请求地址：{}，异常信息：{}", request.getRequestURI(), e.getMessage());
        Integer code = e.getCode();
        return StringUtils.isNotNull(code) ? AjaxResult.error(code, e.getMessage()) : AjaxResult.error(e.getMessage());
    }

    /**
     * 权限校验失败
     */
    @ExceptionHandler(AccessDeniedException.class)
    public AjaxResult handleAccessDeniedException(AccessDeniedException e, HttpServletRequest request)
    {
        log.warn("权限校验失败，请求地址：{}", request.getRequestURI());
        return AjaxResult.error(403, "没有权限，请联系管理员授权");
    }
}
