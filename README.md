# 博客源代码存档

博客使用 [hexo 博客框架](https://hexo.io/)，使用 [yilia 主题](https://github.com/litten/hexo-theme-yilia)。

## 1 使用步骤

### 1.1 推送博客内容更新

- hexo clean 清理
- hexo generate 生成
- hexo server 本地部署
- hexo deploy 远程部署

本地查看效果时直接使用 `hexo server` 也会完成内容更改 generate 的工作。

### 1.2 保存源文件信息

方便换电脑，所以在分支 source-file 保存源文件信息。平时写博客在 source-file 分支操作即可。hexo 相关的命令会自动将生成的静态网页文件推送到 master 分支，source-file 分支的变更则需要手动推送上来。

- git add .
- git commit -m "xxx"
- git push

### 1.3 创建新文章

- hexo new "your-new-article-name"
- write article
- with guide 1.1 to deploy new blog

### 1.4 安装 hexo

- npm install hexo-cli -g --registry https://registry.npm.taobao.org/
- npm install --registry https://registry.npm.taobao.org/

### 1.5 添加图片

```shell
# add photos to cd ./blog_photos/photos with naming convention:
#   - yyyy-MM-dd_TOPIC_seq.png

cd ./blog_photos/
python3 ./tool.py
git status
git add .
git commit -m "feat: new photos"
git push
cd -

nvm use 12.22.12
hexo server

git status
git add .
git commit -m "feat: new photos"
git push

hexo clean
hexo generate
hexo deploy
```

## 2 常见问题

### 2.1 hexo No layout: index.html

一般是因为选用的主题没有拉取下来，主题文件夹(如 themes/yilia)是空白的，重新拉取即可，如使用以下命令拉取 yilia 主题到主题文件夹

- git clone https://github.com/litten/hexo-theme-yilia.git themes/yilia

### 2.2 原有目录消失

由于使用 yilia 主题，目录也是在该主题的配置文件中配置的，即需要定位到 themes/yilia/\_config.yml 文件。配置目录示范：

```yml
menu:
  主页: /
  Slides: /slides
  English: /english
  CV: /CV
```

### 2.3 图片设置

三种图片为：

```yml
打赏图片weixin: /img/wechatpay.png
网站标签栏图片favicon: /img/avatarlang.png
头像avatar: /img/avatarlang.png
```

对应的存放路径是 `themes/yilia/source/img`

### 2.4 备份 yilia 配置文件

由于对 git 有些理解还不不到位，本地使用的 `themes/yilia` 主题文件夹无法推上来。故在 `yilia_backup` 文件夹备份 yilia 相关配置。

- 切换新电脑时，需要将 `yilia_backup/yilia` 文件夹复制到 `themes/yilia` 文件夹
- 更新 `themes/yilia` 文件夹时，需要同步更新 `yilia_backup/yilia` 文件夹
- 实际生效的样式文件为 `themes/yilia` 文件夹中的主题

### 2.5 新电脑切换到编辑分支时使用 hexo 命令报错

报错内容为：

- ERROR Local hexo not found in xxx

在 hexo 添加到环境变量的前提下，在该路径执行 npm install 后即恢复正常。

### 2.6 hexo g 生成空白的 html 文档

原因是 node --version 版本 >= 14。使用[nvm](https://github.com/nvm-sh/nvm)来控制使用的 node 版本 (12.0.0 支持 m1 有问题)。

- 安装 nvm：curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.0/install.sh | bash
- restart terminal
- nvm install 12.22.12
- nvm use 12.22.12
- nvm 使用 proxy：ALL_PROXY=socks5://127.0.0.1:7891 nvm install 12.0.0
