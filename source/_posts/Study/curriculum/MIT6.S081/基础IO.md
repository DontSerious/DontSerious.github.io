---
title: LINUX 基础IO
date: 2023-09-02 11:33:07
updated: 2023-09-02 11:33:07
categories:
     - Study
tags:
     - linux
toc: false
---

# OPEN

```c
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
int open(const char *pathname, int flags);
int open(const char *pathname, int flags, mode_t mode);
pathname: 要打开或创建的目标文件
flags: 打开文件时，可以传入多个参数选项，用下面的一个或者多个常量进行“或”运算，构成flags。
参数:
O_RDONLY: 只读打开
O_WRONLY: 只写打开
O_RDWR : 读，写打开
这三个常量，必须指定一个且只能指定一个
O_CREAT : 若文件不存在，则创建它。需要使用mode选项，来指明新文件的访问权限
O_APPEND: 追加写
返回值：
成功：新打开的文件描述符
失败：-1
```

## 0 & 1 & 2

Linux进程默认情况下会有3个缺省打开的文件描述符，分别是标准输入0，标准输出1，标准错误2.  
0,1,2对应的物理设备一般是：键盘，显示器，显示器

# 重定向

## fd 分配规则

```c
int main()
{
	close(1);
	int fd = open("myfile", O_WRONLY|O_CREAT, 00644);
	if(fd < 0){
		perror("open");
		return 1;
	}
	printf("fd: %d\n", fd);
	fflush(stdout);
	close(fd);
	exit(0);
}

```

以上第三行 close 执行后，write 往 fd 中写数据，显示器上不会显示，而回写入到文件中

分配规则：
1. 系统会将012分配给标准输入，标准输出，标准错误。（因为底层要和硬件进行交互）  
2. 当我们提前关闭其中的一个时候会发现，fd 会选择下标小的进行分配。  
3. 这样也就引入了重定向

`close(1)` 执行之后，1就是最小的下标，open 一个文件通过文件描述符 fd 来描述，此时 fd 的值就为1，而后边向显示器中输入就会重定向到文件里。

## 例子

`redirect`

```c
int main() {
	int pid;

	pid = fork();
	if(pid == 0) {
		close(1);
		open("output.txt", 0_WRONLY|0_CREATE);

		char *argv[] = { "echo", "this", "is", "redirected", "echo", 0 }; // 0 表示到达结尾
		exec("echo", argv);
		printf("exec failed!\n");
		exit(1);
	} else {
		wait((int *) 0);
	}

	exit(0);
}
```

```powershell
$ redirect
$ cat output.txt
this is redirected echo
```