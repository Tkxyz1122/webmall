/**
 * 权限控制工具函数
 */

import { ElMessage } from 'element-plus'
import router from '@/router'

/**
 * 检查用户是否已登录
 * @returns {boolean}
 */
export const isUserLoggedIn = () => {
  const isLoggedIn = localStorage.getItem('isLoggedIn') === 'true'
  const token = localStorage.getItem('token')
  const result = isLoggedIn && !!token
  console.log('isUserLoggedIn检查:', { isLoggedIn, token, result }) // 添加调试信息
  return result
}

/**
 * 检查管理员是否已登录
 * @returns {boolean}
 */
export const isAdminLoggedIn = () => {
  const adminToken = localStorage.getItem('adminToken')
  const adminInfo = localStorage.getItem('adminInfo')
  return !!adminToken && !!adminInfo
}

/**
 * 要求用户登录，未登录则跳转到登录页
 * @param {string} message 提示消息
 * @returns {boolean} 是否已登录
 */
export const requireUserLogin = (message = '请先登录') => {
  if (!isUserLoggedIn()) {
    ElMessage.warning(message)
    router.push('/login')
    return false
  }
  return true
}

/**
 * 要求管理员登录，未登录则跳转到管理员登录页
 * @param {string} message 提示消息
 * @returns {boolean} 是否已登录
 */
export const requireAdminLogin = (message = '请先登录管理员账号') => {
  if (!isAdminLoggedIn()) {
    ElMessage.warning(message)
    router.push('/admin/login')
    return false
  }
  return true
}

/**
 * 获取用户token
 * @returns {string|null}
 */
export const getUserToken = () => {
  return localStorage.getItem('token')
}

/**
 * 获取管理员token
 * @returns {string|null}
 */
export const getAdminToken = () => {
  return localStorage.getItem('adminToken')
}

/**
 * 清除用户登录信息
 */
export const clearUserAuth = () => {
  localStorage.removeItem('token')
  localStorage.removeItem('user')
  localStorage.removeItem('isLoggedIn')
}

/**
 * 清除管理员登录信息
 */
export const clearAdminAuth = () => {
  localStorage.removeItem('adminToken')
  localStorage.removeItem('adminInfo')
}

/**
 * 清除所有登录信息
 */
export const clearAllAuth = () => {
  clearUserAuth()
  clearAdminAuth()
} 