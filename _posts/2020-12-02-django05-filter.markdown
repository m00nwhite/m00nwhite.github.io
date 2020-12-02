---
layout: post
title:  "Django笔记：5.模版过滤器"
date:   2020-12-02 08:55:46 +0800
categories: web django python template
---

## 为什么需要过滤器？
因为在DTL中，不支持函数的调用形式`()`，因此不能给函数传递参数，这将有很大的局限性。而过滤器其实就是一个函数，可以对需要处理的参数进行处理，并且还可以额外接收一个参数（也就是说，最多只能有2个参数）。

## add过滤器：
将传进来的参数添加到原来的值上面。这个过滤器会尝试将`值`和`参数`转换成整形然后进行相加。如果转换成整形过程中失败了，那么会将`值`和`参数`进行拼接。如果是字符串，那么会拼接成字符串，如果是列表，那么会拼接成一个列表。示例代码如下：

```python
{{ value|add:"2" }}
```

如果`value`是等于4，那么结果将是6。如果`value`是等于一个普通的字符串，比如`abc`，那么结果将是`abc2`。`add`过滤器的源代码如下：

```python
def add(value, arg):
"""Add the arg to the value."""
try:
return int(value) + int(arg)
except (ValueError, TypeError):
try:
return value + arg
except Exception:
return ''
```

## cut过滤器：
移除值中所有指定的字符串。类似于`python`中的`replace(args,"")`。示例代码如下：

```python
{{ value|cut:" " }}
```

以上示例将会移除`value`中所有的空格字符。`cut`过滤器的源代码如下：

```python
def cut(value, arg):
"""Remove all values of arg from the given string."""
safe = isinstance(value, SafeData)
value = value.replace(arg, '')
if safe and arg != ';':
return mark_safe(value)
return value
```

## `date`过滤器：
将
一个日期按照指定的格式，格式化成字符串。示例代码如下：

```python
# 数据
context = {
"birthday": datetime.now()
}

# 模版
{{ birthday|date:"Y/m/d" }}
```
那么将会输出`2018/02/01`。其中`Y`代表的是四位数字的年份，`m`代表的是两位数字的月份，`d`代表的是两位数字的日。  
还有更多时间格式化的方式。见下表。

| 格式字符 | 描述 | 示例 |
| --- | --- | --- |
| Y | 四位数字的年份 | 2018 |
| m | 两位数字的月份 | 01-12 |
| n | 月份，1-9前面没有0前缀 | 1-12 |
| d | 两位数字的天 | 01-31 |
| j | 天，但是1-9前面没有0前缀 | 1-31 |
| g | 小时，12小时格式的，1-9前面没有0前缀 | 1-12 |
| h | 小时，12小时格式的，1-9前面有0前缀 | 01-12 |
| G | 小时，24小时格式的，1-9前面没有0前缀 | 1-23 |
| H | 小时，24小时格式的，1-9前面有0前缀 | 01-23 |
| i | 分钟，1-9前面有0前缀 | 00-59 |
| s | 秒，1-9前面有0前缀 | 00-59 |


## default

如果值被评估为`False`。比如`[]`，`""`，`None`，`{}`等这些在`if`判断中为`False`的值，都会使用`default`过滤器提供的默认值。示例代码如下：

```python
{{ value|default:"nothing" }}
```

如果`value`是等于一个空的字符串。比如`""`，那么以上代码将会输出`nothing`。

### default\_if\_none

如果值是`None`，那么将会使用`default_if_none`提供的默认值。这个和`default`有区别，`default`是所有被评估为`False`的都会使用默认值。而`default_if_none`则只有这个值是等于`None`的时候才会使用默认值。示例代码如下：

```python
{{ value|default_if_none:"nothing" }}
```

如果`value`是等于`""`也即空字符串，那么以上会输出空字符串。如果`value`是一个`None`值，以上代码才会输出`nothing`。

### first

返回列表/元组/字符串中的第一个元素。示例代码如下：

```python
{{ value|first }}
```

如果`value`是等于`['a','b','c']`，那么输出将会是`a`。

### last

返回列表/元组/字符串中的最后一个元素。示例代码如下：

```python
{{ value|last }}
```

如果`value`是等于`['a','b','c']`，那么输出将会是`c`。

### floatformat

使用四舍五入的方式格式化一个浮点类型。如果这个过滤器没有传递任何参数。那么只会在小数点后保留一个小数，如果小数后面全是0，那么只会保留整数。当然也可以传递一个参数，标识具体要保留几个小数。

1. 如果没有传递参数：

| value | 模版代码 | 输出 |
| --- | --- | --- |
| 34.23234 | `{{ value\|floatformat }}` | 34.2 |
| 34.000 | `{{ value\|floatformat }}` | 34 |
| 34.260 | `{{ value\|floatformat }}` | 34.3 |

2. 如果传递参数：

| value | 模版代码 | 输出 |
| --- | --- | --- |
| 34.23234 | `{{value\|floatformat:3}}` | 34.232 |
| 34.0000 | `{{value\|floatformat:3}}` | 34.000 |
| 34.26000 | `{{value\|floatformat:3}}` | 34.260 |

### join

类似与`Python`中的`join`，将列表/元组/字符串用指定的字符进行拼接。示例代码如下：

```python
{{ value|join:"/" }}
```

如果`value`是等于`['a','b','c']`，那么以上代码将输出`a/b/c`。

### length

获取一个列表/元组/字符串/字典的长度。示例代码如下：

```python
{{ value|length }}
```

如果`value`是等于`['a','b','c']`，那么以上代码将输出`3`。如果`value`为`None`，那么以上将返回`0`。

### lower

将值中所有的字符全部转换成小写。示例代码如下：

```python
{{ value|lower }}
```

如果`value`是等于`Hello World`。那么以上代码将输出`hello world`。

### upper

类似于`lower`，只不过是将指定的字符串全部转换成大写。

### random

在被给的列表/字符串/元组中随机的选择一个值。示例代码如下：

```python
{{ value|random }}
```

如果`value`是等于`['a','b','c']`，那么以上代码会在列表中随机选择一个。

### safe

标记一个字符串是安全的。也即会关掉这个字符串的自动转义。示例代码如下：

```python
{{value|safe}}
```

如果`value`是一个不包含任何特殊字符的字符串，比如`<a>`这种，那么以上代码就会把字符串正常的输入。如果`value`是一串`html`代码，那么以上代码将会把这个`html`代码渲染到浏览器中。

### slice

类似于`Python`中的切片操作。示例代码如下：

```python
{{ some_list|slice:"2:" }}
```

以上代码将会给`some_list`从`2`开始做切片操作。

### stringtags

删除字符串中所有的`html`标签。示例代码如下：

```python
{{ value|striptags }}
```

如果`value`是`<strong>hello world</strong>`，那么以上代码将会输出`hello world`。

### truncatechars

如果给定的字符串长度超过了过滤器指定的长度。那么就会进行切割，并且会拼接三个点来作为省略号。示例代码如下：

```python
{{ value|truncatechars:5 }}
```

如果`value`是等于`北京欢迎您~`，那么输出的结果是`北京...`。可能你会想，为什么不会`北京欢迎您...`呢。因为三个点也占了三个字符，所以`北京`+三个点的字符长度就是5。

### truncatechars\_html

类似于`truncatechars`，只不过是不会切割`html`标签。示例代码如下：

```python
{{ value|truncatechars:5 }}
```

如果`value`是等于`<p>北京欢迎您~</p>`，那么输出将是`<p>北京...</p>`。
