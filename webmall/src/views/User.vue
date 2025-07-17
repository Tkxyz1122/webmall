<template>
  <div class="user-center">
    <div class="user-header">
      <div class="user-avatar">
        <img :src="userInfo?.avatar || defaultAvatar" :alt="userInfo?.username">
      </div>
      <div class="user-info">
        <h2>{{ userInfo?.username || '未登录' }}</h2>
        <p class="user-email">{{ userInfo?.email }}</p>
        <p class="member-level">{{ userInfo?.memberLevel || '普通会员' }}</p>
      </div>
      <div class="user-actions">
        <el-button v-if="!isLoggedIn" type="primary" @click="$router.push('/login')">
          立即登录
        </el-button>
        <el-button v-else type="default" @click="handleLogout">
          退出登录
        </el-button>
      </div>
    </div>

    <!-- 订单统计 -->
    <div class="order-stats" v-if="isLoggedIn">
      <el-card shadow="never">
        <template #header>
          <div class="card-header">
            <h3>我的订单</h3>
            <el-button type="text" @click="$router.push('/orders')">查看全部</el-button>
          </div>
        </template>
        
        <div class="stats-grid">
          <div class="stat-item" @click="goToOrders('待支付')">
            <div class="stat-icon pending">
              <el-icon><Clock /></el-icon>
            </div>
            <div class="stat-info">
              <div class="stat-number">{{ orderStats.pending || 0 }}</div>
              <div class="stat-label">待支付</div>
            </div>
          </div>
          
          <div class="stat-item" @click="goToOrders('已支付')">
            <div class="stat-icon paid">
              <el-icon><SuccessFilled /></el-icon>
            </div>
            <div class="stat-info">
              <div class="stat-number">{{ orderStats.paid || 0 }}</div>
              <div class="stat-label">已支付</div>
            </div>
          </div>
          
          <div class="stat-item" @click="goToOrders('已发货')">
            <div class="stat-icon shipped">
              <el-icon><Van /></el-icon>
            </div>
            <div class="stat-info">
              <div class="stat-number">{{ orderStats.shipped || 0 }}</div>
              <div class="stat-label">已发货</div>
            </div>
          </div>
          
          <div class="stat-item" @click="goToOrders('已完成')">
            <div class="stat-icon completed">
              <el-icon><CircleCheckFilled /></el-icon>
            </div>
            <div class="stat-info">
              <div class="stat-number">{{ orderStats.completed || 0 }}</div>
              <div class="stat-label">已完成</div>
            </div>
          </div>
        </div>
      </el-card>
    </div>

    <!-- 最近订单 -->
    <div class="recent-orders" v-if="isLoggedIn && recentOrders.length > 0">
      <el-card shadow="never">
        <template #header>
          <div class="card-header">
            <h3>最近订单</h3>
            <el-button type="text" @click="$router.push('/orders')">查看更多</el-button>
          </div>
        </template>
        
        <div class="order-list">
          <div v-for="order in recentOrders" :key="order.id" class="order-item" @click="$router.push(`/order/${order.id}`)">
            <div class="order-image">
              <img :src="order.firstItemImage" :alt="order.firstItemName">
            </div>
            <div class="order-info">
              <div class="order-name">{{ order.firstItemName }}</div>
              <div class="order-meta">
                <span class="order-id">{{ order.id }}</span>
                <span class="order-time">{{ formatDate(order.createTime) }}</span>
              </div>
            </div>
            <div class="order-status">
              <el-tag :type="getStatusType(order.status)">{{ order.status }}</el-tag>
            </div>
            <div class="order-amount">
              ¥{{ order.finalAmount.toLocaleString() }}
            </div>
          </div>
        </div>
      </el-card>
    </div>

    <!-- 功能菜单 -->
    <div class="feature-menu">
      <el-card shadow="never">
        <template #header>
          <h3>功能菜单</h3>
        </template>
        
        <div class="menu-grid">
          <div class="menu-item" @click="$router.push('/orders')">
            <div class="menu-icon">
              <el-icon><List /></el-icon>
            </div>
            <div class="menu-label">我的订单</div>
          </div>
          
          <div class="menu-item" @click="$router.push('/cart')">
            <div class="menu-icon">
              <el-icon><ShoppingCart /></el-icon>
            </div>
            <div class="menu-label">购物车</div>
          </div>
          
          <div class="menu-item" @click="$router.push('/')">
            <div class="menu-icon">
              <el-icon><Star /></el-icon>
            </div>
            <div class="menu-label">我的收藏</div>
          </div>
          
          <div class="menu-item" @click="$router.push('/')">
            <div class="menu-icon">
              <el-icon><Location /></el-icon>
            </div>
            <div class="menu-label">收货地址</div>
          </div>
          
          <div class="menu-item" @click="$router.push('/')">
            <div class="menu-icon">
              <el-icon><Setting /></el-icon>
            </div>
            <div class="menu-label">账户设置</div>
          </div>
          
          <div class="menu-item" @click="$router.push('/')">
            <div class="menu-icon">
              <el-icon><Service /></el-icon>
            </div>
            <div class="menu-label">客服中心</div>
          </div>
        </div>
      </el-card>
    </div>

    <!-- 未登录提示 -->
    <div v-if="!isLoggedIn" class="login-prompt">
      <el-card shadow="never">
        <div class="prompt-content">
          <el-icon class="prompt-icon"><User /></el-icon>
          <h3>您还未登录</h3>
          <p>登录后可查看订单、管理账户等更多功能</p>
          <div class="prompt-actions">
            <el-button type="primary" @click="$router.push('/login')">立即登录</el-button>
            <el-button type="default" @click="$router.push('/register')">注册账户</el-button>
          </div>
        </div>
      </el-card>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useStore } from 'vuex'
import { useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import { 
  Clock, 
  SuccessFilled, 
  Van, 
  CircleCheckFilled,
  List,
  ShoppingCart,
  Star,
  Location,
  Setting,
  Service,
  User
} from '@element-plus/icons-vue'
import { getOrders, getUserProfile, logout } from '@/api'

const store = useStore()
const router = useRouter()

const orderStats = ref({
  pending: 0,
  paid: 0,
  shipped: 0,
  completed: 0
})
const recentOrders = ref([])
const loading = ref(false)

const defaultAvatar = 'https://cube.elemecdn.com/3/7c/3ea6beec64369c2642b92c6726f1epng.png'

// 计算属性
const isLoggedIn = computed(() => store.getters.isLoggedIn)
const userInfo = computed(() => store.getters.currentUser)

// 获取用户信息
const fetchUserInfo = async () => {
  if (!isLoggedIn.value) return
  
  try {
    const response = await getUserProfile()
    store.commit('setUser', response.data)
  } catch (error) {
    console.error('获取用户信息失败:', error)
  }
}

// 获取订单统计
const fetchOrderStats = async () => {
  if (!isLoggedIn.value) return
  
  try {
    // 获取不同状态的订单数量
    const [pendingRes, paidRes, shippedRes, completedRes] = await Promise.all([
      getOrders({ status: '待支付', limit: 1 }),
      getOrders({ status: '已支付', limit: 1 }),
      getOrders({ status: '已发货', limit: 1 }),
      getOrders({ status: '已完成', limit: 1 })
    ])
    
    orderStats.value = {
      pending: pendingRes.data.total,
      paid: paidRes.data.total,
      shipped: shippedRes.data.total,
      completed: completedRes.data.total
    }
  } catch (error) {
    console.error('获取订单统计失败:', error)
  }
}

// 获取最近订单
const fetchRecentOrders = async () => {
  if (!isLoggedIn.value) return
  
  try {
    const response = await getOrders({ limit: 5 })
    recentOrders.value = response.data.orders
  } catch (error) {
    console.error('获取最近订单失败:', error)
  }
}

// 跳转到订单页面
const goToOrders = (status) => {
  if (status === 'all') {
    router.push('/orders')
  } else {
    router.push(`/orders?status=${status}`)
  }
}

// 获取状态类型
const getStatusType = (status) => {
  const statusMap = {
    '待支付': 'warning',
    '已支付': 'info',
    '已发货': 'primary',
    '已完成': 'success',
    '已取消': 'danger'
  }
  return statusMap[status] || 'info'
}

// 格式化日期
const formatDate = (dateString) => {
  return new Date(dateString).toLocaleDateString('zh-CN')
}

// 退出登录
const handleLogout = async () => {
  try {
    await ElMessageBox.confirm('确定要退出登录吗？', '提示', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    })

    await logout()
    store.commit('logout')
    ElMessage.success('已退出登录')
    router.push('/')
  } catch (error) {
    if (error !== 'cancel') {
      console.error('退出登录失败:', error)
      ElMessage.error('退出登录失败')
    }
  }
}

// 初始化数据
const initData = async () => {
  if (isLoggedIn.value) {
    loading.value = true
    try {
      await Promise.all([
        fetchUserInfo(),
        fetchOrderStats(),
        fetchRecentOrders()
      ])
    } finally {
      loading.value = false
    }
  }
}

onMounted(() => {
  initData()
})
</script>

<style scoped>
.user-center {
  max-width: 1200px;
  margin: 0 auto;
  padding: 20px;
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.user-header {
  display: flex;
  align-items: center;
  gap: 20px;
  padding: 30px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border-radius: 12px;
  color: white;
}

.user-avatar {
  width: 80px;
  height: 80px;
  border-radius: 50%;
  overflow: hidden;
  border: 3px solid rgba(255, 255, 255, 0.3);
}

.user-avatar img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.user-info {
  flex: 1;
}

.user-info h2 {
  margin: 0 0 8px 0;
  font-size: 1.5rem;
}

.user-email {
  margin: 0 0 4px 0;
  opacity: 0.8;
}

.member-level {
  margin: 0;
  opacity: 0.8;
  font-size: 0.9rem;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.card-header h3 {
  margin: 0;
  color: #333;
}

.stats-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 20px;
}

.stat-item {
  display: flex;
  align-items: center;
  gap: 16px;
  padding: 20px;
  background: #f8f9fa;
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.3s;
}

.stat-item:hover {
  background: #e9ecef;
  transform: translateY(-2px);
}

.stat-icon {
  width: 48px;
  height: 48px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 24px;
  color: white;
}

.stat-icon.pending {
  background: #f39c12;
}

.stat-icon.paid {
  background: #27ae60;
}

.stat-icon.shipped {
  background: #3498db;
}

.stat-icon.completed {
  background: #2ecc71;
}

.stat-number {
  font-size: 1.5rem;
  font-weight: 600;
  color: #333;
}

.stat-label {
  color: #666;
  font-size: 0.9rem;
}

.order-list {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.order-item {
  display: flex;
  align-items: center;
  gap: 16px;
  padding: 16px;
  background: #f8f9fa;
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.3s;
}

.order-item:hover {
  background: #e9ecef;
}

.order-image {
  width: 60px;
  height: 60px;
  border-radius: 8px;
  overflow: hidden;
  flex-shrink: 0;
}

.order-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.order-info {
  flex: 1;
}

.order-name {
  font-weight: 500;
  color: #333;
  margin-bottom: 4px;
}

.order-meta {
  display: flex;
  gap: 16px;
  font-size: 0.9rem;
  color: #666;
}

.order-amount {
  font-size: 1.1rem;
  font-weight: 600;
  color: #e74c3c;
}

.menu-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 20px;
}

.menu-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 12px;
  padding: 24px;
  background: #f8f9fa;
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.3s;
}

.menu-item:hover {
  background: #e9ecef;
  transform: translateY(-2px);
}

.menu-icon {
  width: 48px;
  height: 48px;
  border-radius: 50%;
  background: #667eea;
  color: white;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 24px;
}

.menu-label {
  color: #333;
  font-weight: 500;
}

.login-prompt {
  text-align: center;
  padding: 60px 20px;
}

.prompt-content {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 16px;
}

.prompt-icon {
  font-size: 64px;
  color: #ccc;
}

.prompt-content h3 {
  margin: 0;
  color: #333;
}

.prompt-content p {
  margin: 0;
  color: #666;
}

.prompt-actions {
  display: flex;
  gap: 16px;
  margin-top: 16px;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .user-center {
    padding: 15px;
  }
  
  .user-header {
    flex-direction: column;
    text-align: center;
    padding: 20px;
  }
  
  .stats-grid {
    grid-template-columns: repeat(2, 1fr);
  }
  
  .menu-grid {
    grid-template-columns: repeat(2, 1fr);
  }
  
  .order-item {
    flex-direction: column;
    text-align: center;
  }
  
  .prompt-actions {
    flex-direction: column;
    align-items: stretch;
  }
}
</style> 