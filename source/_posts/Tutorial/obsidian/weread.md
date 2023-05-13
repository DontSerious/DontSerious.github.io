---
title: weread插件
date: 2023-05-13 17:11:45
updated: 2023-05-13 17:11:46
categories:
     - Tutorial
tags:
     - obsidian
     - memo
toc: false
---

# 笔记模板

```
---
isbn: {{metaData.isbn}}
category: {{metaData.category}}
---
# 元数据
> [!abstract] {{metaData.title}}
> - ![ {{metaData.title}}|200]({{metaData.cover}})
> - 书名： {{metaData.title}}
> - 作者： {{metaData.author}}
> - 简介： {{metaData.intro}}
> - 出版时间 {{metaData.publishTime}}
> - ISBN： {{metaData.isbn}}
> - 分类： {{metaData.category}}
> - 出版社： {{metaData.publisher}}

# 高亮划线
{% for chapter in chapterHighlights %}
## {{chapter.chapterTitle}}
{% for highlight in chapter.highlights %}
{% if highlight.reviewContent %}{% else %}
- 📌 {{ highlight.markText |trim }} ^{{highlight.chapterUid}}-{{highlight.range}}
    - ⏱ {{highlight.createTime}}{% endif %} {% endfor %}{% endfor %}
# 读书笔记
{% for chapter in bookReview.chapterReviews %}{% if chapter.reviews or chapter.chapterReview %}
## {{chapter.chapterTitle}}
{% if  chapter.chapterReviews %}{% for chapterReview in chapter.chapterReviews %}
### 章节评论 No.{{loop.index}}
- {{chapterReview.content}} ^{{chapterReview.reviewId}}
    - ⏱ {{chapterReview.createTime}} {% endfor%}{%endif %}{% if chapter.reviews %}{%for review in chapter.reviews %}
### 划线评论
- 📌 {{review.abstract |trim }}  ^{{review.reviewId}}
    - 💭 {{review.content}}
    - ⏱ {{review.createTime}}
{% endfor %} {%endif %} {% endif %} {% endfor %}
# 本书评论
{% if bookReview.bookReviews %}{% for bookReview in bookReview.bookReviews %}
## 书评 No.{{loop.index}} {{bookReview.mdContent}} ^{{bookReview.reviewId}}
⏱ {{bookReview.createTime}}
{% endfor%}{% endif %}
```

## 自用模板

- 添加了 reverse 过滤器，使得评论按照文章位置排序（划线评论上方最后一个`|reverse`）。

```
---
title: {{metaData.title}}
date: 
updated: {{metaData.lastReadDate}}
categories:
     - Study
tags:
     - bookNote
toc: true
---
# 元数据
> [!abstract] {{metaData.title}}
> - ![ {{metaData.title}}|200]({{metaData.cover}})
> - 书名： {{metaData.title}}
> - 作者： {{metaData.author}}

# 读书笔记
{% for chapter in bookReview.chapterReviews %}{% if chapter.reviews or chapter.chapterReview %}
## {{chapter.chapterTitle}}
{% if  chapter.chapterReviews %}{% for chapterReview in chapter.chapterReviews %}
### 章节评论 No.{{loop.index}}
- {{chapterReview.content}} ^{{chapterReview.reviewId}}
    - ⏱ {{chapterReview.createTime}} {% endfor%}{%endif %}{% if chapter.reviews %}{%for review in chapter.reviews|reverse %}
### 划线评论
- 📌 {{review.abstract |trim }}
    - 💭 {{review.content}}
{% endfor %} {%endif %} {% endif %} {% endfor %}
```