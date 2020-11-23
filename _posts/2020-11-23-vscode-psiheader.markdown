---
layout: post
title:  "vscode插件使用系列：1.psioniq File Header自动添加文件头"
date:   2020-11-23 09:46:26 +0800
categories: vscode
---

## 安装
使用vscode时经常需要重复性插入相同的文件头代码，或者Jekyll这种要求的固定格式文件头。使用`psioniq File Header`可以方便地满足这一需求，而且可以根据不同类型的文件设置生成不同的文件头内容和格式。

<kbd>command</kbd> + <kbd>shift</kbd> + <kbd>P</kbd> 调出命令面板找到`Extensions：Install Extensions` ，或者<kbd>command</kbd> + <kbd>shift</kbd> + <kbd>X</kbd>后在左侧切换到应用商店，搜索`psioniq File Header`，找到后安装即可


## 设置
<kbd>command</kbd> + <kbd>shift</kbd> + <kbd>P</kbd> 打开命令面板后输入settings，选择打开设置，打开`settings.json`文件
![](http://sjdt.online/img/20201123_vscode_psi1.png)

在`settings.json`中添加如下内容后保存：
```json
"psi-header.config": {
        "forceToTop": true
    },
    "psi-header.changes-tracking": {
        "isActive": true,
        "modAuthor": "Modified By  : ",
        "modDate"  : "Date Modified: ",
        "modDateFormat": "date",
        "include": [],
        "exclude": [
            "markdown",
            "json"
        ]
    },
    "psi-header.license-text": [
        "Just have a little faith!"
    ],
    "psi-header.variables": [
        ["company", "MoonWhite inc."],
        ["author", "mooonwhite"],
        ["authoremail", "moonwh173@gmail.com"]
    ],
    "psi-header.lang-config": [
        {
            "language": "python",
            "begin": "###",
            "prefix": "# ",
            "end" : "###",
            "blankLinesAfter": 0,
            "beforeHeader": [
                "#!/usr/bin/env python3",
                "# -*- coding:utf-8 -*-"
            ]
        },
        {
            "language": "markdown",
            "begin": "---",
            "prefix": "",
            "end": "---",
            "blankLinesAfter": 2,
            "forceToTop": true
        },
        {
            "language": "javascript",
            "begin": "/**",
            "prefix": " * ",
            "end": " */",
            "blankLinesAfter": 2,
            "forceToTop": false
        }
    ],
    "psi-header.templates": [
        {
            "language": "c",
            "template": [
                "File: <<filepath>>",
                "Created Date: <<filecreated('YYYY-MM-DD HH:mm:ss')>>",
                "Author: <<author>>",
                "-----",
                "Last Modified: <<dateformat('YYYY-MM-DD HH:mm:ss')>>",
                "Modified By: ",
                "-----",
                "Copyright (c) <<year>> <<company>>",
                "",
                "<<licensetext>>",
                "-----",
                "HISTORY:",
                "Date      \tBy\tComments",
                "----------\t---\t----------------------------------------------------------"
            ],
            "changeLogCaption": "HISTORY:",
            "changeLogHeaderLineCount": 2,
            "changeLogEntryTemplate": [
                "<<dateformat('YYYY-MM-DD')>>\t<<initials>>\t"
            ]
        },
        {
            "language": "markdown",
            "template": [
                "layout: post",
                "title:  \"title\"",
                "date:   <<filecreated('YYYY-MM-DD hh:mm:ss')>> +0800",
                "categories: web"
            ]
        },
        {
            "language": "javascript",
            "template": [
                "File: <<filepath>>",
                "Created Date: <<filecreated('dddd, MMMM Do YYYY, h:mm:ss a')>>",
                "Author: <<author>>",
                "-----",
                "Last Modified: ",
                "Modified By: ",
                "-----",
                "Copyright (c) <<year>> <<company>>",
                "------------------------------------",
                "Javascript will save your soul!"
            ]
        },
        {
            "language": "typescript",
            "mapTo": "javascript"
        }
    ]
```

效果：新建一个markdown文件，然后使用热键<kbd>option</kbd> + <kbd>contrl</kbd> + <kbd>H</kbd> 来自动添加文件头
![](http://sjdt.online/img/20201123_spiheader.gif)


