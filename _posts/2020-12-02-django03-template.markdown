---
layout: post
title:  "Django笔记：4.模版"
date:   2020-12-02 02:47:42 +0800
categories: web django python template
---


# 1. 模版变量笔记：
## 1.1. 在模版中使用变量，需要将变量放到`{{ 变量 }}`中。
## 1.2. 如果想要访问对象的属性，那么可以通过`对象.属性名`来进行访问。
    ```python
    class Person(object):
        def __init__(self,username):
            self.username = username

    context = {
        'person': p
    }
    ```
以后想要访问`person`的`username`，那么就是通过`person.username`来访问。
## 1.3. 如果想要访问一个字典的key对应的value，那么只能通过`字典.key`的方式进行访问，不能通过`中括号[]`的形式进行访问。
    ```python
    context = {
        'person': {
            'username':'zhiliao'
        }
    }
    ```
那么以后在模版中访问`username`。就是以下代码`person.username`
## 1.4. 因为在访问字典的`key`时候也是使用`点.`来访问，因此不能在字典中定义字典本身就有的属性名当作`key`，否则字典的那个属性将编程字典中的key了。
    ```python
    context = {
        'person': {
            'username':'zhiliao',
            'keys':'abc'
        }
    }
    ```
以上因为将`keys`作为`person`这个字典的`key`了。因此以后在模版中访问`person.keys`的时候，返回的不是这个字典的所有key，而是对应的值。
## 1.5. 如果想要访问列表或者元组，那么也是通过`点.`的方式进行访问，不能通过`中括号[]`的形式进行访问。这一点和python中是不一样的。示例代码如下：
    ```python
    {{ persons.1 }}
    ```

# 2. if语句笔记：
* if标签有闭合标签。就是`{% endif %}`。
* if标签的判断运算符，就跟python中的判断运算符是一样的。`==、!=、<、<=、>、>=、in、not in、is、is not`这些都可以使用。
* 还可以使用`elif`以及`else`等标签。


# 3. `for...in...`标签：
`for...in...`类似于`Python`中的`for...in...`。可以遍历列表、元组、字符串、字典等一切可以遍历的对象。示例代码如下：
```python
{% for person in persons %}
<p>{{ person.name }}</p>
{% endfor %}
```

如果想要反向遍历，那么在遍历的时候就加上一个`reversed`。示例代码如下：
```python
{% for person in persons reversed %}
<p>{{ person.name }}</p>
{% endfor %}
```

遍历字典的时候，需要使用`items`、`keys`和`values`等方法。在`DTL`中，执行一个方法不能使用圆括号的形式。遍历字典示例代码如下：

```python
{% for key,value in person.items %}
<p>key：{{ key }}</p>
<p>value：{{ value }}</p>
{% endfor %}
```

## 在`for`循环中，`DTL`提供了一些变量可供使用。这些变量如下：

* `forloop.counter`：当前循环的下标。以1作为起始值。
* `forloop.counter0`：当前循环的下标。以0作为起始值。
* `forloop.revcounter`：当前循环的反向下标值。比如列表有5个元素，那么第一次遍历这个属性是等于5，第二次是4，以此类推。并且是以1作为最后一个元素的下标。
* `forloop.revcounter0`：类似于forloop.revcounter。不同的是最后一个元素的下标是从0开始。
* `forloop.first`：是否是第一次遍历。
* `forloop.last`：是否是最后一次遍历。
* `forloop.parentloop`：如果有多个循环嵌套，那么这个属性代表的是上一级的for循环。

**模板中的for...in...没有continue和break语句，这一点和Python中有很大的不同，一定要记清楚！**

## `for...in...empty`标签：
这个标签使用跟`for...in...`是一样的，只不过是在遍历的对象如果没有元素的情况下，会执行`empty`中的内容。示例代码如下：

```python
{% for person in persons %}
<li>{{ person }}</li>
{% empty %}
暂时还没有任何人
{% endfor %}
```

continue和break在模版中是不可以使用的。



# 4. with标签笔记：

1. 在模板中，想要定义变量，可以通过`with`语句来实现。
2. `with`语句有两种使用方式，第一种是`with xx=xxx`的形式，第二种是`with xxx as xxx`的形式。
3. 定义的变量只能在with语句块中使用，在with语句块外面使用取不到这个变量。
示例代码如下：
```python
    {% with zs=persons.0%}
        <p>{{ zs }}</p>
        <p>{{ zs }}</p>
    {% endwith %}
    下面这个因为超过了with语句块，因此不能使用
    <p>{{ zs }}</p>

    {% with persons.0 as zs %}
        <p>{{ zs }}</p>
    {% endwith %}
```
* 注意with后面的等号两边不能有空格



# 5. url标签笔记：

`url`标签：在模版中，我们经常要写一些`url`，比如某个`a`标签中需要定义`href`属性。当然如果通过硬编码的方式直接将这个`url`写死在里面也是可以的。但是这样对于以后项目维护可能不是一件好事。因此建议使用这种反转的方式来实现，类似于`django`中的`reverse`一样。示例代码如下：

```python
<a href="{% url 'book:list' %}">图书列表页面</a>
```

如果`url`反转的时候需要传递参数，那么可以在后面传递。但是参数分位置参数和关键字参数。位置参数和关键字参数不能同时使用。示例代码如下：

```python
# path部分
path('detail/<book_id>/',views.book_detail,name='detail')

# url反转，使用位置参数
<a href="{% url 'book:detail' 1 %}">图书详情页面</a>

# url反转，使用关键字参数
<a href="{% url 'book:detail' book_id=1 %}">图书详情页面</a>
```

如果想要在使用`url`标签反转的时候要传递查询字符串的参数，那么必须要手动在在后面添加。示例代码如下：

```python
<a href="{% url 'book:detail' book_id=1 %}?page=1">图书详情页面</a>
```

如果需要传递多个参数，那么通过空格的方式进行分隔。示例代码如下：

```python
<a href="{% url 'book:detail' book_id=1 page=2 %}">图书详情页面</a>
```

# 6. spaceless标签
移除html标签中的空白字符，包括空格、tab键、换行等。
比如
```python
{% spaceless%}
    <p>
        <a href="foo/">Foo</a>
    </p>
{% endspaceless%}
```
上面代码在选然后会变成以下的代码：
```html
<p><a href="foo/">Foo</a></p>
```

# 7. autoescape自动转义：

1. DTL中默认已经开启了自动转义。会将那些特殊字符进行转义。比如会将`<`转义成`&lt;`等。
2. 如果你不知道自己在干什么，那么最好是使用DTL的自动转义。这样网站才不容易出现XSS漏洞。
3. 如果变量确实是可信任的。那么可以使用`autoescape`标签来关掉自动转义。示例代码如下：
```python
{% autoescape off %}
    {{ info }}
{% endautoescape %}
```

# 8.verbatim标签：

`verbatim`标签：默认在`DTL`模板中是会去解析那些特殊字符的。比如`{%`和`%}`以及`{{`等。如果你在某个代码片段中不想使用`DTL`的解析引擎。那么你可以把这个代码片段放在`verbatim`标签中。示例代码下：

```python
{% verbatim %}
{{if dying}}Still alive.{{/if}}
{% endverbatim %}
``` 

