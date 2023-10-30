---
title: Vue速记
date: 2023-10-26 16:31:52
updated: 2023-10-26 16:31:52
categories:
- FrontEnd
tags:
- Vue.js
toc: true
---

# 2.0 基础

## 基础格式

```html
<script>
	const vm = new Vue({
		el: '#app',
		data() {
			return {
				title: '',
				content: ''
			}
		},
		methods: {
			func() {
				
			}
		},
		computed: {
			computedFunc() {
			
			}
		},
		watch: {
			title (newValue, oldValue) {
				
			}
		}
	})
</script>

<div>
	<p v-text="title"></p>
	<p v-html="title"></p>
</div>
```

- {{ title }} 显示 title 内容
- {{ func() }} 显示 fun() return 内容
- {{ computedFunc }} 有缓存的显示 computedFunc() return 内容
- watch 监听：title 改变时执行花括号内代码
- v-text 和 v-html 都可以覆盖元素显示内容，但 v-html 会经过编译
- `v-for="(item, key, index) in arr"` : arr 可以替换为数字，表示循环几次
- `v-if="true"` 
- `v-show="true"` 适合频繁开关
- `v-bind:title` == `:title`
- `v-on:click="func"` == `@click="func"`
- `v-model=""` 双向数据绑定

# 组件化开发

```JavaScript
<script>
export default {
	name: '',
	props: {
		msg: String,
		count: {
			type: [String, Number],    // 类型
			default: 100,              // 默认值
			required: true,            // 是否必须设置
		}
	},
	data () {},
	method: {}
}
</script>
```