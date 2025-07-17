<template>
  <div class="register-container">
    <div class="register-wrapper">
      <div class="register-left">
        <div class="register-background"></div>
        <div class="register-content">
          <h1>加入我们</h1>
          <p>创建您的账户，开启精彩购物体验</p>
        </div>
      </div>
      
      <div class="register-right">
        <div class="register-form-container">
          <div class="register-header">
            <h2>注册</h2>
            <p>已有账户？<router-link to="/login" class="link">立即登录</router-link></p>
          </div>
          
          <el-form
            ref="registerFormRef"
            :model="registerForm"
            :rules="registerRules"
            class="register-form"
            @keyup.enter="handleRegister"
          >
            <el-form-item prop="username">
              <el-input
                v-model="registerForm.username"
                placeholder="请输入用户名"
                size="large"
                :prefix-icon="User"
              />
            </el-form-item>
            
            <el-form-item prop="email">
              <el-input
                v-model="registerForm.email"
                placeholder="请输入邮箱地址"
                size="large"
                :prefix-icon="Message"
              />
            </el-form-item>
            
            <el-form-item prop="password">
              <el-input
                v-model="registerForm.password"
                type="password"
                placeholder="请输入密码"
                size="large"
                :prefix-icon="Lock"
                show-password
              />
            </el-form-item>
            
            <el-form-item prop="confirmPassword">
              <el-input
                v-model="registerForm.confirmPassword"
                type="password"
                placeholder="请确认密码"
                size="large"
                :prefix-icon="Lock"
                show-password
              />
            </el-form-item>
            
            <el-form-item prop="phone">
              <el-input
                v-model="registerForm.phone"
                placeholder="请输入手机号码"
                size="large"
                :prefix-icon="Phone"
              />
            </el-form-item>
            
            <el-form-item prop="agreement">
              <el-checkbox v-model="registerForm.agreement">
                我已阅读并同意<el-button type="text" class="agreement-link">《用户协议》</el-button>和<el-button type="text" class="agreement-link">《隐私政策》</el-button>
              </el-checkbox>
            </el-form-item>
            
            <el-form-item>
              <el-button
                type="primary"
                size="large"
                class="register-button"
                :loading="registerLoading"
                @click="handleRegister"
              >
                {{ registerLoading ? '注册中...' : '立即注册' }}
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
              使用 Google 注册
            </el-button>
            
            <el-button class="social-button" size="large">
              <svg class="social-icon" viewBox="0 0 24 24">
                <path d="M12 2.04C6.5 2.04 2 6.53 2 12.06C2 17.06 5.66 21.21 10.44 21.96V14.96H7.9V12.06H10.44V9.85C10.44 7.34 11.93 5.96 14.22 5.96C15.31 5.96 16.45 6.15 16.45 6.15V8.62H15.19C13.95 8.62 13.56 9.39 13.56 10.18V12.06H16.34L15.89 14.96H13.56V21.96C18.34 21.21 22 17.06 22 12.06C22 6.53 17.5 2.04 12 2.04Z" fill="#1877F2"/>
              </svg>
              使用 Facebook 注册
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
import { ElMessage } from 'element-plus'
import { User, Message, Lock, Phone } from '@element-plus/icons-vue'

const router = useRouter()
const registerFormRef = ref()
const registerLoading = ref(false)

const registerForm = reactive({
  username: '',
  email: '',
  password: '',
  confirmPassword: '',
  phone: '',
  agreement: false
})

const validateConfirmPassword = (rule, value, callback) => {
  if (value !== registerForm.password) {
    callback(new Error('两次输入的密码不一致'))
  } else {
    callback()
  }
}

const registerRules = {
  username: [
    { required: true, message: '请输入用户名', trigger: 'blur' },
    { min: 2, max: 20, message: '用户名长度为2-20个字符', trigger: 'blur' }
  ],
  email: [
    { required: true, message: '请输入邮箱地址', trigger: 'blur' },
    { type: 'email', message: '请输入正确的邮箱格式', trigger: 'blur' }
  ],
  password: [
    { required: true, message: '请输入密码', trigger: 'blur' },
    { min: 6, max: 20, message: '密码长度为6-20位', trigger: 'blur' },
    { pattern: /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d@$!%*?&]/, message: '密码必须包含大小写字母和数字', trigger: 'blur' }
  ],
  confirmPassword: [
    { required: true, message: '请确认密码', trigger: 'blur' },
    { validator: validateConfirmPassword, trigger: 'blur' }
  ],
  phone: [
    { required: true, message: '请输入手机号码', trigger: 'blur' },
    { pattern: /^1[3-9]\d{9}$/, message: '请输入正确的手机号码', trigger: 'blur' }
  ],
  agreement: [
    { required: true, message: '请阅读并同意用户协议', trigger: 'change' },
    { 
      validator: (rule, value, callback) => {
        if (!value) {
          callback(new Error('请同意用户协议'))
        } else {
          callback()
        }
      }, 
      trigger: 'change' 
    }
  ]
}

const handleRegister = async () => {
  try {
    await registerFormRef.value.validate()
    registerLoading.value = true
    
    // 模拟注册API调用
    setTimeout(() => {
      registerLoading.value = false
      ElMessage.success('注册成功！即将跳转到登录页面')
      setTimeout(() => {
        router.push('/login')
      }, 1500)
    }, 2000)
    
  } catch (error) {
    console.log('表单验证失败:', error)
  }
}
</script>

<style scoped>
.register-container {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  padding: 20px;
}

.register-wrapper {
  width: 100%;
  max-width: 1100px;
  display: flex;
  background: white;
  border-radius: 20px;
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.1);
  overflow: hidden;
  min-height: 700px;
}

.register-left {
  flex: 1;
  position: relative;
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
  text-align: center;
}

.register-background {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  opacity: 0.9;
}

.register-content {
  position: relative;
  z-index: 2;
  padding: 40px;
}

.register-content h1 {
  font-size: 2.5rem;
  margin-bottom: 16px;
  font-weight: 600;
}

.register-content p {
  font-size: 1.1rem;
  opacity: 0.9;
  line-height: 1.6;
}

.register-right {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 40px;
}

.register-form-container {
  width: 100%;
  max-width: 400px;
}

.register-header {
  margin-bottom: 32px;
  text-align: center;
}

.register-header h2 {
  font-size: 2rem;
  margin-bottom: 8px;
  color: #333;
  font-weight: 600;
}

.register-header p {
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

.register-form {
  margin-bottom: 24px;
}

.agreement-link {
  color: #409EFF;
  font-size: 14px;
  padding: 0;
  text-decoration: underline;
}

.register-button {
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
  .register-wrapper {
    flex-direction: column;
    margin: 0;
    border-radius: 0;
    min-height: 100vh;
  }
  
  .register-left {
    min-height: 200px;
  }
  
  .register-content h1 {
    font-size: 2rem;
  }
  
  .register-right {
    padding: 20px;
  }
}
</style> 