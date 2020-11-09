---
layout: post
title:  "使用Gitpage和Jekyll搭建个人博客"
date:   2020-11-07 12:00:25 +0800
categories: jekyll update
---
# 如何开始搭建个人博客
工作生活中经常会遇到一些需要记录下来的东西，将搭建的过程记录下来以备和我遇到相同问题的同学参考。
本人使用Mac，搭建过程中主要使用到的工具如下：
* Github账户 + GitPage配置
* Jekyll / Hexo （生成静态HTML页面）
* 七牛云账户 + qshell（用于存储Blog重的图片）
* Alfred + Powerpack + qimage-mac（用于本地截图或文档自动上传七牛云对象存储，Windows可使用AutoHotKey）
* vscode + Markdown All in One + Markdown Preview Github Styling (用于本地编辑markdown及实时预览)
* Snipaste 或其他截图工具


## 1. GitHub及相关配置
### 1-1 创建repository
登陆Github，并新建一个repository，这里需要注意一下的是需要按照`username.github.io`格式来创建repository，这样后面才能够使用`https://username.github.io`这样的URL来访问GitPage。

![img](http://sjdt.online/img/create_github_repo.png)

### 1-2 修改repository的Setting
找到Repository的Setting tab页面，如下图：
![img](http://sjdt.online/img/20201108_github_setting.png)


向下一直拖动到GitHub Pages页面，启用GitPages，这里可以设置GitPages使用哪个分支，修改显示的主题风格，以及修改为自定义的域名。

![img](http://sjdt.online/img/20201108_github_page_setting.png)

至此，基于GitPages的一个免费个人博客就已经搭建成功了，我们在代码中可以直接编辑html，然后访问username.github.io即可看到个人博客网站的显示结果。
比如将以下代码保存成index.html放到repository的根目录：
```html
<!DOCTYPE HTML>
<html>
	<head>
	<title>m00nwhite</title>
	</head>
	<body>
		welcome to m00nwhite.github.io! 
	</body>
</html>
```
然后访问`username.github.io` 即可看到显示结果

![img](http://sjdt.online/img/20201108_github_test_index.png)



## 2.Jekyll及相关配置
Jekyll是GitHub官方指定的免费Blog生成框架，也可以使用Hexo，看个人喜好，Jekyll和GitPage的契合度更高一些，但是生成静态页面的速度方面不如Hexo迅速，使用方面较Hexo也略微复杂一些，这里使用Jekyll，单纯的是因为想学习一下。

官方网址：[Jekyll](https://jekyllrb.com/)

### 2-1 jekyll的安装
先来看一下官方安装教程，简单得只有一张图：

![](http://sjdt.online/img/20201108_jekyll_install.png)

需要安装bundler，gem
```bash
# 安装bundler和gem
gem install bundler jekyll

# 使用jekyll新建一个博客项目，m00nwhite请替换成你喜欢的名字
jekyll new m00nwhite

# 进入到jekyll为你创建的文件夹，并启动jekyll的本地服务
cd m00nwhite
bundle exec jekyll serve
```

执行了上面的命令之后，jekyll就为你在本地4000端口创建了一个博客服务。
![img](http://sjdt.online/img/20201108_jekyll_local_server.png)

使用浏览器访问一下，可以看到Jekyll为我们生成的页面：
![img](http://sjdt.online/img/20201108_local_jekyll_server_started.png)




