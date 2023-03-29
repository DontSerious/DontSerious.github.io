---
title: C# OOP
date: 2023-03-12 16:32:13
updated: 2023-03-12 16:32:13
categories:
- BackEnd
tags:
- cs
toc: true
---
# 属性
```C#
class Person
{
  private string name; // 方法
  // 以下写法可以使用get，set
  public string Name   // 属性
  {
    get { return name; }
    set { name = value; }
  }
}
// 以下简写产生同样结果
class Person
{
  public string Name  // property
  { get; set; }
}
```
# 继承
要从类继承，请使用 `:` 符号。
```C#
class Vehicle  // 基类（父类）
{
  public string brand = "Ford";  // Vehicle 字段
  public void honk()             // Vehicle 方法 
  {                    
    Console.WriteLine("Tuut, tuut!");
  }
}

class Car : Vehicle  // 派生类（子）
{
  public string modelName = "Mustang";  // Car 字段
}
```
## 密封关键字
如果不希望其他类从类继承，请使用`sealed`关键字
```C#
sealed class Vehicle 
{
  ...
}

class Car : Vehicle 
{
  ...
}
```

# 多态
C#提供了一个重写基类方法的选项，方法是将virtual关键字添加到基类内的方法，并对每个派生类方法使用override关键字：  
```C#
class Animal  // 基类（父类）
{
  public virtual void animalSound() 
  {
    Console.WriteLine("The animal makes a sound");
  }
}

class Pig : Animal  // 派生类（子）
{
  public override void animalSound() 
  {
    Console.WriteLine("The pig says: wee wee");
  }
}

class Dog : Animal  // 派生类（子）
{
  public override void animalSound() 
  {
    Console.WriteLine("The dog says: bow wow");
  }
}

class Program 
{
  static void Main(string[] args) 
  {
    Animal myAnimal = new Animal();  // 创建一个 Animal 对象
    Animal myPig = new Pig();  // 创建 Pig 对象
    Animal myDog = new Dog();  // 创建 Dog 对象

    myAnimal.animalSound();
    myPig.animalSound();
    myDog.animalSound();
  }
}
```
输出：
```
The animal makes a sound
The pig says: wee wee
The dog says: bow wow
```

# 抽象类
使用`abstract`关键字
```C#
// 抽象类
abstract class Animal
{
  // 抽象方法（没有主体）
  public abstract void animalSound();
  // 常规方法
  public void sleep()
  {
    Console.WriteLine("Zzz");
  }
}

// 派生类（继承自 Animal）
class Pig : Animal
{
  public override void animalSound()
  {
    // 这里提供了 animalSound() 的主体
    Console.WriteLine("The pig says: wee wee");
  }
}

class Program
{
  static void Main(string[] args)
  {
    Pig myPig = new Pig(); // 创建 Pig 对象
    myPig.animalSound();  // 调用抽象方法
    myPig.sleep();  // 调用常规方法
  }
}
```

# 接口
要访问接口方法，接口必须由另一个类实现(类似于继承)。要实现接口，请使用:符号(与继承一样)。接口方法的主体由"implement"类提供。 注意，在实现接口时，不必使用`override` 关键字  
**可实现多个接口**
```C#
// 接口
interface IFirstInterface 
{
  void myMethod(); // 接口方法
}

interface ISecondInterface 
{
  void myOtherMethod(); // 接口方法
}

// 实现多个接口
class DemoClass : IFirstInterface, ISecondInterface 
{
  public void myMethod() 
  {
    Console.WriteLine("Some text..");
  }
  public void myOtherMethod() 
  {
    Console.WriteLine("Some other text...");
  }
}

class Program 
{
  static void Main(string[] args)
  {
    DemoClass myObj = new DemoClass();
    myObj.myMethod();
    myObj.myOtherMethod();
  }
}
```

# 枚举
枚举 `enum` 是一个特殊的类"class"，它表示一组常量(不可更改/只读变量)。  
## 类内枚举
```C#
class Program
{
  enum Level
  {
    Low,
    Medium,
    High
  }
  static void Main(string[] args)
  {
    Level myVar = Level.Medium;
    Console.WriteLine(myVar);
  }
}
```
## 枚举值  
**必须进行显示转换为int**  
可自定义枚举值
```C#
enum Months
{
  January,    // 0
  February,   // 1
  March=6,    // 6
  April,      // 7
  May,        // 8
  June,       // 9
  July        // 10
}

static void Main(string[] args)
{
  int myNum = (int) Months.April;
  Console.WriteLine(myNum);
}
```
输出为7

## Switch中的应用
```C#
enum Level 
{
  Low,
  Medium,
  High
}

static void Main(string[] args) 
{
  Level myVar = Level.Medium;
  switch(myVar) 
  {
    case Level.Low:
      Console.WriteLine("Low level");
      break;
    case Level.Medium:
       Console.WriteLine("Medium level");
      break;
    case Level.High:
      Console.WriteLine("High level");
      break;
  }
}
```
输出： `Medium level`