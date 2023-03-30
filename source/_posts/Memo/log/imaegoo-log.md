---
title: imaegoo log
categories:
  - Memo
tags:
  - log
date: 2023-03-28 13:46:42
updated: 2023-03-29 17:43:59
toc: true
---
# 去除评论

在`themes/icarus/layout/common/scripts.jsx`中注释第三十五行

# 设置归档格式
修改`_config.icarus.yml`
```yml
# Where should the widget be placed, left sidebar or right sidebar
position: left
type: archives
format: YYYY年MM月DD日
```

# 修改头像下的关注按钮文字

修改`themes/icarus/languages/zh-CN.yml`
```yml
widget:
    follow: 'Github'
```

# 删除访客数量

`themes/icarus/layout/common/article.jsx`注释81-83行