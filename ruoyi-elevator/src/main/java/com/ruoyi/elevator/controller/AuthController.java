package com.ruoyi.elevator.controller;

import com.ruoyi.common.constant.CacheConstants;
import com.ruoyi.common.constant.Constants;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.domain.entity.SysRole;
import com.ruoyi.common.core.domain.entity.SysUser;
import com.ruoyi.common.core.domain.model.LoginBody;
import com.ruoyi.common.core.domain.model.LoginUser;
import com.ruoyi.common.core.redis.RedisCache;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.elevator.domain.Community;
import com.ruoyi.elevator.mapper.UserQueryMapper;
import com.ruoyi.elevator.service.CommunityService;
import com.ruoyi.framework.web.service.SysLoginService;
import com.ruoyi.framework.web.service.SysPermissionService;
import com.ruoyi.framework.web.service.TokenService;
import com.ruoyi.system.service.ISysUserService;
import com.google.code.kaptcha.Producer;
import jakarta.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.FastByteArrayOutputStream;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.IOException;
import java.util.Base64;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

/**
 * 用户端认证
 * 对应论文模块一的用户注册与登录子功能
 * 提供图形验证码、四类角色注册、账号密码登录、退出登录与当前用户信息查询
 *
 * 登录复用 RuoYi 官方 SysLoginService.login，与管理端共用同一套 JWT 令牌体系，
 * 安全过滤链与权限注解不做任何改动。
 *
 * @author 董泽晟
 */
@RestController
@RequestMapping("/basic/auth")
public class AuthController
{
    private static final Logger log = LoggerFactory.getLogger(AuthController.class);

    /** 允许注册的角色标识，与论文 3.1 节「支持四类角色注册」一致 */
    private static final String[] ALLOWED_ROLES = { "owner", "property", "worker", "admin" };

    /** 验证码有效期，单位分钟，与 RuoYi 的 CaptchaController 保持一致 */
    private static final long CAPTCHA_EXPIRE_MINUTES = 2L;

    @Autowired
    private Producer captchaProducer;

    @Autowired
    private RedisCache redisCache;

    @Autowired
    private SysLoginService sysLoginService;

    @Autowired
    private TokenService tokenService;

    @Autowired
    private ISysUserService sysUserService;

    @Autowired
    private UserQueryMapper userQueryMapper;

    @Autowired
    private SysPermissionService permissionService;

    @Autowired
    private CommunityService communityService;

    /**
     * 获取图形验证码
     * 与管理端 /captchaImage 使用同一套 Redis 键与校验逻辑
     */
    @GetMapping("/captcha")
    public AjaxResult captcha(HttpServletResponse response) throws IOException
    {
        AjaxResult ajax = AjaxResult.success();
        response.setHeader("Cache-Control", "no-store, no-cache");

        String capText = captchaProducer.createText();
        String uuid = UUID.randomUUID().toString().replace("-", "");
        redisCache.setCacheObject(CacheConstants.CAPTCHA_CODE_KEY + uuid, capText,
                (int) CAPTCHA_EXPIRE_MINUTES, java.util.concurrent.TimeUnit.MINUTES);

        BufferedImage image = captchaProducer.createImage(capText);
        FastByteArrayOutputStream os = new FastByteArrayOutputStream();
        ImageIO.write(image, "jpg", os);
        ajax.put("uuid", uuid);
        ajax.put("img", Base64.getEncoder().encodeToString(os.toByteArray()));
        ajax.put("captchaEnabled", true);
        return ajax;
    }

    /**
     * 账号密码登录
     * 请求体字段与管理端 LoginBody 一致：username、password、code、uuid
     * 说明：登录接口处于无认证上下文，用户信息一律按请求中的用户名查询，
     * 不使用 SecurityUtils 从安全上下文取用户，避免上下文缺失导致异常。
     */
    @PostMapping("/login")
    public AjaxResult login(@RequestBody LoginBody loginBody)
    {
        String token = sysLoginService.login(loginBody.getUsername(), loginBody.getPassword(),
                loginBody.getCode(), loginBody.getUuid());
        SysUser user = sysUserService.selectUserByUserName(loginBody.getUsername());
        AjaxResult ajax = AjaxResult.success();
        ajax.put(Constants.TOKEN, token);
        if (user != null)
        {
            ajax.put("userInfo", buildUserInfo(user));
        }
        return ajax;
    }

    /**
     * 手机号密码登录
     * 对应论文「通过手机号或账号密码登录」中的手机号登录方式
     * 手机号在 sys_user.phonenumber 上建有唯一索引，按手机号定位账号后校验密码
     */
    @PostMapping("/phoneLogin")
    public AjaxResult phoneLogin(@RequestBody Map<String, Object> params)
    {
        String phonenumber = str(params, "phonenumber");
        String password = str(params, "password");
        String code = str(params, "code");
        String uuid = str(params, "uuid");

        if (StringUtils.isEmpty(phonenumber) || !phonenumber.matches("^1[3-9]\\d{9}$"))
        {
            return AjaxResult.error("请填写正确的手机号");
        }
        if (StringUtils.isEmpty(password))
        {
            return AjaxResult.error("请输入密码");
        }
        // 复用官方图形验证码校验
        sysLoginService.validateCaptcha(phonenumber, code, uuid);

        Long userId = userQueryMapper.selectUserIdByPhone(phonenumber);
        if (userId == null)
        {
            return AjaxResult.error("该手机号未注册，请先注册账号");
        }
        SysUser user = sysUserService.selectUserById(userId);
        if (user == null || "2".equals(user.getDelFlag()))
        {
            return AjaxResult.error("该手机号未注册，请先注册账号");
        }
        if ("1".equals(user.getStatus()))
        {
            return AjaxResult.error("账号已停用，请联系管理员");
        }
        if (!SecurityUtils.matchesPassword(password, user.getPassword()))
        {
            return AjaxResult.error("手机号或密码错误");
        }

        // 按用户名走官方登录流程签发令牌，保证令牌体系与管理端一致
        String token = issueToken(user);

        AjaxResult ajax = AjaxResult.success();
        ajax.put(Constants.TOKEN, token);
        ajax.put("userInfo", buildUserInfo(user));
        return ajax;
    }

    /**
     * 注册
     * 支持业主、物业、维修员、管理员四类角色注册，与论文 3.1 节一致
     */
    @PostMapping("/register")
    public AjaxResult register(@RequestBody Map<String, Object> params)
    {
        String userName = str(params, "userName");
        String nickName = str(params, "nickName");
        String password = str(params, "password");
        String phonenumber = str(params, "phonenumber");
        String roleKey = str(params, "roleKey");
        String code = str(params, "code");
        String uuid = str(params, "uuid");

        if (StringUtils.isEmpty(userName))
        {
            return AjaxResult.error("用户名不能为空");
        }
        if (userName.length() < 2 || userName.length() > 20)
        {
            return AjaxResult.error("用户名长度必须在 2 到 20 个字符之间");
        }
        if (StringUtils.isEmpty(password) || password.length() < 5 || password.length() > 20)
        {
            return AjaxResult.error("密码长度必须在 5 到 20 个字符之间");
        }
        if (StringUtils.isEmpty(phonenumber) || !phonenumber.matches("^1[3-9]\\d{9}$"))
        {
            return AjaxResult.error("请填写正确的手机号");
        }
        if (StringUtils.isEmpty(roleKey))
        {
            return AjaxResult.error("请选择注册角色");
        }
        boolean roleAllowed = false;
        for (String allowed : ALLOWED_ROLES)
        {
            if (allowed.equals(roleKey))
            {
                roleAllowed = true;
                break;
            }
        }
        if (!roleAllowed)
        {
            return AjaxResult.error("该角色不开放注册");
        }

        // 复用官方验证码校验，校验后验证码即失效
        sysLoginService.validateCaptcha(userName, code, uuid);

        if (sysUserService.selectUserByUserName(userName) != null)
        {
            return AjaxResult.error("用户名【" + userName + "】已存在");
        }
        if (userQueryMapper.selectUserIdByPhone(phonenumber) != null)
        {
            return AjaxResult.error("手机号【" + phonenumber + "】已被注册");
        }
        SysRole role = findRoleByKey(roleKey);
        if (role == null)
        {
            return AjaxResult.error("所选角色不存在，请联系管理员初始化角色数据");
        }

        SysUser user = new SysUser();
        user.setUserName(userName);
        user.setNickName(StringUtils.isEmpty(nickName) ? userName : nickName);
        user.setPassword(SecurityUtils.encryptPassword(password));
        user.setPhonenumber(phonenumber);
        user.setStatus("0");
        user.setRoleIds(new Long[] { role.getRoleId() });
        // 所属小区写入 sys_user.community_id，供数据权限按小区隔离
        Long communityId = parseLong(params.get("communityId"));
        if (communityId != null && communityService.selectCommunityById(communityId) != null)
        {
            user.setCommunityId(communityId);
        }
        user.setCreateBy("register");
        sysUserService.insertUser(user);

        AjaxResult ajax = AjaxResult.success("注册成功，请登录");
        ajax.put("userName", userName);
        return ajax;
    }

    /**
     * 退出登录
     * 从请求头解析令牌并清除其登录缓存，令牌随之下线
     */
    @PostMapping("/logout")
    public AjaxResult logout(jakarta.servlet.http.HttpServletRequest request)
    {
        try
        {
            LoginUser loginUser = tokenService.getLoginUser(request);
            if (loginUser != null)
            {
                tokenService.delLoginUser(loginUser.getToken());
            }
        }
        catch (Exception e)
        {
            // 令牌已过期或未携带时，按已退出处理
            log.debug("退出登录时未获取到有效令牌，按已退出处理");
        }
        return AjaxResult.success("退出成功");
    }

    /**
     * 查询当前登录用户信息
     */
    @GetMapping("/userInfo")
    public AjaxResult userInfo()
    {
        SysUser user = sysUserService.selectUserById(SecurityUtils.getUserId());
        if (user == null)
        {
            return AjaxResult.error("用户不存在");
        }
        return AjaxResult.success(buildUserInfo(user));
    }

    /**
     * 按角色标识查询角色
     * 直接查库，避开带 @DataScope 切面的服务方法，保证注册等无安全上下文场景下可用
     */
    private SysRole findRoleByKey(String roleKey)
    {
        Long roleId = userQueryMapper.selectRoleIdByRoleKey(roleKey);
        if (roleId == null)
        {
            return null;
        }
        SysRole role = new SysRole();
        role.setRoleId(roleId);
        role.setRoleKey(roleKey);
        return role;
    }

    /**
     * 组装用户信息，包含主角色标识与所属小区
     */
    private Map<String, Object> buildUserInfo(SysUser user)
    {
        Map<String, Object> info = new LinkedHashMap<>();
        info.put("userId", user.getUserId());
        info.put("userName", user.getUserName());
        info.put("nickName", user.getNickName());
        info.put("phonenumber", user.getPhonenumber());
        info.put("avatar", user.getAvatar());
        String roleKey = resolvePrimaryRoleKey(user.getUserId());
        info.put("roleKey", roleKey);
        info.put("roleName", roleName(roleKey));
        // 所属小区取自 sys_user.community_id，是真实可查询的字段
        info.put("communityId", user.getCommunityId());
        info.put("communityName", resolveCommunityName(user.getCommunityId()));
        return info;
    }

    /**
     * 按小区ID查询小区名称
     */
    private String resolveCommunityName(Long communityId)
    {
        if (communityId == null)
        {
            return "";
        }
        Community community = communityService.selectCommunityById(communityId);
        return community == null ? "" : community.getCommunityName();
    }

    /**
     * 构造登录用户并签发令牌
     * 用于手机号登录等已自行校验过凭证的场景，避免走二次密码校验
     */
    private String issueToken(SysUser user)
    {
        LoginUser loginUser = new LoginUser();
        loginUser.setUserId(user.getUserId());
        loginUser.setUser(user);
        java.util.Set<String> permissions = new java.util.HashSet<>();
        permissions.addAll(permissionService.getRolePermission(user));
        permissions.addAll(permissionService.getMenuPermission(user));
        loginUser.setPermissions(permissions);
        tokenService.setUserAgent(loginUser);
        return tokenService.createToken(loginUser);
    }

    /**
     * 取用户的主角色标识，优先级：管理员 > 物业 > 维修员 > 业主
     * 直接从 sys_user_role 查角色标识，避开带 @DataScope 切面的服务方法，
     * 保证登录等无安全上下文场景下同样可用
     */
    private String resolvePrimaryRoleKey(Long userId)
    {
        List<String> roleKeys = userQueryMapper.selectRoleKeysByUserId(userId);
        String found = null;
        for (String key : roleKeys)
        {
            if ("admin".equals(key))
            {
                return "admin";
            }
            if ("property".equals(key))
            {
                found = "property";
            }
            else if ("worker".equals(key) && found == null)
            {
                found = "worker";
            }
            else if ("owner".equals(key) && found == null)
            {
                found = "owner";
            }
        }
        return found == null ? "owner" : found;
    }

    private String roleName(String roleKey)
    {
        switch (roleKey)
        {
            case "admin":
                return "管理员";
            case "property":
                return "物业";
            case "worker":
                return "维修员";
            default:
                return "业主";
        }
    }

    private String str(Map<String, Object> params, String key)
    {
        Object value = params.get(key);
        return value == null ? null : String.valueOf(value).trim();
    }

    /**
     * 把请求参数安全转换为 Long，转换失败返回 null
     */
    private Long parseLong(Object value)
    {
        if (value == null || StringUtils.isEmpty(String.valueOf(value)))
        {
            return null;
        }
        try
        {
            return Long.valueOf(String.valueOf(value));
        }
        catch (NumberFormatException e)
        {
            log.warn("参数转换为 Long 失败：{}", value);
            return null;
        }
    }
}
