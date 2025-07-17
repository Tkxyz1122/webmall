<template>
  <el-container class="layout-container">
    <el-header class="main-header">
      <div class="header-content">
        <div class="logo">
          <h1>Mall</h1>
        </div>
        <el-menu mode="horizontal" :router="true" class="main-menu">
          <el-menu-item index="/">首页</el-menu-item>
          <el-menu-item index="/products">全部商品</el-menu-item>
          <el-menu-item index="/categories">商品分类</el-menu-item>
        </el-menu>
        <div class="user-actions">
          <el-button-group>
            <el-button :icon="ShoppingCart" @click="handleCartClick">
              购物车
              <el-badge :value="cartItemCount" class="cart-badge" v-if="cartItemCount > 0"/>
            </el-button>
            
            <!-- 未登录状态 -->
            <template v-if="!isLoggedIn">
              <el-button :icon="User" @click="$router.push('/login')">登录</el-button>
            </template>
            
            <!-- 已登录状态 -->
            <template v-else>
              <el-dropdown trigger="click" @command="handleUserAction">
                <el-button :icon="User">
                  {{ currentUser.username }}
                  <el-icon class="el-icon--right"><arrow-down /></el-icon>
                </el-button>
                <template #dropdown>
                  <el-dropdown-menu>
                    <el-dropdown-item command="profile">
                      <el-icon><User /></el-icon> 个人中心
                    </el-dropdown-item>
                    <el-dropdown-item command="orders">
                      <el-icon><List /></el-icon> 我的订单
                    </el-dropdown-item>
                    <el-dropdown-item command="settings">
                      <el-icon><Setting /></el-icon> 账户设置
                    </el-dropdown-item>
                    <el-dropdown-item divided command="logout">
                      <el-icon><SwitchButton /></el-icon> 退出登录
                    </el-dropdown-item>
                  </el-dropdown-menu>
                </template>
              </el-dropdown>
            </template>
          </el-button-group>
        </div>
      </div>
    </el-header>
    
    <el-container class="main-container">
      <el-main>
        <router-view></router-view>
      </el-main>
    </el-container>

    <el-footer class="main-footer">
      <p>&copy; 2024 Mall商城. All rights reserved.</p>
    </el-footer>
    
    <!-- 全局悬浮购物车 -->
    <FloatingCart />
  </el-container>
</template>

<script setup>
import { computed } from 'vue'
import { useStore } from 'vuex'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { ShoppingCart, User, ArrowDown, List, Setting, SwitchButton } from '@element-plus/icons-vue'
import { requireUserLogin } from '@/utils/auth'
import FloatingCart from '../FloatingCart.vue'

const store = useStore()
const router = useRouter()

const cartItemCount = computed(() => store.getters.cartItemCount)
const isLoggedIn = computed(() => store.getters.isLoggedIn)
const currentUser = computed(() => store.getters.currentUser)

const handleCartClick = () => {
  if (requireUserLogin('请先登录后再查看购物车')) {
    router.push('/cart')
  }
}

const handleUserAction = (command) => {
  switch (command) {
    case 'profile':
      router.push('/user')
      break
    case 'orders':
      router.push('/orders')
      break
    case 'settings':
      ElMessage.info('设置功能开发中...')
      break
    case 'logout':
      store.commit('logout')
      ElMessage.success('已退出登录')
      router.push('/')
      break
  }
}
</script>

<style scoped>
.layout-container {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
}

.main-header {
  background: #fff;
  box-shadow: 0 2px 8px rgba(0,0,0,0.1);
  padding: 0;
  height: 64px;
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  z-index: 1000;
}

.header-content {
  width: 100%;
  margin: 0;
  padding: 0 20px;
  height: 100%;
  display: flex;
  align-items: center;
}

.logo {
  margin-right: 40px;
}

.logo h1 {
  margin: 0;
  font-size: 24px;
  color: #409EFF;
}

.main-menu {
  flex: 1;
  border: none;
}

.user-actions {
  margin-left: auto;
}

.main-container {
  flex: 1;
  margin-top: 64px; /* 与header高度相同 */
  background: #f5f7fa;
}

.el-main {
  padding: 20px;
  width: 100%;
  margin: 0;
}

.main-footer {
  text-align: center;
  background: #fff;
  padding: 24px;
  color: #666;
}
</style> 