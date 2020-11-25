---
layout: post
title:  "使用Alfred的workflow实现效率翻译"
date:   2020-11-10 20:57:25 +0800
categories: jekyll update
---


## 1. 下载并安装效率神器Alfred
关于Alfred的使用请参考[这里]()

## 2.下载有道词典的workflow
有道词典翻译的workflow，[传送门](https://github.com/wensonsmith/YoudaoTranslate)

## 3.有道智云配置
前往[有道智云](https://ai.youdao.com/#/)，注册账户并登陆控制台，创建自然语言翻译实例


![](http://yinyang.space/img/20201110_youdao_create_instance.png)

根据提示创建应用
![](http://yinyang.space/img/20201110_youdao_create_app.png)

填写应用信息
![](http://yinyang.space/img/20201110_youdao_create_app2.png)

创建成功后即可在页面上看到应用ID和应用密钥
![](http://yinyang.space/img/20201110_youdao_create_app_success.png)


将刚刚的应用ID和应用密钥设置到workflow的参数中：
![](http://yinyang.space/img/20201110_youdao_set_key.png)


效果预览:
![](http://yinyang.space/img/20201110_youdao_workflow.gif)

