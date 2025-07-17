-- 创建数据库
CREATE DATABASE IF NOT EXISTS webmall CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE webmall;

-- 用户表
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

-- 分类表
CREATE TABLE categories (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL,
  description TEXT,
  image VARCHAR(255),
  product_count INT DEFAULT 0,
  create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 品牌表
CREATE TABLE brands (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL,
  description TEXT,
  logo VARCHAR(255),
  product_count INT DEFAULT 0,
  create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 轮播图表
CREATE TABLE banners (
  id INT PRIMARY KEY AUTO_INCREMENT,
  title VARCHAR(255),
  image VARCHAR(255) NOT NULL,
  link VARCHAR(255),
  sort_order INT DEFAULT 0,
  is_active BOOLEAN DEFAULT TRUE,
  create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 商品表
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

-- 订单表
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

-- 订单商品表
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

-- 插入测试数据
INSERT INTO categories (name, description, image, product_count) VALUES 
('手机', '智能手机及配件', 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=300&h=300&fit=crop', 2),
('电脑', '笔记本电脑、台式机', 'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=300&h=300&fit=crop', 1);

INSERT INTO brands (name, description, logo, product_count) VALUES 
('Apple', '创新科技产品', 'https://images.unsplash.com/photo-1621768216002-5ac171876625?w=100&h=100&fit=crop', 2),
('华为', '智能终端设备', 'https://images.unsplash.com/photo-1611532736597-de2d4265fba3?w=100&h=100&fit=crop', 1);

-- 插入轮播图数据
INSERT INTO banners (title, image, link, sort_order, is_active) VALUES 
('iPhone 15 Pro 新品上市', 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=1200&h=400&fit=crop', '/products/1', 1, TRUE),
('MacBook Pro 专业之选', 'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=1200&h=400&fit=crop', '/products/2', 2, TRUE),
('华为Mate 60 Pro 旗舰体验', 'https://images.unsplash.com/photo-1506744038136-46273834b3fb?w=1200&h=400&fit=crop', '/products/3', 3, TRUE);

INSERT INTO products (name, description, price, original_price, image, images, brand, category_id, stock, rating, reviews, tags, features, specs, detail) VALUES 
('iPhone 15 Pro', '最新款iPhone，配备A17 Pro芯片', 7999.00, 8999.00, 
'https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=300&h=300&fit=crop',
'["https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=500&h=500&fit=crop", "https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=500&h=500&fit=crop"]',
'Apple', 1, 100, 4.8, 1234, 
'["新品", "热销"]', 
'["5G", "三摄", "快充"]', 
'{"屏幕": "6.1英寸", "内存": "128GB", "处理器": "A17 Pro"}',
'<div><h3>产品特色</h3><p>iPhone 15 Pro采用全新的A17 Pro芯片，性能更加强劲...</p></div>'),

('MacBook Pro', '专业级笔记本电脑', 12999.00, 13999.00,
'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=300&h=300&fit=crop',
'["https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=500&h=500&fit=crop"]',
'Apple', 2, 50, 4.9, 567,
'["专业", "高性能"]',
'["M2芯片", "Retina显示屏", "长续航"]',
'{"屏幕": "14英寸", "内存": "16GB", "存储": "512GB SSD"}',
'<div><h3>产品特色</h3><p>MacBook Pro搭载M2芯片，为专业用户提供强大性能...</p></div>'),

('华为Mate 60 Pro', '华为旗舰手机', 6999.00, 7999.00,
'https://images.unsplash.com/photo-1574944985070-8f3ebc6b79d2?w=300&h=300&fit=crop',
'["https://images.unsplash.com/photo-1574944985070-8f3ebc6b79d2?w=500&h=500&fit=crop"]',
'华为', 1, 80, 4.7, 890,
'["国产", "旗舰"]',
'["麒麟芯片", "徕卡影像", "鸿蒙系统"]',
'{"屏幕": "6.82英寸", "内存": "256GB", "处理器": "麒麟9000S"}',
'<div><h3>产品特色</h3><p>华为Mate 60 Pro搭载麒麟9000S芯片，支持5G网络...</p></div>');

-- 插入测试用户
INSERT INTO users (username, email, password, phone, avatar, member_level) VALUES 
('testuser', 'test@example.com', '123456', '13800138000', 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=100&h=100&fit=crop&crop=face', 'VIP'); 