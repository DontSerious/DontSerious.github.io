---
title: OOP class
date: 2023-03-19 14:50:00
updated: 2023-03-19 14:50:00
categories:
- BackEnd
tags:
- cpp
---

# 类定义
```cpp
// 关键字 类名
class Box
{
    // 默认为private
    double length;   // 变量

    public: // 访问修饰符：private/public/protected
        double breadth;
        double height;
        // 内部定义函数
        double getV(void) 
        {
        return length * breadth * height;
        }
        // 外部定义函数
        void set( double len, double bre, double hei );
};  // 分号结束一个类
// 成员函数定义
void Box::set(double len, double bre, double hei)
{
    length = len;
    breadth = bre;
    height = hei;
}
```

## 构造函数
1. 类的构造函数是类的一种特殊的成员函数，它会在每次创建类的新对象时执行。
2. 构造函数的名称与类的名称是完全相同的，并且不会返回任何类型，也不会返回 void。
3. 构造函数可用于为某些成员变量设置初始值。

*sort from [菜鸟教程](https://www.runoob.com/cplusplus/cpp-classes-objects.html)*