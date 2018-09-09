---
title: 条条大路通罗马 —— Java 路径漫谈
date: 2018-05-20 21:54:35
reward: true
toc: true
tags: 
	- Java
---

编写 Java 程序，无论是 Java EE 还是 SE ，和各种程序外资源打交道都蛮多的。本文对 Java 程序中的路径问题进行一定探索，帮助 Javaer 不迷路。

<!--more-->

## 1. Java SE 中的文件路径

>System.getProperty("user.dir") = E:\CodeRepository\java\PathTest
file.getAbsolutePath() = E:\CodeRepository\java\PathTest\target.txt

以上输出结果在 IDEA 中得到，容易让我们误以为当前 Module 的路径就是默认的 user.dir。实际上，这个系统属性在 IDEA 中可以设置，如我的电脑中设置为 $MODULE_DIR$，所以以上结果就很正常了。为了进一步说明，我在 Desktop 下放置了一个拥有相同代码段的 Java 文件并编译运行，得到如下结果：

>file.getAbsolutePath() = C:\Users\Rebecca\Desktop\target.txt
System.getProperty("user.dir") = C:\Users\Rebecca\Desktop

可以看到，这时候工作目录直接变成了桌面。
也就是说，我们常说的相对路径所指的就是 user.dir 所代表的路径，我们的程序中所有的相对路径即是相对于这个路径的。这点在 Java web 项目中仍然是适用的。

## 2. Java web 中的相对路径和绝对路径
由于 web 项目被部署在服务器上（如 Tomcat ），我们很多时候会被相对路径和绝对路径搅糊。事实上，程序运行本质上永远是使用绝对路径来寻找资源，所谓的相对路径，都要经过 API 在底层帮助我们构建绝对路径。

要使用相对路径，需要搞明白web 程序中默认的相对路径到底是哪儿？如上文所言，所谓的相对路径相对的即是 user.dir 这个路径。在 Servlet 中输出 user.dir 可以得到

>System.getProperty("user.dir") = E:\CodeRepository\apache-tomcat-8.5.24\bin

即 Tomcat 的启动文件所在目录成为了我们的默认相对路径的根目录。这是因为我们的 web 程序实际上运行在 Tomcat 下。一般情况下，Tomcat 文件夹下的 webapps 文件夹是我们的 web 应用放置的地方（这里的 war 包也会在服务器启动时自动解压），但是我们一般会通过修改配置文件进行虚拟目录映射使得另外的物理路径下的 web 应用也能运行。

在这种虚拟目录映射的情况下，通过默认的 Tomcat 的 bin 目录再去修修补补拿到 webapps 目录就不太能够应付实际情况了，所以服务器上很多时候需要采用绝对路径来获取资源，主要有以下两种方法：

- 采用 Servlet 相关类的 API 来获得

>getServletContext().getRealPath(url)

以上方法返回任意 url 相对当前应用在服务器上位置的地址。 getServletContext() 方法在 HttpServlet 的父抽象类 GenericServlet 类中，而它又通过 ServletConfig 对象拿到 ServletContex 对象，再由 getRealPath() 方法拿到给定的参数虚拟路径的真实路径。这个路径会与运行此 Servelt 的不同硬件、操作系统自适应。

- 根据类的加载机制
当在非类 Servlet对象中，拿不到 ServletContext对象，要获得真实路径，可以通过如下方法：

>XX类.class.geiClassLoader().getResource("");

这样就拿到了 WEB-INF 下的 classes 文件夹的真实路径，经过适当处理，就可以拿到 web 应用的路径。比如：
>XX类.class.getClassLoader().getResource("../../a.txt").getPath();

就拿到了 classes 的父目录的父目录中（即 web 目录）的 a.txt 这个文件。

## 3. Java web 不同 web 资源间跳转的路径设置
上文所述部署在服务器上的 web 应用相对路径功能如此孱弱，那么相对路径毫就没点用吗？显然不是的，当底层 API 能够帮助我们自动补全绝对路径的时候，相对路径也就有了用武之地。不过这时候的相对路径和上面的 user.dir 代表的相对路径已经发生了变化，下面我们谈论的相对路径变成了真正相对于服务器、web 应用的相对路径。


例如当请求转发 getRequestDispather 或者 重定向 sendRedirect 时：

>以 "/" 开头的路径表示相对于当前 web 应用的根目录，通常用于重定向中，因为此时需要浏览器再次访问服务器资源
以非 "/" 开头的路径表示相对于当前访问的url资源的同级目录（如 Servlet 的父目录），通常用于请求转发，因为其他的处理器基本上和当前处理器都在一个目录下

另外，html 页面中的表单提交也涉及 action 属性中的路径问题：

>以 "/" 开头的路径表示相对于当前服务器的根目录，即为当前 web 应用根目录的父目录
以非 "/" 开头的路径表示相对于当前访问的url资源的同级目录

## 4. 推荐写法

### 4.1 表单提交、前端资源请求地址

> 由于是浏览器使用的地址，所以加上应用名
> <form action="${pageContext.request.contextPath}/pages/login.html" method=”get”>

### 4.2 请求转发、请求包含

> 由于在 Tomcat 容器的 web 应用内部，所以不用写应用名。
> request.getRequestDispatcher("/servlet/ServletA");
> request.getRequestDispatcher("/myapp/index.jsp");

> 前端转发包含标签也同理：
> <jsp:forward page="/servlet/servletB"></jsp:forward>

### 4.3 response 报文中的刷新字段

> 由于是浏览器使用的地址，所以加上应用名
> response.setHeader("refresh", "2;url='/myapp/index.html'");

### 4.3 response 报文中的重定向字段

> 由于是浏览器使用的地址，所以加上应用名
> response.sendRedirect("/myapp/indexl.jsp");

> response.setStatus(307);
> respongse.setHeader("Location", "/myapp/index.jsp");

