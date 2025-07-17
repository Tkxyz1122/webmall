# Vue商城后端API

基于FastAPI实现的最简单商城后端API，支持用户认证、商品管理、订单管理等功能。

## 特性

- 🚀 FastAPI框架，性能优秀
- 🔐 简单Token认证
- 📦 MySQL数据库存储
- 🛍️ 完整的商城功能
- 📝 直接SQL查询，无ORM
- 🔧 密码明文存储（开发环境）

## 快速开始

### 1. 安装依赖

```bash
pip install -r requirements.txt
```

### 2. 配置数据库

修改 `main.py` 中的数据库配置：

```python
DB_CONFIG = {
    'host': 'localhost',
    'user': 'root',
    'password': 'root',
    'database': 'webmall',
    'charset': 'utf8mb4'
}
```

### 3. 初始化数据库

在MySQL中执行 `database.sql` 文件：

```bash
mysql -u root -p < database.sql
```

### 4. 启动服务

```bash
python main.py
```

或者使用uvicorn：

```bash
uvicorn main:app --host 0.0.0.0 --port 3000 --reload
```

服务启动后访问：
- API文档：http://localhost:3000/docs
- 接口测试：http://localhost:3000/redoc

## API接口

### 认证相关
- `POST /api/auth/register` - 用户注册
- `POST /api/auth/login` - 用户登录
- `POST /api/auth/logout` - 用户登出
- `GET /api/auth/profile` - 获取用户信息

### 商品相关
- `GET /api/products` - 获取商品列表
- `GET /api/products/{id}` - 获取商品详情
- `GET /api/categories` - 获取分类列表
- `GET /api/brands` - 获取品牌列表

### 订单相关
- `POST /api/orders` - 创建订单
- `GET /api/orders` - 获取订单列表
- `GET /api/orders/{id}` - 获取订单详情
- `PUT /api/orders/{id}/status` - 更新订单状态

## 测试账号

- 邮箱：test@example.com
- 密码：123456

## 项目结构

```
webmall-backend/
├── main.py              # 主程序文件
├── database.sql         # 数据库初始化脚本
├── requirements.txt     # 依赖文件
├── README.md           # 项目说明
└── API接口文档.md      # 接口文档
```

## 技术栈

- **后端框架**: FastAPI
- **数据库**: MySQL
- **数据库驱动**: PyMySQL
- **认证**: 简单Token
- **部署**: Uvicorn

## 注意事项

⚠️ 这是一个最简单的实现方案，仅适用于学习和开发环境：

1. **密码明文存储** - 生产环境请使用密码哈希
2. **简单Token** - 生产环境建议使用JWT
3. **无输入验证** - 生产环境需要添加参数验证
4. **无错误处理** - 生产环境需要完善错误处理
5. **无日志记录** - 生产环境需要添加日志系统

## 开发建议

如果要用于生产环境，建议添加：

- 密码哈希（bcrypt）
- JWT认证
- 输入参数验证（Pydantic）
- 错误处理中间件
- 日志系统
- 限流中间件
- CORS配置优化
- 数据库连接池 