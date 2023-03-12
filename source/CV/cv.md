---
layout: post
title: Curriculum Vitae
---

# <center><font size=6>刘郎</font></center>

<center>邮箱: langinteger@outlook.com | 电话: 17608387765</center>

## <font size=5>教育背景</font>

- 2013.09-2017.06（本科）&nbsp;&nbsp;&nbsp;中南大学&nbsp;&nbsp;&nbsp;加权成绩：86.89（前15%）

## <font size=5>所获荣誉</font>

- [四川省NOIP2010 信息学奥林匹克联赛三等奖](http://www.myjks.com/zhengcewenjian/suoneiwenjian/jianbao/2010-12-28/1852.html)
- [中南大学第十届大学生程序设计竞赛三等奖](http://tz.its.csu.edu.cn/Home/Release_TZTG_zd/415EAACD037445198C981C041613D4FA)
- 中南大学 2013/2014/2015 学年度二等奖学金（校级）

## <font size=5>工作经历</font>

### <font size=4><div><div style="float:left">万国游（深圳）科技有限公司</div><div style="float:right">软件工程师 2018.07-至今</div></div></font></br>

- 参与基于 Spring Boot 微服务架构的 Java 后端服务开发，贡献项目核心代码近 20 万行（增 18 万行，删 7 万行）
- 实现业务逻辑若干
  - 实现了国内机票预定流程，成功对接 OTA、航空公司四家
  - 实现了国内火车票预定流程，成功对接供应商一家
  - 实现了国际酒店预定流程，成功对接供应商一家
- 解决技术问题若干
  - 排查死锁问题：数据库结构中存在外键，新增从表记录时会获取指向主表记录的 S 锁，再结合主表记录的保存和另一张表记录的保存即会产生死锁
  - 排查项目 N+1 问题：使用 JPA 2.1 规范中的 NamedEntityGraph，或者使用 Redis 缓存数据解决
  - 实现分布式唯一 ID 生成：采用 Twitter SnowFlake 算法的 Java 实现来达到目的
  - 梳理项目配置文件优先级：解决了多实例部署场景下由于配置优先级理解不当给两个实例配置了相同的 dataCenterId/machineId 造成 SnowFlake 生成 ID 重复的问题
  - 梳理 Spring Boot 参数校验机制：对 @Valid 和 @Validated 注解各自的作用场景进行了深入梳理，并在团队做交流规范其使用

##  <font size=5>开源贡献</font>

- [MERGED] 解决 [Embedded-consul 项目 (74 Star)](https://github.com/pszymczyk/embedded-consul) 中由于依赖冲突导致的测试用例无法单独启动运行的问题：[To resolve the failure of running test singlely due to http client dependency conflict ](https://github.com/pszymczyk/embedded-consul/pull/93)
- [UNMERGED] 解决 [Hikari CP 项目 (11.6k star)](https://github.com/brettwooldridge/HikariCP) 中 `blockUntilFilled` 模式的设计问题以及流程 BUG：[Change the thread pool size of AddConnectionExecutor to minimumIdle on hikari startup phase in blocked initialization](https://github.com/brettwooldridge/HikariCP/pull/1405)

## <font size=5>公开文章</font>

- [Spring Boot 项目配置文件详析](https://langinteger.github.io/2019/05/30/centralized-configuration/)
- [Java Bean Validation 及其在 Spring Boot 参数校验中的应用](https://langinteger.github.io/2019/09/13/java-bean-validation/)
- [String 和它的常量池朋友以及 intern() 方法在 JDK1.7 中的变化](https://langinteger.github.io/2018/04/19/java-String-pool/)
- [Java 排序算法的实现及比美-进阶篇](https://langinteger.github.io/2018/04/08/java-sort-algrithm2/)
- [天堂电影院-Cinema Paradiso](https://langinteger.github.io/2018/04/11/movie-cinema-paradiso/)

## <font size=5>技能清单</font>

- Web 开发：熟练掌握基于 Spring Boot/Spring Data JPA 的 Java 后端开发工作
- 数据库：理解事务，熟悉 Mysql 及其锁机制，熟悉 Hikari CP
- 版本管理、文档和自动化部署工具：深入理解 Git 工作流，熟练使用和配置 jenkins，熟练使用 Kubernetes
