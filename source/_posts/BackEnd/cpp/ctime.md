---
title: ctime
date: 2023-03-19 13:45:31
updated: 2023-03-19 13:45:31
categories:
- BackEnd
tags:
- cpp
---
# ctime常用函数

## time()
> time_t time(time_t *seconds)
>> seconds -- 这是指向类型为 time_t 的对象的指针，用来存储 seconds 的值。  

用法
```cpp
time_t seconds = time(NULL);
```
```cpp
time_t seconds;
time( &seconds );
```

## ctime()
> char *ctime(const time_t *timer)
>> timer -- 这是指向 time_t 对象的指针，该对象包含了一个日历时间。

返回：Www Mmm dd hh:mm:ss yyyy

## localtime() 和 asctime()
> struct tm *localtime(const time_t *timer)
>> timer -- 这是指向表示日历时间的 time_t 值的指针。  

> char *asctime(const struct tm *timeptr)
>> struct tm *timeptr -- 指的是结构体tm

`localtime()` 使用 `time_t *timer` 生成 `结构体tm`
`asctime()` 将 `结构体tm` 转换为字符串形式

### cpp安全问题
在Visual Studio 2015里使用asctime函数报错C4996提示asctime不安全，建议使用asctime_s代替。与localtime_s结合使用：
```cpp
#include <iostream>
#include <ctime>

using namespace std;

int main()
{
  struct tm t;    //tm结构指针
  char stTmp[32];
  time_t now;        //声明time_t类型变量
  time(&now);        //获取系统日期和时间
  localtime_s(&t, &now);    //获取当地日期和时间
  asctime_s(stTmp, &t);
  cout << stTmp << endl;
  return 0;
}
```

# 结构体 tm

```cpp
struct tm {
  int tm_sec;   // 秒，正常范围从 0 到 59，但允许至 61
  int tm_min;   // 分，范围从 0 到 59
  int tm_hour;  // 小时，范围从 0 到 23
  int tm_mday;  // 一月中的第几天，范围从 1 到 31
  int tm_mon;   // 月，范围从 0 到 11
  int tm_year;  // 自 1900 年起的年数
  int tm_wday;  // 一周中的第几天，范围从 0 到 6，从星期日算起
  int tm_yday;  // 一年中的第几天，范围从 0 到 365，从 1 月 1 日算起
  int tm_isdst; // 夏令时
};
```

针对计算程序执行时间问题使用[clock_t clock(void);](https://www.runoob.com/cprogramming/c-function-clock.html)

*sort from [菜鸟教程](https://www.runoob.com/cplusplus/cpp-date-time.html)*