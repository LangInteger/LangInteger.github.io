# 博客源代码存档

## 使用步骤

- hexo clean
- hexo generate
- hexo server

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
