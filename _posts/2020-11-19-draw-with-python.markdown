---
layout: post
title:  "使用python和matplotlib实现数据可视化"
date:   2020-11-19 22:34:25 +0800
categories: python matplotlib
---

## 背景
最近有个项目需要对批处理任务进行优化，批处理使用120个进程执行任务，但是任务之间存在依赖关系，任务执行的日志中记载了每个任务开始和结束的时间，看起来不够直观，于是考虑使用python和matplotlib进行可视化加以分析。

## 工具
* pycharm
* matplotlib

## 实现
### 关于matplotlib
Matplotlib 是 Python 的绘图库。 它可与 NumPy 一起使用，提供了一种有效的 MatLab 开源替代方案。
这里仅仅用到了Matplotlib的极小部分功能，画线和加文字：
```python
# 绘制line
plt.plot([start_x_position, end_x_position], [start_y_position, end_y_position])

# 添加文字说明
plt.text(x_position, y_position, text, size, color, alpha, ...)
```

### 代码
日志中的时间格式为数值型表示的时间，比如12345表示的是1:23:45，需要进行一下转换。
```python
def conv2NormalTime(digitalTime):
    seconds = 0
    minuts = 0
    hours = 0
    if digitalTime < 60:
        seconds = digitalTime
    elif digitalTime < 3600:
        seconds = digitalTime % 60
        minuts = digitalTime // 60
    else:
        seconds = digitalTime % 60
        minuts = (digitalTime // 60) % 60
        hours = digitalTime // 3600

    if seconds < 10:
        seconds = '0' + str(seconds)
    else:
        seconds = str(seconds)

    if minuts < 10:
        minuts = '0' + str(minuts)
    else:
        minuts = str(minuts)

    if hours < 10:
        hours = '0' + str(hours)
    else :
        hours = str(hours)
    return hours + ":" + minuts + ":" + seconds
```

由于需要使用秒单位作为参数调用matplotlib，因此需要将时间转换为秒单位，添加函数实现。
```python
def conv2Seconds(digitalTime):
    seconds=0
    minuts=0
    hours = 0
    totalSeconds = 0
    if digitalTime < 100:
        seconds = digitalTime
        totalSeconds = seconds
    elif digitalTime < 10000:
        seconds = digitalTime % 100
        minuts = digitalTime // 100
        totalSeconds = minuts * 60 + seconds
    else:
        seconds = digitalTime % 100
        minuts = (digitalTime // 100) % 100
        hours = digitalTime // 10000
        totalSeconds = hours* 3600 + minuts* 60 + seconds
    return int(totalSeconds)
```

绘图代码
```python
def draw():
    f = open('log_file.txt', encoding='GBK')
    i = 0
    machid = 0
    jiaoyms = []
    fig = plt.gcf()
    fig.set_size_inches(100, 15)
    fig.savefig('test2png.png', dpi=100)
    plt.xlabel('time')
    plt.ylabel('process')
    plt.title('batch stat - 20201118 - TimeLine')

    mintime=1000000
    maxtime=0
    for line in f:
        i += 1
        machid += 1
        if machid == 120:
            machid = 1
        # 截取开始时间
        starttime = int(line.split('|')[-6])
        # 截取终止时间
        endtime = int(line.split('|')[-5])
        if starttime > 220000:
            continue
        # 截取其他显示信息
        info1 = line.split('|')[5]
        info2 = line.split('|')[8]
        machine = line.split('|')[17][0:4]
        # 开始时间秒数及结束时间秒数
        startsecs = conv2Seconds(starttime)
        endsecs = conv2Seconds(endtime)
        if starttime < mintime:
            mintime = starttime
        if endtime > maxtime:
            maxtime = endtime

        # 绘制
        plt.plot([startsecs, endsecs], [machid, machid])

        # 这里根据不同的任务执行时间长度，显示为不同的风格
        if endsecs - startsecs < 10: # 10秒内结束的任务
            plt.text(endsecs, machid, info1+":"+info2, size=4, alpha=0.3)
        elif endsecs - startsecs <60 : # 1分钟以内结束的任务
            plt.text(endsecs, machid, info1 + ":" + info2, size=5, color='green', alpha=0.4)
        elif endsecs - startsecs < 600: # 耗时十分钟以内的任务
            plt.text(endsecs, machid, info1 + ":" + info2, size=5, color='blue', alpha=0.5)
        else: # 耗时十分钟以上的任务，重点关注
            plt.text(endsecs, machid, info1+":"+info2, size=8, color='red', alpha=1)

    # 取整体任务的开始和结束时间
    minsecs=conv2Seconds(mintime)
    maxsecs=conv2Seconds(maxtime)

    # 每隔10分钟绘制时间刻度
    for i in range(minsecs, maxsecs):
        if i % 600 == 0:
            curTime = conv2NormalTime(i)
            plt.text(i, -5, curTime, size=10, alpha=0.7)
    # 将绘制结果保存为png图片
    plt.savefig("batch_analyze_result.png")
    plt.show()
```

### 执行结果
![](http://sjdt.online/img/20201119_python_plot1.png)
