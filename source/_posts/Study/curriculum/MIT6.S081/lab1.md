---
title: lab1 Unix 实用工具
date: 2023-09-06 16:21:53
updated: 2023-09-21 17:14:14
categories:
  - Study
tags:
  - curriculum
  - MIT6.S081
toc: true
---
# sleep

```c
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int main(int argc, char **argv) {
    if(argc != 2){
        fprintf(2, "Usage: sleep number\n");
        exit(1);
    }
    
    sleep(atoi(argv[1]));
    exit(0);
}
```

# pingpong

[pipe函数介绍](../基础IO/#Pipe-函数)

```c
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int main(int argc, char *argv[]) {
    int pp2c[2], pc2p[2];
    pipe(pp2c);
    pipe(pc2p);

    // parent send in pp2c[1]
    // child send in pc2p[1]
    int pid = fork();
    if (pid != 0) {
        // parent
        close(pp2c[0]);
        close(pc2p[1]);
        write(pp2c[1], "o", 1);   // 首先发出
        char buf;
        read(pc2p[0], &buf, 1);   // 等待回复
        printf("%d: received pong\n", getpid());
        wait(0);
    } else {
        // child
        char buf;
        close(pp2c[1]);
        close(pc2p[0]);
        read(pp2c[0], &buf, 1);   // 收到数据
        printf("%d: received ping\n", getpid());
        write(pc2p[1], &buf, 1);  // 送回数据
        exit(0);
    }
    exit(0);
}
```

# prime

输出 2~35 之间的素数

```c
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

void sieve(int pleft[2]) {
    int p;

    int bytesRead = read(pleft[0], &p, sizeof(p)); // 读出来的第一个数一定是素数
    if (bytesRead == 0) {  // 读不出东西时，read函数返回0，代表读取完毕，退出程序
        exit(0);
    }
    printf("prime %d\n", p);

    // 创建下一个 subprocess 用的管道
    int pright[2];
    pipe(pright);

    if (fork() == 0) {
        // next subprocess
        close(pright[1]);   // 只需要读取，不需要输入
        close(pleft[0]);    // 父进程管道使用完毕，关掉
        sieve(pright);
        exit(0);
    } else {
        // current subprocess
        close(pright[0]);   // 只需要输入，不需要读取
        int buf;
        while (1) {
            bytesRead = read(pleft[0], &buf, sizeof(buf));
            if (bytesRead == 0) {  // 读到0时，代表管道清空，退出循环
                break;
            }
            if (buf % p != 0) { // 筛掉非素数
                write(pright[1], &buf, sizeof(buf));
            }
        }
        close(pleft[0]);  // 关闭管道
        close(pright[1]);  // 关闭管道
        wait(0);
        exit(0);
    }
}

int main(int argc, char *argv[]) {
    // main
    int p[2];
    pipe(p);

    if (fork() == 0) {
        // subprocess
        // 第一个子进程
        close(p[1]);    // 不需要插入，关闭插入管道
        sieve(p);
        exit(0);
    } else {
        // main
        close(p[0]);    // 主进程只需要输入，不需要读取
        int i;
        for (i = 2; i <= 35; i++) {
            write(p[1], &i, sizeof(i));
        }
        i = 0;  // 用0作为结束标识
        write(p[1], &i, sizeof(i));
        close(p[1]);  // 关闭管道
    }
    wait(0);
    exit(0);
}

```

# find

-  `de.inum==0` 表示这是一块已经初始化并且可以用来创建文件或者文件夹的位置，所以在读取的过程中应当无视这一块空间

```c
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"

int
find(char *path, char *fName)
{
    char buf[512], *p;
    int fd;
    struct dirent de;   // xv6文件系统中的目录层结构
    struct stat st;
    int findSuccess = 0;

	// 打开文件
    if((fd = open(path, 0)) < 0){
        fprintf(2, "find: cannot open %s\n", path);
        return -1;
    }

	// 读取状态
    if(fstat(fd, &st) < 0){
        fprintf(2, "find: cannot stat %s\n", path);
        close(fd);
        return -1;
    }

    // 读取目录并且将其放入到buf中，用一个活动的指针p去对buf中的内容进行拼接和修饰操作
    strcpy(buf, path);
    p = buf + strlen(buf);
    *p++ = '/';

	// 循环，判断条件为是否成功从句柄fd中读取dirent结构（目录层），使用read()函数将读取到的dirent存储到de中
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
        if(de.inum == 0)
            continue;

        if(!strcmp(de.name, ".") || !strcmp(de.name, ".."))
            continue;

		// 拼接de.name到buf末尾，获得fd指向的目录下的一个文件完整路径
        memcpy(p, de.name, DIRSIZ);
        p[DIRSIZ] = 0;

        if(stat(buf, &st) < 0){
            printf("find: cannot stat %s\n", buf);
            continue;
        }

        switch(st.type){
        case T_FILE:
            if (strcmp(de.name, fName) == 0)
            {
                printf("%s\n", buf);
                findSuccess = 1;
            }
            break;

        case T_DIR:
            findSuccess = find(buf, fName);
            break;
        }
    }
    close(fd);
    return findSuccess;
}

int 
main(int argc, char *argv[]) 
{
    int findSuccess = 0;

    if (argc < 2 || argc > 3) {
        fprintf(2, "find: Wrong usage... \n");
        exit(0);
    }

    if (argc == 2)
        findSuccess = find(".", argv[1]);
    if (argc == 3)
        findSuccess = find(argv[1], argv[2]);

    if (findSuccess == 0)
        printf("Cannot find the target...\n");
    
    exit(0);
}
```

# xargs

- 用 read 或者 get 读取管道传来的输入流
- 传来的输入流末尾会带一个换行 `'\n'`

```c
#include "kernel/param.h"
#include "kernel/types.h"
#include "user/user.h"

void run(char *program, char **args) 
{
    if (fork() == 0) {
        exec(program, args);
        exit(0);
    }
    return;
}

int
main (int argc, char *argv[])
{
    // buf缓冲区，用来读取管道传来的输入流
    // xargs数组用来保存xargs命令之后的参数
    // index指向xargs下一个参数写入下标
    char *xargs[MAXARG], buf[2048];
    int index = argc - 1;
    // 优先填入xargs自带参数
    for (int i = 1; i < argc; i++)
        xargs[i - 1] = argv[i];

    // 从标准输入0读取到缓冲区中
    char *p = buf;
    xargs[index] = buf;
    while (read(0, p, 1) != 0) {
        // 将空格或者\n设置为0，代表结尾
        if (*p == ' ' || *p == '\n') {
            *p = 0;
            // 设置下一个参数从空格后开始
            xargs[++index] = p + 1;

            if (*p == '\n') {
                // 创建子进程开始执行，并重置下标，开始第二个指令
                run(argv[1], xargs);
                index = argc - 1;
            }
        }
        p++;
    }
    
    run(argv[1], xargs);

    wait(0);
    exit(0);
}
```