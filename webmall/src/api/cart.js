import request from './request'

/**
 * 购物车相关API
 */

// 获取购物车列表
export const getCart = () => {
  return request.get('/cart')
}

// 添加商品到购物车
export const addToCart = (productData) => {
  return request.post('/cart', productData)
}

// 更新购物车商品数量
export const updateCartItem = (itemId, quantity) => {
  return request.put(`/cart/${itemId}`, { quantity })
}

// 删除购物车商品
export const removeFromCart = (itemId) => {
  return request.delete(`/cart/${itemId}`)
}

// 清空购物车
export const clearCart = () => {
  return request.delete('/cart')
}

// 批量删除购物车商品
export const batchRemoveFromCart = (itemIds) => {
  return request.delete('/cart/batch', { data: { itemIds } })
} 