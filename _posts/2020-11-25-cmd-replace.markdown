---
layout: post
title:  "一些常用的linux命令"
date:   2020-11-25 03:41:26 +0800
categories: Linux
---


## 批量替换
批量替换`sjdt.online/img`为`yinyang.space/img`的方法。

```bash
perl -pi -e 's|sjdt.online/img|yinyang.space/img|g' `find ./ -type f`
```
