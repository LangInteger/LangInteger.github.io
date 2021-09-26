---
title: PlantUML Workflow Hand by Hand
date: 2021-09-27 23:59:59
tags: [PlantUML]
---

接触 PlantUML 好一阵子了，一直以来也经常向周围的朋友安利。每次都会丢出去一堆链接和教程，于是想着整理整理,这样下次再安利的时候就直接把博客甩出去就好，便有了这篇手摸手教程，讲一讲日常工作中使用 PlantUML 的方法。PlantUML 基础语法相关内容在本文中先按下不表，大家可以自行前往[官网](https://plantuml.com/zh/)或者 [REAL WORLD PlantUML](https://real-world-plantuml.com/) 学习。

<!--more-->

作为一个打工人，难免有时要向他人介绍某个流程、讲一讲数据库的设计等。这种时候，万语千言往往不如一张图片。我曾试图用 [DrawIO](https://app.diagrams.net/)、[ProcessOn](https://www.processon.com/) 等工具来表达自己的想法，但是作为一个手残党兼一丢丢完美主义者，经常因为两个矩形的相对位置、某条线的家长里短而纠结半天，耗费精力不说，最后出来的图片也不尽如人意。而 PlantUML 的出现，完美解决了我心中画图这项工作应该支持而很难解决的痛点：

- 1 画图在可以天马行空地发挥之外，应该是可以有底线的。按部就班地付出就能得到一个平均水平不低且有风格的作品
- 2 图片是可以像纯文本一样，结合 Git 等工具进行版本化变更追溯的，给人以稳稳的安全感

## 1 PlantUML 工作流

有朋友可能会疑惑，不就是画图吗，怎么扯出「工作流」来了。殊不知画图也是一个系统性工程，涉及摆盘、研磨、勾线、上色、浸染、风干等等工序，自然是有严格顺序的。下面介绍一下半导体时代一个版本化患者的 PlantUML 画图工作流。

### 1.1 本地创作

本地电脑上进行基于 PlantUML 的图片创作的时候，建议使用 [Visual Studio Code](https://code.visualstudio.com/download) （一款轻便的文本编辑器）搭配 [PlantUML 插件](https://marketplace.visualstudio.com/items?itemName=jebbs.plantuml)，即可快速地进行「预览-修改-预览」的循环，不断修改直到生成图片能够正确、完善地表达心之所想。

![daily process, if cannot see, please check your network](https://raw.githubusercontent.com/LangInteger/learning/master/draw/plantuml/daily-process.gif)

当创作结束，或者想中途小憩后续再来完善的时候，通过 [git](https://git-scm.com/downloads) 将纯文本的 `.puml` 文件保存到本地 git 仓库并推送到远端（本文以 Github 为例）进行备份。

### 1.2 成果部署

完成创作之后，`.puml` 文件已经充实了内容。然鹅绘图的目的是为了在其他地方进行展示，比如要放到 wiki 文档中，某个需求说明里，或者像我今天一样，是为了放到博客。怎么放？就像茴字有三种写法，放也有很多种方式。

最简单的方式就是截图并粘贴。然鹅截图的做法明显戳中了之前提到的痛点，违背了革命的初心。试想如果后续此 `.puml` 文档被修改了，作为文档和图片二者母亲的我们是不是又要转过身去修改文档呢？Java 代码都可以一次书写到处运行，我们的绘图大业是否也可以做到一次修改，遍地开花呢？答案是肯定的。

上述 1.1 小节中创作完成的示例 `.puml` 文件被推送到了 [Github 仓库](https://github.com/LangInteger/learning/blob/master/draw/plantuml/20210916-test.puml)，只需要获取到该文件对应的 `githubusercontent`（点击 Github 网页中的 RAW 按钮皆可获得地址），借助 `plantuml proxy` [渲染服务](https://www.plantuml.com/plantuml/proxy)即可通过下面的 URL 拼接方式通过一个 `HTTP GET` 请求得到渲染后的结果图片：

```text
https://www.plantuml.com/plantuml/proxy?cache=no&src=path-to-your-github-user-raw-content
```

示例文件获取地址为（在浏览器中打开即可看到渲染后的图片）：

```text
https://www.plantuml.com/plantuml/proxy?cache=no&src=https://raw.githubusercontent.com/LangInteger/learning/master/draw/plantuml/20210916-test.puml
```

最后再结合 markdown 的 [image 语法](https://www.markdownguide.org/basic-syntax/#images) `![description](url)`，就可以在任意 markdown 文件（我已经使用 markdown 书写自己的所有文档，因此在我这里文档与 markdown 等同，强烈建议还在 word 等工具中挣扎的小伙伴早日脱离苦海）中展示绘图成果。比如下面的图片就是用上面的链接在你打开本 markdown 文档的过程中实时渲染出来的。

![plantuml demo, if cannot see, please check your network](https://www.plantuml.com/plantuml/proxy?cache=no&amp;src=https://raw.githubusercontent.com/LangInteger/learning/master/draw/plantuml/20210916-test.puml)

### 1.3 持续发布

经过上面的历程之后，相信你已经发现，如果我们要对图片进行一些修改，只需要修改本地的 `.puml` 文件，推送至远程的 git 仓库，相应的 `githubusercontent` 中的内容也会发生变更，继而引用了这些内容的文档中渲染出来的图片也会响应变更。看起来我们只做了更改图片的事情，实际上所有文档都会在重新打开时完成更新。

## 2 常见问题

### 2.1 Graphviz Needed

复杂图形在 vscode 本地渲染需要安装 [graphviz](https://graphviz.org/download/)，不然会无法渲染而报错。不同操作系统下的安装方法见[链接]((https://graphviz.org/download/))。

### 2.2 `.puml` 文件变更后不生效问题

一般是由于缓存引起，无论是浏览器还是 vscode 都会对 HTTP 请求获取到的资源按一定逻辑进行缓存，对于 GET 得到的图片资源，更是看起来就长得超像需要缓存那种。所以请刷新（甚至强制刷新）你的软件后再看看呢。

### 2.3 PlantUml Proxy 字体渲染问题

默认情况下，你会发现 `plantuml proxy` 的渲染存在对中文的支持并不友好的明显问题。早年间我一直未能找到解决办法故在图片中只使用英文，后来参考这个 [plantuml-server issue](https://github.com/plantuml/plantuml-server/issues/43)  发现通过下面两个步骤可以解决此问题：

- 1 访问 [plantuml proxy](http://www.plantuml.com/plantuml/uml/SoWkIImgAStDuSh9B2v9oyyhKNYoTy7JfNkv75BpKe3Y0000) 使用`listfont 你好`打印出该服务器支持的所有字体打印汉字的情况
- 2 选择其中观感比较好的字体，将字体指定在 `.puml` 文件中，如 `skinparam defaultFontName AR PL UKai CN`

上述第 1.2 节中的示例图片也使用了这项技术。

### 2.4 数据保密问题

Github 仓库分 `private` 和 `public`。`public` 仓库的 `raw user content` 链接是一直有效的，但 `private` 仓库生成的 `raw user content` 链接是包含一个访问 token 的。这个 token 的默认有效期并不长，建议替换成个人的永久有效的有读权限的 `access token`，相关讨论可以在[这个 Stackoverflow](https://stackoverflow.com/questions/38132908/do-github-raw-urls-expire) 讨论中查看。

对于很多携带工作或者项目细节的场景，使用 `public` 仓库存储 `.puml` 文件是不合适的（甚至 `private` 也不一定合适），请谨慎考量。
