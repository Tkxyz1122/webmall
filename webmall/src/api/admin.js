import request from './request'

/**
 * 管理员相关API
 */

// 管理员登录
export const adminLogin = (credentials) => {
  return request.post('/admin/login', credentials)
}

// 获取仪表板数据
export const getDashboardData = () => {
  return request.get('/admin/dashboard')
}

// 管理员获取所有订单
export const getAdminOrders = (params = {}) => {
  return request.get('/admin/orders', { params })
}

// 管理员更新订单状态
export const adminUpdateOrderStatus = (orderId, status) => {
  return request.put(`/admin/orders/${orderId}/status`, { status })
}

// 管理员获取所有商品
export const getAdminProducts = (params = {}) => {
  return request.get('/admin/products', { params })
}

// 创建商品
export const createProduct = (productData) => {
  return request.post('/admin/products', productData)
}

// 更新商品
export const updateProduct = (productId, productData) => {
  return request.put(`/admin/products/${productId}`, productData)
}

// 删除商品
export const deleteProduct = (productId) => {
  return request.delete(`/admin/products/${productId}`)
} 