package com.ruoyi.elevator.config;

import org.springdoc.core.models.GroupedOpenApi;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * 电梯业务接口文档分组配置
 * 分组名称与论文第3章的五个功能模块一致
 *
 * 说明：RuoYi 框架已提供 OpenAPI 信息配置 Bean（customOpenApi），
 * 此处只做接口分组，不再重复定义 OpenAPI Bean，避免 Bean 冲突。
 *
 * @author 董泽晟
 */
@Configuration
public class ElevatorSwaggerConfig
{
    @Bean
    public GroupedOpenApi basicApi()
    {
        return GroupedOpenApi.builder()
                .group("模块一-基础数据与权限管理")
                .pathsToMatch("/basic/**", "/common/file/**")
                .build();
    }

    @Bean
    public GroupedOpenApi repairApi()
    {
        return GroupedOpenApi.builder()
                .group("模块二-故障报修与跟踪")
                .pathsToMatch("/repair/**")
                .build();
    }

    @Bean
    public GroupedOpenApi orderApi()
    {
        return GroupedOpenApi.builder()
                .group("模块三-工单调度与执行")
                .pathsToMatch("/order/**")
                .build();
    }

    @Bean
    public GroupedOpenApi maintainApi()
    {
        return GroupedOpenApi.builder()
                .group("模块四-预防性维保")
                .pathsToMatch("/maintain/**")
                .build();
    }

    @Bean
    public GroupedOpenApi analysisApi()
    {
        return GroupedOpenApi.builder()
                .group("模块五-数据分析与预警")
                .pathsToMatch("/analysis/**")
                .build();
    }

    @Bean
    public GroupedOpenApi cascadeApi()
    {
        return GroupedOpenApi.builder()
                .group("公共-级联查询")
                .pathsToMatch("/common/cascade/**")
                .build();
    }
}
