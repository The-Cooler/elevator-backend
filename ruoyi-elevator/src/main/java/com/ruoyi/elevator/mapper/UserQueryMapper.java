package com.ruoyi.elevator.mapper;

import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 用户查询辅助 Mapper
 * 用于按角色查用户、查维修员等跨模块查询
 *
 * @author 董泽晟
 */
public interface UserQueryMapper
{
    /**
     * 按角色标识查询启用状态的用户ID列表
     */
    List<Long> selectUserIdsByRoleKey(@Param("roleKey") String roleKey);

    /**
     * 按角色标识与小区查询维修员ID列表
     */
    List<Long> selectWorkerIdsByCommunity(@Param("communityId") Long communityId);

    /**
     * 查询指定用户的昵称
     */
    String selectNickNameById(@Param("userId") Long userId);

    /**
     * 查询指定用户的角色标识列表
     * 不使用若依的 ISysRoleService.selectRolesByUserId，该方法带 @DataScope 切面，
     * 在登录等无安全上下文的场景会抛「获取用户信息异常」
     */
    List<String> selectRoleKeysByUserId(@Param("userId") Long userId);

    /**
     * 按手机号查询用户ID，供手机号密码登录使用
     * 手机号在 sys_user.phonenumber 上有唯一索引
     */
    Long selectUserIdByPhone(@Param("phonenumber") String phonenumber);

    /**
     * 按角色标识查询角色ID
     * 不使用 ISysRoleService.selectRoleAll，该方法内部经 AOP 代理调用带 @DataScope 切面的
     * selectRoleList，在注册等无安全上下文的场景会抛「获取用户信息异常」
     */
    Long selectRoleIdByRoleKey(@Param("roleKey") String roleKey);
}
