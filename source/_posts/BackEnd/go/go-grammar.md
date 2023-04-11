---
title: go grammar
categories:
  - BackEnd
tags:
  - go
toc: true
date: 2023-04-11 15:11:33
updated: 2023-04-11 15:11:33
---
# 基础语法

## 变量定义

```go
var identifier [type] = value
// or
identifier := value
// or
var (
    vname1 v_type1
    vname2 v_type2
)

var a int = 10
```

## 常量定义

```go
const identifier [type] = value
```
作为枚举使用
```go
const (
    Unknown = 0
    Female = 1
    Male = 2
)
```

### iota

iota，特殊常量，可以认为是一个可以被编译器修改的常量。

在每一个const关键字出现时，被重置为0，然后再下一个const出现之前，每出现一次iota，其所代表的数字会自动增加1。

iota 可以被用作枚举值：

```go
const (
    a = iota
    b = iota
    c = iota
)
```

第一个 iota 等于 0，每当 iota 在新的一行被使用时，它的值都会自动加 1；所以 a=0, b=1, c=2 可以简写为如下形式：

```go
const (
    a = iota
    b
    c
)
```

#### 用法

```go
package main

import "fmt"

func main() {
    const (
            a = iota   //0
            b          //1
            c          //2
            d = "ha"   //独立值，iota += 1
            e          //"ha"   iota += 1
            f = 100    //iota +=1
            g          //100  iota +=1
            h = iota   //7,恢复计数
            i          //8
    )
    fmt.Println(a,b,c,d,e,f,g,h,i)
}
```
```
0 1 2 ha ha 100 100 7 8
```