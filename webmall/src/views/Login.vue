<template>
  <div class="login-container">
    <div class="login-wrapper">
      <div class="login-left">
        <div class="login-background"></div>
        <div class="login-content">
          <h1>欢迎回来</h1>
          <p>登录您的账户，继续购物之旅</p>
        </div>
      </div>
      
      <div class="login-right">
        <div class="login-form-container">
          <div class="login-header">
            <h2>登录</h2>
            <p>还没有账户？<router-link to="/register" class="link">立即注册</router-link></p>
          </div>
          
          <el-form
            ref="loginFormRef"
            :model="loginForm"
            :rules="loginRules"
            class="login-form"
            @keyup.enter="handleLogin"
          >
            <el-form-item prop="email">
              <el-input
                v-model="loginForm.email"
                placeholder="请输入邮箱地址"
                size="large"
                :prefix-icon="Message"
              />
            </el-form-item>
            
            <el-form-item prop="password">
              <el-input
                v-model="loginForm.password"
                type="password"
                placeholder="请输入密码"
                size="large"
                :prefix-icon="Lock"
                show-password
              />
            </el-form-item>
            
            <el-form-item>
              <div class="form-extras">
                <el-checkbox v-model="loginForm.remember">记住我</el-checkbox>
                <el-button type="text" class="forgot-password">忘记密码？</el-button>
              </div>
            </el-form-item>
            
            <el-form-item>
              <el-button
                type="primary"
                size="large"
                class="login-button"
                :loading="loginLoading"
                @click="handleLogin"
              >
                {{ loginLoading ? '登录中...' : '登录' }}
              </el-button>
            </el-form-item>
          </el-form>
          
          <div class="divider">
            <span>或者</span>
          </div>
          
          <div class="social-login">
            <el-button class="social-button" size="large">
              <svg class="social-icon" viewBox="0 0 24 24">
                <path d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z" fill="#4285F4"/>
              </svg>
              使用 Google 登录
            </el-button>
            
            <el-button class="social-button" size="large">
              <svg class="social-icon" viewBox="0 0 24 24">
                <path d="M12 2.04C6.5 2.04 2 6.53 2 12.06C2 17.06 5.66 21.21 10.44 21.96V14.96H7.9V12.06H10.44V9.85C10.44 7.34 11.93 5.96 14.22 5.96C15.31 5.96 16.45 6.15 16.45 6.15V8.62H15.19C13.95 8.62 13.56 9.39 13.56 10.18V12.06H16.34L15.89 14.96H13.56V21.96C18.34 21.21 22 17.06 22 12.06C22 6.53 17.5 2.04 12 2.04Z" fill="#1877F2"/>
              </svg>
              使用 Facebook 登录
            </el-button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { useRouter } from 'vue-router'
import { useStore } from 'vuex'
import { ElMessage } from 'element-plus'
import { Message, Lock } from '@element-plus/icons-vue'
import { login } from '@/api'

const router = useRouter()
const store = useStore()
const loginFormRef = ref()
const loginLoading = ref(false)

const loginForm = reactive({
  email: '',
  password: '',
  remember: false
})

const loginRules = {
  email: [
    { required: true, message: '请输入邮箱地址', trigger: 'blur' },
    { type: 'email', message: '请输入正确的邮箱格式', trigger: 'blur' }
  ],
  password: [
    { required: true, message: '请输入密码', trigger: 'blur' },
    { min: 6, message: '密码长度至少6位', trigger: 'blur' }
  ]
}

const handleLogin = async () => {
  try {
    await loginFormRef.value.validate()
    loginLoading.value = true
    
    // 调用真实登录API
    const response = await login({
      email: loginForm.email,
      password: loginForm.password
    })
    
    console.log('登录响应:', response) // 添加调试信息
    
    // 保存token到localStorage
    localStorage.setItem('token', response.data.token)
    console.log('Token已保存:', response.data.token) // 添加调试信息
    
    // 保存用户状态到Vuex store（这会同时更新localStorage中的用户信息）
    store.commit('setUser', response.data)
    console.log('用户状态已保存到Vuex') // 添加调试信息
    
    ElMessage.success('登录成功！')
    
    // 检查是否有重定向地址
    const redirect = router.currentRoute.value.query.redirect || '/'
    console.log('准备跳转到:', redirect) // 添加调试信息
    router.push(redirect)
    
  } catch (error) {
    console.error('登录失败:', error)
    ElMessage.error('登录失败，请检查邮箱和密码')
  } finally {
    loginLoading.value = false
  }
}
</script>

<style scoped>
.login-container {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  padding: 20px;
}

.login-wrapper {
  width: 100%;
  max-width: 1000px;
  display: flex;
  background: white;
  border-radius: 20px;
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.1);
  overflow: hidden;
  min-height: 600px;
}

.login-left {
  flex: 1;
  position: relative;
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
  text-align: center;
}

.login-background {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  opacity: 0.9;
}

.login-content {
  position: relative;
  z-index: 2;
  padding: 40px;
}

.login-content h1 {
  font-size: 2.5rem;
  margin-bottom: 16px;
  font-weight: 600;
}

.login-content p {
  font-size: 1.1rem;
  opacity: 0.9;
  line-height: 1.6;
}

.login-right {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 40px;
}

.login-form-container {
  width: 100%;
  max-width: 400px;
}

.login-header {
  margin-bottom: 32px;
  text-align: center;
}

.login-header h2 {
  font-size: 2rem;
  margin-bottom: 8px;
  color: #333;
  font-weight: 600;
}

.login-header p {
  color: #666;
  margin: 0;
}

.link {
  color: #409EFF;
  text-decoration: none;
  font-weight: 500;
}

.link:hover {
  text-decoration: underline;
}

.login-form {
  margin-bottom: 24px;
}

.form-extras {
  width: 100%;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.forgot-password {
  color: #409EFF;
  font-size: 14px;
  padding: 0;
}

.login-button {
  width: 100%;
  height: 48px;
  font-size: 16px;
  font-weight: 500;
  border-radius: 12px;
}

.divider {
  text-align: center;
  margin: 32px 0;
  position: relative;
  color: #999;
}

.divider::before {
  content: '';
  position: absolute;
  top: 50%;
  left: 0;
  right: 0;
  height: 1px;
  background: #e0e0e0;
}

.divider span {
  background: white;
  padding: 0 16px;
  position: relative;
}

.social-login {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.social-button {
  width: 100%;
  height: 48px;
  border: 1px solid #e0e0e0;
  background: white;
  color: #333;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 12px;
  border-radius: 12px;
  font-weight: 500;
}

.social-button:hover {
  background: #f5f5f5;
  border-color: #d0d0d0;
}

.social-icon {
  width: 20px;
  height: 20px;
}

@media (max-width: 768px) {
  .login-wrapper {
    flex-direction: column;
    margin: 0;
    border-radius: 0;
    min-height: 100vh;
  }
  
  .login-left {
    min-height: 200px;
  }
  
  .login-content h1 {
    font-size: 2rem;
  }
  
  .login-right {
    padding: 20px;
  }
}
</style> 