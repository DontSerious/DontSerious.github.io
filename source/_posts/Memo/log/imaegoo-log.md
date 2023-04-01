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

# 添加主页自动折叠

```jsx
{/* 改为主页文章全折叠 */}
<div class="content" dangerouslySetInnerHTML={{
    __html: index ? page.content.split('\n').slice(0,config.auto_excerpt.lines).join('\n') : page.content
}}></div>

{/* 改为文章行数大于auto_excerpt.lines就加上按钮 */}
{ page.content.split('\n').length > config.auto_excerpt.lines ? <a class="article-more button is-small is-size-7" href={`${url_for(page.link || page.path)}#more`}>{__('article.more')}</a> : null}
```

```yml
# Excerpt 
## Auto creat excerpt with not <!--more-->
## Enable will truncate auto_excerpt.lines rows in post head to replace excerpt.
auto_excerpt:
    enable: true
    lines: 5
```