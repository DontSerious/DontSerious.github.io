---
title: lab1 Unix 实用工具
date: 2023-09-06 16:21:53
updated: 2023-09-18 13:31:27
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