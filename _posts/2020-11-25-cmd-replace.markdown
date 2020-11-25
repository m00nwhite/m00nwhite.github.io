---
layout: post
title:  "批量替换多个文件中的字符串"
date:   2020-11-25 03:41:26 +0800
categories: Linux
---

批量替换`sjdt.online/img`为`yinyang.space/img`的方法。

## 使用perl
```bash
perl -pi -e 's|sjdt.online/img|yinyang.space/img|g' `find ./ -type f`
```

## 使用sed
```bash

```