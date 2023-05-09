---
title: cp3 程序的机器级表示
categories:
  - Study
tags:
  - csapp
toc: true
date: 2023-04-09 14:54:13
updated: 2023-05-09 15:52:22
---
# 名词

- ISA：Instruction Set Architecture(指令集架构)的缩写，也叫指令集体系结构。它定义了机器级程序的格式和行为，它定义了处理器状态、指令的格式，以及每条指令对状态的影响。
- PC：程序计数器，在x86-64中称为`%rip`，表示下一条要执行的指令在内存中的地址。
- scalar data types：标量数据类型，是计算机科学中的一个术语。标量是指一种基本的数据类型，它表示单个值，并且不可拆分为更小的部分。标量数据类型在程序设计中非常常见，包括整数、浮点数、字符和布尔型等。
- vector：向量，表示一种被用于向量数据计算或是多媒体处理等运算的指令集或硬件加速器。这些指令集和硬件加速器通常用于执行一些对于大规模数据和向量的加速运算，如矩阵乘法、卷积等。

# gcc

## 参数

### 优化等级

`-Og`：告诉编译器使用会生成符合原始C代码整体结构的机器代码的优化等级
- 使用较高的优化级别优化产生的代码会严重变形，以至于产生的机器代码和初始源代码之间的关系难以理解。
- 实际上，从得到的程序的性能考虑，较高级别的优化被认为是较好的选择
  - 例如，以选项 `-O1` 或 `-O2` 指定

### 汇编代码

C预处理器扩展源代码，插入所有用`#include`命令指定的文件，并扩展所有用`#define`声明指定的宏。

`-S`：能看到C语言编译器产生的汇编代码。
- 生成 `*.s` 汇编文件，但是不做其他进一步的工作。

### 目标代码

汇编器将 `*.s` 文件的汇编代码转换为二进制的目标代码文件。并生成目标代码文件 `*.o`。
- 包含所有指令的二进制表示，但还没填入全局的地址

`-c`：GCC会编译并汇编该代码，生成 `*.o` 文件 
- 它是二进制格式的，无法直接查看

### 可执行代码

`-o`：链接器将目标代码文件 `*.o` 与实现库函数的代码合并，并产生最终的可执行代码文件。
- 文件名由 `-o 文件名` 指定

### 反汇编器

`objdump -d 文件名`：根据机器代码产生一种类似于汇编代码的格式。针对`*.o`文件。

# 数据格式

| C declaration | Intel data type  | Assembly-code | suffix	Size (bytes) |
| :-----------: | :--------------: | :-----------: | :-----------------: |
|     char      |       Byte       |       b       |          1          |
|     short     |       Word       |       w       |          2          |
|      int      |   Double word    |       l       |          4          |
|     long      |    Quad word     |       q       |          8          |
|    char *     |    Quad word     |       q       |          8          |
|     float     | Single precision |       s       |          4          |
|    double     | Double precision |       l       |          8          |

# 访问信息

1. 最初的8086中有 8 个 16 位的寄存器，即下表中 %ax ~ %sp
2. IA32中寄存器扩展为32位，标号有 %eax ~ %esp
3. X86-64中寄存器扩展成64位，编号有 %rax ~ %rsp，还增加了 8 个寄存器

| 63 ~ 31 | 31 ~ 15 | 15 ~ 7 | 7 ~ 0 |     usage     |
| :-----: | :-----: | :----: | :---: | :-----------: |
|  %rax   |  %eax   |  %ax   |  %al  | return value  |
|  %rbx   |  %ebx   |  %bx   |  %bl  | Callee saved  |
|  %rcx   |  %ecx   |  %cx   |  %cl  | 4th argument  |
|  %rdx   |  %edx   |  %dx   |  %dl  | 3rd argument  |
|  %rsi   |  %esi   |  %si   | %sil  | 2nd argument  |
|  %rdi   |  %edi   |  %di   | %dil  | 1st argument  |
|  %rbp   |  %ebp   |  %bp   | %bpl  | Callee saved  |
|  %rsp   |  %esp   |  %sp   | %spl  | Stack pointer |
|   %r8   |  %r8d   |  %r8w  | %r8b  | 5th argument  |
|   %r9   |  %r9d   |  %r9w  | %r9b  | 6th argument  |
|  %r10   |  %r10d  | %r10w  | %r10b | Callee saved  |
|  %r11   |  %r11d  | %r11w  | %r11b | Callee saved  |
|  %r12   |  %r12d  | %r12w  | %r12b | Callee saved  |
|  %r13   |  %r13d  | %r13w  | %r13b | Callee saved  |
|  %r14   |  %r14d  | %r14w  | %r14b | Callee saved  |
|  %r15   |  %r15d  | %r15w  | %r15b | Callee saved  |

- 字节级操作可以访问最低的字节
- 16位操作可以访问最低的两个字节
- 32位操作可以访问最低的四个字节
- 64位操作可以访问整个寄存器

## 操作数指示符

![](source/static/CSAPP/f3.3.png)

- 立即数(immediate): 在ATT格式的汇编代码中，立即数的书写方式是 `$` 后面跟一个用标准 C 表示法表示的整数，例如`$-577`、`$0x1F`。
- 寄存器(register): ra 表示任意寄存器a，用引用 R[ra] 来代表它的值
- 内存引用：根据地址访问内存位置。用符号 Mb[Addr] 表示对存储在内存中从地址 Addr 开始的 b 个字节值的引用。通常省略 b
- 最下面的表示是最常用的形式

## 数据传送指令

- S：源操作数（source operand）
- D：目标操作数（destination operand）
- I：立即数操作数（immediate operand）
- R：寄存器操作数（register operand）

### 简单的数据传送指令

- 根据源操作数选择指令
- 使用到操作数格式寻址时，必须为64位寄存器
- 两个操作数不能都为内存地址，进行mov其中一个必须为寄存器
- 不能以立即数作为目标操作数

|   Instruction   | Effect |       Description       |
| :-------------: | :----: | :---------------------: |
| mov	       S, D | D ← S  |          Move           |
|      movb       |        |        Move byte        |
|      movw       |        |        Move word        |
|      movl       |        |    Move double word     |
|      movq       |        |     Move quad word      |
| movabsq	   I, R | R ← I  | Move absolute quad word |

- movl 指令以寄存器作为目标时，会把该寄存器的高位4字节设置为0
  - x86-64采用的惯例，即任何为寄存器生成32位值的指令都会将该寄存器的高位部分设置为0

### 零扩展数据传送指令

| Instruction |      Effect       |              Description               |
| :---------: | :---------------: | :------------------------------------: |
|  movz S,R   | R ← ZeroExtend(S) |        Move with zero extension        |
|   movzbw    |                   |    Move zero-extended byte to word     |
|   movzbl    |                   | Move zero-extended byte to double word |
|   movzwl    |                   | Move zero-extended word to double word |
|   movzbq    |                   |  Move zero-extended byte to quad word  |
|   movzwq    |                   |  Move zero-extended word to quad word  |

- 以寄存器或内存为源，以寄存器作为目的
- MOVZ 类指令把目的中的剩余的字节填充为0

### 符号扩展数据传送指令

| Instruction |         Effect          |                 Description                 |
| :---------: | :---------------------: | :-----------------------------------------: |
|  movs S,R   |    R ← SignExtend(S)    |          Move with sign extension           |
|   movsbw    |                         |       Move sign-extended byte to word       |
|   movsbl    |                         |   Move sign-extended byte to double word    |
|   movswl    |                         |   Move sign-extended word to double word    |
|   movsbq    |                         |    Move sign-extended byte to quad word     |
|   movswq    |                         |    Move sign-extended word to quad word     |
|   movslq    |                         | Move sign-extended double word to quad word |
|    cltq     | %rax ← SignExtend(%eax) |          Sign-extend %eax to %rax           |

- 以寄存器或内存为源，以寄存器作为目的
- cltq 指令它没有操作数，总是以 %eax 为源，以 %rax 为符号扩展结果的目的。它的效果和 `movslq %eax, %rax` 完全一致
- MOVZ 类指令通过符号扩展来填充，把源操作的最高位进行复制

## 压入和弹出栈数据

| Instruction |                  Effect                  |  Description   |
| :---------: | :--------------------------------------: | :------------: |
|   pushq S   | R[%rsp] ← R[%rsp] –8;<br>M[R[%rsp]] ← S  | Push quad word |
|   popq D    | D ← M[R[%rsp]];<br>R[%rsp] ← R[%rsp] + 8 | Pop quad word  |

pushq 等价
```
subq $8,%rsp
movq %rbp,(%rsp)
```
popq 等价
```
movq (%rsp),%rax
addq $8,$rsp
```

- 虽然等价，但是 pushq 和 popq 的指令编码仅为一个字节，而上面两条指令一共需要八个字节
- 栈和程序代码以及其它形式的程序数据都放在同一内存中，所以程序可以用标准的内存寻址方法访问栈内任何位置

# 算数和逻辑操作

| Instruction |     Effect     |       Description        |
| :---------: | :------------: | :----------------------: |
|  leaq S, D  |     D ← &S     |  Load effective address  |
|    inc D    |   D ← D + 1    |        Increment         |
|    dec D    |   D ← D - 1    |        Decrement         |
|    neg D    |     D ← -D     |          Negate          |
|    not D    |     D ← ~D     |        Complement        |
|  add S, D   |   D ← D + S    |           Add            |
|  sub S, D   |   D ← D - S    |         Subtract         |
|  imul S, D  |   D ← D * S    |         Multiply         |
|  xor S, D   |   D ← D ^ S    |       Exclusive-or       |
|   or S, D   | D ← D &#124; S |            Or            |
|  and S, D   |   D ← D & S    |           And            |
|  sal k, D   |   D ← D << k   |        Left shift        |
|  shl k, D   |   D ← D << k   | Left shift (same as sal) |
|  sar k, D   |  D ← D >>A k   |  Arithmetic right shift  |
|  shr k, D   |  D ← D >>L k   |   Logical right shift    |

- 加载有效地址(leaq)指令通常用来执行简单的算术操作
- ATT格式的汇编代码中操作数的顺序与一般的直觉相反

## 加载有效地址(leaq)

- 实际上是movq指令的变形，指令形式是从内存读数据到寄存器，但实际上根本没有引用内存
- 该指令并不是从指定的位置读入数据，而是将有效地址写入到目的操作数
- 它可以简洁的描述普通的算术操作
  - 如果寄存器 %rdx 的值为 x，那么指令 `leaq 7(%rdx, %rdx, 4)`，%rax 将设置寄存器 %rax 的值为 `5x + 7`
- 目的数必须为一个寄存器

例如：  

c程序
```c
long scale(long x, long y, long z) {
    long t = x + 4 * y + 12 * z;
    return t;
}
```
编译时，算术运算将以三条 leaq 指令实现：
```
  // long scale(long x, long y, long z)
  // x in %rdi, y in %rsi, z in %rdx
scale:
  leaq	(%rdi,%rsi,4), %rax		// x + 4*y
  leaq	(%rdx,%rdx,2), %rdx		// z + 2*z = 3*z
  leaq	(%rax,%rdx,4), %rax		// (x+4*y) + 4*(3*z) = x + 4*y + 12*z
  ret
```

- 它能执行加法和有限形式的乘法

## 二元操作

- 源操作数是第一个，目的操作数是第二个
  - `subq %rax,%rdx` 可以解读为：从%rdx中减去%rax
- 第一个操作数可以是立即数、寄存器或是内存位置
- 第二个操作数可以是寄存器或是内存地址。
  - 当第二个数位内存地址时，处理器必须从内存读出值，执行操作，再把结果写回内存

## 移位操作 SA

`SAL 移位量, 移位的数`

- 移位量可以是一个立即数，或者放在单字节寄存器 %cl 中(能且只能放在这个特定寄存器)
- 当寄存器 %cl 的十六进制值为 0xFF 时，salb 会移 7 位，salw 会移 15 位，sall 会移 31 位，salq 会移 63 位
- 左移指令有两个名字：SAL 和 SHL
  - 两者效果一致，都是将右边填上0
- 右移指令不同
  - SAR执行算术移位(填上符号位)
  - SHR执行逻辑以为(填上0)

## xorq %rdx,%rdx

- 这个指令用来将寄存器设置为0
- 最直接的方法是 movq $0,%rdx
- xorq版本只需要三个字节，movq版本则需要七个字节

## 特殊的算术操作

- x86-64 指令集对 128 位(16 字节)数的操作提供有限的支持。
- 延续字(2字节)、双字(4字节)和四字(8字节)的命名惯例，Intel 把16字节的数称为八字(oct word)。

| Instruction |                              Effect                               |      Description       |
| :---------: | :---------------------------------------------------------------: | :--------------------: |
|   imulq S   |                   R[%rdx]:R[%rax] ← S × R[%rax]                   |  Signed full multiply  |
|   mulq S    |                   R[%rdx]:R[%rax] ← S × R[%rax]                   | Unsigned full multiply |
|    cqto     |               R[%rdx]:R[%rax] ← SignExtend(R[%rax])               |  Convert to oct word   |
|   idivq S   | R[%rdx] ← R[%rdx]:R[%rax] mod S;<br>R[%rax] ← R[%rdx]:R[%rax] ÷ S |     Signed divide      |
|   divq S    | R[%rdx] ← R[%rdx]:R[%rax] mod S;<br>R[%rax] ← R[%rdx]:R[%rax] ÷ S |    Unsigned divide     |

# 控制

## 条件码

- cf: 进位标志：最近的操作使最高位产生了进位。可用来检查无符号操作的溢出。
  - (unsigned) t < (unsigned) a
  - Unsigned overflow
- zf: 零标志：最近的操作得出的结果为 0，如果两个操作数相等，零标志设置为 1
  - (t == 0)
  - Zero
- sf: 符号标志：最近的操作得到的结果为负数
  - (t < 0)
  - Negative
- of: 溢出标志：最近的操作导致一个补码溢出--正溢出或负溢出
  - (a < 0 == b < 0) && (t < 0 ! = a < 0)
  - Signed overflow

## 访问条件码

条件码通常不会直接读取，常见使用方式：

1. 可以根据条件码的某种组合，将一个字节设置为 0 或 1
2. 可以条件跳转到程序的某个其他的部分
3. 可以有条件地传送数据

![](source/static/CSAPP/f3.14set.png)

## 跳转指令

![](source/static/CSAPP/f3.15jmp.png)

```
  movq	%rdi, %rax
  jmp	.L2
.L3:
  sarq	%rax
.L2:
  testq	%rax, %rax
  jg	.L3
  rep; ret
```

汇编器产生的“. o”格式的反汇编版本如下：

```
0:	48 89 f8	mov	%rdi,%rax
3:	eb 03		jmp	8 <loop+0x8>
5:	48 d1 f8	sar	%rax
8:	48 85 c0	test	%rax,%rax
b:	7f f8		jg	5 <loop+0x5>
d:	f3 c3		repz retq
```

链接后的程序反汇编版本：

```
4004d0: 48 89 f8	mov %rdi,%rax
4004d3: eb 03		jmp 4004d8 <loop+0x8>
4004d5: 48 d1 f8	sar %rax
4004d8: 48 85 c0	test %rax,%rax
4004db: 7f f8		jg 4004d5 <loop+0x5>
4004dd: f3 c3		repz retq
```

## 条件控制实现条件分支

goto 风格代码与汇编代码实现条件控制时非常相似

c 语言中 if-else 语句的通用形式：

```c
if (test-expr)
	then-statement
else
	else-statement
```

Goto 风格代码块：

```c
	t = text-expr;
	if (!t)
		goto false;
	then-statement
	goto done;
false:
	else-statement
done:
```

其中的 goto 在汇编中为 jmp 指令

### 练习

```c
long test(long x, long y, long z) {
  long val = x + y + z;
  if (x < -3) {
  	if (y < z)
  		val = x * y;
  	else
  		val = y * z;
  } else if (x > 2)
	  	val = x * z;
  return val;
}
```

gcc 产生如下汇编代码

```
  long test(long x, long y, long z)
  x in %rdi, y in %rsi, z in %rdx
  
  test:
  leaq	(%rdi,%rsi), %rax
  addq	%rdx, %rax
  cmpq	$-3, %rdi
  jge	.L2
  cmpq	%rdx, %rsi
  jge	.L3
  movq	%rdi, %rax
  imulq	%rsi, %rax
  ret
  .L3:
  movq	%rsi, %rax
  imulq	%rdx, %rax
  ret
  .L2:
  cmpq	$2, %rdi
  jle	.L4
  movq	%rdi, %rax
  imulq	%rdx, %rax
  .L4:
  rep; ret
```

## 条件传送实现条件分支

条件操作的传统方式简单而通用，但在现代处理器上可能会非常低效。

![](source/static/CSAPP/f3.18cmov.png)

条件传送指令。当传送条件满足时，指令把源值 S 复制到目的 R

同条件跳转不同，处理器无需预测测试的结果就可以执行条件传送。**但不是所有情况下都可以使用条件传送。**

```c
v = test-expr ? then-expr : else-expr
```

用条件控制转移的标准方法编译：

```c
  if (!test-expr)
  	goto false;
  v = then-expr;
  goto done;
false:
  v = else-expr;
done:
```

基于条件传送代码会对两数都求值，可以用下面的抽象代码描述：

```c
v = then-expr;
ve = else-expr;
t = test-expr;
if (!t) v = ve;
```

- GCC 只有在两个表达式都很容易计算时，例如表达式分别都是一条加法指令，它才会使用条件传送。
- 即使许多分支预测错误的开销会超过更复杂的计算，GCC 还是会使用条件控制转移。
- 条件数据传送提供了一种用条件控制转移来实现条件操作的替代策略。它们只能用于非常受限制的情况。

## 循环

### while 循环

C

```c
long fact_while(long n)
{
	long result = 1;
	while (n > 1) {
		result *= n;
		n = n-1;
	}
	return result;
}
```

Goto version

```c
long fact_while_jm_goto(long n)
{
	long result = 1;
	goto test;
loop:
	result *= n;
	n = n-1;
test:
	if (n > 1)
	goto loop;
	return result;
}
```

assembly-language code

```
long fact_while(long n)
n in %rdi

fact_while:
  movl	$1, %eax	         Set result = 1
  jmp	.L5		             Goto test
.L6:		             loop:
  imulq	%rdi, %rax	         Compute result *= n
  subq	$1, %rdi	         Decrement n
.L5:		             test:
  cmpq	$1, %rdi	         Compare n:1
  jg	.L6		             If >, goto loop
  rep; ret		             Return
```

### Guarded-do 翻译方法

- 首先使用条件分支
- 如果初始条件不成立就跳过循环，把代码变换为 do-while 循环。
- 当使用较高优化等级时，例如使用命令行选项 `-O1` 时，GCC 会采用这种策略。

```c
t = test-expr;
if (!t)
	goto done;
do
	body-statement
	while (test-expr);
done:
```

Goto version

```c
t = test-expr;
if (!t)
	goto done;
loop:
	body-statement
	t = test-expr;
	if (t)
	goto loop;
done:
```

# 过程

## 运行时栈

![](source/static/CSAPP/f3.25stack%20frame.png)

- 通用的栈帧结构
- 栈用来传递参数、存储返回信息、保持寄存器，以及局部存储
- 为了提高空间和时间效率，`x86-64` 过程只分配自己所需要的栈帧部分
- 许多过程有 6 个或者更少的参数，那么所有的参数都可以通过寄存器传递
- 实际上，许多函数甚至根本不需要栈帧
- 当所有的局部变量都可以保存在寄存器中，而且该函数不会调用任何其他函数时，就可以这样处理。

### 练习

汇编代码：

```
	Disassembly of leaf(long y)
	y in %rdi
1	0000000000400540 <leaf>:
2	400540:	48 8d 47 02	lea	0x2(%rdi),%rax	L1: z+2
3	400544:	c3		retq			L2: Return

4	0000000000400545 <top>:
	Disassembly of top(long x)
	x in %rdi
5	400545:	48 83 ef 05	 sub	$0x5,%rdi	T1: x-5
6	400549: e8 f2 ff ff ff	callq   400540 <leaf>	T2: Call leaf(x-5)
7	40054e: 4801c0		add	%rax,%rax	T3: Double result
8	400551:c3		retq			T4: Return
	...
	Call to top from function main
9	40055b: e8 e5 ff ff ff	callq	400545 <top>	M1: Call top(100)
10	400560: 4889c2		mov	%rax,%rdx	M2: Resume
```

代码执行过程表：

![](source/static/CSAPP/f3.27.png)
