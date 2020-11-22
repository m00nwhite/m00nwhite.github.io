---
layout: post
title:  "搭建本地Web开发环境"
date:   2020-11-12 21:57:25 +0800
categories: php web
---
# 1 MAMP 配置

首先配置MAMP的Hosts，在MAMP -> Main Window
![](http://sjdt.online/img/20201121_MAMP0.png)

这里保留默认配置
![](http://sjdt.online/img/20201121_MAMP1.png)

修改Apache默认的端口为80，Nginx为8000，MySQL为3316
![](http://sjdt.online/img/20201121_MAMP2.png)

这样基本的Apache+MySQL+PHP环境就配置好了。

# 2 PHPStorm 配置
phpstorm 中新建php project，项目文档位置选择刚刚MAMP配置的Document Root目录下:`/Applications/MAMP/htdocs/sjdt.online`
![](http://sjdt.online/img/20201121_phpstorm1.png)

选择：phpstorm -> Preference -> Build,Execution,Deployment -> Deployment，单击右侧的 + 加号新建一个服务器，类型选择In place，名字随便起，这里使用mamp
![](http://sjdt.online/img/20201121_mamp1.png)

在Connection Tab页中配置Web server URL为`http://localhost`
![](http://sjdt.online/img/20201121_mamp2.png)

在Mappings Tab页配置本地路径和远程路径之间的映射，这里选择将本地工程目录映射为远程的sjdt.online目录
![](http://sjdt.online/img/20201121_mamp3.png)

这样在phpstorm中就可以使用PHPStorm中的preview按钮快速在浏览器中预览页面效果了。
![](http://sjdt.online/img/20201121_mamp4.gif)

# 3 Apache 多域名配置
实际工作中经常会遇到需要同时开发多个项目或者在一个Host上配置多个域名的情况，使用VirtualHost配置可以很好的解决这个问题。

首先，修改本地/etc/hosts解析文件，添加如下内容：
```
127.0.0.1	localhost
127.0.0.1	sjdt.online.test
```

然后修改MAMP的Apache配置文件：`/Applications/MAMP/conf/apache/httpd.conf` ，找到Virtual hosts的配置的位置：

```bash
# Virtual hosts
#Include /Applications/MAMP/conf/apache/extra/httpd-vhosts.conf
```
去掉Include前面的注释，像这样，然后保存退出：
```bash
# Virtual hosts
Include /Applications/MAMP/conf/apache/extra/httpd-vhosts.conf
```
然后，编辑修改VirtualHosts配置文件：`/Applications/MAMP/conf/apache/extra/httpd-vhosts.conf`：
![](http://sjdt.online/img/20201121_apache1.png)


尽管显示virtual host已经生效了，但是实际上是不好用的，MAMP的Document Root一直指向了MAMP的htdoc根目录，不知道是MAMP的bug还是httpd配置有问题
![](http://sjdt.online/img/20201121_mamp6.png)

于是换个思路，使用MAMP的添加Hosts来解决开发环境多个域名的问题，实际生产上线使用VirtualHost。
在MAMP的Hosts界面中使用左下角的"+"加号按钮新建一个Host，Hostname输入sjdt.online.test
![](http://sjdt.online/img/20201121_mamp_host1.png)
修改DocumentRoot：`/Users/yiny/Sites/sjdt.online`
![](http://sjdt.online/img/20201121_mamp_host2.png)


phpstorm中新建项目，项目目录选择刚刚Apache中Document Root的位置`/Users/yiny/Sites/sjdt.online`
选择：phpstorm -> Preference -> Build,Execution,Deployment -> Deployment，单击右侧的 + 加号新建一个服务器mbp，Web server URL填写本地测试域名：http://sjdt.online.test

![](http://sjdt.online/img/20201121_mbp1.png)

效果：
![](http://sjdt.online/img/20201121_mbp2.gif)

