---
title: 天下还有免费的午餐--Heroku初体验
date: 2018-05-17 19:41:41
reward: true
toc: true
tags:
	- Heroku
	- Server
	- Java
	- WebCrawler
---

作为最早的云服务平台之一，经过十年的努力，Heroku 终于在 2018 年引起了我的注意（做不要脸状）。本文主要介绍在 Heroku 平台上部署运行在 Jetty 容器中的 Java Web 应用的过程以及踩的那些坑。最终的成果见 [langexample](http://langexample.herokuapp.com/)。

<!--more-->

## 1. 工具的安装

- The Heroku CLI
	- Heroku 命令行接口工具用于在 terminal 中管理 Heroku 应用
	- 通过 **heroku login** 来登录到 Heroku

## 2. 程序的部署

- 创建项目
	- 在本地通过 maven 创建 Java Web 项目
	- 命令行：$ mvn archetype:generate -DarchetypeArtifactId=maven-archetype-webapp
	- 为提升速度，使用本地原型信息创建，加上参数： -DarchetypeCatalog=internal
- 添加 Web 容器插件
	- Jetty 是一种轻量级的 Java 应用容器
	- 执行 java 代码即可启动 Jetty 服务器
	> $ java -jar jetty-runner.jar application.war
	- 在 pom.xml 中添加 Jetty 服务器插件的代码如下
	```xml
	<build>
	  ...
	  <plugins>
	    <plugin>
	      <groupId>org.apache.maven.plugins</groupId>
	      <artifactId>maven-dependency-plugin</artifactId>
	      <version>2.4</version>
	      <executions>
	        <execution>
	          <phase>package</phase>
	          <goals><goal>copy</goal></goals>
	          <configuration>
	            <artifactItems>
	              <artifactItem>
	                <groupId>org.eclipse.jetty</groupId>
	                <artifactId>jetty-runner</artifactId>
	                <version>9.4.9.v20180320</version>
	                <destFileName>jetty-runner.jar</destFileName>
	              </artifactItem>
	            </artifactItems>
	          </configuration>
	        </execution>
	       </executions>
	    </plugin>
	  </plugins>
	</build>
	```
- 指定 程序运行方式
	- 创建 Procfile 文件
	- procfile 声明了程序运行的方式
	- 添加如下代码，表示启动 Jetty 服务器运行 Java 程序
	>web: java $JAVA_OPTS -jar target/dependency/jetty-runner.jar --port $PORT target\*.war

- 指定 Java 版本
	- 创建 system.properties 文件
	- 通过 **java.runtime.version=8**的形式指定 Java 版本
	- 默认采用 Java 8，但是鉴于将来可能会变，还是手动指定一下吧

- 添加 git 忽略
	- 创建 .gitignore 文件
	- 由于 target 目录的文件由 mvn 编译打包产生用于本地运行，并不需要推送到 Heroku ，故将 target 写入 .gitignore 文件，在 deploy 时忽略此文件夹中的文件
	- win 下直接新建 .gitignore 是不行的，在文本编辑器中选择保存或者另存为则可以

- 注册 Servlet
	- Jetty 某个版本以后貌似就支持 @WebServlet 注解了，但还是记录在这儿吧
	- 在 WEB-INF 文件夹下的 web.xml 中添加以下代码注册 Servlet
	```xml
	  <servlet>
	    <servlet-name>Servlet</servlet-name>
	    <servlet-class>com.lebecca.exchangerate.Servlet</servlet-class>
	  </servlet>
	  <servlet-mapping>
	    <servlet-name>Servlet</servlet-name>
	    <url-pattern>exchangerateservlet</url-pattern>
	  </servlet-mapping>
	```
- 添加本地 git 仓库
	- git init
	- git add .
	- git commit -m "Ready to deploy"

- 部署到 Heroku
	- 创建应用 **$ heroku create [appname]**
		- 应用创建时，一个远程git（heroku）也会同时创建并与本地库关联
	- 本地推送 **$ git push heroku master**
	- 添加资源 **$ heroku ps:scale web=1**
	- 打开应用 **$ heroku open**
	- 本地运行 **$ foreman start web -f Profile.windows**
		- localhost:500，linux系统可以省略 -f


## 3. 功能的实现

- 一个底层得不能再底层的爬虫，不添加任何框架的成分
	- 从[中国银行官网](http://www.boc.cn/sourcedb/whpj/)获得每日更新的外汇牌价
	- 使用 iframe 实现了前端页面和服务器的交互
	- 实现了常用及不常用的 12 种货币之间的汇率兑换


## 4. 参考资料
- [Deploy a Java Web Application That Launches with Jetty Runner](https://devcenter.heroku.com/articles/deploy-a-java-web-application-that-launches-with-jetty-runner)
- [heroku 部署 java web 项目 —— Vino007 的 CSDN 博客](https://blog.csdn.net/helloxiaoyueyue/article/details/45507329)
- [Heroku 简明教程 —— hoptop 的简书](https://www.jianshu.com/p/638e0f6f1d2a)



