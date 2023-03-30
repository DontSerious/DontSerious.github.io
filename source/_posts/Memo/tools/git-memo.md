---
title: git
date: 2023-03-18 15:41:53
updated: 2023-03-30 15:42:59
categories:
- Memo
tags:
- tools
---

# 配置

## linux生成ssh key

```
ssh-keygen -t ed25519 -C "1090087271@qq.com"
```

默认情况下，GitHub 支持的公钥的文件名是以下之一：

- id_rsa.pub
- id_ecdsa.pub
- id_ed25519.pub

## github用户名邮箱设置
```bash
# --global 全局
git config --global user.name  "username"  
git config --global user.email  "email"
git config --replace-all user.name "name"
git config --replace-all user.email "email"
```

# clone 下来的项目脱离git管理
删除.git文件夹`git rm --cached`  
解决“子项目错误”问题，会导致外层git也脱离  

# 子项目

*sort form [掘金](https://juejin.cn/post/6948251963133788196)*

## 常用命令

```shell
# 结果的 hash 前带 - 号说明该 module 未初始化
# 结果的 hash 前带 + 号说明该 module 版本未同步
git submodule status

# 初始化 modules，重复初始化无影响，例子中后跟 名称 为指定初始化某个 module 的名称（下同）
git submodule init [submodule 名称]

# 添加 submodule，例子中后跟 目录 为该 module 名称与目录名
git submodule add [submodule 地址] [目录]

# 版本未同步时，检出 modules，保证检出的版本与主项目匹配，但子 module 会创建临时分支
git submodule update [submodule 名称]

# 如果 status 已存在子项目且最前面带个负号
git submodule update --init [submodule 名称]

# 遍历所有 submodule 执行指定命令
# git submodule foreach 其他命令，如：
git submodule foreach git pull
git submodule foreach ls -l
```

```shell
# pull 项目，并移除废弃 submodule
# 建议重新 clone 项目

# pull 项目，并重命名 submodule
# 建议重新 clone 项目
```

## 删除子项目

### 废弃本地仓库的做法（推荐）

- 修改【.gitmodules】文件内容：去除被删除的 submodule 内容
- 提交修改并推送到远程仓库
- 重新 clone 仓库

### 不废弃本地仓库的做法（不推荐）

- 假设 submodule 名称为 subA
- 非必须步骤不做也行，但日后重复添加相同名称的 submodule 时，可能存在问题
- 如果想反悔（不删了）的话，git reset --hard HEAD 即可，再次强调所有修改都已提交再操作

```
 1. 缓存清理：`git rm -r --cached subA`
 	- 执行前请保证所有修改都已提交
 	- 验证上述步骤是否成功：`git submodule` 的结果没有 subA
 	- 这个必须第一个执行，后续的操作则无所谓顺序了
 2. 删除对应目录：`rm -rf subA/`
 3. 修改【.gitmodules】文件内容：去除被删除的 submodule 内容
 	- 修改后，就可以提交修改并推送远程仓库了
 4. 非必须，修改【.git/config】文件内容：去除被删除的 submodule 内容
 5. 非必须，删除【.git/modules】目录下对应 submodule 目录
```