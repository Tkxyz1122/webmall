import request from './request'

/**
 * 通用API
 */

// 获取轮播图列表
export const getBanners = () => {
  return request.get('/banners')
}

// 获取首页数据
export const getHomeData = () => {
  return request.get('/home')
}

// 全局搜索
export const globalSearch = (keyword) => {
  return request.get('/search', { params: { keyword } })
}

// 获取搜索热词
export const getSearchHotwords = () => {
  return request.get('/search/hotwords')
}

// 上传文件
export const uploadFile = (file) => {
  const formData = new FormData()
  formData.append('file', file)
  return request.post('/upload', formData, {
    headers: {
      'Content-Type': 'multipart/form-data'
    }
  })
}

// 获取系统配置
export const getSystemConfig = () => {
  return request.get('/config')
}

// 获取地区列表
export const getRegions = () => {
  return request.get('/regions')
}

// 发送短信验证码
export const sendSmsCode = (phone) => {
  return request.post('/sms/send', { phone })
}

// 验证短信验证码
export const verifySmsCode = (phone, code) => {
  return request.post('/sms/verify', { phone, code })
} 