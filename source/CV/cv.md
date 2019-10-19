---
layout: post
title: Curriculum Vitae
date: 2018-04-19 22:57:12
---

# 刘郎
# 联系方式

- 手机：17608387765
- QQ/微信：709091988
- Email：LangInteger@outlook.com
---

# 个人信息

 - 男/1995年生人
 - 本科/中南大学土木工程 2013级/加权成绩：86.89/排名：前15%
 - 四六级：优秀（565/526）/计算机等考二三级：合格
 - 技术博客：[LangInteger.github.io](http://LangInteger.github.io )
 - 期望职位/城市：Java后台开发工程师/北京、上海、深圳
 - 期望薪资：萌新害怕，不敢说话

---

# 所获荣誉
 - [四川省NOIP2010 信息学奥林匹克联赛三等奖](http://www.myjks.com/zhengcewenjian/suoneiwenjian/jianbao/2010-12-28/1852.html)
 - [中南大学第十届大学生程序设计竞赛三等奖](http://tz.its.csu.edu.cn/Home/Release_TZTG_zd/415EAACD037445198C981C041613D4FA)

# 技术/影评文章

- [String和它的常量池朋友以及intern()方法在JDK1.7中的变化](https://langinteger.github.io/2018/04/19/java-String-pool/)
- [Java排序算法的实现及比美-进阶篇](https://langinteger.github.io/2018/04/08/java-sort-algrithm2/)
- [天堂电影院-Cinema Paradiso](https://langinteger.github.io/2018/04/11/movie-cinema-paradiso/)

# 项目经历

## 在线汇率转换项目
实施抓取中国银行汇率信息，实现十余种货币汇率的相互转换
体验地址：http://langexample.herokuapp.com/exchangerate.html

## web 商城项目
一个完整的web商城项目，融入 MVC 架构思想，不添加任何框架的成分，原汁原味体验原生 Servlet
 和 JSP。主要模块有：
 - 后台管理：实现商品库存、订单、管理员账户的增删改查
 - 前台展示：用户登录注册、商品搜索与显示、购物车与订单管理、支付模块（采用easypay api）
主要痛点：
 - 文字编码问题：文件上传框架 uploadfile 对文件名采用 ISO8895-1 格式进行编码，需指定 utf-8 编码以兼容此应用
 - 日期格式转换问题：BeanUtils 可以使 Map 转成对应的 Bean 类，但是如果 bean 有个日期字段而Map中这个日期字段传过来是字符串，数据类型无法转换，会导致报错，可以为 BeanUtils 指定一个日期转换器来解决日期格式转换问题
 - 分页处理：构建辅助对象 PageHelper 封装所有与分页相关的信息，查询结果集也可封装在其中
 - 事务与数据库连接：使用 DButils框架时，其QueryRunner的query方法中，有一个类型为boolean的closeConn参数。当connection作为参数显式传递给query方法时（比如在事务中，我们不得不这么做），这个开关默认是关闭的，反之则是打开的。所以在使用事务时（以及一切将connection作为query方法参数的情况），我们必须要手动关闭connection。

## 企业人力资源管理系统
该管理系统基于Spring，Spring MVC和Mybatis构建。
主要模块如下：
1. 登录模块：登录、注销、错误信息回显等功能
2. 部门、职位、员工、公告管理模块：实现相应实体的增删改查，分页显示，以及查询报表的生成。其中查询模块在mapper映射文件中使用resultmap实现多表查询
3. 文件模块：文件的增删改查以及下载功能


# 技能清单

以下均为我熟练使用的技能

- Web开发：Spring/Spring MVC/Mybatis
- 数据库相关：MySQL/Mybatis/C3P0/DBCP
- 版本管理、文档和自动化部署工具：Maven/Git
- 单元测试：Junit4
---

# 中意书籍

- 《CSS世界》			张鑫旭
- 《图解HTTP》			上野宣
- *Pointers on C*	Kenneth·Reek


# 致谢
感谢您花时间阅读我的简历，您的意见和反馈是我前进路上的最大动力。
