import request from './request'

/**
 * 用户认证相关API
 */

// 用户注册
export const register = (userData) => {
  return request.post('/auth/register', userData)
}

// 用户登录
export const login = (credentials) => {
  return request.post('/auth/login', credentials)
}

// 用户登出
export const logout = () => {
  return request.post('/auth/logout')
}

// 获取用户信息
export const getUserProfile = () => {
  return request.get('/auth/profile')
}

// 更新用户信息
export const updateUserProfile = (userData) => {
  return request.put('/auth/profile', userData)
}

// 修改密码
export const changePassword = (passwordData) => {
  return request.put('/auth/password', passwordData)
} 