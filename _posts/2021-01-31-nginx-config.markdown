---
layout: post
title:  "Nginx虚拟主机的多域名配置"
date:   2021-01-31 21:29:37 +0800
categories: nginx django php-fpm fastcgi python php
---

本文的目的是使用Nginx的虚拟主机功能在同一台服务器上配置多个域名，多域名之间可以使用不同架构，比如同时使用php的thinkphp或者Laravel和python的Django。
主要架构思想为使用Nginx作为反向代理，配合php-fpm和fastcgi作为上游服务端提供服务。

![](http://yinyang.space/img/20210131_nginx.png)


## 1. 目录说明

|序号|目录|用途|
|:----:|----|----|
|1|/etc/nginx/nginx.conf   |Nginx主配置文件|
|2|/etc/nginx/vhosts/    |Nginx虚拟主机配置文件存放目录|
|3|/etc/nginx/vhosts/aaa.com.conf    |网站aaa.com的虚拟主机配置文件存放目录|
|4|/etc/nginx/vhosts/bbb.com.conf    |网站bbb.com的虚拟主机配置文件存放目录|
|5|/usr/share/nginx/html/aaa.com/ |网站aaa.com的文件存放目录|
|6|/usr/share/nginx/html/bbb.com/ |网站bbb.com的文件存放目录|
|7|/etc/php-fpm.d/www.conf|php-fpm配置文件|



```




```
## 2. Nginx配置
### 2.1 修改Nginx主配置文件 
修改 `/etc/nginx/nginx.conf` 
```bash
http {
    include /etc/nginx/conf.d/*.conf;
    # 将所有虚拟主机的配置文件都放在vhosts文件夹中
    include /etc/nginx/vhosts/*.conf; 

    # 注释掉Nginx默认的server部分的服务器配置
    #server{
    #    listen 80 default_server;
    #    ...
    #}
}
```

### 2.2 修改php版的虚拟主机配置

`/etc/nginx/vhosts/aaa.com.conf`:
```bash
server {
    listen       80;
    server_name  aaa.com www.aaa.com;
    #charset utf-8;
    access_log  /usr/share/nginx/html/aaa.com/log/host.access.log;
    error_log   /usr/share/nginx/html/aaa.com/log/error.log;
    # gzip off;
    root        /usr/share/nginx/html/aaa.com/public;
    index       index.php index.html index.htm;
    location / {
        if (!-e $request_filename) {
           rewrite  ^/(.*)$  /index.php/$1  last;
           break;
        }
    }
    location ~ .*\.(gif|jpg|jpeg|png|bmp|swf)$ {
        expires 100d;
    }
    location ~ .*\.(js|css)?$ {
        expires 30d;
    }
    #error_page  404              /404.html;
    # redirect server error pages to the static page /50x.html
    #
    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   html;
    }
    # pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
    #
    location ~ \.php(/|$) {
        fastcgi_pass   127.0.0.1:9000;
        fastcgi_index  index.php;
        include        /etc/nginx/fastcgi.conf;
        set $fastcgi_script_name2 $fastcgi_script_name;
        if ($fastcgi_script_name ~ "^(.+\.php)(/.+)$") {
            set $fastcgi_script_name2 $1;
            set $path_info $2;
        }
        fastcgi_param   PATH_INFO $path_info;
        fastcgi_param   SCRIPT_FILENAME   /usr/share/nginx/html/aaa.com/public/$fastcgi_script_name2;
        fastcgi_param   SCRIPT_NAME   $fastcgi_script_name2;
    }
}
```
### 2.3 配置python虚拟环境
使用virtualenv和virtualenvwrapper来新建和管理虚拟环境，相关命令如下：
```bash
# 安装
pip3 install virtualenvwrapper
# 安装好后需要将下面内容添加至~/.bashrc中
export WORKON_HOME=~/Env
source /usr/local/bin/virtualenvwrapper.sh
export LD_LIBRARY_PATH="/usr/local/lib"
export PATH=$PATH:/usr/local/python3/bin/

# 新建虚拟环境
mkvirtualenv my_env

# 切换至虚拟环境
workon my_env

# 退出虚拟环境
deactivate

# 删除虚拟环境
rmvirtualenv my_env

# 列出虚拟环境
lsvirtualenv
```


### 2.4 修改Django版的虚拟主机配置
`/etc/nginx/vhosts/bbb.com.conf`

```bash
upstream hello{
    server unix:///usr/share/nginx/html/hello/hello.sock;
}

server {
    listen      80;
    server_name bbb.com www.bbb.com;
    charset     utf-8;
    # 发送所有非静态请求至Django服务器
    location / {
        uwsgi_pass hello;
        include /etc/nginx/uwsgi_params;
        # root   html/moonwhite.design;
        # index  index.html index.htm index.php;
    }
}
```

## 3 php-fpm配置
修改`/etc/php-fpm.d/www.conf` 文件
```bash
listen = 127.0.0.1:9000
listen.allowed_clients = 127.0.0.1
```

* php-fpm启动命令：`php-fpm`
* php-fpm停止命令：`ps -ef|grep php-fpm|grep master|awk '{print $2}'|xargs kill -QUIT`


## 4 配置使用uwsgi

命令行方式：`uwsgi --http :4000 --module hello.wsgi --virtualenv=/root/Env/mwd`


配置文件方式：`/usr/share/nginx/html/hello/hello.ini`
```ini
[uwsgi]

# Django 相关配置
# 必须为绝对路径
# 项目的路径
chdir        = /usr/share/nginx/html/hello
# Django 的wsgi文件
module       = hello.wsgi
# python 虚拟环境的路径
home         = /root/Env/mwd

# 通讯方式：http
#http         = :4000

# 进程相关设置
# 主进程
master       = true
# 最大数量的工作进程
processes    = 10
# 通讯方式：socket
# socket 文件路径
socket       = /usr/share/nginx/html/hello/hello.sock
# socket 权限
chomd-socket = 666
# 退出的时候是否清理环境
vacuum       = true
```
配置好之后就可以使用`uwsgi --ini hello.ini`来启动了。

停止命令：`wsgi| grep -v grep |awk '{print $2}'|xargs kill -9`

这里需要注意的是uwsgi不要安装在虚拟环境，要安装在系统python环境中。
而Django和相关项目依赖要安装在python虚拟环境中。





