package com.ruoyi.elevator.util;

import com.ruoyi.common.core.domain.model.LoginUser;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.elevator.exception.ElevatorErrorCode;
import com.ruoyi.elevator.exception.ElevatorException;

import java.util.Set;

/**
 * 当前登录用户工具类
 * 封装角色判断与数据归属校验，供各业务模块复用
 *
 * 说明：角色标识取自 LoginUser.user.roles，由 UserDetailsServiceImpl 在登录时装载；
 * LoginUser.permissions 只包含菜单与按钮权限串，不含角色标识。
 *
 * @author 董泽晟
 */
public class LoginUserUtil
{
    /** 管理员角色标识 */
    public static final String ROLE_ADMIN = "admin";

    /** 物业角色标识 */
    public static final String ROLE_PROPERTY = "property";

    /** 维修员角色标识 */
    public static final String ROLE_WORKER = "worker";

    /** 业主角色标识 */
    public static final String ROLE_OWNER = "owner";

    /**
     * 获取当前登录用户ID
     */
    public static Long getUserId()
    {
        return SecurityUtils.getUserId();
    }

    /**
     * 获取当前登录用户名
     */
    public static String getUsername()
    {
        return SecurityUtils.getUsername();
    }

    /**
     * 获取当前登录用户完整信息
     */
    public static LoginUser getLoginUser()
    {
        return SecurityUtils.getLoginUser();
    }

    /**
     * 获取当前登录用户手机号
     */
    public static String getPhone()
    {
        return SecurityUtils.getLoginUser().getUser().getPhonenumber();
    }

    /**
     * 获取当前登录用户昵称
     */
    public static String getNickName()
    {
        LoginUser loginUser = SecurityUtils.getLoginUser();
        return loginUser.getUser().getNickName();
    }

    /**
     * 获取当前登录用户所属小区ID
     * 对应论文表3-1 的 community_id 字段，管理员返回 null 表示不限制小区
     */
    public static Long getCommunityId()
    {
        LoginUser loginUser = SecurityUtils.getLoginUser();
        if (loginUser.getUser() == null || isAdmin())
        {
            return null;
        }
        return loginUser.getUser().getCommunityId();
    }

    /**
     * 获取当前登录用户携带的角色标识集合
     * LoginUser.permissions 只含菜单按钮权限串，角色标识在 LoginUser.user.roles 中，
     * 登录时由 UserDetailsServiceImpl 一并装载，语义等价于 hasRole 判断。
     */
    public static Set<String> getRoleKeys()
    {
        LoginUser loginUser = SecurityUtils.getLoginUser();
        if (loginUser.getUser() == null || loginUser.getUser().getRoles() == null)
        {
            return new java.util.HashSet<>();
        }
        return loginUser.getUser().getRoles().stream()
                .map(role -> role.getRoleKey())
                .collect(java.util.stream.Collectors.toSet());
    }

    /**
     * 获取当前登录用户的主角色标识（取第一个非管理员的角色，没有则返回 admin）
     */
    public static String getPrimaryRoleKey()
    {
        Set<String> roleKeys = getRoleKeys();
        if (roleKeys.contains(ROLE_ADMIN))
        {
            return ROLE_ADMIN;
        }
        if (roleKeys.contains(ROLE_PROPERTY))
        {
            return ROLE_PROPERTY;
        }
        if (roleKeys.contains(ROLE_WORKER))
        {
            return ROLE_WORKER;
        }
        if (roleKeys.contains(ROLE_OWNER))
        {
            return ROLE_OWNER;
        }
        return ROLE_ADMIN;
    }

    /**
     * 是否为管理员
     */
    public static boolean isAdmin()
    {
        return getRoleKeys().contains(ROLE_ADMIN);
    }

    /**
     * 是否为物业
     */
    public static boolean isProperty()
    {
        return getRoleKeys().contains(ROLE_PROPERTY);
    }

    /**
     * 是否为维修员
     */
    public static boolean isWorker()
    {
        return getRoleKeys().contains(ROLE_WORKER);
    }

    /**
     * 是否为业主
     */
    public static boolean isOwner()
    {
        return getRoleKeys().contains(ROLE_OWNER);
    }

    /**
     * 校验当前用户是否有权访问指定归属人的数据
     * 管理员与物业可访问全部数据，维修员可访问指派给本人的数据，业主只能访问本人数据
     *
     * @param ownerId 数据归属人ID
     */
    public static void checkDataPermission(Long ownerId)
    {
        if (isAdmin() || isProperty())
        {
            return;
        }
        if (ownerId == null || !ownerId.equals(getUserId()))
        {
            throw new ElevatorException(ElevatorErrorCode.NO_DATA_PERMISSION.getMessage(),
                    ElevatorErrorCode.NO_DATA_PERMISSION.getCode());
        }
    }

    /**
     * 校验当前用户是否为业主
     */
    public static void checkOwner()
    {
        if (!isOwner())
        {
            throw new ElevatorException("该操作仅业主可执行", ElevatorErrorCode.NO_DATA_PERMISSION.getCode());
        }
    }

    /**
     * 校验当前用户是否为物业或管理员
     */
    public static void checkPropertyOrAdmin()
    {
        if (!isProperty() && !isAdmin())
        {
            throw new ElevatorException("该操作仅物业或管理员可执行", ElevatorErrorCode.NO_DATA_PERMISSION.getCode());
        }
    }

    /**
     * 校验当前用户是否为维修员
     */
    public static void checkWorker()
    {
        if (!isWorker())
        {
            throw new ElevatorException("该操作仅维修员可执行", ElevatorErrorCode.NO_DATA_PERMISSION.getCode());
        }
    }
}
