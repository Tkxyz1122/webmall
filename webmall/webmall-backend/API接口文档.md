# Vue商城项目 - API接口文档

## 📋 项目概述

本文档定义了Vue商城项目的后端API接口规范，采用RESTful风格设计，支持JSON数据格式。

### 基础信息
- **Base URL**: `http://localhost:3000/api`
- **认证方式**: Bearer Token
- **数据格式**: JSON
- **字符编码**: UTF-8

### 通用响应格式
```json
{
  "code": 200,
  "message": "success",
  "data": {}
}
```

### 状态码说明
- `200`: 成功
- `400`: 请求参数错误
- `401`: 未授权
- `403`: 禁止访问
- `404`: 资源不存在
- `500`: 服务器内部错误

---

## 🔐 用户认证模块

### 1. 用户注册
**接口地址**: `POST /api/auth/register`

**请求参数**:
```json
{
  "username": "testuser",
  "email": "test@example.com",
  "password": "123456",
  "phone": "13800138000"
}
```

**响应示例**:
```json
{
  "code": 200,
  "message": "注册成功",
  "data": {
    "id": 1,
    "username": "testuser",
    "email": "test@example.com",
    "phone": "13800138000",
    "avatar": "",
    "memberLevel": "普通会员",
    "createTime": "2024-01-01T00:00:00.000Z"
  }
}
```

### 2. 用户登录
**接口地址**: `POST /api/auth/login`

**请求参数**:
```json
{
  "email": "test@example.com",
  "password": "123456"
}
```

**响应示例**:
```json
{
  "code": 200,
  "message": "登录成功",
  "data": {
    "id": 1,
    "username": "testuser",
    "email": "test@example.com",
    "phone": "13800138000",
    "avatar": "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=100&h=100&fit=crop&crop=face",
    "memberLevel": "VIP",
    "token": "simple_token_123456",
    "loginTime": "2024-01-01T00:00:00.000Z"
  }
}
```

### 3. 用户登出
**接口地址**: `POST /api/auth/logout`

**请求头**: `Authorization: Bearer simple_token_123456`

**响应示例**:
```json
{
  "code": 200,
  "message": "登出成功"
}
```

### 4. 获取用户信息
**接口地址**: `GET /api/auth/profile`

**请求头**: `Authorization: Bearer simple_token_123456`

**响应示例**:
```json
{
  "code": 200,
  "data": {
    "id": 1,
    "username": "testuser",
    "email": "test@example.com",
    "phone": "13800138000",
    "avatar": "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=100&h=100&fit=crop&crop=face",
    "memberLevel": "VIP"
  }
}
```

---

## 🛍️ 商品模块

### 1. 获取商品列表
**接口地址**: `GET /api/products`

**查询参数**:
- `page`: 页码（默认1）
- `limit`: 每页数量（默认12）
- `category`: 分类ID
- `minPrice`: 最低价格
- `maxPrice`: 最高价格
- `search`: 搜索关键词
- `sort`: 排序方式（default/price-asc/price-desc/newest）

**请求示例**:
```
GET /api/products?page=1&limit=12&category=1&minPrice=100&maxPrice=1000&search=手机&sort=price-asc
```

**响应示例**:
```json
{
  "code": 200,
  "data": {
    "products": [
      {
        "id": 1,
        "name": "iPhone 15 Pro",
        "description": "最新款iPhone，配备A17 Pro芯片",
        "price": 7999,
        "originalPrice": 8999,
        "image": "https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=300&h=300&fit=crop",
        "images": [
          "https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=500&h=500&fit=crop",
          "https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=500&h=500&fit=crop"
        ],
        "brand": "Apple",
        "category": 1,
        "categoryName": "手机",
        "stock": 100,
        "rating": 4.8,
        "reviews": 1234,
        "tags": ["新品", "热销"],
        "features": ["5G", "三摄", "快充"],
        "specs": {
          "屏幕": "6.1英寸",
          "内存": "128GB",
          "处理器": "A17 Pro"
        }
      }
    ],
    "total": 50,
    "page": 1,
    "limit": 12,
    "totalPages": 5
  }
}
```

### 2. 获取商品详情
**接口地址**: `GET /api/products/:id`

**响应示例**:
```json
{
  "code": 200,
  "data": {
    "id": 1,
    "name": "iPhone 15 Pro",
    "description": "最新款iPhone，配备A17 Pro芯片",
    "price": 7999,
    "originalPrice": 8999,
    "image": "https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=300&h=300&fit=crop",
    "images": [
      "https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=500&h=500&fit=crop",
      "https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=500&h=500&fit=crop",
      "https://images.unsplash.com/photo-1565849904461-04a58ad377e0?w=500&h=500&fit=crop"
    ],
    "brand": "Apple",
    "category": 1,
    "categoryName": "手机",
    "stock": 100,
    "rating": 4.8,
    "reviews": 1234,
    "tags": ["新品", "热销"],
    "features": ["5G", "三摄", "快充", "无线充电"],
    "specs": {
      "屏幕": "6.1英寸Super Retina XDR",
      "内存": "128GB",
      "处理器": "A17 Pro",
      "摄像头": "48MP主摄",
      "电池": "3274mAh",
      "系统": "iOS 17"
    },
    "detail": "<div><h3>产品特色</h3><p>iPhone 15 Pro采用全新的A17 Pro芯片，性能更加强劲...</p></div>"
  }
}
```

### 3. 获取分类列表
**接口地址**: `GET /api/categories`

**响应示例**:
```json
{
  "code": 200,
  "data": [
    {
      "id": 1,
      "name": "手机",
      "description": "智能手机及配件",
      "image": "https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=300&h=300&fit=crop",
      "productCount": 150,
      "subcategories": [
        {"id": 11, "name": "iPhone"},
        {"id": 12, "name": "华为"},
        {"id": 13, "name": "小米"}
      ]
    },
    {
      "id": 2,
      "name": "电脑",
      "description": "笔记本电脑、台式机",
      "image": "https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=300&h=300&fit=crop",
      "productCount": 80,
      "subcategories": [
        {"id": 21, "name": "MacBook"},
        {"id": 22, "name": "ThinkPad"},
        {"id": 23, "name": "戴尔"}
      ]
    }
  ]
}
```

### 4. 获取品牌列表
**接口地址**: `GET /api/brands`

**响应示例**:
```json
{
  "code": 200,
  "data": [
    {
      "id": 1,
      "name": "Apple",
      "description": "创新科技产品",
      "logo": "https://images.unsplash.com/photo-1621768216002-5ac171876625?w=100&h=100&fit=crop",
      "productCount": 25
    },
    {
      "id": 2,
      "name": "华为",
      "description": "智能终端设备",
      "logo": "https://images.unsplash.com/photo-1611532736597-de2d4265fba3?w=100&h=100&fit=crop",
      "productCount": 30
    }
  ]
}
```

---

## 📦 订单模块

### 1. 创建订单
**接口地址**: `POST /api/orders`

**请求头**: `Authorization: Bearer simple_token_123456`

**请求参数**:
```json
{
  "items": [
    {
      "productId": 1,
      "quantity": 2,
      "price": 7999
    },
    {
      "productId": 2,
      "quantity": 1,
      "price": 5999
    }
  ],
  "shippingAddress": {
    "name": "张三",
    "phone": "13800138000",
    "address": "北京市朝阳区建国路88号SOHO现代城"
  },
  "paymentMethod": "支付宝",
  "remark": "请尽快发货"
}
```

**响应示例**:
```json
{
  "code": 200,
  "message": "订单创建成功",
  "data": {
    "orderId": "ORDER_20240101_001",
    "totalAmount": 21997,
    "shippingFee": 0,
    "finalAmount": 21997,
    "status": "待支付",
    "createTime": "2024-01-01T00:00:00.000Z"
  }
}
```

### 2. 获取订单列表
**接口地址**: `GET /api/orders`

**请求头**: `Authorization: Bearer simple_token_123456`

**查询参数**:
- `page`: 页码（默认1）
- `limit`: 每页数量（默认10）
- `status`: 订单状态（待支付/已支付/已发货/已完成/已取消）

**响应示例**:
```json
{
  "code": 200,
  "data": {
    "orders": [
      {
        "id": "ORDER_20240101_001",
        "totalAmount": 21997,
        "shippingFee": 0,
        "finalAmount": 21997,
        "status": "待支付",
        "createTime": "2024-01-01T00:00:00.000Z",
        "itemCount": 3,
        "firstItemImage": "https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=100&h=100&fit=crop",
        "firstItemName": "iPhone 15 Pro"
      },
      {
        "id": "ORDER_20240102_002",
        "totalAmount": 8999,
        "shippingFee": 15,
        "finalAmount": 9014,
        "status": "已发货",
        "createTime": "2024-01-02T00:00:00.000Z",
        "itemCount": 1,
        "firstItemImage": "https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=100&h=100&fit=crop",
        "firstItemName": "MacBook Pro"
      }
    ],
    "total": 5,
    "page": 1,
    "limit": 10
  }
}
```

### 3. 获取订单详情
**接口地址**: `GET /api/orders/:id`

**请求头**: `Authorization: Bearer simple_token_123456`

**响应示例**:
```json
{
  "code": 200,
  "data": {
    "id": "ORDER_20240101_001",
    "status": "待支付",
    "totalAmount": 21997,
    "shippingFee": 0,
    "finalAmount": 21997,
    "createTime": "2024-01-01T00:00:00.000Z",
    "items": [
      {
        "productId": 1,
        "name": "iPhone 15 Pro",
        "image": "https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=100&h=100&fit=crop",
        "price": 7999,
        "quantity": 2,
        "subtotal": 15998
      },
      {
        "productId": 2,
        "name": "MacBook Pro",
        "image": "https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=100&h=100&fit=crop",
        "price": 5999,
        "quantity": 1,
        "subtotal": 5999
      }
    ],
    "shippingAddress": {
      "name": "张三",
      "phone": "13800138000",
      "address": "北京市朝阳区建国路88号SOHO现代城"
    },
    "paymentMethod": "支付宝",
    "remark": "请尽快发货"
  }
}
```

### 4. 更新订单状态
**接口地址**: `PUT /api/orders/:id/status`

**请求头**: `Authorization: Bearer simple_token_123456`

**请求参数**:
```json
{
  "status": "已支付"
}
```

**响应示例**:
```json
{
  "code": 200,
  "message": "订单状态更新成功",
  "data": {
    "orderId": "ORDER_20240101_001",
    "status": "已支付",
    "updateTime": "2024-01-01T01:00:00.000Z"
  }
}
```

---

## 🗄️ 数据库设计

### 用户表 (users)
```sql
CREATE TABLE users (
  id INT PRIMARY KEY AUTO_INCREMENT,
  username VARCHAR(50) NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL,
  password VARCHAR(255) NOT NULL,
  phone VARCHAR(20),
  avatar VARCHAR(255),
  member_level VARCHAR(20) DEFAULT '普通会员',
  create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  update_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

### 商品表 (products)
```sql
CREATE TABLE products (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  price DECIMAL(10,2) NOT NULL,
  original_price DECIMAL(10,2),
  image VARCHAR(255),
  images TEXT,
  brand VARCHAR(100),
  category_id INT,
  stock INT DEFAULT 0,
  rating DECIMAL(3,2) DEFAULT 0,
  reviews INT DEFAULT 0,
  tags TEXT,
  features TEXT,
  specs TEXT,
  detail TEXT,
  create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  update_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

### 分类表 (categories)
```sql
CREATE TABLE categories (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL,
  description TEXT,
  image VARCHAR(255),
  product_count INT DEFAULT 0,
  create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### 品牌表 (brands)
```sql
CREATE TABLE brands (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL,
  description TEXT,
  logo VARCHAR(255),
  product_count INT DEFAULT 0,
  create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### 订单表 (orders)
```sql
CREATE TABLE orders (
  id VARCHAR(50) PRIMARY KEY,
  user_id INT NOT NULL,
  total_amount DECIMAL(10,2) NOT NULL,
  shipping_fee DECIMAL(10,2) DEFAULT 0,
  final_amount DECIMAL(10,2) NOT NULL,
  status VARCHAR(20) DEFAULT '待支付',
  shipping_address TEXT,
  payment_method VARCHAR(50),
  remark TEXT,
  create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  update_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id)
);
```

### 订单商品表 (order_items)
```sql
CREATE TABLE order_items (
  id INT PRIMARY KEY AUTO_INCREMENT,
  order_id VARCHAR(50) NOT NULL,
  product_id INT NOT NULL,
  product_name VARCHAR(255),
  product_image VARCHAR(255),
  price DECIMAL(10,2) NOT NULL,
  quantity INT NOT NULL,
  subtotal DECIMAL(10,2) NOT NULL,
  FOREIGN KEY (order_id) REFERENCES orders(id),
  FOREIGN KEY (product_id) REFERENCES products(id)
);
```

---

## 🔧 实现建议

### 技术栈推荐
- **后端框架**: Express.js (Node.js) 或 FastAPI (Python)
- **数据库**: MySQL 或 PostgreSQL
- **ORM**: Sequelize (Node.js) 或 SQLAlchemy (Python)
- **认证**: JWT 或简单Token
- **文件存储**: 本地存储 或 云存储服务

### 开发步骤
1. 搭建基础项目结构
2. 配置数据库连接
3. 创建数据模型
4. 实现用户认证接口
5. 实现商品相关接口
6. 实现订单相关接口
7. 添加错误处理和日志
8. 接口测试和文档完善

### 安全考虑
- 密码加密存储（生产环境）
- SQL注入防护
- XSS攻击防护
- 请求频率限制
- 输入参数验证

---

## 📝 更新日志

### v1.0.0 (2024-01-01)
- 初始版本
- 完成用户认证、商品、订单基础接口设计
- 支持商品搜索、分类筛选
- 支持订单创建和状态管理 