/**
 * API统一入口文件
 * 导出所有API接口，方便统一管理和使用
 */

// 用户认证相关API
export * from './auth'

// 商品相关API
export * from './product'

// 订单相关API
export * from './order'

// 购物车相关API
export * from './cart'

// 通用API
export * from './common'

// 管理员API
export * from './admin'

// 导出请求实例，供特殊情况使用
export { default as request } from './request' 