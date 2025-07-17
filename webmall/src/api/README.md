# API接口封装使用指南

## 📋 概述

本项目已根据API接口文档完成了所有接口的封装，包括用户认证、商品管理、订单处理、购物车操作等功能。

## 🏗️ 项目结构

```
src/api/
├── index.js        # API统一入口文件
├── request.js      # axios基础配置
├── config.js       # API配置文件
├── auth.js         # 用户认证相关API
├── product.js      # 商品相关API
├── order.js        # 订单相关API
├── cart.js         # 购物车相关API
├── common.js       # 通用API
└── README.md       # 使用说明文档
```

## 🚀 快速开始

### 1. 基础使用

```javascript
// 导入需要的API
import { login, getProducts, createOrder } from '@/api'

// 或者导入特定模块
import { login, logout } from '@/api/auth'
import { getProducts, getProductDetail } from '@/api/product'
```

### 2. 用户认证示例

```javascript
// 用户登录
const handleLogin = async () => {
  try {
    const response = await login({
      email: 'test@example.com',
      password: '123456'
    })
    
    // 保存token
    localStorage.setItem('token', response.data.token)
    
    console.log('登录成功:', response.data)
  } catch (error) {
    console.error('登录失败:', error)
  }
}

// 用户注册
const handleRegister = async () => {
  try {
    const response = await register({
      username: 'testuser',
      email: 'test@example.com',
      password: '123456',
      phone: '13800138000'
    })
    
    console.log('注册成功:', response.data)
  } catch (error) {
    console.error('注册失败:', error)
  }
}

// 获取用户信息
const getUserInfo = async () => {
  try {
    const response = await getUserProfile()
    console.log('用户信息:', response.data)
  } catch (error) {
    console.error('获取用户信息失败:', error)
  }
}
```

### 3. 商品相关示例

```javascript
// 获取商品列表
const getProductList = async () => {
  try {
    const response = await getProducts({
      page: 1,
      limit: 12,
      category: 1,
      minPrice: 100,
      maxPrice: 1000,
      search: '手机',
      sort: 'price-asc'
    })
    
    console.log('商品列表:', response.data)
  } catch (error) {
    console.error('获取商品列表失败:', error)
  }
}

// 获取商品详情
const getProductInfo = async (productId) => {
  try {
    const response = await getProductDetail(productId)
    console.log('商品详情:', response.data)
  } catch (error) {
    console.error('获取商品详情失败:', error)
  }
}

// 获取分类列表
const getCategoryList = async () => {
  try {
    const response = await getCategories()
    console.log('分类列表:', response.data)
  } catch (error) {
    console.error('获取分类列表失败:', error)
  }
}
```

### 4. 订单相关示例

```javascript
// 创建订单
const handleCreateOrder = async () => {
  try {
    const response = await createOrder({
      items: [
        {
          productId: 1,
          quantity: 2,
          price: 7999
        }
      ],
      shippingAddress: {
        name: '张三',
        phone: '13800138000',
        address: '北京市朝阳区建国路88号SOHO现代城'
      },
      paymentMethod: '支付宝',
      remark: '请尽快发货'
    })
    
    console.log('订单创建成功:', response.data)
  } catch (error) {
    console.error('创建订单失败:', error)
  }
}

// 获取订单列表
const getOrderList = async () => {
  try {
    const response = await getOrders({
      page: 1,
      limit: 10,
      status: '待支付'
    })
    
    console.log('订单列表:', response.data)
  } catch (error) {
    console.error('获取订单列表失败:', error)
  }
}

// 获取订单详情
const getOrderInfo = async (orderId) => {
  try {
    const response = await getOrderDetail(orderId)
    console.log('订单详情:', response.data)
  } catch (error) {
    console.error('获取订单详情失败:', error)
  }
}
```

### 5. 购物车相关示例

```javascript
// 添加商品到购物车
const handleAddToCart = async (product) => {
  try {
    const response = await addToCart({
      productId: product.id,
      quantity: 1
    })
    
    console.log('添加到购物车成功:', response.data)
  } catch (error) {
    console.error('添加到购物车失败:', error)
  }
}

// 获取购物车列表
const getCartList = async () => {
  try {
    const response = await getCart()
    console.log('购物车列表:', response.data)
  } catch (error) {
    console.error('获取购物车列表失败:', error)
  }
}
```

## 🔧 Vue组件中的使用

### 在Vue 3 Composition API中使用

```vue
<template>
  <div>
    <div v-if="loading">加载中...</div>
    <div v-else>
      <div v-for="product in products" :key="product.id">
        {{ product.name }} - ¥{{ product.price }}
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { getProducts } from '@/api'

const products = ref([])
const loading = ref(false)

const fetchProducts = async () => {
  loading.value = true
  try {
    const response = await getProducts({ page: 1, limit: 10 })
    products.value = response.data.products
  } catch (error) {
    console.error('获取商品失败:', error)
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  fetchProducts()
})
</script>
```

### 在Vuex Store中使用

```javascript
// store/modules/products.js
import { getProducts, getProductDetail } from '@/api'

const state = {
  products: [],
  currentProduct: null,
  loading: false
}

const mutations = {
  SET_PRODUCTS(state, products) {
    state.products = products
  },
  SET_CURRENT_PRODUCT(state, product) {
    state.currentProduct = product
  },
  SET_LOADING(state, loading) {
    state.loading = loading
  }
}

const actions = {
  async fetchProducts({ commit }, params) {
    commit('SET_LOADING', true)
    try {
      const response = await getProducts(params)
      commit('SET_PRODUCTS', response.data.products)
    } catch (error) {
      console.error('获取商品失败:', error)
    } finally {
      commit('SET_LOADING', false)
    }
  },
  
  async fetchProductDetail({ commit }, productId) {
    try {
      const response = await getProductDetail(productId)
      commit('SET_CURRENT_PRODUCT', response.data)
    } catch (error) {
      console.error('获取商品详情失败:', error)
    }
  }
}

export default {
  namespaced: true,
  state,
  mutations,
  actions
}
```

## ⚙️ 配置说明

### 环境配置

在 `src/api/config.js` 中可以配置不同环境的API地址：

```javascript
// 开发环境
const development = {
  baseURL: 'http://localhost:3000/api',
  timeout: 10000
}

// 生产环境
const production = {
  baseURL: 'https://your-api-domain.com/api',
  timeout: 10000
}
```

### 请求拦截器

已配置自动添加token到请求头：

```javascript
// 请求拦截器会自动添加token
const token = localStorage.getItem('token')
if (token) {
  config.headers.Authorization = `Bearer ${token}`
}
```

### 响应拦截器

已配置统一的错误处理：

- 自动显示错误消息
- 401错误自动跳转登录页
- 统一的响应数据格式处理

## 🔍 错误处理

所有API调用都应该使用try-catch进行错误处理：

```javascript
try {
  const response = await getProducts()
  // 处理成功响应
} catch (error) {
  // 处理错误
  console.error('API调用失败:', error)
}
```

## 📝 注意事项

1. **Token管理**: 登录成功后需要手动保存token到localStorage
2. **错误处理**: 所有API调用都应该进行适当的错误处理
3. **Loading状态**: 建议在API调用时显示loading状态
4. **环境配置**: 部署时需要修改生产环境的API地址
5. **请求取消**: 对于可能被取消的请求，建议使用AbortController

## 🚀 后续优化建议

1. 添加请求缓存机制
2. 实现请求重试功能
3. 添加请求去重功能
4. 实现更细粒度的错误处理
5. 添加请求和响应的日志记录 