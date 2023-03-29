---
title: VSCode memo
categories:
  - Tutorial
tags:
  - hexo
date: 2023-03-27 21:20:15
updated: 2023-03-29 18:50:37
---
# 使用vscode快捷键解决hexo的updated时间插入问题

## 新建快捷方法

1. `ctrl + shift + p`，输入snippets
2. 找到configura user snippets
3. new global或工作区都可以
4. 输入名字
5. 在花括号内输入

```json
"insertDate":{
	"prefix":"insert date",
	"body":"$CURRENT_YEAR-$CURRENT_MONTH-$CURRENT_DATE $CURRENT_HOUR:$CURRENT_MINUTE:$CURRENT_SECOND"
}
```

## 使用
1. 点击需要插入的地方
1. `ctrl + shift + p`，找到insert snippet
2. 选择insert date