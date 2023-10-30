---
title: react笔记
date: 2023-10-28 10:43:37
updated: 2023-10-28 10:43:37
categories:
- FrontEnd
tags:
- React
toc: true
---

# 基础语法

## 状态

```jsx
const [content, setContent] = useState('123');
const [data, setData] = useState({
	title: '',
	content: ''
})
```

修改

```jsx
function fun() {
	setContent('')
	setData({
		...data,
		title: ''
	})
}
```

### 数组用法

```jsx
const [data, setData] = useState({
	{ id: 1, name: 'a' },
	{ id: 2, name: 'b' },
	{ id: 3, name: 'c' }
})

const listData = data.map(item => (
	<li key={item.id}>{item.name}</li>
))

let id = 3
function handleClick () {
	//setData([
	//	...data,
	//	{ id: ++id, name: 'd' }
	//])
	setData(data.filter(item => item.id !== 2))
}

return {
	<>
		<ul>{listData}</ul>
		<button onclick={handleClick}>按钮</button>
	</>
}
```

## 展开

```jsx
import img form './logo.svg'

function App() {
	const imgData = {
		className: 'small',
		style: {
			width: 200,
			height: 200
		}
	}

	return (
		<div>
			<img
				src={img}
				alt=""
				{...imgData}
			/>
		</div>
	)
}
```

## 传值

### 父向子

```jsx
function Detail({content, active}) {
    return (
        <>
            <p>{content}</p>
            <p>状态：{active ? '显示中' : '已隐藏'}</p>
        </>
    )
}

function Article({title, articleData}) {
    return (
        <div>
            <h2>{title}</h2>
            <Detail {...articleData} />
        </div>
    )
}

export default function App() {
    const articleData = {
        title: '标题1',
        detailData: {
            content: '内容1',
            active: true
        }
    }

    return (
        <>
            <Article
                {...articleData}
            />
        </>
    )
}
```

### 子向父

```jsx
import { useState } from "react"

function Detail ({ onActive }) {
    const [status, setStatus] = useState(false)
    function handleClick() {
        setStatus(!status)
        onActive(status)
    }

    return (
        <div>
            <button onClick={handleClick}>按钮</button>
            <p style={{
                display: status ? 'block' : 'none'
            }}>Detail的内容</p>
        </div>
    )
}

export default function App() {
    function handleActive(status) {
        console.log(status)
    }
    
    return (
        <>
            <Detail 
                onActive={handleActive}
            />
        </>
    )
}
```

### 多级传输 Context

```jsx

```



## 插槽

```jsx
function List ({ children }) {
    return (
        <div>
            {children}
        </div>
    )
}

export default function App() {
    return (
        <>
            <List>
                <li>列表项</li>
                <li>列表项</li>
                <li>列表项</li>
            </List>
        </>
    )
}
``` 

# 脚手架安装

## 依赖

```bash
npm i -g create-react-app
```

## 初始化

使用 react+ts

```bash
create-react-app 项目名 --template typescript
```

### 暴露 webpack 配置文件 (可选)

```bash
npm run eject
```

# 引入 Ant-Design 组件库

## 依赖

```bash
npm i antd --save
```

## 引入测试

```tsx
// App.tsx
import type { FC } from 'react'
import { Button } from 'antd'

const App: FC = () => (
  <div>
    <Button type='primary'>Button</Button>
    <Button type='link'>哈哈哈</Button>
  </div>
)

export default App

```

## 语言汉化

- 使用 ConfigProvider 包裹 App 根组件

```tsx
//index.tsx
import React from 'react';
import ReactDOM from 'react-dom/client';
import App from './App';

// 汉化
import { ConfigProvider } from 'antd';
import zhCN from 'antd/locale/zh_CN'

const root = ReactDOM.createRoot(
  document.getElementById('root') as HTMLElement
);

root.render(
	<React.StrictMode>
		<ConfigProvider locale={ zhCN }>
			<App />
		</ConfigProvider>
	</React.StrictMode>
);
```

# 引入 react 路由

## 依赖

```bash
npm i react-router-dom
```

## 编写路由表

- src/routes

```tsx
// index.tsx
import { Navigate } from "react-router-dom";
import Login from '../pages/login'
import Home from '../pages/home'

export default [
    {
        path: '/login',
        element: <Login />
    },
    {
        path: '/home',
        element: <Home />
    },
    {
        // 重定向
        path: '/',
        element: <Navigate to = '/home' />
    }
] as {
    path: string,
    element: JSX.Element
}[]
```

## 注册路由

```tsx
// index.tsx
import React from 'react';
import ReactDOM from 'react-dom/client';
import App from './App';

// 路由
import { BrowserRouter } from 'react-router-dom';

// 汉化
import { ConfigProvider } from 'antd';
import zhCN from 'antd/locale/zh_CN'

const root = ReactDOM.createRoot(
  document.getElementById('root') as HTMLElement
);
root.render(
  <React.StrictMode>
    <BrowserRouter>
      <ConfigProvider locale={ zhCN }>
        <App />
      </ConfigProvider>
    </BrowserRouter>
  </React.StrictMode>
);

```

```tsx
// App.tsx
import type { FC } from 'react'
import { useRoutes } from 'react-router-dom'
import routes from './routes/index'

const App: FC = () => {
  // 获得路由表
  const routeView = useRoutes(routes)

  return (
    <div>
      { routeView }
    </div>
  )
}

export default App

```