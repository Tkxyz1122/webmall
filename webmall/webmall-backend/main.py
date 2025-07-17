from fastapi import FastAPI, HTTPException, Depends, Header
from fastapi.middleware.cors import CORSMiddleware
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
import pymysql
import json
from typing import Optional, List
from datetime import datetime
import uuid

app = FastAPI(title="Vue商城后端API", version="1.0.0")

# 认证方案
security = HTTPBearer()

# 允许跨域
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# 数据库配置
DB_CONFIG = {
    'host': 'localhost',
    'user': 'root',
    'password': '123123qwe',
    'database': 'webmall',
    'charset': 'utf8mb4'
}

# 简单的内存token存储
tokens = {}

def get_db():
    """获取数据库连接"""
    return pymysql.connect(**DB_CONFIG)

def verify_token(credentials: HTTPAuthorizationCredentials = Depends(security)):
    """验证token"""
    token = credentials.credentials
    if token not in tokens:
        raise HTTPException(status_code=401, detail="无效的token")
    
    return tokens[token]

@app.get("/")
async def root():
    return {"message": "Vue商城后端API服务"}

# ================================
# 用户认证模块
# ================================

@app.post("/api/auth/register")
async def register(user_data: dict):
    """用户注册"""
    db = get_db()
    cursor = db.cursor()
    
    try:
        # 检查邮箱是否已存在
        cursor.execute("SELECT id FROM users WHERE email = %s", (user_data['email'],))
        if cursor.fetchone():
            raise HTTPException(status_code=400, detail="邮箱已存在")
        
        # 插入用户数据
        sql = """
        INSERT INTO users (username, email, password, phone, avatar, member_level, create_time)
        VALUES (%s, %s, %s, %s, %s, %s, %s)
        """
        cursor.execute(sql, (
            user_data['username'],
            user_data['email'],
            user_data['password'],  # 明文存储
            user_data.get('phone', ''),
            '',
            '普通会员',
            datetime.now()
        ))
        
        user_id = cursor.lastrowid
        db.commit()
        
        return {
            "code": 200,
            "message": "注册成功",
            "data": {
                "id": user_id,
                "username": user_data['username'],
                "email": user_data['email'],
                "phone": user_data.get('phone', ''),
                "avatar": "",
                "memberLevel": "普通会员",
                "createTime": datetime.now().isoformat()
            }
        }
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=str(e))
    finally:
        cursor.close()
        db.close()

@app.post("/api/auth/login")
async def login(login_data: dict):
    """用户登录"""
    db = get_db()
    cursor = db.cursor()
    
    try:
        # 查询用户
        sql = "SELECT id, username, email, phone, avatar, member_level FROM users WHERE email = %s AND password = %s"
        cursor.execute(sql, (login_data['email'], login_data['password']))
        user = cursor.fetchone()
        
        if not user:
            raise HTTPException(status_code=401, detail="邮箱或密码错误")
        
        # 生成简单token
        token = f"simple_token_{user[0]}_{uuid.uuid4().hex[:8]}"
        tokens[token] = {
            "id": user[0],
            "username": user[1],
            "email": user[2],
            "phone": user[3],
            "avatar": user[4] or "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=100&h=100&fit=crop&crop=face",
            "memberLevel": user[5]
        }
        
        return {
            "code": 200,
            "message": "登录成功",
            "data": {
                "id": user[0],
                "username": user[1],
                "email": user[2],
                "phone": user[3],
                "avatar": user[4] or "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=100&h=100&fit=crop&crop=face",
                "memberLevel": user[5],
                "token": token,
                "loginTime": datetime.now().isoformat()
            }
        }
    finally:
        cursor.close()
        db.close()

@app.post("/api/auth/logout")
async def logout(credentials: HTTPAuthorizationCredentials = Depends(security), user_info = Depends(verify_token)):
    """用户登出"""
    token = credentials.credentials
    # 从tokens中移除token
    if token in tokens:
        del tokens[token]
    return {"code": 200, "message": "登出成功"}

@app.get("/api/auth/profile")
async def get_profile(user_info = Depends(verify_token)):
    """获取用户信息"""
    return {
        "code": 200,
        "data": user_info
    }

# ================================
# 商品模块
# ================================

@app.get("/api/products")
async def get_products(
    page: int = 1,
    limit: int = 12,
    category: Optional[int] = None,
    minPrice: Optional[float] = None,
    maxPrice: Optional[float] = None,
    search: Optional[str] = None,
    sort: str = "default"
):
    """获取商品列表"""
    db = get_db()
    cursor = db.cursor()
    
    try:
        # 构建查询条件
        where_conditions = []
        params = []
        
        if category:
            where_conditions.append("category_id = %s")
            params.append(category)
        
        if minPrice:
            where_conditions.append("price >= %s")
            params.append(minPrice)
        
        if maxPrice:
            where_conditions.append("price <= %s")
            params.append(maxPrice)
        
        if search:
            where_conditions.append("(name LIKE %s OR description LIKE %s)")
            params.extend([f"%{search}%", f"%{search}%"])
        
        where_clause = " AND ".join(where_conditions) if where_conditions else "1=1"
        
        # 排序
        order_clause = "id DESC"
        if sort == "price-asc":
            order_clause = "price ASC"
        elif sort == "price-desc":
            order_clause = "price DESC"
        elif sort == "newest":
            order_clause = "create_time DESC"
        
        # 查询总数
        count_sql = f"SELECT COUNT(*) FROM products WHERE {where_clause}"
        cursor.execute(count_sql, params)
        total = cursor.fetchone()[0]
        
        # 查询商品
        offset = (page - 1) * limit
        sql = f"""
        SELECT id, name, description, price, original_price, image, images, brand, 
               category_id, stock, rating, reviews, tags, features, specs
        FROM products 
        WHERE {where_clause}
        ORDER BY {order_clause}
        LIMIT %s OFFSET %s
        """
        cursor.execute(sql, params + [limit, offset])
        products = cursor.fetchall()
        
        # 格式化结果
        product_list = []
        for p in products:
            product_list.append({
                "id": p[0],
                "name": p[1],
                "description": p[2],
                "price": float(p[3]),
                "originalPrice": float(p[4]) if p[4] else None,
                "image": p[5],
                "images": json.loads(p[6]) if p[6] else [],
                "brand": p[7],
                "category": p[8],
                "categoryName": "手机" if p[8] == 1 else "电脑",  # 简化处理
                "stock": p[9],
                "rating": float(p[10]) if p[10] else 0,
                "reviews": p[11],
                "tags": json.loads(p[12]) if p[12] else [],
                "features": json.loads(p[13]) if p[13] else [],
                "specs": json.loads(p[14]) if p[14] else {}
            })
        
        return {
            "code": 200,
            "data": {
                "products": product_list,
                "total": total,
                "page": page,
                "limit": limit,
                "totalPages": (total + limit - 1) // limit
            }
        }
    finally:
        cursor.close()
        db.close()

@app.get("/api/products/{product_id}")
async def get_product_detail(product_id: int):
    """获取商品详情"""
    db = get_db()
    cursor = db.cursor()
    
    try:
        sql = """
        SELECT id, name, description, price, original_price, image, images, brand,
               category_id, stock, rating, reviews, tags, features, specs, detail
        FROM products WHERE id = %s
        """
        cursor.execute(sql, (product_id,))
        product = cursor.fetchone()
        
        if not product:
            raise HTTPException(status_code=404, detail="商品不存在")
        
        return {
            "code": 200,
            "data": {
                "id": product[0],
                "name": product[1],
                "description": product[2],
                "price": float(product[3]),
                "originalPrice": float(product[4]) if product[4] else None,
                "image": product[5],
                "images": json.loads(product[6]) if product[6] else [],
                "brand": product[7],
                "category": product[8],
                "categoryName": "手机" if product[8] == 1 else "电脑",
                "stock": product[9],
                "rating": float(product[10]) if product[10] else 0,
                "reviews": product[11],
                "tags": json.loads(product[12]) if product[12] else [],
                "features": json.loads(product[13]) if product[13] else [],
                "specs": json.loads(product[14]) if product[14] else {},
                "detail": product[15] or ""
            }
        }
    finally:
        cursor.close()
        db.close()

@app.get("/api/categories")
async def get_categories():
    """获取分类列表"""
    db = get_db()
    cursor = db.cursor()
    
    try:
        cursor.execute("SELECT id, name, description, image, product_count FROM categories")
        categories = cursor.fetchall()
        
        category_list = []
        for c in categories:
            category_list.append({
                "id": c[0],
                "name": c[1],
                "description": c[2],
                "image": c[3],
                "productCount": c[4],
                "subcategories": []  # 简化处理
            })
        
        return {"code": 200, "data": category_list}
    finally:
        cursor.close()
        db.close()

@app.get("/api/brands")
async def get_brands():
    """获取品牌列表"""
    db = get_db()
    cursor = db.cursor()
    
    try:
        cursor.execute("SELECT id, name, description, logo, product_count FROM brands")
        brands = cursor.fetchall()
        
        brand_list = []
        for b in brands:
            brand_list.append({
                "id": b[0],
                "name": b[1],
                "description": b[2],
                "logo": b[3],
                "productCount": b[4]
            })
        
        return {"code": 200, "data": brand_list}
    finally:
        cursor.close()
        db.close()

@app.get("/api/banners")
async def get_banners():
    """获取首页轮播图数据"""
    db = get_db()
    cursor = db.cursor()
    
    try:
        cursor.execute("""
            SELECT id, title, subtitle, image, button_text, link, sort 
            FROM banners 
            ORDER BY sort ASC, id ASC
        """)
        banners = cursor.fetchall()
        
        banner_list = []
        for b in banners:
            banner_list.append({
                "id": b[0],
                "title": b[1],
                "subtitle": b[2],
                "image": b[3],
                "buttonText": b[4],
                "link": b[5],
                "sortOrder": b[6]
            })
        
        return {"code": 200, "data": banner_list}
    finally:
        cursor.close()
        db.close()

# ================================
# 订单模块
# ================================

@app.post("/api/orders")
async def create_order(order_data: dict, user_info = Depends(verify_token)):
    """创建订单"""
    db = get_db()
    cursor = db.cursor()
    
    try:
        # 生成订单ID
        order_id = f"ORDER_{datetime.now().strftime('%Y%m%d')}_{uuid.uuid4().hex[:6].upper()}"
        
        # 计算总金额
        total_amount = sum(item['price'] * item['quantity'] for item in order_data['items'])
        shipping_fee = order_data.get('shippingFee', 0)
        final_amount = total_amount + shipping_fee
        
        # 插入订单
        order_sql = """
        INSERT INTO orders (id, user_id, total_amount, shipping_fee, final_amount, 
                           status, shipping_address, payment_method, remark, create_time)
        VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
        """
        cursor.execute(order_sql, (
            order_id,
            user_info['id'],
            total_amount,
            shipping_fee,
            final_amount,
            '待支付',
            json.dumps(order_data['shippingAddress']),
            order_data.get('paymentMethod', ''),
            order_data.get('remark', ''),
            datetime.now()
        ))
        
        # 插入订单商品
        for item in order_data['items']:
            # 获取商品信息
            cursor.execute("SELECT name, image FROM products WHERE id = %s", (item['productId'],))
            product = cursor.fetchone()
            
            item_sql = """
            INSERT INTO order_items (order_id, product_id, product_name, product_image, 
                                   price, quantity, subtotal)
            VALUES (%s, %s, %s, %s, %s, %s, %s)
            """
            cursor.execute(item_sql, (
                order_id,
                item['productId'],
                product[0] if product else '',
                product[1] if product else '',
                item['price'],
                item['quantity'],
                item['price'] * item['quantity']
            ))
        
        db.commit()
        
        return {
            "code": 200,
            "message": "订单创建成功",
            "data": {
                "orderId": order_id,
                "totalAmount": total_amount,
                "shippingFee": shipping_fee,
                "finalAmount": final_amount,
                "status": "待支付",
                "createTime": datetime.now().isoformat()
            }
        }
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=str(e))
    finally:
        cursor.close()
        db.close()

@app.get("/api/orders")
async def get_orders(
    page: int = 1,
    limit: int = 10,
    status: Optional[str] = None,
    user_info = Depends(verify_token)
):
    """获取订单列表"""
    db = get_db()
    cursor = db.cursor()
    
    try:
        # 构建查询条件
        where_conditions = ["user_id = %s"]
        params = [user_info['id']]
        
        if status:
            where_conditions.append("status = %s")
            params.append(status)
        
        where_clause = " AND ".join(where_conditions)
        
        # 查询总数
        count_sql = f"SELECT COUNT(*) FROM orders WHERE {where_clause}"
        cursor.execute(count_sql, params)
        total = cursor.fetchone()[0]
        
        # 查询订单
        offset = (page - 1) * limit
        sql = f"""
        SELECT o.id, o.total_amount, o.shipping_fee, o.final_amount, o.status, o.create_time,
               COUNT(oi.id) as item_count
        FROM orders o
        LEFT JOIN order_items oi ON o.id = oi.order_id
        WHERE {where_clause}
        GROUP BY o.id
        ORDER BY o.create_time DESC
        LIMIT %s OFFSET %s
        """
        cursor.execute(sql, params + [limit, offset])
        orders = cursor.fetchall()
        
        # 格式化结果
        order_list = []
        for o in orders:
            # 获取第一个商品的信息
            cursor.execute("""
                SELECT product_name, product_image 
                FROM order_items 
                WHERE order_id = %s 
                LIMIT 1
            """, (o[0],))
            first_item = cursor.fetchone()
            
            order_list.append({
                "id": o[0],
                "totalAmount": float(o[1]),
                "shippingFee": float(o[2]),
                "finalAmount": float(o[3]),
                "status": o[4],
                "createTime": o[5].isoformat(),
                "itemCount": o[6],
                "firstItemImage": first_item[1] if first_item else "",
                "firstItemName": first_item[0] if first_item else ""
            })
        
        return {
            "code": 200,
            "data": {
                "orders": order_list,
                "total": total,
                "page": page,
                "limit": limit
            }
        }
    finally:
        cursor.close()
        db.close()

@app.get("/api/orders/{order_id}")
async def get_order_detail(order_id: str, user_info = Depends(verify_token)):
    """获取订单详情"""
    db = get_db()
    cursor = db.cursor()
    
    try:
        # 查询订单基本信息
        order_sql = """
        SELECT id, total_amount, shipping_fee, final_amount, status, create_time,
               shipping_address, payment_method, remark
        FROM orders 
        WHERE id = %s AND user_id = %s
        """
        cursor.execute(order_sql, (order_id, user_info['id']))
        order = cursor.fetchone()
        
        if not order:
            raise HTTPException(status_code=404, detail="订单不存在")
        
        # 查询订单商品
        items_sql = """
        SELECT product_id, product_name, product_image, price, quantity, subtotal
        FROM order_items
        WHERE order_id = %s
        """
        cursor.execute(items_sql, (order_id,))
        items = cursor.fetchall()
        
        item_list = []
        for item in items:
            item_list.append({
                "productId": item[0],
                "name": item[1],
                "image": item[2],
                "price": float(item[3]),
                "quantity": item[4],
                "subtotal": float(item[5])
            })
        
        return {
            "code": 200,
            "data": {
                "id": order[0],
                "status": order[4],
                "totalAmount": float(order[1]),
                "shippingFee": float(order[2]),
                "finalAmount": float(order[3]),
                "createTime": order[5].isoformat(),
                "items": item_list,
                "shippingAddress": json.loads(order[6]) if order[6] else {},
                "paymentMethod": order[7],
                "remark": order[8]
            }
        }
    finally:
        cursor.close()
        db.close()

@app.put("/api/orders/{order_id}/status")
async def update_order_status(order_id: str, status_data: dict, user_info = Depends(verify_token)):
    """更新订单状态"""
    db = get_db()
    cursor = db.cursor()
    
    try:
        sql = """
        UPDATE orders 
        SET status = %s, update_time = %s
        WHERE id = %s AND user_id = %s
        """
        cursor.execute(sql, (
            status_data['status'],
            datetime.now(),
            order_id,
            user_info['id']
        ))
        
        if cursor.rowcount == 0:
            raise HTTPException(status_code=404, detail="订单不存在")
        
        db.commit()
        
        return {
            "code": 200,
            "message": "订单状态更新成功",
            "data": {
                "orderId": order_id,
                "status": status_data['status'],
                "updateTime": datetime.now().isoformat()
            }
        }
    finally:
        cursor.close()
        db.close()

# ================================
# 管理员模块
# ================================

# 管理员token存储
admin_tokens = {}

def verify_admin_token(credentials: HTTPAuthorizationCredentials = Depends(security)):
    """验证管理员token"""
    token = credentials.credentials
    if token not in admin_tokens:
        raise HTTPException(status_code=401, detail="无效的管理员token")
    
    return admin_tokens[token]

@app.post("/api/admin/login")
async def admin_login(login_data: dict):
    """管理员登录"""
    # 简单的管理员验证（实际项目中应该从数据库验证）
    if login_data.get('username') == 'admin' and login_data.get('password') == 'admin123':
        # 生成管理员token
        token = f"admin_token_{uuid.uuid4().hex[:8]}"
        admin_tokens[token] = {
            "id": 1,
            "username": "admin",
            "role": "admin",
            "loginTime": datetime.now().isoformat()
        }
        
        return {
            "code": 200,
            "message": "管理员登录成功",
            "data": {
                "id": 1,
                "username": "admin",
                "role": "admin",
                "token": token,
                "loginTime": datetime.now().isoformat()
            }
        }
    else:
        raise HTTPException(status_code=401, detail="管理员账号或密码错误")

@app.get("/api/admin/dashboard")
async def get_dashboard_data(admin_info = Depends(verify_admin_token)):
    """获取仪表板数据"""
    db = get_db()
    cursor = db.cursor()
    
    try:
        # 统计订单数据
        cursor.execute("SELECT COUNT(*) FROM orders")
        total_orders = cursor.fetchone()[0]
        
        cursor.execute("SELECT COUNT(*) FROM orders WHERE status = '待支付'")
        pending_orders = cursor.fetchone()[0]
        
        cursor.execute("SELECT COUNT(*) FROM orders WHERE status = '已支付'")
        paid_orders = cursor.fetchone()[0]
        
        cursor.execute("SELECT COUNT(*) FROM orders WHERE status = '已完成'")
        completed_orders = cursor.fetchone()[0]
        
        # 统计商品数据
        cursor.execute("SELECT COUNT(*) FROM products")
        total_products = cursor.fetchone()[0]
        
        # 统计用户数据
        cursor.execute("SELECT COUNT(*) FROM users")
        total_users = cursor.fetchone()[0]
        
        # 计算总收入
        cursor.execute("SELECT SUM(final_amount) FROM orders WHERE status = '已完成'")
        total_revenue = cursor.fetchone()[0] or 0
        
        # 最近7天的订单
        cursor.execute("""
            SELECT DATE(create_time) as date, COUNT(*) as count, SUM(final_amount) as revenue
            FROM orders 
            WHERE create_time >= DATE_SUB(NOW(), INTERVAL 7 DAY)
            GROUP BY DATE(create_time)
            ORDER BY date DESC
        """)
        recent_orders = cursor.fetchall()
        
        return {
            "code": 200,
            "data": {
                "totalOrders": total_orders,
                "pendingOrders": pending_orders,
                "paidOrders": paid_orders,
                "completedOrders": completed_orders,
                "totalProducts": total_products,
                "totalUsers": total_users,
                "totalRevenue": float(total_revenue),
                "recentOrders": [
                    {
                        "date": str(row[0]),
                        "count": row[1],
                        "revenue": float(row[2]) if row[2] else 0
                    }
                    for row in recent_orders
                ]
            }
        }
    finally:
        cursor.close()
        db.close()

@app.get("/api/admin/orders")
async def get_admin_orders(
    page: int = 1,
    limit: int = 10,
    status: Optional[str] = None,
    admin_info = Depends(verify_admin_token)
):
    """管理员获取所有订单"""
    db = get_db()
    cursor = db.cursor()
    
    try:
        # 构建查询条件
        where_conditions = []
        params = []
        
        if status:
            where_conditions.append("o.status = %s")
            params.append(status)
        
        where_clause = " AND ".join(where_conditions) if where_conditions else "1=1"
        
        # 查询总数
        count_sql = f"SELECT COUNT(*) FROM orders o WHERE {where_clause}"
        cursor.execute(count_sql, params)
        total = cursor.fetchone()[0]
        
        # 查询订单
        offset = (page - 1) * limit
        sql = f"""
        SELECT o.id, o.total_amount, o.shipping_fee, o.final_amount, o.status, o.create_time,
               u.username as user_name, u.email as user_email,
               COUNT(oi.id) as item_count
        FROM orders o
        LEFT JOIN users u ON o.user_id = u.id
        LEFT JOIN order_items oi ON o.id = oi.order_id
        WHERE {where_clause}
        GROUP BY o.id
        ORDER BY o.create_time DESC
        LIMIT %s OFFSET %s
        """
        cursor.execute(sql, params + [limit, offset])
        orders = cursor.fetchall()
        
        # 格式化结果
        order_list = []
        for o in orders:
            order_list.append({
                "id": o[0],
                "totalAmount": float(o[1]),
                "shippingFee": float(o[2]),
                "finalAmount": float(o[3]),
                "status": o[4],
                "createTime": o[5].isoformat(),
                "userName": o[6],
                "userEmail": o[7],
                "itemCount": o[8]
            })
        
        return {
            "code": 200,
            "data": {
                "orders": order_list,
                "total": total,
                "page": page,
                "limit": limit
            }
        }
    finally:
        cursor.close()
        db.close()

@app.put("/api/admin/orders/{order_id}/status")
async def admin_update_order_status(order_id: str, status_data: dict, admin_info = Depends(verify_admin_token)):
    """管理员更新订单状态"""
    db = get_db()
    cursor = db.cursor()
    
    try:
        sql = """
        UPDATE orders 
        SET status = %s, update_time = %s
        WHERE id = %s
        """
        cursor.execute(sql, (
            status_data['status'],
            datetime.now(),
            order_id
        ))
        
        if cursor.rowcount == 0:
            raise HTTPException(status_code=404, detail="订单不存在")
        
        db.commit()
        
        return {
            "code": 200,
            "message": "订单状态更新成功",
            "data": {
                "orderId": order_id,
                "status": status_data['status'],
                "updateTime": datetime.now().isoformat()
            }
        }
    finally:
        cursor.close()
        db.close()

@app.get("/api/admin/products")
async def get_admin_products(
    page: int = 1,
    limit: int = 10,
    admin_info = Depends(verify_admin_token)
):
    """管理员获取所有商品"""
    db = get_db()
    cursor = db.cursor()
    
    try:
        # 查询总数
        cursor.execute("SELECT COUNT(*) FROM products")
        total = cursor.fetchone()[0]
        
        # 查询商品
        offset = (page - 1) * limit
        sql = """
        SELECT id, name, description, price, original_price, stock, image, 
               category_id, brand, create_time
        FROM products
        ORDER BY create_time DESC
        LIMIT %s OFFSET %s
        """
        cursor.execute(sql, [limit, offset])
        products = cursor.fetchall()
        
        # 格式化结果
        product_list = []
        for p in products:
            product_list.append({
                "id": p[0],
                "name": p[1],
                "description": p[2],
                "price": float(p[3]),
                "originalPrice": float(p[4]) if p[4] else None,
                "stock": p[5],
                "image": p[6],
                "categoryId": p[7],
                "brand": p[8],
                "createTime": p[9].isoformat() if p[9] else None
            })
        
        return {
            "code": 200,
            "data": {
                "products": product_list,
                "total": total,
                "page": page,
                "limit": limit
            }
        }
    finally:
        cursor.close()
        db.close()

@app.post("/api/admin/products")
async def create_product(product_data: dict, admin_info = Depends(verify_admin_token)):
    """创建商品"""
    db = get_db()
    cursor = db.cursor()
    
    try:
        sql = """
        INSERT INTO products (name, description, price, original_price, stock, image, 
                             category_id, brand, create_time)
        VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
        """
        cursor.execute(sql, (
            product_data['name'],
            product_data.get('description', ''),
            product_data['price'],
            product_data.get('originalPrice'),
            product_data.get('stock', 0),
            product_data.get('image', ''),
            product_data.get('categoryId'),
            product_data.get('brand', ''),
            datetime.now()
        ))
        
        product_id = cursor.lastrowid
        db.commit()
        
        return {
            "code": 200,
            "message": "商品创建成功",
            "data": {
                "id": product_id,
                "name": product_data['name']
            }
        }
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=str(e))
    finally:
        cursor.close()
        db.close()

@app.put("/api/admin/products/{product_id}")
async def update_product(product_id: int, product_data: dict, admin_info = Depends(verify_admin_token)):
    """更新商品"""
    db = get_db()
    cursor = db.cursor()
    
    try:
        sql = """
        UPDATE products 
        SET name = %s, description = %s, price = %s, original_price = %s, 
            stock = %s, image = %s, category_id = %s, brand = %s, update_time = %s
        WHERE id = %s
        """
        cursor.execute(sql, (
            product_data['name'],
            product_data.get('description', ''),
            product_data['price'],
            product_data.get('originalPrice'),
            product_data.get('stock', 0),
            product_data.get('image', ''),
            product_data.get('categoryId'),
            product_data.get('brand', ''),
            datetime.now(),
            product_id
        ))
        
        if cursor.rowcount == 0:
            raise HTTPException(status_code=404, detail="商品不存在")
        
        db.commit()
        
        return {
            "code": 200,
            "message": "商品更新成功",
            "data": {
                "id": product_id,
                "name": product_data['name']
            }
        }
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=str(e))
    finally:
        cursor.close()
        db.close()

@app.delete("/api/admin/products/{product_id}")
async def delete_product(product_id: int, admin_info = Depends(verify_admin_token)):
    """删除商品"""
    db = get_db()
    cursor = db.cursor()
    
    try:
        cursor.execute("DELETE FROM products WHERE id = %s", (product_id,))
        
        if cursor.rowcount == 0:
            raise HTTPException(status_code=404, detail="商品不存在")
        
        db.commit()
        
        return {
            "code": 200,
            "message": "商品删除成功"
        }
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=str(e))
    finally:
        cursor.close()
        db.close()

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=3000) 