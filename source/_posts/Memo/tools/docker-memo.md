---
title: docker备忘
date: 2023-08-22 17:23:22
updated: 2023-08-22 17:23:22
categories:
- Memo
tags:
- tools

toc: true
---
# Dockerfile

```Dockerfile
FROM node:18
WORKDIR /dir
COPY package.json .
RUN npm install
COPY . .
EXPOSE 3000
CMD ["npx", "hexo", "server"]
```

- EXPOSE 是说明对外暴露的端口
- RUN 是在构建时执行的命令
- CMD 是构建完毕启动之后执行的命令
- 使用的相对地址

## 缓存

docker 构建镜像时会使用缓存，从上到下执行，分两次 copy 可以让构建时的工作减少


## .dockerignore

copy 命令忽略的文件，`.dockerignore` 也要写进去

# 指令

docker +

- `build . `
	- 在当前目录根据 Dockerfile 文件构建
- `images`
	- 查看所有镜像
- `tag 用户名/镜像名: 版本 `
	- 给镜像命名
- `rmi 镜像名`
	- 删除镜像
	-  -f 强制删除
- `pull 镜像名`
	- 将镜像存在本地
- `run`
	- 运行镜像 
	- `-d` 后台运行
	- `-p 主机端口:容器端口` 对外暴露端口
	- `--name 自定义名` 自定义容器名
	- `-v 本地路径:容器文件夹路径:ro` 动态绑定，动态更新文件
		- `:ro` 代表让本地文件夹变为 readonly，使得容器文件改变，本地不改变
		- 这里要使用绝对路径，也可也使用环境变量
		- 可以使用 `nodemon` 实现重启
			- `npm i nodemon --save-dev` 
			- 并修改 `package.json` 中 `script` 处，添加 `"dev" : "nodemon app.js"`
			- 此时执行改为 `CMD ["npm", "run", "dev"]`
		-  `-v 容器文件路径` 表示该路径不同步
- `ps` 查看所有容器
- `stop 容器 id `
	- 暂停运行
	- -a 暂停所有
- `rm -f 容器名`
	- 删除容器
	- `-fv` 同时删除 volume
- `exec -it 容器名 /bin/sh` 访问容器
	- `-i` 交互
	- `-t` 终端模式
	-  `/bin/sh` 表示执行一个新的 bash shell

# docker-compose.yml

```yml
version: "3.8"
services:
	blog:   # 容器名
		build: . # 根据当前文件夹进行构建
		ports: 
			- "3000:3000"  # 暴露端口，本地路径:容器文件夹路径
		volumes:
			- ./:/blog:ro # 动态绑定，可以使用相对地址
			- /blog/node_modules # 不绑定
```

- `docker-compose up -d --build` 执行
	- `-d` 后台运行
	- `--build` 如果镜像修改则重建
- `docker-compose down -v` 清除
	- `-v` 删除 volume
