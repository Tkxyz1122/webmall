<template>
  <el-container class="admin-layout">
    <!-- 侧边栏 -->
    <el-aside width="250px" class="admin-sidebar">
      <div class="sidebar-header">
        <h2>商城管理后台</h2>
      </div>
      
      <el-menu
        :default-active="activeMenu"
        class="sidebar-menu"
        @select="handleMenuSelect"
        router
      >
        <el-menu-item index="/admin/dashboard">
          <el-icon><DataBoard /></el-icon>
          <span>仪表板</span>
        </el-menu-item>
        
        <el-menu-item index="/admin/orders">
          <el-icon><List /></el-icon>
          <span>订单管理</span>
        </el-menu-item>
        
        <el-menu-item index="/admin/products">
          <el-icon><Goods /></el-icon>
          <span>商品管理</span>
        </el-menu-item>
        <el-menu-item index="">
          <el-icon><Goods /></el-icon>
          <span>分类管理</span>
        </el-menu-item>
        <el-menu-item index="">
          <el-icon><Goods /></el-icon>
          <span>标签管理</span>
        </el-menu-item>
        <el-menu-item index="">
          <el-icon><Goods /></el-icon>
          <span>评论管理</span>
        </el-menu-item>
        <el-menu-item index="">
          <el-icon><Goods /></el-icon>
          <span>用户管理</span>
        </el-menu-item>
        <el-menu-item index="">
          <el-icon><Goods /></el-icon>
          <span>运营管理</span>
        </el-menu-item>
        <el-menu-item index="">
          <el-icon><Goods /></el-icon>
          <span>日志管理</span>
        </el-menu-item>
        <el-menu-item index="">
          <el-icon><Goods /></el-icon>
          <span>系统信息管理</span>
        </el-menu-item>
      </el-menu>
    </el-aside>
    
    <!-- 主内容区 -->
    <el-container class="admin-main">
      <!-- 顶部导航 -->
      <el-header class="admin-header">
        <div class="header-left">
          <h3>{{ pageTitle }}</h3>
        </div>
        
        <div class="header-right">
          <el-dropdown @command="handleUserAction">
            <span class="user-info">
              <el-avatar :size="32" :src="adminInfo.avatar || 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=100&h=100&fit=crop&crop=face'" />
              <span class="username">{{ adminInfo.username }}</span>
              <el-icon><ArrowDown /></el-icon>
            </span>
            <template #dropdown>
              <el-dropdown-menu>
                <el-dropdown-item command="logout">
                  <el-icon><SwitchButton /></el-icon> 退出登录
                </el-dropdown-item>
              </el-dropdown-menu>
            </template>
          </el-dropdown>
        </div>
      </el-header>
      
      <!-- 内容区域 -->
      <el-main class="admin-content">
        <router-view></router-view>
      </el-main>
    </el-container>
  </el-container>
</template>

<script setup>
import { computed, ref, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { DataBoard, List, Goods, ArrowDown, SwitchButton } from '@element-plus/icons-vue'

const route = useRoute()
const router = useRouter()

const adminInfo = ref({})

// 获取管理员信息
const getAdminInfo = () => {
  const savedInfo = localStorage.getItem('adminInfo')
  if (savedInfo) {
    adminInfo.value = JSON.parse(savedInfo)
  }
}

// 当前激活的菜单
const activeMenu = computed(() => route.path)

// 页面标题
const pageTitle = computed(() => {
  const titleMap = {
    '/admin/dashboard': '仪表板',
    '/admin/orders': '订单管理',
    '/admin/products': '商品管理'
  }
  return titleMap[route.path] || '管理后台'
})

// 菜单选择处理
const handleMenuSelect = (index) => {
  router.push(index)
}

// 用户操作处理
const handleUserAction = (command) => {
  if (command === 'logout') {
    // 清除管理员信息
    localStorage.removeItem('adminToken')
    localStorage.removeItem('adminInfo')
    ElMessage.success('已退出登录')
    router.push('/admin/login')
  }
}

onMounted(() => {
  getAdminInfo()
})
</script>

<style scoped>
.admin-layout {
  height: 100vh;
}

.admin-sidebar {
  background: #304156;
  color: white;
}

.sidebar-header {
  padding: 20px;
  border-bottom: 1px solid #435266;
}

.sidebar-header h2 {
  margin: 0;
  color: white;
  font-size: 1.2rem;
}

.sidebar-menu {
  border: none;
  background: transparent;
}

.sidebar-menu :deep(.el-menu-item) {
  color: #bfcbd9;
  background: transparent;
}

.sidebar-menu :deep(.el-menu-item:hover) {
  color: white;
  background: #263445;
}

.sidebar-menu :deep(.el-menu-item.is-active) {
  color: #409eff;
  background: #263445;
}

.admin-main {
  background: #f0f2f5;
}

.admin-header {
  background: white;
  border-bottom: 1px solid #e4e7ed;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 20px;
}

.header-left h3 {
  margin: 0;
  color: #333;
  font-size: 1.2rem;
}

.user-info {
  display: flex;
  align-items: center;
  gap: 8px;
  cursor: pointer;
  padding: 8px 12px;
  border-radius: 6px;
  transition: background-color 0.3s;
}

.user-info:hover {
  background: #f5f7fa;
}

.username {
  color: #333;
  font-weight: 500;
}

.admin-content {
  padding: 20px;
  overflow-y: auto;
}
</style> 