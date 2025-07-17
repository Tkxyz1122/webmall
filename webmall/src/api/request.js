import axios from 'axios'
import { ElMessage } from 'element-plus'
import config from './config'

// 创建axios实例
const request = axios.create({
  baseURL: config.baseURL,
  timeout: config.timeout,
  withCredentials: config.withCredentials,
  headers: {
    'Content-Type': 'application/json'
  }
})

// 请求拦截器
request.interceptors.request.use(
  config => {
    // 从localStorage获取token（优先使用管理员token）
    const adminToken = localStorage.getItem('adminToken')
    const userToken = localStorage.getItem('token')
    const token = adminToken || userToken
    
    if (token) {
      config.headers.Authorization = `Bearer ${token}`
    }
    return config
  },
  error => {
    console.error('请求错误:', error)
    return Promise.reject(error)
  }
)

// 响应拦截器
request.interceptors.response.use(
  response => {
    const { data } = response
    
    // 根据后端返回的code判断请求是否成功
    if (data.code === 200) {
      return data
    } else {
      // 请求失败，显示错误信息
      ElMessage.error(data.message || '请求失败')
      return Promise.reject(new Error(data.message || '请求失败'))
    }
  },
  error => {
    console.error('响应错误:', error)
    
    // 处理HTTP错误状态码
    if (error.response) {
      const { status, data } = error.response
      
      switch (status) {
        case 401:
          ElMessage.error('未授权，请重新登录')
          // 清除token并跳转到登录页
          localStorage.removeItem('token')
          localStorage.removeItem('user')
          localStorage.removeItem('isLoggedIn')
          window.location.href = '/login'
          break
        case 403:
          ElMessage.error('禁止访问')
          break
        case 404:
          ElMessage.error('请求的资源不存在')
          break
        case 500:
          ElMessage.error('服务器内部错误')
          break
        default:
          ElMessage.error(data?.message || `请求失败 (${status})`)
      }
    } else if (error.request) {
      ElMessage.error('网络连接失败，请检查网络设置')
    } else {
      ElMessage.error('请求配置错误')
    }
    
    return Promise.reject(error)
  }
)

export default request 