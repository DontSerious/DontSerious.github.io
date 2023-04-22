---
title: go grammar
categories:
  - BackEnd
tags:
  - go
toc: true
date: 2023-04-11 15:11:33
updated: 2023-04-12 15:35:18
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

## 条件语句

### switch语句

switch 语句执行的过程从上至下，直到找到匹配项，匹配项后面也不需要再加break

```go
switch var1 {
    case val1:
        ...
    case val2:
        ...
    default:
        ...
}
```

#### Type Switch

switch 语句还可以被用于 type-switch 来判断某个 interface 变量中实际存储的变量类型。

```go
switch x.(type){
    case type:
       statement(s)     
    case type:
       statement(s)
    /* 你可以定义任意个数的case */
    default: /* 可选 */
       statement(s)
}
```

### select语句

```go
select {
    case communication clause  :
       statement(s)      
    case communication clause  :
       statement(s)
    /* 你可以定义任意数量的 case */
    default : /* 可选 */
       statement(s)
}
```

- 每个case都必须是一个通信
- 所有channel表达式都会被求值
- 所有被发送的表达式都会被求值
- 如果任意某个通信可以进行，它就执行；其他被忽略。
- 如果有多个case都可以运行，Select会随机公平地选出一个执行。其他不会执行。

否则：

- 如果有default子句，则执行该语句。
- 如果没有default字句，select将阻塞，直到某个通信可以运行；Go不会重新对channel或值进行求值。

## 循环语句

```go
func main() {

   var b int = 15
   var a int

   numbers := [6]int{1, 2, 3, 5} 

   /* for 循环 */
   for a := 0; a < 10; a++ {
      fmt.Printf("a 的值为: %d\n", a)
   }

    // 代替while
   for a < b {
      a++
      fmt.Printf("a 的值为: %d\n", a)
   }

   for i,x:= range numbers {
      fmt.Printf("第 %d 位 x 的值 = %d\n", i,x)
   }   
}
```

## 函数

```go
func function_name( [parameter list] ) [return_types]{
   函数体
}
```

### 闭包

Go 语言支持匿名函数，可作为闭包。匿名函数是一个"内联"语句或表达式。匿名函数的优越性在于可以直接使用函数内的变量，不必申明。

```go
func getSequence() func() int {
   i:=0
   return func() int {
      i+=1
     return i  
   }
}

func main(){
   /* nextNumber 为一个函数，函数 i 为 0 */
   nextNumber := getSequence()  

   /* 调用 nextNumber 函数，i 变量自增 1 并返回 */
   fmt.Println(nextNumber())
   fmt.Println(nextNumber())
   fmt.Println(nextNumber())
   
   /* 创建新的函数 nextNumber1，并查看结果 */
   nextNumber1 := getSequence()  
   fmt.Println(nextNumber1())
   fmt.Println(nextNumber1())
}
```
```
1
2
3
1
2
```

### 函数方法

设置接收者函数，接受者可以是命名类型或者结构体类型的一个值或者是一个指针。

```go
func (variable_name variable_data_type) function_name() [return_type]{
   /* 函数体*/
}
```

例如：

```go
/* 定义函数 */
type Circle struct {
  radius float64
}

func main() {
  var c1 Circle
  c1.radius = 10.00
  fmt.Println("Area of Circle(c1) = ", c1.getArea())
}

//该 method 属于 Circle 类型对象中的方法
func (c Circle) getArea() float64 {
  //c.radius 即为 Circle 类型对象中的属性
  return 3.14 * c.radius * c.radius
}
```
```
Area of Circle(c1) =  314
```

### defer语句

Go语言中的defer语句会将其后面跟随的语句进行延迟处理

在defer所属的函数即将返回时，将延迟处理的语句按照defer定义的顺序入栈执行，即先进后出

```go
func main() {
	fmt.Println("开始")
	defer fmt.Println(1)
	defer fmt.Println(2)
	defer fmt.Println(3)
	fmt.Println("结束")
}
```
```
开始
结束
3
2
1
```

## 数组

```go
var variable_name [SIZE] variable_type

var balance = [5]float32{1000.0, 2.0, 3.4, 7.0, 50.0}
```

## 切片

"动态数组"

```go
var slice1 []type = make([]type, len)

slice1 := make([]type, len)

// 也可以指定容量，其中capacity为可选参数。
make([]T, length, capacity)

// 初始化，可缺省其中一个
s := arr[startIndex:endIndex] 
```

### len() 和 cap() 

切片是可索引的，并且可以由 len() 方法获取长度。

切片提供了计算容量的方法 cap() 可以测量切片最长可以达到多少。

### append() 和 copy()

```go
func main() {
   var numbers []int
   printSlice(numbers)

   /* 允许追加空切片 */
   numbers = append(numbers, 0)
   printSlice(numbers)

   /* 向切片添加一个元素 */
   numbers = append(numbers, 1)
   printSlice(numbers)

   /* 同时添加多个元素 */
   numbers = append(numbers, 2,3,4)
   printSlice(numbers)

   /* 创建切片 numbers1 是之前切片的两倍容量*/
   numbers1 := make([]int, len(numbers), (cap(numbers))*2)

   /* 拷贝 numbers 的内容到 numbers1 */
   copy(numbers1,numbers)
   printSlice(numbers1)   
}

func printSlice(x []int){
   fmt.Printf("len=%d cap=%d slice=%v\n",len(x),cap(x),x)
}
```
```
len=0 cap=0 slice=[]
len=1 cap=1 slice=[0]
len=2 cap=2 slice=[0 1]       
len=5 cap=6 slice=[0 1 2 3 4] 
len=5 cap=12 slice=[0 1 2 3 4]
```

## 结构体

```go
type struct_variable_type struct {
   member definition
   member definition
   ...
   member definition
}
```

## Map

```go
/* 声明变量，默认 map 是 nil */
var map_variable map[key_data_type]value_data_type

/* 使用 make 函数 */
map_variable = make(map[key_data_type]value_data_type)

/* delete() */
delete(map_variable, key)
```

```go
func main() {
   var countryCapitalMap map[string]string
   /* 创建集合 */
   countryCapitalMap = make(map[string]string)
   
   /* map 插入 key-value 对，各个国家对应的首都 */
   countryCapitalMap["France"] = "Paris"
   countryCapitalMap["Italy"] = "Rome"
   countryCapitalMap["Japan"] = "Tokyo"
   countryCapitalMap["India"] = "New Delhi"
   
   /* 查看元素在集合中是否存在 */
   capital, ok := countryCapitalMap["United States"]
   /* 如果 ok 是 true, 则存在，否则不存在 */
    if(ok){
        fmt.Println("Capital of United States is", capital)  
    }else {
        fmt.Println("Capital of United States is not present") 
    }
```
```
Capital of United States is not present
```

## 类型转换

**go 不支持隐式转换类型**

```go
type_name(expression)
```

## 接口

```go
/* 定义接口 */
type interface_name interface {
   method_name1 [return_type]
   method_name2 [return_type]
   ...
}

/* 定义结构体 */
type struct_name struct {
   /* variables */
}

/* 实现接口方法 */
func (struct_name_variable struct_name) method_name1() [return_type] {
   /* 方法实现 */
}
```

```go
type Phone interface {
    call()
}

type NokiaPhone struct {
}

func (nokiaPhone NokiaPhone) call() {
    fmt.Println("I am Nokia, I can call you!")
}

type IPhone struct {
}

func (iPhone IPhone) call() {
    fmt.Println("I am iPhone, I can call you!")
}

func main() {
    var phone Phone

    phone = new(NokiaPhone)
    phone.call()

    phone = new(IPhone)
    phone.call()

}
```
```
I am Nokia, I can call you!
I am iPhone, I can call you!
```

## Reflect

### Reflect.TypeOf()

TypeOf返回接口中保存的值得类型，TypeOf(nil)会返回nil

### Reflect.ValueOf()

ValueOf返回一个初始化为interface接口保管的具体值得Value，ValueOf(nil)返回Value零值

# 并发

## goroutine

**goroutine的调度是随机的**

```go
go func()
```

创建线程之后需要一段时间让线程执行：
- time.sleep()睡眠一会
- sync.WaitGroup

### sync.WaitGroup

当你并不关心并发操作的结果或者有其它方式收集并发操作的结果时，WaitGroup是实现等待一组并发操作完成的好方法

```go
package main

import (
	"fmt"
	"sync"
)

var wg sync.WaitGroup

func hello() {
	fmt.Println("world!")
	defer wg.Done()         //计数器减一
}

func main() {
	wg.Add(1)               //计数器加一
	go hello()
	fmt.Print("hello ")
	wg.Wait()               //阻塞代码的运行，直到计数器为0
}
```
```
hello world!
```

## channel

goroutine 之间交换数据的解决办法：
- 为了保证线程间数据交换的正确性，很多并发模型使用互斥锁，但这样会造成性能问题。
- Go采用的并发模型是CSP（Communicating Sequential Processes），提倡通过通信共享内存，而不是通过共享内存而实现通信
- Go 语言中的`channel`是一种特殊的类型。`channel`像一个队列，总是遵循先入先出的规则，保证收发数据的顺序。每一个`channel`都是一个具体类型的导管，也就是声明`channel`的时候需要为其指定元素类型。

### 操作

- `channel` 的零值为nil
- 发送和接收操作均用`​<-`​符号
- 它和关闭文件不一样，通常在结束操作之后关闭文件是必须要做的，但关闭通道不是必须的。

```go
// 使用make()初始化
make(chan 元素类型,[缓冲大小])

// 声明一个通道并初始化
a := make(chan int)

// 把10发送给a通道
a <- 10

// x从a通道中取值
value, ok := <-ch
//从a通道中取值，忽略结果
<-a

// 关闭通道
close(a)
```

### 关闭

- 当一个通道被关闭后，再往该通道发送值会引发panic。
- 对已关闭的通道进行取值的操作会先取完通道中的值。
- 通道内的值被接收完后再对通道执行接收操作得到的值会一直都是对应元素类型的零值。

```go
// 使用 for range 取完通道所有的值
func receive(ch chan int) {
	for i:=range ch{
		fmt.Printf("v:%v",i)
	}
}
```

### 无缓冲channel(阻塞的channel)

- 无缓冲的通道只有在有接收方能够接收值的时候才能发送成功，否则会一直处于等待发送的阶段。
- 同理，如果对一个无缓冲通道执行接收操作时，没有任何向通道中发送值的操作那么也会导致接收操作阻塞。

```go
// 报错，deadlock
func main() {
	a := make(chan int)
	a <- 10
	fmt.Println("发送成功")
}
```

```go
// 成功
func receive(x chan int) {
	ret := <-x
	fmt.Println("接收成功", ret)
}

func main() {
	a := make(chan int)
	go receive(a)
	a <- 10
	fmt.Println("发送成功")
}
```

### 有缓冲区channel

- 通道的容量大于零，该通道就是有缓冲的通道，通道的容量表示通道中最大能存放的元素数量。
- 通道内已有元素数达到最大容量后，再向通道执行发送操作就会阻塞，除非有从通道执行接收操作。
- 可以使用 `len()` 获取通道的长度，使用 `cap()` 获取通道的容量

```go
// 成功
func main() {
	a := make(chan int,1)
	a <- 10
	fmt.Println("发送成功")
}
```

### 单项通道

限制函数只能发送或只能接收

```go
<- chan int // 只接收通道，只能接收不能发送
chan <- int // 只发送通道，只能发送不能接收
```

### select 多路复用

```go
// 每次进入循环只会执行其中满足条件的，下列结果为 1 3 5 7 9
func main() {
	ch := make(chan int, 1)
	for i := 1; i <= 10; i++ {
		select {
            case x := <-ch:
                fmt.Println(x)
            case ch <- i:
		}
	}
}
```

### 互斥锁

一种常用的控制共享资源访问的方法，它能够保证同一时间只有一个 goroutine 可以访问共享资源。Go语言中使用sync包中提供的Mutex类型来实现互斥锁

- 互斥锁能够保证同一时间有且只有一个 goroutine 进入临界区，其他的 goroutine 则在等待锁；
- 当互斥锁释放后，等待的 goroutine 才可以获取锁进入临界区
- 多个 goroutine 同时等待一个锁时，唤醒的策略是随机的

```go
var (
	x  int64
	wg sync.WaitGroup
	m  sync.Mutex           // 互斥锁
)

func add() {
	for i := 0; i < 5000; i++ {
		m.Lock()            // 修改x前加锁
		x = x + 1
		m.Unlock()          // 改完解锁
	}
	wg.Done()
}

func main() {
	wg.Add(2)
	go add()
	go add()
	wg.Wait()
	fmt.Println(x)          //10000
}
```

### 读写锁

- 当并发的去读取一个资源而不涉及资源修改的时没有必要使用互斥锁，读写锁是一种更好的选择。
- 在Go语言中使用sync包中的RWMutex类型来实现读写互斥锁
- 读写锁分为两种：读锁和写锁。
  - 当一个 goroutine 获取到读锁之后，其他的 goroutine 如果是获取读锁会继续获得锁，如果是获取写锁就会等待；
  - 而当一个 goroutine 获取写锁之后，其他的 goroutine 无论是获取读锁还是写锁都会等待

```go
var (
	x  = 0
	wg sync.WaitGroup
	RWLock sync.RWMutex
)

func read() {
	defer wg.Done()
	RWLock.RLock()
	fmt.Println(x)
	time.Sleep(time.Millisecond)
	RWLock.RUnlock()
}

func write() {
	defer wg.Done()
	RWLock.Lock()
	x += 1
	time.Sleep(time.Millisecond * 5)
	RWLock.Unlock()
}

func main() {
	start := time.Now()
	for i := 0; i < 10; i++ {
		go write()
		wg.Add(1)
	}
	time.Sleep(time.Second)
	for i := 0; i < 1000; i++ {
		go read()
		wg.Add(1)
	}
	wg.Wait()
	fmt.Println(time.Since(start))
}
```
