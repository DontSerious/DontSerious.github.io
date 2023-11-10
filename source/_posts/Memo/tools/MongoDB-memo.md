---
title: MongoDB备忘
date: 2023-11-04 15:25:37
updated: 2023-11-04 15:25:37
categories:
- Memo
tags:
- tools

toc: true
---

# 安装

ubuntu 20.04

```bash
wget https://repo.mongodb.org/apt/ubuntu/dists/focal/mongodb-org/7.0/multiverse/binary-amd64/mongodb-org-server_7.0.2_amd64.deb
sudo dpkg -i mongodb-org-server_7.0.2_amd64.deb
sudo systemctl start mongod     ## 开启服务
sudo systemctl enable mongod    ## 开机自启
sudo systemctl status mongod    ## 查看状态
```

# 配置

## /etc/mongod.conf

```conf
# mongod.conf

storage:
  dbPath: /var/lib/mongodb

# where to write logging data.
systemLog:
  destination: file
  logAppend: true
  path: /var/log/mongodb/mongod.log
  
# bindIp默认是127.0.0.1，要设置为0.0.0.0才能被公网访问到
net:
  port: 27017
  bindIp: 0.0.0.0
```

## 开启认证

先连接数据库创建管理员用户

```bash
mongo
```

```bash
use admin
db.createUser({
    user: "adminUser",   // 您的管理员用户名
    pwd: "adminPassword", // 您的管理员密码
	roles: [ { role: "userAdminAnyDatabase", db: "admin" } ]
})
```

编辑配置文件 `/etc/mongod.conf`

```yaml
security:
  authorization: enabled
```

重启服务

```
sudo systemctl restart mongod
or
sudo service mongod restart
```

注销并使用管理员身份登录

```shell
db.auth("adminUser", "adminPassword")
```

创建其他用户

```shell
use yourDatabase
db.createUser({
    user: "appUser",
    pwd: "appPassword",
    roles: [ { role: "readWrite", db: "yourDatabase" } ]
})
```

# 连接数据库

```shell
mongosh "<connectionString>"
```

connectionString：`mongodb://<username>:<password>@<hostname>:<port>/<database>`

## 认证错误

`panic: connection() error occurred during connection handshake: auth error: sasl conversation error: unable to authenticate using mechanism "SCRAM-SHA-1": (AuthenticationFailed) Authentication failed.`

在 connectString 后面加上: `?authSource=admin&authMechanism=SCRAM-SHA-1"` 即可解决