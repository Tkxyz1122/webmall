<template>
  <div class="admin-login">
    <div class="login-container">
      <div class="login-card">
        <div class="login-header">
          <h1>管理员登录</h1>
          <p>请输入管理员账号和密码</p>
        </div>
        
        <el-form
          ref="loginFormRef"
          :model="loginForm"
          :rules="loginRules"
          class="login-form"
          @keyup.enter="handleLogin"
        >
          <el-form-item prop="username">
            <el-input
              v-model="loginForm.username"
              placeholder="管理员账号"
              size="large"
              :prefix-icon="User"
            />
          </el-form-item>
          
          <el-form-item prop="password">
            <el-input
              v-model="loginForm.password"
              type="password"
              placeholder="管理员密码"
              size="large"
              :prefix-icon="Lock"
              show-password
            />
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
        
        <div class="login-footer">
          <el-button type="text" @click="$router.push('/')">返回商城</el-button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { User, Lock } from '@element-plus/icons-vue'
import { adminLogin } from '@/api'

const router = useRouter()
const loginFormRef = ref()
const loginLoading = ref(false)

const loginForm = reactive({
  username: '',
  password: ''
})

const loginRules = {
  username: [
    { required: true, message: '请输入管理员账号', trigger: 'blur' }
  ],
  password: [
    { required: true, message: '请输入管理员密码', trigger: 'blur' },
    { min: 6, message: '密码长度至少6位', trigger: 'blur' }
  ]
}

const handleLogin = async () => {
  try {
    await loginFormRef.value.validate()
    loginLoading.value = true
    
    const response = await adminLogin({
      username: loginForm.username,
      password: loginForm.password
    })
    
    // 保存管理员token
    localStorage.setItem('adminToken', response.data.token)
    localStorage.setItem('adminInfo', JSON.stringify(response.data))
    
    ElMessage.success('管理员登录成功！')
    router.push('/admin/dashboard')
    
  } catch (error) {
    console.error('管理员登录失败:', error)
    ElMessage.error('管理员登录失败，请检查账号和密码')
  } finally {
    loginLoading.value = false
  }
}
</script>

<style scoped>
.admin-login {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  padding: 20px;
}

.login-container {
  width: 100%;
  max-width: 400px;
}

.login-card {
  background: white;
  border-radius: 16px;
  padding: 40px;
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.1);
}

.login-header {
  text-align: center;
  margin-bottom: 30px;
}

.login-header h1 {
  font-size: 2rem;
  color: #333;
  margin-bottom: 8px;
}

.login-header p {
  color: #666;
  font-size: 1rem;
}

.login-form {
  margin-bottom: 20px;
}

.login-button {
  width: 100%;
  height: 48px;
  font-size: 1.1rem;
  font-weight: 600;
}

.login-footer {
  text-align: center;
  padding-top: 20px;
  border-top: 1px solid #f0f0f0;
}
</style> 