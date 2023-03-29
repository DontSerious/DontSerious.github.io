---
title: wsl 备忘基操
date: 2023-02-24 10:24:20
updated: 2023-02-24 10:24:20
categories:
- Memo
tags:
- linux
toc: true
---
# 安装 WSL
```
# 此方法安装默认使用wsl2 之后无需额外设置
wsl --install -d Debian

# 检查版本
cat /etc/issue

# 重装
wsl --unregister Debian
wsl --install -d Debian
```
## 修改 root 密码
### powershell中输入 设置进入root用户
> Debian config --default-user root
### 进入wsl系统 输入此命令按提示修改密码
> passwd
### powershell 根据个人需求选择是否设置回普通用户
> Debian config --default-user tomato

## 记得换源

## 迁移wsl位置到其他盘
```
#导出系统
wsl --export Debian E:\Debian2.tar

#取消挂载（删除debian系统）
wsl --unregister Debian

#重新挂载到E盘wsl2目录下
wsl --import Debian E:\wsl2\Debian E:\Debian2.tar
```

# WSL操作 [高级系统配置官方文档](https://learn.microsoft.com/zh-cn/windows/wsl/wsl-config#wslconfig)
## hosts问题

wsl会自动获取物理机hosts文件内容，如果要改善git速度问题，建议在物理机安装[SwitchHosts](https://github.com/oldj/SwitchHosts)

配置参考下面：

- Title: 随意

- Type: Remote

- URL: https://raw.hellogithub.com/hosts

- Auto Refresh: 最好选 1 hour

## 在物理机资源管理器访问wsl文件
### 在wsl命令行输入
`explorer.exe .`  
访问当前目录
### 资源管理器输入
`\\wsl$\{distro name}\`

## 配置WSL性能
在文件 `%USERPROFILE%\.wslconfig` 中配置
```Bash
[wsl2]
memory=8GB          # 运存
processors=3        # 处理器
debugConsole=true   # 启动时开启debug窗口
```

## 加速启动

### 配置wsl不自动挂载全部硬盘

在虚拟机`/etc/wsl.conf`中新增
```Bash
[automount]
enabled=false           # 关闭自动挂载
mountFsTab = true       # 如果需要单独挂载则开启FsTab配置挂载
```

### 配置/etc/fstab实现自动单独挂载
示例：
`C:  /mnt/c  drvfs rw,noatime,uid=1000,gid=1000,fmask=0027,dmask=0027,metadata 0 0`