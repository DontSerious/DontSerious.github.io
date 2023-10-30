---
title: TypeScript笔记
date: 2023-10-30 12:08:57
updated: 2023-10-30 12:08:57
categories:
- FrontEnd
tags:
- TypeScript
toc: true
---

# 基础语法

```ts
let v1: string = 'abc'
let v2: number = 10
let v3: boolean = true
let nu: null = null
let un: undefined = undefined

let v4: string | null = null
let v5: 1 | 2 | 3 = 2

let arr: number[] = [1, 2, 3]
let arr1: Array<String> = ['a', 'b', 'c']

// 元组
let t1: [number, string, number?] = [1, 'a', 2]
t1 = [2, 'c']

// 枚举
enum myEnum {
    A,
    B,
    C
}
// 相等
console.log(myEnum.A)
console.log(myEnum[0])

// : void 表示没有返回值
// a = 10 代表默认赋值，建议写左边
// ? 代表可选参数，建议写右边
function MyFun(a = 10, b: string, c?: boolean, ...rest: number[]): void {
    let d = a + b + c
    // return c
}

// 接口
interface Boy {
    name: string,
    age: number
}
const bobo: Boy = {
    name: 'bobo',
    age: 10
}

// 自定义类型
type MyUserName = string | number
let a: MyUserName = 1

// 泛型
function MyFunc<T>(a: T, b: T): T[] {
    return [a, b]
}
MyFunc<number>(1, 2)
```