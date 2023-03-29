---
title: git
date: 2023-03-18 15:41:53
updated: 2023-03-18 15:41:53
categories:
- Memo
tags:
- tools
---

# 配置
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
# 查看 submodules
# 结果的 hash 前不带符号说明该 module 正常且提交版本同步（提交版本同步指主项目记录提交版本与子模块当前提交版本一致）
# 结果的 hash 前带 - 号说明该 module 未初始化
# 结果的 hash 前带 + 号说明该 module 版本未同步
git submodule
git submodule status

# 初始化 modules，重复初始化无影响，例子中后跟 名称 为指定初始化某个 module 的名称（下同）
git submodule init
git submodule init [submodule 名称]

# 版本未同步时，检出 modules，保证检出的版本与主项目匹配，但子 module 会创建临时分支
git submodule update
git submodule update [submodule 名称]

# 添加 submodule，例子中后跟 名称 为该 module 名称与目录名
git submodule add [submodule 地址]
git submodule add [submodule 地址] [目录]

# 强制添加 submodule（仅用于 git submodule 没有正确的显示某个 module）
git submodule add --force --name [submodule 名称] [submodule 地址]

# 遍历所有 submodule 执行指定命令
# git submodule foreach 其他命令，如：
git submodule foreach git pull
git submodule foreach ls -l
```

## 复合命令

```shell
# 重新 clone 项目（含 clone 所有子项目）方式一
git clone --recursive [submodule 地址]

# 重新 clone 项目（含 clone 所有子项目）方式二，依次执行以下命令
git clone [submodule 地址]
git submodule init
git submodule update

# pull 项目，并检出新增 submodule
git pull
git submodule init
git submodule update [submodule 名称]

# pull 项目，并移除废弃 submodule
# 建议重新 clone 项目

# pull 项目，并重命名 submodule
# 建议重新 clone 项目
```

## 说明：

- 子项目更新，直接使用 git pull 即可。如果想让提交版本同步，主项目使用 git submodule update [submodule 名称]
- 新增 submodule 部分 IDE 工具需要新打开主项目才行，包括 IDEA

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

#### 其他合作伙伴更新

- 建议重新 clone 项目
- 如果不想废弃本地仓库的话，和上述做法一致，就是没有修改【.gitmodules】这一步了

