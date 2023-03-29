---
title: Linux 备忘基操
date: 2023-02-24 17:28:00
updated: 2023-02-24 17:28:00
categories:
- Memo
tags:
- linux
---
# Linux 查看当前版本
```
cat /etc/issue
```
# Debian 11 换源
```
cat >> /etc/apt/sources.list  << EOF
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye main contrib non-free
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-updates main contrib non-free
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-backports main contrib non-free
deb https://mirrors.tuna.tsinghua.edu.cn/debian-security bullseye-security main contrib non-free
# deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye main contrib non-free
# deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-updates main contrib non-free
# deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-backports main contrib non-free
# deb-src https://mirrors.tuna.tsinghua.edu.cn/debian-security bullseye-security main contrib non-free
EOF
```

# 版本不对头使用 aptitude install

# 释放占用端口

```bash
# 假设要释放端口 1997
netstat -tln | grep 1997    # 查找端口号网络连接情况
lsof -i:1997                # 找到端口号对应的进程
# 假设 1997 端口对应进程PID为 29999
kill -9 29999
```

# 查看开机日志 dmesg