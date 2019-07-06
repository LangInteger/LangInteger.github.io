# 博客源代码存档

## 使用步骤

### 1 推送博客内容更新

- hexo clean 清理
- hexo generate 生成
- hexo server 本地部署
- hexo deploy 远程部署

### 2 保存源文件信息

方便换电脑，所以在分支 source-file 保存源文件信息

- git add .
- git commit -m "xxx"
- git push

## 常见问题

### 1 hexo No layout: index.html

一般是因为选用的主题没有拉取下来，主题文件夹(如themes/yilia)是空白的，重新拉取即可，如使用以下命令拉取yilia主题到主题文件夹

- git clone https://github.com/litten/hexo-theme-yilia.git themes/yilia

### 2 原有目录消失

由于使用yilia主题，目录也是在该主题的配置文件中配置的，即需要定位到themes/yilia/_config.yml文件。配置目录示范：

```yml
menu:
  主页: /
  BOOKS: /books
  ENGLISH: /english
  CV: /CV
```

### 3 图片设置

三种图片为：

```yml
打赏图片weixin: /img/wechatpay.png
网站标签栏图片favicon: /img/avatarlang.png
头像avatar: /img/avatarlang.png
```

对应的存放路径是 `themes/yilia/source/img`

### 4 备份yilia配置文件

由于对 git 有些理解还不不到位，本地使用的 `themes/yilia` 主题文件夹无法腿上来。故在 `yilia_backup` 文件夹备份 yilia 相关配置。

- 切换新电脑时，需要将 `yilia_backup/yilia` 文件夹复制到 `themes/yilia` 文件夹
- 更新 `themes/yilia` 文件夹时，需要同步更新 `yilia_backup/yilia` 文件夹
- 实际生效的样式文件为 `themes/yilia` 文件夹中的主题
