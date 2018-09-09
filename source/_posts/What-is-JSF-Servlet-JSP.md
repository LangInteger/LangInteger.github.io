---
title: JSF、Servlet和JSP的前世今生
date: 2018-04-29 15:49:56
toc: true
tags:
	- Translation
	- Java
---

JSP 和 Servlet 之间是何种关系？ JSP 本身是不是就是一种 Servlet ？ JSP 和 JSF 的联系间又蕴藏何种玄机？ JSF 是否如 ASP.NET-MVC 一样，是某种形式的 prebuild UI ？答案尽在译者[新番](https://stackoverflow.com/questions/2095397/what-is-the-difference-between-jsf-servlet-and-jsp)。
<!--more-->

## JSP(JavaServer Pages)
JSP 运行在服务器端，是一种 Java view technology ，允许程序员采用客户端语言（如 HTML, CSS, JavaScript 等）来编写模版文档。JSP 支持[ taglibs ](http://docs.oracle.com/javaee/5/tutorial/doc/bnann.html)，taglibs 由很多 Java 代码段组成，允许程序员动态控制网页流，如 [JSTL](https://stackoverflow.com/tags/jstl/info) 就是一种著名的 taglibs。 JSP 也支持 [Expression Language](https://stackoverflow.com/tags/el/info)，可搭配 taglibs 用于获取后端数据（通过页面、请求、session 和 application scops 的属性）。

当 JSP 第一次被请求或者当 web app 启动的时候， servlet 容器会把它编译成 [HttpServlet](https://docs.oracle.com/javaee/6/api/javax/servlet/http/HttpServlet.html) 的扩展类并在 web app 的生命周期中使用它。生成的源代码可以在服务器的工作目录下找到，如 Tomcat 的 /work 目录。在一次 JSP 请求中， servlet 容器会执行编译好的 JSP 类文件并将生成的输出文件（通常仅仅是 HTML/CSS/JS ）通过 web 服务器穿过整个网络发送到客户端并依次展示在网页浏览器中。

## Servlets
Servlet 是一个运行在服务器的 Java 应用程序编程接口 (API) ，它能够侦听 (intercept) 客户端发出的请求并回复。 HttpServlet 是其中一个著名的例子，它使用流行的 [HTTP methods](http://www.w3.org/Protocols/rfc2616/rfc2616-sec9.html) （如 GET 和 POST ）来提供获取 HTTP 请求报文的方法。 HttpServlet 可在 web.xml 中进行配置，用来侦听某种特定的 HTTP URL ，在 Java EE 6 中可还通过 @webServlet 注解来配置。

当 Serlet 被首次请求或者在 web app 的启动过程中， servlet 容器实例会生成一个 servlet 实例并在 web app 的整个生命周期中存活于内存。同一个 servlet 实例被用来处理匹配此 servlet URL pattern 的一切请求。可通过 [HttpServletRequest](https://docs.oracle.com/javaee/6/api/javax/servlet/http/HttpServletRequest.html) 来获得请求数据并可通过 [HttpServletResponse](https://docs.oracle.com/javaee/6/api/javax/servlet/http/HttpServletResponse.html) 来处理。

## JSF(JavaServer Faces)
JSF 是一个基于组件的模型-视图-控制器框架 (component based MVC framework) ，构建在 Servlet API 的顶层，可通过 taglibs 提供 [components](https://docs.oracle.com/javaee/6/tutorial/doc/bnarf.html) ，应用于 JSP 或其它基于 Java 的 view technology ，如 [Facelets](http://docs.oracle.com/javaee/6/tutorial/doc/giepx.html) 。 相比于 JSP ，Facelets 更适合 JSF。 Facelets 提供了更大容量的模版库 [templating capabilities](https://docs.oracle.com/javaee/6/tutorial/doc/giqxp.html) 如 [composite components](https://docs.oracle.com/javaee/6/tutorial/doc/giqzr.html) ,而 JSP 仅仅提供了 [<jsp:include>](http://java.sun.com/products/jsp/syntax/2.0/syntaxref2020.html#8828) ，导致当想要用单个组件替换一组重复组件的时候，程序员不得不用原生 Java 代码创建自定义组件（在 JSF 中这是一项不甚容易且无聊的工作）。从 JSF2.0 开始，为支持 Facelets ， JSP 被视为 (deprecated) 一种 view technology 。 

作为一种 MVC([Model-View-Controller](https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93controller)) 框架， JSF提供 [FacesServlet](http://docs.oracle.com/javaee/6/api/javax/faces/webapp/FacesServlet.html) 作为 sole-request-response 的 Controller。它将处理用户输入等所有模式化且乏味的 HTTP 请求/回应 工作从程序员手中拿走，并放到模型对象中，由模型对象调用方法并给予回复。最终，以一个 JSP 或者 Facelets(XHTML) 页面作为 View 和一个 JavaBean 类作为 Model 来结束。 JSF 组件用来将 view 和 model 捆绑在一起（就如 ASP.NET web control 所做的一样），而 FacesServlet 使用 JFS-component-tree 来完成所有工作。

## Reference/参考资料
- [Java EE web development, what skills do I need?](https://stackoverflow.com/questions/1958808/java-ee-web-development-where-do-i-start-and-what-skills-do-i-need)