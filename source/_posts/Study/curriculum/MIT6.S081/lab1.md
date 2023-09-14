---
title: lab1 Unix 实用工具
date: 2023-09-06 16:21:53
updated: 2023-09-06 16:21:53
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