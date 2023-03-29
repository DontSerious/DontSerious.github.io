---
title: IO
date: 2023-03-19 14:27:30
updated: 2023-03-19 14:27:30
categories:
- BackEnd
tags:
- cpp
---

# 标准错误流（cerr）
预定义的对象 `cerr` 是 `iostream` 类的一个实例。`cerr` 对象附属到标准输出设备，通常也是显示屏，但是 `cerr` 对象是非缓冲的，且每个流插入到 `cerr` 都会立即输出。
```cpp
#include <iostream>
 
using namespace std;
 
int main( )
{
   char str[] = "Unable to read....";
 
   cerr << "Error message : " << str << endl;
}
```
> Error message : Unable to read....  

# 标准日志流（clog）
预定义的对象 `clog` 是 `iostream` 类的一个实例。`clog` 对象附属到标准输出设备，通常也是显示屏，但是 `clog` 对象是缓冲的。这意味着每个流插入到 `clog` 都会先存储在缓冲区，直到缓冲填满或者缓冲区刷新时才会输出。

```cpp
#include <iostream>
 
using namespace std;
 
int main( )
{
   char str[] = "Unable to read....";
 
   clog << "Error message : " << str << endl;
}
```
> Error message : Unable to read....

**使用 cerr 流来显示错误消息，而其他的日志消息则使用 clog 流来输出。**

*sort from [菜鸟教程](https://www.runoob.com/cplusplus/cpp-basic-input-output.html)*