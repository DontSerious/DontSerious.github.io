---
title: go memo
categories:
  - BackEnd
tags:
  - go
toc: true
date: 2023-04-11 15:12:19
updated: 2023-04-11 15:12:19
---
# 安装

[官网](https://go.dev/)

```bash
# 解压
sudo tar -C /usr/local -xzf go1.12.7.linux-amd64.tar.gz

# 编辑 .bashrc 加入环境变量
export PATH=$PATH:/usr/local/go/bin
source .bashrc
```

## 换源

- 七牛：Goproxy 中国 https://goproxy.cn
- 阿里： mirrors.aliyun.com/goproxy/
- 官方： < 全球 CDN 加速 https://goproxy.io/>
- 其他：jfrog 维护 https://gocenter.io

```bash
# 启用 Go Modules 功能
go env -w GO111MODULE=on

# 配置 GOPROXY 环境变量，以下三选一

# 1. 七牛 CDN
go env -w  GOPROXY=https://goproxy.cn,direct

# 2. 阿里云
go env -w GOPROXY=https://mirrors.aliyun.com/goproxy/,direct

# 3. 官方
go env -w  GOPROXY=https://goproxy.io,direct
```

## 清除模块缓存

`GO111MODULE=on` 以后，下载的模块内容会缓存在 `$GOPATH/pkg/mod` 目录中

```bash
# 清除缓存命令
go clean --modcache
```

# 命令行

## go test

- `-race` 运行 Go race detector。
- `-run` 来过滤要由 regex 和 -run 标志运行的测试: `go test -run=FunctionName`
- `-bench` 去运行基准测试。 - `-cpuprofile cpu.out` 退出前将 CPU 配置文件写入指定的文件。
- `-memprofile` mem.out 在所有测试通过后，将内存配置文件写入文件。
- 我总是用 -v. 它打印测试名称、状态 (失败或通过)、运行测试需要多少时间、测试用例中的任何日志等等。
- `-cover` 度量在运行一组测试时执行的代码行的百分比。

## go list

它列出了由导入路径命名的包，每行一个。

## go fmt

他是在保存文件时运行的。它会根据 Go 的标准重新格式化你的代码。

还有基于 `gofmt` 的 `goimports`，它会更新你的 Go 导入行，添加缺失的行，删除未引用的行。

## go generate

「在编译前自动运行生成源代码的工具」

Go 工具会扫描与当前包相关的文件，寻找带有表单 //go:generate command arguments「魔力注释」的行。此命令不需要执行任何与 Go 或代码生成相关的操作。例如：

```go
package project

//go:generate echo Hello, Go Generate!

func Add(x, y int) int {
    return x + y
}
```

```bash
$ go generate
Hello, Go Generate!
```

