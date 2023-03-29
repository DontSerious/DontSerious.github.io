---
title: C# 高级
date: 2023-03-15 15:54:00
updated: 2023-03-15 15:54:00
categories:
- PG
tags:
- cs
toc: true
---
# IO
文件类`File`来自`System.IO`命名空间，允许我们处理文件

| 方法           | 描述                                                       |
| -------------- | ---------------------------------------------------------- |
| AppendText()   | 在现有文件末尾追加文本                                     |
| Copy()         | 复制文件                                                   |
| Create()       | 创建或覆盖文件                                             |
| Delete()       | 删除文件                                                   |
| Exists()       | 测试文件是否存在                                           |
| ReadAllText()  | 读取文件的内容                                             |
| Replace()      | 用另一个文件的内容替换文件的内容                           |
| WriteAllText() | 创建新文件并将内容写入其中。如果文件已经存在，它将被覆盖。 |
### 实例
```C#
using System.IO;  // 包括 System.IO 命名空间

string writeText = "Hello World!";  // 创建文本字符串
File.WriteAllText("filename.txt", writeText);  // 创建一个文件并将 writeText 的内容写入其中

string readText = File.ReadAllText("filename.txt");  // 读取文件内容
Console.WriteLine(readText);  // 输出内容
```
> Hello World!

# 异常处理
`try` 语句允许您定义要在执行时测试错误的代码块。

`catch` 语句允许您定义要执行的代码块，如果 `try` 块中发生错误。

`finally` 语句允许您在 `try...catch` 之后执行代码，而不管结果如何
### 实例
```C#
try
{
  int[] myNumbers = {1, 2, 3};
  Console.WriteLine(myNumbers[10]);
}
catch (Exception e)
{
  Console.WriteLine("Something went wrong.");
}
finally
{
  Console.WriteLine("The 'try catch' is finished.");
}
```
## throw 语句
`throw` 语句允许您创建自定义错误。

`throw` 语句与异常类exception class一起使用。 
C# 中有许多可用的异常类： `ArithmeticException`, `FileNotFoundException`, 
`IndexOutOfRangeException`, `TimeOutException`等
### 实例
```C#
static void checkAge(int age)
{
  if (age < 18)
  {
    throw new ArithmeticException("Access denied - You must be at least 18 years old.");
  }
  else
  {
    Console.WriteLine("Access granted - You are old enough!");
  }
}

static void Main(string[] args)
{
  checkAge(15);
}
```
> System.ArithmeticException: 'Access denied - You must be at least 18 years old.'

# 运算符重载
您可以重定义或重载 C# 中内置的运算符。因此，程序员也可以使用用户自定义类型的运算符。重载运算符是具有特殊名称的函数，是通过关键字 `operator` 后跟运算符的符号来定义的。与其他函数一样，重载运算符有返回类型和参数列表。
### 实例
```C#
public static Box operator + (Box b, Box c)
{
   Box box = new Box();
   box.length = b.length + c.length;
   box.breadth = b.breadth + c.breadth;
   box.height = b.height + c.height;
   return box;
}
```
上面的函数为用户自定义的类 Box 实现了加法运算符（+）。它把两个 Box 对象的属性相加，并返回相加后的 Box 对象。

## 可重载和不可重载运算符
| 运算符                                | 描述                                         |
| ------------------------------------- | -------------------------------------------- |
| +, -, !, ~, ++, --                    | 这些一元运算符只有一个操作数，且可以被重载。 |
| +, -, *, /, %                         | 这些二元运算符带有两个操作数，且可以被重载。 |
| ==, !=, <, >, <=, >=                  | 这些比较运算符可以被重载。                   |
| &&, \|\|                              | 这些条件逻辑运算符不能被直接重载。           |
| +=, -=, *=, /=, %=                    | 这些赋值运算符不能被重载。                   |
| =, ., ?:, ->, new, is, sizeof, typeof | 这些运算符不能被重载。                       |
### 实例
```C#
public static bool operator == (Box lhs, Box rhs)
      {
          bool status = false;
          if (lhs.length == rhs.length && lhs.height == rhs.height 
             && lhs.breadth == rhs.breadth)
          {
              status = true;
          }
          return status;
      }
      public static bool operator !=(Box lhs, Box rhs)
      {
          bool status = false;
          if (lhs.length != rhs.length || lhs.height != rhs.height 
              || lhs.breadth != rhs.breadth)
          {
              status = true;
          }
          return status;
      }
      public static bool operator <(Box lhs, Box rhs)
      {
          bool status = false;
          if (lhs.length < rhs.length && lhs.height 
              < rhs.height && lhs.breadth < rhs.breadth)
          {
              status = true;
          }
          return status;
      }

      public static bool operator >(Box lhs, Box rhs)
      {
          bool status = false;
          if (lhs.length > rhs.length && lhs.height 
              > rhs.height && lhs.breadth > rhs.breadth)
          {
              status = true;
          }
          return status;
      }

      public static bool operator <=(Box lhs, Box rhs)
      {
          bool status = false;
          if (lhs.length <= rhs.length && lhs.height 
              <= rhs.height && lhs.breadth <= rhs.breadth)
          {
              status = true;
          }
          return status;
      }

      public static bool operator >=(Box lhs, Box rhs)
      {
          bool status = false;
          if (lhs.length >= rhs.length && lhs.height 
             >= rhs.height && lhs.breadth >= rhs.breadth)
          {
              status = true;
          }
          return status;
      }
      public override string ToString()
      {
          return String.Format("({0}, {1}, {2})", length, breadth, height);
      }
```

# 结构体(struct)
在 C# 中，结构体是值类型数据结构。它使得一个单一变量可以存储各种数据类型的相关数据。`struct` 关键字用于创建结构体。
```C#
struct Books
{
   private string title;
   private string author;
   private string subject;
   private int book_id;
   public void setValues(string t, string a, string s, int id)
   {
      title = t;
      author = a;
      subject = s;
      book_id =id; 
   }
   public void display()
   {
      Console.WriteLine("Title : {0}", title);
      Console.WriteLine("Author : {0}", author);
      Console.WriteLine("Subject : {0}", subject);
      Console.WriteLine("Book_id :{0}", book_id);
   }

};  
```
## 特点
您已经用了一个简单的名为 Books 的结构。在 C# 中的结构与传统的 C 或 C++ 中的结构不同。C# 中的结构有以下特点：

- 结构可带有方法、字段、索引、属性、运算符方法和事件。
- 结构可定义构造函数，但不能定义析构函数。但是，您不能为结构定义无参构造函数。无参构造函数(默认)是自动定义的，且不能被改变。
- 与类不同，结构不能继承其他的结构或类。
- 结构不能作为其他结构或类的基础结构。
- 结构可实现一个或多个接口。
- 结构成员不能指定为 abstract、virtual 或 protected。
- 当您使用 New 操作符创建一个结构对象时，会调用适当的构造函数来创建结构。与类不同，结构可以不使用 New 操作符即可被实例化。
- 如果不使用 New 操作符，只有在所有的字段都被初始化之后，字段才被赋值，对象才被使用。

# 命名空间(namespace)
- 命名空间的设计目的是提供一种让一组名称与其他名称分隔开的方式。在一个命名空间中声明的类的名称与另一个命名空间中声明的相同的类的名称不冲突。  
- 为了调用支持命名空间版本的函数或变量，会把命名空间的名称置于前面。  
例如：`namespace_name.item_name;`
- 命名空间可以被嵌套，即您可以在一个命名空间内定义另一个命名空间
```C#
using System;
using SomeNameSpace;
using SomeNameSpace.Nested;

namespace SomeNameSpace
{
    public class MyClass 
    {
        static void Main() 
        {
            Console.WriteLine("In SomeNameSpace");
            Nested.NestedNameSpaceClass.SayHello();
        }
    }

    // 内嵌命名空间

    namespace Nested   
    {
        public class NestedNameSpaceClass 
        {
            public static void SayHello() 
            {
                Console.WriteLine("In Nested");
            }
        }
    }
}
```
> In SomeNameSpace  
> In Nested