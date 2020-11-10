---
layout: post
title:  "使用Gitpage和Jekyll搭建个人博客"
date:   2020-11-07 12:00:25 +0800
categories: jekyll update
---
工作生活中经常会遇到一些需要记录下来的东西，设想是本地编写markdown文档，文档中的各种图片资源会随时使用截图工具或者图片文件，使用Alfred或者AutoHotKey自动将图片或者剪贴板中的截图内容上传至七牛云图床，并返回markdown格式的图片链接，本地编写好之后git push到GitHub上面，使用GitPages自动生成博客。
将搭建的过程记录下来以备和我有相同需求或者遇到相同问题的同学参考。
本人使用Mac，搭建过程也以Mac过程为主，主要使用到的工具如下：
* Github账户 + GitPage配置
* Jekyll / Hexo （生成静态HTML页面）
* 七牛云账户 + qshell（用于存储Blog重的图片）
* Alfred + Powerpack + qimage-mac（用于本地截图或文档自动上传七牛云对象存储，Windows可使用AutoHotKey）
* vscode + Markdown All in One + Markdown Preview Github Styling (用于本地编辑markdown及实时预览)
* Snipaste 或其他截图工具
* 一个免费或收费的域名


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
Jekyll是一个的免费Blog生成框架，可以运行在GitHub Pages上，详细的使用教程请参考 [官方文档](http://jekyllcn.com/docs/home/)。 也可以使用Hexo，看个人喜好，Jekyll和GitPage的契合度更高一些，但是生成静态页面的速度方面不如Hexo迅速，使用方面较Hexo也略微复杂一些，这里使用Jekyll，单纯的是因为想学习一下。

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


## 3 图片配置
其实上面两步完成之后，对于简单的博客来说应该就基本够用了，但是对于追求效率的重度使用者来说还需要优化一下，比如贴图的过程。一张一张手工编辑链接地址并且上传的话未免效率低下，体验不是很友好。于是考虑使用七牛云图床，一来可以提高效率，二来可以使用CDN加速提高访问速度。

### 3-1 七牛云配置
需要注册七牛云账户并登陆至管理控制台，添加对象存储。

![img](http://sjdt.online/img/20201110_qiniu_new_ods.png)


### 3-2 安装及配置qshell

创建完存储空间之后，我们就可以使用七牛提供的管理控制台来上传和管理我们的图片了。也可以使用客户端，这里选择使用七牛提供的命令行工具（qshell）来方便地上传和使用图片。

官方安装链接在七牛的：[开发者中心](https://developer.qiniu.com/kodo/tools/1302/qshell)
下载对应平台的qshell并安装即可。

一些需要鉴权的qshell命令需要先设置好AK（`AccessKey`）和SK(`SecretKey`)，这两个Key在七牛管理控制台右侧的密钥管理中可以找到。
![](http://sjdt.online/img/20201110_qiniu_miyao.png)



![img](http://sjdt.online/img/20201110_qiniu_aksk.png)

然后使用下面的命令设置好qshell的AK和SK，这样我们就可以使用Alfred创建Workflow来调用qshell自动上传图片了。
```
qshell account ak sk name
```

其他qshell的使用请参考[官方文档](https://developer.qiniu.com/kodo/tools/1302/qshell)，这里不再赘述。


### 3-3 配置Alfred的workflow

这里使用[qimage-mac](https://github.com/jiwenxing/qimage-mac)
详细的教程请参考[使用 Alfred 在 markdown 中愉快的贴图](https://jverson.com/2017/04/28/alfred-qiniu-upload/)

导入workflow之后需要修改一下热键
![](http://sjdt.online/img/20201110_qiniu_workflow_hotkey.png)

修改一下参数配置，设置七牛的AK，SK和bucket等参数。
![img](http://sjdt.online/img/20201110_qiniu_workflow_config.png)

![](http://sjdt.online/img/20201110_qiniu_workflow_setting.png)

这里在执行的时候报错了，调试发现设置qshell账户的shell命令行参数数量不对，因为之前已经设置过了，这里就直接注释掉了，速度还能快一些。
![](http://sjdt.online/img/20201110_qiniu_uploadworkflow.png)

最后，将GitHub上的仓库克隆到本地，修改之后再push就可以直接更新博客内容了。
```bash
git clone git@github.com:username/username.github.io.git
# 修改markdown文档
git commit -m "your comment"
git push 
```

本地修改可以使用`vscode`或者`typora`，`vscode`需要安装`Markdown All in One` 和 `Markdown Preview Github Styling`两个插件，可以在编辑markdown文件的时候实时生成预览效果。

## 4. 一些问题
搭建过程中并不是一帆风顺的，难免遇到一些问题
### 4.1 问题1.GitPage上面七牛的图片显示不出。
原因：GitPage不绑定域名时默认使用https方式提供服务，而七牛云提供的图片外链是http的。
解决方法：GitPage使用自定义域名，并将服务方式修改为http，GitPage和七牛云都修改为Https应该也可以，留待以后验证。
首先申请一个域名，这里选择腾讯云的域名。然后在腾讯云的管理控制台中将域名的CNAME指向修改为GitPage的`username.github.io`

![](http://sjdt.online/img/20201110_tx_domain_setting.png)

CNAME修改后一般需要十分钟左右才能生效
![](http://sjdt.online/img/20201110_tx_domain_cname.png)

在GitPages的setting中也将域名修改为自定义域名
![](http://sjdt.online/img/20201110_gitpage_custom_domain.png)

另外，由于七牛的测试域名只能使用30天，所以这里把七牛云空间也一并修改为自定义域名，修改方式也是在腾讯云的管理控制台里面把域名的CNAME修改为七牛云提供的CNAME即可。

![](http://sjdt.online/img/20201110_qiniu_domain_cname.png)

