---
title: git
date: 2023-03-18 15:41:53
updated: 2023-04-08 13:39:45
categories:
- Memo
tags:
- tools
toc: true
---
# 配置

## 将 SSH 密钥添加到 ssh-agent

### 启动 SSH 代理

要允许 `git` 使用您的 `SSH` 密钥，需要在您的设备上运行 SSH 代理。

要检查它是否已运行，请运行 `ps` 命令。如果 `ssh` 代理已在运行，它应该出现在输出中，例如：

```bash
$ ps -auxc | grep ssh-agent
tomato      1317  0.0  0.0   7972  3316 ?        Ss   15:03   0:00 ssh-agent
```

要启动代理，请运行：

```bash
eval $(ssh-agent)
```

最后需要将此命令添加到 `~/.bashrc`、`~/.zshrc`、`~/.profile` 或等效的 `shell` 配置文件中。将此命令添加到 `shell` 配置文件将确保打开终端时代理正在运行。

### 创建 SSH 密钥对

使用 `ssh-keygen` 生成 SSH 密钥对，例如：

```
cd ~/.ssh
ssh-keygen -t ed25519 -b 4096 -C "{username@emaildomain.com}" -f {ssh-key-name}
```

完成后，`ssh-keygen` 将输出两个文件：

- {ssh-key-name} — 私钥。
- {ssh-key-name}.pub — 公钥。

#### bitbucket

- {username@emaildomain.com} 是与 Bitbucket Cloud 帐户关联的电子邮件地址，例如您的工作电子邮件帐户。
- {ssh-key-name} 是键的输出文件名。我们建议使用可识别的名称，例如bitbucket_work。

#### github

默认情况下，GitHub 支持的公钥的文件名是以下之一：

- id_rsa.pub
- id_ecdsa.pub
- id_ed25519.pub

### 添加ssh密钥对给ssh-agent代理

```bash
ssh-add /path/to/your/ssh-key1
ssh-add /path/to/your/ssh-key2
```

每次重启都会导致ssh-agent的配置消失，所以需要将ssh-add命令添加到 `~/.bashrc`、`~/.zshrc`、`~/.profile` 或等效的 `shell` 配置文件中，保证每次启动都自动代理ssh密钥对。

同时也建议配置 `ssh-agent -k` 到 `~/.bash_logout` 文件中，用于离开时关闭代理。

## github用户名邮箱设置
```bash
# --global 全局
git config --global user.name  "username"  
git config --global user.email  "email"
git config --replace-all user.name "name"
git config --replace-all user.email "email"
```

# 常用指令

## 切换远程仓库

`git remote -v` 查看远程仓库的地址

### 修改远程仓库地址

`git remote set-url origin URL` 更换远程仓库地址，URL为新地址。

### 先删除远程仓库地址，然后再添加

`git remote rm origin` 删除现有远程仓库
`git remote add origin url` 添加新远程仓库

## clone 下来的项目脱离git管理
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