---
layout: post
title:  "VSCode 中 snippets 的使用"
date:   2020-11-12 21:57:25 +0800
categories: php web
---

## 新建snippet

Code -> 首选项 -> 用户片段

![](http://sjdt.online/img/20201112_vscode_snippet_1.png)

之后Code为我们生成了一个`filename.code-snippets`的json文件，内容如下：

```json
{
	// Place your 全局 snippets here. Each snippet is defined under a snippet name and has a scope, prefix, body and 
	// description. Add comma separated ids of the languages where the snippet is applicable in the scope field. If scope 
	// is left empty or omitted, the snippet gets applied to all languages. The prefix is what is 
	// used to trigger the snippet and the body will be expanded and inserted. Possible variables are: 
	// $1, $2 for tab stops, $0 for the final cursor position, and ${1:label}, ${2:another} for placeholders. 
	// Placeholders with the same ids are connected.
	// Example:
	// "Print to console": {
	// 	"scope": "javascript,typescript",
	// 	"prefix": "log",
	// 	"body": [
	// 		"console.log('$1');",
	// 		"$2"
	// 	],
	// 	"description": "Log output to console"
	// }
}
```

snippets 语法：
```
prefix      :代码片段名字，即输入此名字就可以调用代码片段。
body        :这个是代码段的主体.需要编写的代码放在这里,　　　　　 
$1          :生成代码后光标的初始位置.
$2          :生成代码后光标的第二个位置,按tab键可进行快速切换,还可以有$3,$4,$5.....
${1,字符}    :生成代码后光标的初始位置(其中1表示光标开始的序号，字符表示生成代码后光标会直接选中字符。)
description :代码段描述,输入名字后编辑器显示的提示信息。
```
注：

* 如果没有description，默认提示信息是类似上图中Print to console一样的信息（即key值）
* 代码多行语句的以 `,` 隔开
* 每行代码需要用引号包裹住
* 字符串间如果值里包含特殊字符需要 \ 进行转义.


下面这些变量可以在snipates中使用:

```
TM_SELECTED_TEXT The currently selected text or the emptstring
TM_CURRENT_LINE The contents of the current line
TM_CURRENT_WORD The contents of the word under cursor othe empty string
TM_LINE_INDEX The zero-index based line number
TM_LINE_NUMBER The one-index based line number
TM_FILENAME The filename of the current document
TM_FILENAME_BASE The filename of the current documenwithout its extensions
TM_DIRECTORY The directory of the current document
TM_FILEPATH The full file path of the current document
CLIPBOARD The contents of your clipboard
WORKSPACE_NAME The name of the opened workspace or folder
```

当前日期和时间:
```
CURRENT_YEAR The current year
CURRENT_YEAR_SHORT The current year’s last two digits
CURRENT_MONTH The month as two digits (example ‘02’)
CURRENT_MONTH_NAME The full name of the month (example ‘July’)
CURRENT_MONTH_NAME_SHORT The short name of the month (example ‘Jul’)
CURRENT_DATE The day of the month
CURRENT_DAY_NAME The name of day (example ‘Monday’)
CURRENT_DAY_NAME_SHORT The short name of the day (example ‘Mon’)
CURRENT_HOUR The current hour in 24-hour clock format
CURRENT_MINUTE The current minute
CURRENT_SECOND The current second
```

针对当前语言，插入单行或多行注释:
```
BLOCK_COMMENT_START Example output: in PHP /* or in HTML <!–
BLOCK_COMMENT_END Example output: in PHP */ or in HTML -->
LINE_COMMENT Example output: in PHP // or in HTML <!-- -->
```

栗子：
```
"c_header": {
        "prefix": "c_header",
        "body": [
            "/**",
            " * Copyright © 2020 Moonwhite. All rights reserved.",
            " * ",
            " * @author: Moonwhite",
            " * @date: $CURRENT_YEAR-$CURRENT_MONTH-$CURRENT_DATE ",
            " */",
            "#include <stdio.h>",
            "#include <stdlib.h>",
            "#include <string.h>",
            "",
            "int main() {",
            "    /****** your code ******/",
            "    $0",
            "    return 0;",
            "}"
        ]
        // "description": "Log output to console"
    }
```

生成的效果：
```c
/**
 * Copyright © 2020 Moonwhite. All rights reserved.
 *
 * @author: Moonwhite
 * @date: 2020-11-12
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main() {
    /****** your code ******/
    
    return 0;
}
```