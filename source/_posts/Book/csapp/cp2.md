---
title: cp2：信息的表示和处理
categories:
  - Book
tags:
  - csapp
date: 2023-03-22 11:25:43
updated: 2023-03-26 21:34:02

toc: true
---
# 信息存储

## 虚拟内存：

1. 大多数计算机使用 8 位的块，或者字节(Byte)，作为最小的可寻址的内存单元，而不是访问内存中单独的位。机器级程序将内存视为一个非常大的字节数组，称为虚拟内存(virtual address space)。

2. 内存的每个字节都有一个唯一的地址，所有可能地址的集合就称为虚拟地址空间。

## 字数据大小
### unsigned 和 signed 之间的相互转换

![Alt text](../../../static/2023/CSAPP/C2UorU2C.png)

**unsigned 和 signed 建议不要混用**

### 32位和64位系统中的字节大小差异

- 因为32位和64位系统，相同的数据类型会存在不同字节大小的差异。  
- 于是`ISO C99`标准中出现了头文件`stdint.h`引入了`intN_t`和`intN_t`，对不同的N值指定N位有符号和无符号整数。  
- 大多数编译器允许N为8、16、32和64  
- 声明为`uint16_t`，表示一个16位无符号变量；声明为`int32_t`，表示一个32位有符号变量  
- **使用确定大小的整数类型是程序员准确控制数据表示的最佳途径。**   

### 用宏打印`intN_t`和`intN_t`
- 确定宽度类型的带格式打印需要使用宏，以与系统相关的方式扩展为格式串。因此，举个例子来说，变量x和y的类型是 int32_t和uint64_t，可以通过调用printf来打印它们的值，如下所示:  
```C
printf("x=%"PRId32“，y = %"PRIu64"\n"，x，y);
```
- 编译为64位程序时，宏`PRId32`展开成字符串“d”，宏`PRIu64`则展开成两个字符串“1”“u”。当C预处理器遇到仅用空格(或其他空白字符)分隔的一个字符串常量序列时，就把它们串联起来。因此，上面的 printf 调用就变成了:  
```C
printf("x= %d,y= %lu\n"，x，y);  
```
**使用宏能保证:不论代码是如何被编译的，都能生成正确的格式字符串。**  

## 寻址和字节顺序
### 16进制浮点数的表示

相同的数字，用整数存储的和用浮点数存储的十六进制数不一样  
**整数中除了最高有效位1，其他都存在与浮点数中**  

## 移位
<table style="text-align:center">
    <tr>
        <td colspan="2">x</td>
        <td colspan="2">x << 3</td>
        <td colspan="2">x >> 2(逻辑的)</td>
        <td colspan="2">x >> 2(算术的)</td>
    </tr>
    <tr>
        <td>十六进制</td>
        <td>二进制</td>
        <td>二进制</td>
        <td>十六进制</td>
        <td>二进制</td>
        <td>十六进制</td>
        <td>二进制</td>
        <td>十六进制</td>
    </tr>
    <tr>
        <td>0xC3</td>
        <td>11000011</td>
        <td>00011000</td>
        <td>0x18</td>
        <td>00110000</td>
        <td>0x30</td>
        <td>11110000</td>
        <td>0xF0</td>
    </tr>
    <tr>
        <td>0x75</td>
        <td>01110101</td>
        <td>10101000</td>
        <td>0xA8</td>
        <td>00011101</td>
        <td>0x1D</td>
        <td>00011101</td>
        <td>0x1D</td>
    </tr>
    <tr>
        <td>0x87</td>
        <td>10000111</td>
        <td>00111000</td>
        <td>0x38</td>
        <td>00100001</td>
        <td>0x21</td>
        <td>11100001</td>
        <td>0xE1</td>
    </tr>
    <tr>
        <td>0x66</td>
        <td>01100110</td>
        <td>00110000</td>
        <td>0x30</td>
        <td>00011001</td>
        <td>0x19</td>
        <td>00011001</td>
        <td>0x19</td>
    </tr>
</table>

# 整数表示

## C语言中的有符号数和无符号数

当执行一个运算时，如果它的一个运算数是有符号的而另一个是无符号的，那么C语言会隐式地将有符号参数强制类型转换为无符号数，并假设这两个数都是非负的，来执行运算。  

### 升级规则

|            表达式            |  类型  | 求值  |
| :--------------------------: | :----: | :---: |
| -2147483647-1 == 2147483648U | 无符号 |   1   |
|  -2147483647-1 < 2147483647  | 有符号 |   1   |
| -2147483647-1U < 2147483647  | 无符号 |   0   |
| -2147483647-1 < -2147483647  | 有符号 |   1   |
| -2147483647-1U < -2147483647 | 无符号 |   0   |

## 扩展一个数字的位表示

### 从一个较小的数据类型转换到一个较大的数据类型是可以的

零扩展(zero extension)

```c
short sx = -12345;          /*-12345*/
unsigned short usx = sx;    /* 53191*/
int x = sx;                 /* -12345*/
unsigned ux = usx;          /* 53191*/
printf("sx = %d:\t", sx);
show_bytes((byte_pointer) &sx, sizeof(short));
printf("usx = %u:\t", usx);
show_bytes((byte_pointer) &usx, sizeof(unsigned short));
printf("x = %d:\t", x);
show_bytes((byte_pointer) &x, sizeof(int));
printf("ux = %u:\t", ux);
show_bytes((byte_pointer) &ux, sizeof(unsigned));
```
在采用补码表示的 32 位大端法机器上运行这段代码时，打印出如下输出：
```
sx  = -12345:   cf c7
usx = 53191:    cf c7
x   = -12345:   ff ff cf c7
ux  = 53191:    00 00 cf c7
```

### 从一个较大的数据类型转换到一个较小的数据类型是不可以的

```c
short sx = -12345;     /*-12345*/
unsigned uy = sx;

printf("uy = %u:\t", uy);
show_bytes((byte_pointer) &uy, sizeof(unsigned));
```
在一台大端法机器上运行这段代码时，打印出如下输出：
```
uy = 4294954951:    ff ff cf c7
```
这表明当把`short`转换为`unsigned`时，我们应该先改变大小，之后再完成从有符号到无符号的转换。也就是说`(unsigned)sx`等价于`(unsigned)(int)sx`，求值得到`4294954951`，而不等价于`(unsigned)(unsigned short)sx`，后者求值得到`53191`。

### C 函数
```C
int fun1(unsigned word) {
    return (int) ((word << 24) >> 24);
}

int fun2(unsigned word) {
    return ((int) word << 24) >> 24;
}
```

|    word    |   func1    |   func2    |
| :--------: | :--------: | :--------: |
| 0x00000076 | 0x00000076 | 0x00000076 |
| 0x87654321 | 0x00000021 | 0x00000021 |
| 0x000000C9 | 0x000000C9 | 0xFFFFFFC9 |
| 0xEDCBA987 | 0x00000087 | 0xFFFFFF87 |
- func1 没有改变word的值  
- func2 当word倒数第二个字节位置处的数字大于等于8时，会输出一个负数  

# 整数运算

## 加法

### 无符号加法

<table style="text-align:center">
    <tr>
        <td colspan="2">x</td>
        <td colspan="2">-x(u 4)</td>
    </tr>
    <tr>
        <td>十六进制</td>
        <td>十进制</td>
        <td>十进制</td>
        <td>十六进制</td>
    </tr>
    <tr>
        <td>0</td>
        <td>0</td>
        <td>0</td>
        <td>0</td>
    </tr>
    <tr>
        <td>5</td>
        <td>5</td>
        <td>11</td>
        <td>B</td>
    </tr>
    <tr>
        <td>8</td>
        <td>8</td>
        <td>8</td>
        <td>8</td>
    </tr>
    <tr>
        <td>D</td>
        <td>13</td>
        <td>3</td>
        <td>3</td>
    </tr>
    <tr>
        <td>F</td>
        <td>15</td>
        <td>1</td>
        <td>1</td>
    </tr>
</table>

*2.28*

#### 代码

```c
/* Determine whether arguments can be added without overflow */
int uAdd_ok(unsigned x, unsigned y) {
    unsigned sum = x + y;
    return sum >= x;
}
```

### 补码加法

|       x       |       y       |     x + y      |  x + y(t 5)   | 情况  |
| :-----------: | :-----------: | :------------: | :-----------: | :---: |
| [10100]\(-12) | [10001]\(-15) | [100101]\(-27) |  [00101]\(5)  |   1   |
| [11000]\(-8)  | [11000]\(-8)  | [110000]\(-16) | [10000]\(-16) |   2   |
| [10111]\(-9)  |  [01000]\(8)  | [111111]\(-1)  | [11111]\(-1)  |   2   |
|  [00010]\(2)  |  [00101]\(5)  |  [000111]\(7)  |  [00111]\(7)  |   3   |
| [01100]\(12)  |  [00100]\(4)  | [010000]\(16)  | [10000]\(-16) |   4   |

*2.29*

#### 代码

```c
/* Determine whether arguments can be added without overflow */
int tAdd_ok(int x, int y) {
    int sum = x + y;
    int neg_over = x < 0 && y < 0 && sum >= 0;
    int pos_over = x > 0 && y > 0 && sum < 0;
    return !neg_over && !pos_over;
}
```

## 补码的非

<table style="text-align:center">
    <tr>
        <td colspan="2">x</td>
        <td colspan="2">-x(t 4)</td>
    </tr>
    <tr>
        <td>十六进制</td>
        <td>十进制</td>
        <td>十进制</td>
        <td>十六进制</td>
    </tr>
    <tr>
        <td>0</td>
        <td>0</td>
        <td>0</td>
        <td>0</td>
    </tr>
    <tr>
        <td>5</td>
        <td>5</td>
        <td>-5</td>
        <td>B</td>
    </tr>
    <tr>
        <td>8</td>
        <td>-8</td>
        <td>-8</td>
        <td>8</td>
    </tr>
    <tr>
        <td>D</td>
        <td>-3</td>
        <td>3</td>
        <td>3</td>
    </tr>
    <tr>
        <td>F</td>
        <td>-1</td>
        <td>1</td>
        <td>1</td>
    </tr>
</table>

*2.33*

## 乘法

### 二进制乘法运算

模仿手工算十进制乘法，一位位乘然后再加
```
     1001
*    1101
=============
     1001
    0000
   1001
+ 1001
=============
  1110101
```

### 规律

- 虽然完整的乘机的位级表示可能会不同，但是截断后成绩的位级表示是相同的。

|      模式       |            x             |            y             |               x·y               |        截断的x·y         |
| :-------------: | :----------------------: | :----------------------: | :-----------------------------: | :----------------------: |
| 无符号</br>补码 | \[100](4)</br>\[100](-4) | \[101](5)</br>\[101](-3) | \[010100](20)</br>\[001100](12) | \[100](4)</br>\[100](-4) |
| 无符号</br>补码 | \[010](2)</br>\[010](2)  | \[111](7)</br>\[111](-1) | \[001110](14)</br>\[111110](-2) | \[110](6)</br>\[110](-2) |
| 无符号</br>补码 | \[110](6)</br>\[110](-2) | \[110](6)</br>\[110](-2) | \[100100](36)</br>\[000100](4)  | \[100](4)</br>\[100](-4) |

### 代码

```c
int tMul_ok(int32_t x, int32_t y)
{
	int32_t p = x * y;

	/* Either x is zero, or dividing p by x gives y */
	return !x || p / x == y;
}

int tMul_ok2(int32_t x, int32_t y)
{
	int64_t p = (int64_t)x * y; /*一定要先将右边手动转成 int64_t */
	/*printf("p=%" PRId64 ", q=%" PRId32 "\n", p,q);*/

	return p == (int32_t)p;
}
```

# 