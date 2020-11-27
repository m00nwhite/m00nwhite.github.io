---
layout: post
title:  "Mac下不同版本Python"
date:   2020-11-27 10:44:58 +0800
categories: mac python
---

官网下载升级安装了Python3.9，之前brew安装过python3.8，Mac自带了2.7，Pycharm安装过3.7，各种情况的默认目录如下：

|来源|python安装路径|
|----|---|
|系统默认（2.7）|/System/Library/Frameworks/Python.framework/Versions/2.x|
|pycharm（3.7）|/Users/username/PycharmProjects/venv/python3.7|
|brew（3.8）|/usr/local/Cellar/python@3.8/3.8.5/bin/|
|官网pkg安装（3.9）|/Library/Frameworks/Python.framework/Versions/3.x|

写入环境变量
```bash
vi ~/.bash_provile
export PATH=$PATH:/usr/local/bin/python3
```

preference -> project Interpreter -> 右侧的Add按钮 
添加System Interpreter
![](http://yinyang.space/img/20201121_pycharm2.png)

添加Pipenv Environment
![](http://yinyang.space/img/20201127_pycharm1.png)
