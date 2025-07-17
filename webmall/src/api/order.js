import request from './request'

/**
 * 订单相关API
 */

// 创建订单
export const createOrder = (orderData) => {
  return request.post('/orders', orderData)
}

// 获取订单列表
export const getOrders = (params = {}) => {
  return request.get('/orders', { params })
}

// 获取订单详情
export const getOrderDetail = (id) => {
  return request.get(`/orders/${id}`)
}

// 更新订单状态
export const updateOrderStatus = (id, status) => {
  return request.put(`/orders/${id}/status`, { status })
}

// 取消订单
export const cancelOrder = (id) => {
  return request.put(`/orders/${id}/status`, { status: '已取消' })
}

// 确认收货
export const confirmOrder = (id) => {
  return request.put(`/orders/${id}/status`, { status: '已完成' })
}

// 删除订单
export const deleteOrder = (id) => {
  return request.delete(`/orders/${id}`)
}

// 获取订单统计
export const getOrderStats = () => {
  return request.get('/orders/stats')
}

// 支付相关API
// 创建支付订单
export const createPayment = (orderId, paymentData) => {
  return request.post(`/orders/${orderId}/payment`, paymentData)
}

// 获取支付状态
export const getPaymentStatus = (orderId) => {
  return request.get(`/orders/${orderId}/payment/status`)
}

// 支付成功回调
export const paymentSuccess = (orderId, paymentData) => {
  return request.post(`/orders/${orderId}/payment/success`, paymentData)
} 