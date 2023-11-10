---
title: Nginx备忘
date: 2023-11-10 18:47:35
updated: 2023-11-10 18:47:35
categories:
- Memo
tags:
- tools
toc: true
---
# 使用 nginx 解决跨域

分析前准备：
前端网站地址： http://localhost:3000
服务端网址： http://localhost:8080

## 响应头

跨域主要涉及4个响应头：
- Access-Control-Allow-Origin 用于设置允许跨域请求源地址 （预检请求和正式请求在跨域时候都会验证）
- Access-Control-Allow-Headers 跨域允许携带的特殊头信息字段 （只在预检请求验证）
- Access-Control-Allow-Methods 跨域允许的请求方法或者说 HTTP 动词 （只在预检请求验证）
- Access-Control-Allow-Credentials 是否允许跨域使用 cookies，如果要跨域使用 cookies，可以添加上此请求响应头，值设为 true（设置或者不设置，都不会影响请求发送，只会影响在跨域时候是否要携带 cookies，但是如果设置，预检请求和正式请求都需要设置）。不过不建议跨域使用（项目中用到过，不过不稳定，有些浏览器带不过去），除非必要，因为有很多方案可以代替。

**什么是预检请求？**：当发生跨域条件时候，览器先询问服务器，当前网页所在的域名是否在服务器的许可名单之中，以及可以使用哪些 HTTP 动词和头信息字段。只有得到肯定答复，浏览器才会发出正式的 XMLHttpRequest 请求，否则就报错

## nginx 配置

完整版：根据报错进行添加删除

```conf
server {
        listen       22222;
        server_name  localhost;
        location  / {
            if ($request_method = 'OPTIONS') {
                add_header Access-Control-Allow-Origin 'http://localhost:3000';
                add_header Access-Control-Allow-Headers '*';
                add_header Access-Control-Allow-Methods '*';
                add_header Access-Control-Allow-Credentials 'true';
                return 204;    # 解决 It does not have HTTP ok status.
            }
            if ($request_method != 'OPTIONS') {
                add_header Access-Control-Allow-Origin 'http://localhost:3000' always;
                add_header Access-Control-Allow-Credentials 'true';
            }
            proxy_pass  http://localhost:8080; 
        }
    }
```

或者

```conf
server {
        listen       22222;
        server_name  localhost;
        location  / {
            add_header Access-Control-Allow-Origin 'http://localhost:8080' always;
            add_header Access-Control-Allow-Headers '*';
            add_header Access-Control-Allow-Methods '*';
            add_header Access-Control-Allow-Credentials 'true';
            if ($request_method = 'OPTIONS') {
                return 204;
            }
            proxy_pass  http://localhost:59200; 
        }
    }
```

个人精简版

```conf
server {
    listen 22222;
    server_name localhost;  # 可以根据实际情况更改

    location / {
        add_header Access-Control-Allow-Origin 'http://localhost:3000' always;
        add_header Access-Control-Allow-Headers '*';
        add_header Access-Control-Allow-Methods '*';
        if ($request_method = 'OPTIONS') {
            return 204;
        }
        proxy_pass http://localhost:8080;
    }
}
```

## 解决问题

- `add_header Access-Control-Allow-Origin ' http://localhost:3000 ' always;`：解决Response to preflight request doesn't pass access control check: No 'Access-Control-Allow-Origin' header is present on the requested resource.
- `always;` 解决每次响应信息都携带头字段信息
- `if ($request_method = 'OPTIONS') {return 204; } `：解决跨域浏览器默认行为的预请求（option 请求）没有收到 ok 状态码，此时再修改配置文件，当请求为 option 请求时候，给浏览器返回一个状态码（一般是204）
- `add_header Access-Control-Allow-Headers '*'`; ： 解决 Request header field authorization is not allowed by Access-Control-Allow-Headers in preflight response.
- `add_header Access-Control-Allow-Methods '*';`：比较早期的 API 可能只用到了 POST 和 GET 请求，而 Access-Control-Allow-Methods 这个请求响应头跨域默认只支持 POST 和 GET，当出现其他请求类型时候，同样会出现跨域异常。

[原帖](https://www.cnblogs.com/fnz0/p/15803011.html)