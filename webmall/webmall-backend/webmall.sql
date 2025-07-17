/*
 Navicat Premium Data Transfer

 Source Server         : localhost_3306
 Source Server Type    : MySQL
 Source Server Version : 80035
 Source Host           : localhost:3306
 Source Schema         : webmall

 Target Server Type    : MySQL
 Target Server Version : 80035
 File Encoding         : 65001

 Date: 17/07/2025 18:06:07
*/
USE webmall;
SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for banners
-- ----------------------------
DROP TABLE IF EXISTS `banners`;
CREATE TABLE `banners`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `subtitle` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `button_text` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `link` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `sort` int NULL DEFAULT 0,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_sort`(`sort` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of banners
-- ----------------------------
INSERT INTO `banners` VALUES (1, 'iPhone 15 Pro 新品首发', 'A17 Pro芯片，专业级摄影体验', 'https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=1200&h=500&fit=crop', '立即购买', '/product/1', 1, '2024-01-01 00:00:00');
INSERT INTO `banners` VALUES (2, 'MacBook Pro 限时优惠', 'M3芯片强劲性能，专业创作首选', 'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=1200&h=500&fit=crop', '查看详情', '/product/4', 2, '2024-01-01 00:00:00');
INSERT INTO `banners` VALUES (3, '华为Mate 60 Pro', '卫星通话，突破想象', 'https://images.unsplash.com/photo-1574944985070-8f3ebc6b79d2?w=1200&h=500&fit=crop', '了解更多', '/product/2', 3, '2024-01-01 00:00:00');
INSERT INTO `banners` VALUES (4, '数码配件大促销', '耳机、手表、平板全场8折起', 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=1200&h=500&fit=crop', '马上抢购', '/products?category=4', 4, '2024-01-01 00:00:00');

-- ----------------------------
-- Table structure for brands
-- ----------------------------
DROP TABLE IF EXISTS `brands`;
CREATE TABLE `brands`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `logo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `product_count` int NULL DEFAULT 0,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_name`(`name` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of brands
-- ----------------------------
INSERT INTO `brands` VALUES (1, 'Apple', '创新科技产品', 'https://images.unsplash.com/photo-1621768216002-5ac171876625?w=100&h=100&fit=crop', 25, '2024-01-01 00:00:00');
INSERT INTO `brands` VALUES (2, '华为', '智能终端设备', 'https://images.unsplash.com/photo-1611532736597-de2d4265fba3?w=100&h=100&fit=crop', 30, '2024-01-01 00:00:00');
INSERT INTO `brands` VALUES (3, '小米', '为发烧而生', 'https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=100&h=100&fit=crop', 35, '2024-01-01 00:00:00');
INSERT INTO `brands` VALUES (4, '三星', '创新科技领导者', 'https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?w=100&h=100&fit=crop', 28, '2024-01-01 00:00:00');
INSERT INTO `brands` VALUES (5, '索尼', '音视频技术专家', 'https://images.unsplash.com/photo-1606107557195-0e29a4b5b4aa?w=100&h=100&fit=crop', 20, '2024-01-01 00:00:00');

-- ----------------------------
-- Table structure for categories
-- ----------------------------
DROP TABLE IF EXISTS `categories`;
CREATE TABLE `categories`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `product_count` int NULL DEFAULT 0,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_name`(`name` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of categories
-- ----------------------------
INSERT INTO `categories` VALUES (1, '手机', '智能手机及配件', 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=300&h=300&fit=crop', 150, '2024-01-01 00:00:00');
INSERT INTO `categories` VALUES (2, '电脑', '笔记本电脑、台式机', 'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=300&h=300&fit=crop', 80, '2024-01-01 00:00:00');
INSERT INTO `categories` VALUES (3, '平板', '平板电脑及配件', 'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?w=300&h=300&fit=crop', 45, '2024-01-01 00:00:00');
INSERT INTO `categories` VALUES (4, '耳机', '有线耳机、无线耳机', 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=300&h=300&fit=crop', 120, '2024-01-01 00:00:00');
INSERT INTO `categories` VALUES (5, '智能手表', '智能手表及运动手环', 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=300&h=300&fit=crop', 60, '2024-01-01 00:00:00');

-- ----------------------------
-- Table structure for order_items
-- ----------------------------
DROP TABLE IF EXISTS `order_items`;
CREATE TABLE `order_items`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `order_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `product_id` int NOT NULL,
  `product_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `product_image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `price` decimal(10, 2) NOT NULL,
  `quantity` int NOT NULL,
  `subtotal` decimal(10, 2) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_order_id`(`order_id` ASC) USING BTREE,
  INDEX `idx_product_id`(`product_id` ASC) USING BTREE,
  CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `order_items_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of order_items
-- ----------------------------
INSERT INTO `order_items` VALUES (1, 'ORDER_20240101_001', 1, 'iPhone 15 Pro', 'https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=100&h=100&fit=crop', 7999.00, 2, 15998.00);
INSERT INTO `order_items` VALUES (2, 'ORDER_20240101_001', 2, '华为Mate 60 Pro', 'https://images.unsplash.com/photo-1574944985070-8f3ebc6b79d2?w=100&h=100&fit=crop', 6999.00, 1, 6999.00);
INSERT INTO `order_items` VALUES (3, 'ORDER_20240102_002', 4, 'MacBook Pro 14英寸', 'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=100&h=100&fit=crop', 14999.00, 1, 14999.00);
INSERT INTO `order_items` VALUES (4, 'ORDER_20240103_003', 7, 'AirPods Pro 2', 'https://images.unsplash.com/photo-1606220945770-b5b6c2c55bf1?w=100&h=100&fit=crop', 1999.00, 2, 3998.00);
INSERT INTO `order_items` VALUES (5, 'ORDER_20240103_003', 8, 'Apple Watch Series 9', 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=100&h=100&fit=crop', 2999.00, 1, 2999.00);
INSERT INTO `order_items` VALUES (6, 'ORDER_20240103_003', 3, '小米14 Pro', 'https://images.unsplash.com/photo-1556656793-08538906a9f8?w=100&h=100&fit=crop', 4999.00, 1, 4999.00);
INSERT INTO `order_items` VALUES (7, 'ORDER_20240104_004', 9, '华为MatePad Pro', 'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?w=100&h=100&fit=crop', 4999.00, 1, 4999.00);
INSERT INTO `order_items` VALUES (8, 'ORDER_20240105_005', 10, '索尼WH-1000XM5', 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=100&h=100&fit=crop', 2399.00, 1, 2399.00);
INSERT INTO `order_items` VALUES (9, 'ORDER_20250704_29B519', 1, 'iPhone 15 Pro', 'https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=300&h=300&fit=crop', 7999.00, 2, 15998.00);
INSERT INTO `order_items` VALUES (10, 'ORDER_20250704_29B519', 2, '华为Mate 60 Pro', 'https://images.unsplash.com/photo-1574944985070-8f3ebc6b79d2?w=300&h=300&fit=crop', 5999.00, 1, 5999.00);
INSERT INTO `order_items` VALUES (11, 'ORDER_20250716_631A6D', 9, '华为MatePad Pro', 'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?w=300&h=300&fit=crop', 4999.00, 1, 4999.00);
INSERT INTO `order_items` VALUES (12, 'ORDER_20250717_D73FAC', 9, '华为MatePad Pro', 'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?w=300&h=300&fit=crop', 4999.00, 1, 4999.00);
INSERT INTO `order_items` VALUES (13, 'ORDER_20250717_D73FAC', 8, 'Apple Watch Series 9', 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=300&h=300&fit=crop', 2999.00, 1, 2999.00);

-- ----------------------------
-- Table structure for orders
-- ----------------------------
DROP TABLE IF EXISTS `orders`;
CREATE TABLE `orders`  (
  `id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `user_id` int NOT NULL,
  `total_amount` decimal(10, 2) NOT NULL,
  `shipping_fee` decimal(10, 2) NULL DEFAULT 0.00,
  `final_amount` decimal(10, 2) NOT NULL,
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '待支付',
  `shipping_address` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `payment_method` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `remark` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  INDEX `idx_create_time`(`create_time` ASC) USING BTREE,
  CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of orders
-- ----------------------------
INSERT INTO `orders` VALUES ('ORDER_20240101_001', 2, 22997.00, 0.00, 22997.00, '待支付', '{\"name\":\"张三\",\"phone\":\"13800138000\",\"address\":\"北京市朝阳区建国路88号SOHO现代城\"}', '支付宝', '请尽快发货', '2024-01-01 00:00:00', '2024-01-01 00:00:00');
INSERT INTO `orders` VALUES ('ORDER_20240102_002', 3, 14999.00, 0.00, 14999.00, '已支付', '{\"name\":\"李四\",\"phone\":\"13800138001\",\"address\":\"上海市浦东新区陆家嘴环路1000号\"}', '微信支付', '', '2024-01-02 00:00:00', '2024-01-02 01:00:00');
INSERT INTO `orders` VALUES ('ORDER_20240103_003', 4, 11996.00, 15.00, 12011.00, '已发货', '{\"name\":\"王五\",\"phone\":\"13800138002\",\"address\":\"广州市天河区珠江新城花城大道123号\"}', '支付宝', '工作日送货', '2024-01-03 00:00:00', '2024-01-03 10:00:00');
INSERT INTO `orders` VALUES ('ORDER_20240104_004', 5, 4999.00, 0.00, 4999.00, '已完成', '{\"name\":\"赵六\",\"phone\":\"13800138003\",\"address\":\"深圳市南山区科技园南区深南大道9988号\"}', '银行卡', '请放在前台', '2024-01-04 00:00:00', '2024-01-10 00:00:00');
INSERT INTO `orders` VALUES ('ORDER_20240105_005', 2, 2399.00, 0.00, 2399.00, '已取消', '{\"name\":\"张三\",\"phone\":\"13800138000\",\"address\":\"北京市朝阳区建国路88号SOHO现代城\"}', '支付宝', '临时取消', '2024-01-05 00:00:00', '2024-01-05 02:00:00');
INSERT INTO `orders` VALUES ('ORDER_20250704_29B519', 2, 21997.00, 0.00, 21997.00, '已支付', '{\"name\": \"\\u5f20\\u4e09\", \"phone\": \"13800138000\", \"address\": \"\\u5317\\u4eac\\u5e02\\u671d\\u9633\\u533a\\u5efa\\u56fd\\u8def88\\u53f7SOHO\\u73b0\\u4ee3\\u57ce\"}', '支付宝', '请尽快发货', '2025-07-04 20:55:42', '2025-07-04 20:58:27');
INSERT INTO `orders` VALUES ('ORDER_20250716_631A6D', 1, 4999.00, 0.00, 4999.00, '已支付', '{\"name\": \"admin\", \"phone\": \"13800138000\", \"address\": \"\\u9ed8\\u8ba4\\u6536\\u8d27\\u5730\\u5740\"}', '在线支付', '', '2025-07-16 22:01:26', '2025-07-16 22:08:04');
INSERT INTO `orders` VALUES ('ORDER_20250717_D73FAC', 1, 7998.00, 0.00, 7998.00, '已支付', '{\"name\": \"admin\", \"phone\": \"13800138000\", \"address\": \"\\u9ed8\\u8ba4\\u6536\\u8d27\\u5730\\u5740\"}', '在线支付', '', '2025-07-17 13:23:24', '2025-07-17 13:23:35');

-- ----------------------------
-- Table structure for products
-- ----------------------------
DROP TABLE IF EXISTS `products`;
CREATE TABLE `products`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `price` decimal(10, 2) NOT NULL,
  `original_price` decimal(10, 2) NULL DEFAULT NULL,
  `image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `images` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `brand` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `category_id` int NULL DEFAULT NULL,
  `stock` int NULL DEFAULT 0,
  `rating` decimal(3, 2) NULL DEFAULT 0.00,
  `reviews` int NULL DEFAULT 0,
  `tags` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `features` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `specs` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `detail` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_category`(`category_id` ASC) USING BTREE,
  INDEX `idx_brand`(`brand` ASC) USING BTREE,
  INDEX `idx_price`(`price` ASC) USING BTREE,
  INDEX `idx_name`(`name` ASC) USING BTREE,
  CONSTRAINT `products_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of products
-- ----------------------------
INSERT INTO `products` VALUES (1, 'iPhone 15 Pro', '最新款iPhone，配备A17 Pro芯片，支持5G网络', 7999.00, 8999.00, 'https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=300&h=300&fit=crop', '[\"https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=500&h=500&fit=crop\",\"https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=500&h=500&fit=crop\",\"https://images.unsplash.com/photo-1565849904461-04a58ad377e0?w=500&h=500&fit=crop\"]', 'Apple', 1, 100, 4.80, 1234, '[\"新品\",\"热销\",\"5G\"]', '[\"5G\",\"三摄\",\"快充\",\"无线充电\"]', '{\"屏幕\":\"6.1英寸Super Retina XDR\",\"内存\":\"128GB\",\"处理器\":\"A17 Pro\",\"摄像头\":\"48MP主摄\",\"电池\":\"3274mAh\",\"系统\":\"iOS 17\"}', '<div><h3>产品特色</h3><p>iPhone 15 Pro采用全新的A17 Pro芯片，性能更加强劲，支持专业级摄影功能。</p></div>', '2024-01-01 00:00:00', '2024-01-01 00:00:00');
INSERT INTO `products` VALUES (2, '华为Mate 60 Pro', '华为旗舰手机，支持卫星通话', 6999.00, 7999.00, 'https://images.unsplash.com/photo-1574944985070-8f3ebc6b79d2?w=300&h=300&fit=crop', '[\"https://images.unsplash.com/photo-1574944985070-8f3ebc6b79d2?w=500&h=500&fit=crop\",\"https://images.unsplash.com/photo-1580910051074-3eb694886505?w=500&h=500&fit=crop\"]', '华为', 1, 80, 4.70, 856, '[\"旗舰\",\"卫星通话\"]', '[\"卫星通话\",\"徕卡影像\",\"快充\",\"无线充电\"]', '{\"屏幕\":\"6.82英寸OLED\",\"内存\":\"256GB\",\"处理器\":\"麒麟9000S\",\"摄像头\":\"50MP主摄\",\"电池\":\"5000mAh\",\"系统\":\"HarmonyOS 4.0\"}', '<div><h3>产品特色</h3><p>华为Mate 60 Pro支持卫星通话功能，即使在没有信号的地方也能保持通讯。</p></div>', '2024-01-01 00:00:00', '2024-01-01 00:00:00');
INSERT INTO `products` VALUES (3, '小米14 Pro', '小米旗舰手机，徕卡影像系统', 4999.00, 5499.00, 'https://images.unsplash.com/photo-1556656793-08538906a9f8?w=300&h=300&fit=crop', '[\"https://images.unsplash.com/photo-1556656793-08538906a9f8?w=500&h=500&fit=crop\",\"https://images.unsplash.com/photo-1598300042247-d088f8ab3a91?w=500&h=500&fit=crop\"]', '小米', 1, 120, 4.60, 672, '[\"性价比\",\"徕卡\"]', '[\"徕卡影像\",\"120W快充\",\"无线充电\",\"5G\"]', '{\"屏幕\":\"6.73英寸AMOLED\",\"内存\":\"256GB\",\"处理器\":\"骁龙8 Gen3\",\"摄像头\":\"50MP主摄\",\"电池\":\"4880mAh\",\"系统\":\"MIUI 15\"}', '<div><h3>产品特色</h3><p>小米14 Pro配备徕卡影像系统，拍照效果专业级。</p></div>', '2024-01-01 00:00:00', '2024-01-01 00:00:00');
INSERT INTO `products` VALUES (4, 'MacBook Pro 14英寸', '苹果专业级笔记本电脑，M3芯片', 14999.00, 16999.00, 'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=300&h=300&fit=crop', '[\"https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=500&h=500&fit=crop\",\"https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=500&h=500&fit=crop\"]', 'Apple', 2, 50, 4.90, 432, '[\"专业\",\"M3芯片\"]', '[\"M3芯片\",\"Liquid Retina XDR显示屏\",\"22小时续航\",\"雷雳4\"]', '{\"屏幕\":\"14.2英寸Liquid Retina XDR\",\"内存\":\"512GB SSD\",\"处理器\":\"Apple M3\",\"内存\":\"18GB统一内存\",\"重量\":\"1.6kg\",\"系统\":\"macOS Sonoma\"}', '<div><h3>产品特色</h3><p>MacBook Pro 14英寸搭载强大的M3芯片，为专业用户提供卓越性能。</p></div>', '2024-01-01 00:00:00', '2024-01-01 00:00:00');
INSERT INTO `products` VALUES (5, 'ThinkPad X1 Carbon', '商务笔记本电脑，轻薄便携', 12999.00, 14999.00, 'https://images.unsplash.com/photo-1541807084-5c52b6b3adef?w=300&h=300&fit=crop', '[\"https://images.unsplash.com/photo-1541807084-5c52b6b3adef?w=500&h=500&fit=crop\",\"https://images.unsplash.com/photo-1588872657578-7efd1f1555ed?w=500&h=500&fit=crop\"]', '联想', 2, 30, 4.50, 298, '[\"商务\",\"轻薄\"]', '[\"轻薄设计\",\"指纹识别\",\"快速充电\",\"军工级测试\"]', '{\"屏幕\":\"14英寸2.8K OLED\",\"内存\":\"512GB SSD\",\"处理器\":\"Intel i7-1365U\",\"内存\":\"16GB LPDDR5\",\"重量\":\"1.12kg\",\"系统\":\"Windows 11\"}', '<div><h3>产品特色</h3><p>ThinkPad X1 Carbon超轻薄设计，是商务人士的理想选择。</p></div>', '2024-01-01 00:00:00', '2024-01-01 00:00:00');
INSERT INTO `products` VALUES (6, 'iPad Pro 12.9英寸', '苹果专业平板电脑，M2芯片', 8999.00, 9999.00, 'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?w=300&h=300&fit=crop', '[\"https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?w=500&h=500&fit=crop\",\"https://images.unsplash.com/photo-1561154464-82e9adf32764?w=500&h=500&fit=crop\"]', 'Apple', 3, 60, 4.80, 567, '[\"专业\",\"M2芯片\"]', '[\"M2芯片\",\"Liquid Retina XDR显示屏\",\"Apple Pencil支持\",\"妙控键盘\"]', '{\"屏幕\":\"12.9英寸Liquid Retina XDR\",\"内存\":\"256GB\",\"处理器\":\"Apple M2\",\"摄像头\":\"12MP广角\",\"重量\":\"682g\",\"系统\":\"iPadOS 17\"}', '<div><h3>产品特色</h3><p>iPad Pro 12.9英寸搭载M2芯片，性能强劲，适合专业创作。</p></div>', '2024-01-01 00:00:00', '2024-01-01 00:00:00');
INSERT INTO `products` VALUES (7, 'AirPods Pro 2', '苹果无线降噪耳机，主动降噪', 1999.00, 2299.00, 'https://images.unsplash.com/photo-1606220945770-b5b6c2c55bf1?w=300&h=300&fit=crop', '[\"https://images.unsplash.com/photo-1606220945770-b5b6c2c55bf1?w=500&h=500&fit=crop\",\"https://images.unsplash.com/photo-1588423771073-b8903fbb85b5?w=500&h=500&fit=crop\"]', 'Apple', 4, 200, 4.70, 1456, '[\"降噪\",\"无线\"]', '[\"主动降噪\",\"空间音频\",\"自适应透明模式\",\"无线充电\"]', '{\"降噪\":\"主动降噪\",\"续航\":\"6小时+24小时\",\"芯片\":\"H2芯片\",\"防水\":\"IPX4\",\"连接\":\"蓝牙5.3\",\"充电\":\"Lightning/无线\"}', '<div><h3>产品特色</h3><p>AirPods Pro 2配备H2芯片，提供更强的主动降噪和空间音频体验。</p></div>', '2024-01-01 00:00:00', '2024-01-01 00:00:00');
INSERT INTO `products` VALUES (8, 'Apple Watch Series 9', '苹果智能手表，健康监测', 2999.00, 3299.00, 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=300&h=300&fit=crop', '[\"https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=500&h=500&fit=crop\",\"https://images.unsplash.com/photo-1510017803434-a899398421b3?w=500&h=500&fit=crop\"]', 'Apple', 5, 150, 4.60, 789, '[\"健康\",\"智能\"]', '[\"健康监测\",\"GPS定位\",\"防水\",\"Siri\"]', '{\"屏幕\":\"45mm Retina显示屏\",\"处理器\":\"S9芯片\",\"续航\":\"18小时\",\"防水\":\"50米防水\",\"传感器\":\"血氧、心率、体温\",\"系统\":\"watchOS 10\"}', '<div><h3>产品特色</h3><p>Apple Watch Series 9搭载S9芯片，提供全面的健康监测功能。</p></div>', '2024-01-01 00:00:00', '2024-01-01 00:00:00');
INSERT INTO `products` VALUES (9, '华为MatePad Pro', '华为专业平板，办公娱乐两不误', 4999.00, 5499.00, 'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?w=300&h=300&fit=crop', '[\"https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?w=500&h=500&fit=crop\",\"https://images.unsplash.com/photo-1561154464-82e9adf32764?w=500&h=500&fit=crop\"]', '华为', 3, 80, 4.50, 423, '[\"办公\",\"娱乐\"]', '[\"M-Pencil支持\",\"智能磁吸键盘\",\"多屏协同\",\"120Hz刷新率\"]', '{\"屏幕\":\"12.6英寸OLED\",\"内存\":\"256GB\",\"处理器\":\"麒麟9000E\",\"摄像头\":\"13MP\",\"重量\":\"609g\",\"系统\":\"HarmonyOS 4.0\"}', '<div><h3>产品特色</h3><p>华为MatePad Pro支持多屏协同，办公娱乐体验升级。</p></div>', '2024-01-01 00:00:00', '2024-01-01 00:00:00');
INSERT INTO `products` VALUES (10, '索尼WH-1000XM5', '索尼旗舰降噪耳机，音质卓越', 2399.00, 2699.00, 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=300&h=300&fit=crop', '[\"https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=500&h=500&fit=crop\",\"https://images.unsplash.com/photo-1484704849700-f032a568e944?w=500&h=500&fit=crop\"]', '索尼', 4, 100, 4.80, 634, '[\"降噪\",\"音质\"]', '[\"行业领先降噪\",\"30小时续航\",\"快速充电\",\"多点连接\"]', '{\"降噪\":\"双降噪处理器\",\"续航\":\"30小时\",\"充电\":\"3分钟充电3小时播放\",\"驱动\":\"30mm动圈\",\"连接\":\"蓝牙5.2\",\"重量\":\"250g\"}', '<div><h3>产品特色</h3><p>索尼WH-1000XM5采用双降噪处理器，提供行业领先的降噪效果。</p></div>', '2024-01-01 00:00:00', '2024-01-01 00:00:00');
INSERT INTO `products` VALUES (11, '测试商品', '测试商品', 199.00, 299.00, '', NULL, '', NULL, 5, 0.00, 0, NULL, NULL, NULL, NULL, '2025-07-17 13:13:59', '2025-07-17 13:13:58');
INSERT INTO `products` VALUES (12, '测试商品2222', '测试商品2222', 99.00, 999.00, '', NULL, '', NULL, 3, 0.00, 0, NULL, NULL, NULL, NULL, '2025-07-17 13:24:44', '2025-07-17 13:24:44');

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `member_level` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '普通会员',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `email`(`email` ASC) USING BTREE,
  INDEX `idx_email`(`email` ASC) USING BTREE,
  INDEX `idx_username`(`username` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO `users` VALUES (1, 'admin', 'admin@example.com', '123456', '13800138000', 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=100&h=100&fit=crop&crop=face', '管理员', '2024-01-01 00:00:00', '2024-01-01 00:00:00');
INSERT INTO `users` VALUES (2, 'testuser', 'test@example.com', '123456', '13800138001', 'https://images.unsplash.com/photo-1494790108755-2616b332c647?w=100&h=100&fit=crop&crop=face', 'VIP', '2024-01-02 00:00:00', '2024-01-02 00:00:00');
INSERT INTO `users` VALUES (3, '张三', 'zhangsan@example.com', '123456', '13800138002', 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&h=100&fit=crop&crop=face', '普通会员', '2024-01-03 00:00:00', '2024-01-03 00:00:00');
INSERT INTO `users` VALUES (4, '李四', 'lisi@example.com', '123456', '13800138003', 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100&h=100&fit=crop&crop=face', 'VIP', '2024-01-04 00:00:00', '2024-01-04 00:00:00');
INSERT INTO `users` VALUES (5, '王五', 'wangwu@example.com', '123456', '13800138004', 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100&h=100&fit=crop&crop=face', '普通会员', '2024-01-05 00:00:00', '2024-01-05 00:00:00');
INSERT INTO `users` VALUES (6, 'testuser1', 'test1@example.com', '123456', '13800138000', '', '普通会员', '2025-07-04 20:42:16', '2025-07-04 20:42:15');

SET FOREIGN_KEY_CHECKS = 1;
