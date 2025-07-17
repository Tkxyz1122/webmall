/**
 * API配置文件
 */

// 开发环境配置
const development = {
  baseURL: 'http://localhost:3000/api',
  timeout: 10000,
  withCredentials: false
}

// 生产环境配置
const production = {
  baseURL: 'https://your-api-domain.com/api',
  timeout: 10000,
  withCredentials: false
}

// 测试环境配置
const test = {
  baseURL: 'https://test-api-domain.com/api',
  timeout: 10000,
  withCredentials: false
}

// 根据环境变量选择配置
const config = {
  development,
  production,
  test
}

// 获取当前环境
const env = process.env.NODE_ENV || 'development'

// 导出当前环境的配置
export default config[env]

// 导出所有配置
export { development, production, test }

// API状态码
export const STATUS_CODE = {
  SUCCESS: 200,
  BAD_REQUEST: 400,
  UNAUTHORIZED: 401,
  FORBIDDEN: 403,
  NOT_FOUND: 404,
  SERVER_ERROR: 500
}

// 请求方法
export const REQUEST_METHOD = {
  GET: 'GET',
  POST: 'POST',
  PUT: 'PUT',
  DELETE: 'DELETE',
  PATCH: 'PATCH'
}

// 内容类型
export const CONTENT_TYPE = {
  JSON: 'application/json',
  FORM: 'application/x-www-form-urlencoded',
  MULTIPART: 'multipart/form-data'
} 