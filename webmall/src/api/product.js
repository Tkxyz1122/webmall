import request from './request'

/**
 * 商品相关API
 */

// 获取商品列表
export const getProducts = (params = {}) => {
  return request.get('/products', { params })
}

// 获取商品详情
export const getProductDetail = (id) => {
  return request.get(`/products/${id}`)
}

// 搜索商品
export const searchProducts = (params = {}) => {
  return request.get('/products', { params })
}

// 获取分类列表
export const getCategories = () => {
  return request.get('/categories')
}

// 获取分类详情
export const getCategoryDetail = (id) => {
  return request.get(`/categories/${id}`)
}

// 获取品牌列表
export const getBrands = () => {
  return request.get('/brands')
}

// 获取品牌详情
export const getBrandDetail = (id) => {
  return request.get(`/brands/${id}`)
}

// 获取推荐商品
export const getRecommendProducts = (params = {}) => {
  return request.get('/products/recommend', { params })
}

// 获取热销商品
export const getHotProducts = (params = {}) => {
  return request.get('/products/hot', { params })
}

// 获取新品
export const getNewProducts = (params = {}) => {
  return request.get('/products/new', { params })
} 