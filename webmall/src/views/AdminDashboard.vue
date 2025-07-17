<template>
  <div class="admin-dashboard">
    <!-- 统计卡片 -->
    <div class="stats-grid">
      <el-card class="stat-card">
        <div class="stat-content">
          <div class="stat-icon orders">
            <el-icon><List /></el-icon>
          </div>
          <div class="stat-info">
            <div class="stat-value">{{ dashboardData.totalOrders }}</div>
            <div class="stat-label">总订单数</div>
          </div>
        </div>
      </el-card>
      
      <el-card class="stat-card">
        <div class="stat-content">
          <div class="stat-icon pending">
            <el-icon><Clock /></el-icon>
          </div>
          <div class="stat-info">
            <div class="stat-value">{{ dashboardData.pendingOrders }}</div>
            <div class="stat-label">待处理订单</div>
          </div>
        </div>
      </el-card>
      
      <el-card class="stat-card">
        <div class="stat-content">
          <div class="stat-icon revenue">
            <el-icon><Money /></el-icon>
          </div>
          <div class="stat-info">
            <div class="stat-value">¥{{ dashboardData.totalRevenue.toLocaleString() }}</div>
            <div class="stat-label">总收入</div>
          </div>
        </div>
      </el-card>
      
      <el-card class="stat-card">
        <div class="stat-content">
          <div class="stat-icon products">
            <el-icon><Goods /></el-icon>
          </div>
          <div class="stat-info">
            <div class="stat-value">{{ dashboardData.totalProducts }}</div>
            <div class="stat-label">商品总数</div>
          </div>
        </div>
      </el-card>
    </div>
    
    <!-- 图表区域 -->
    <div class="charts-grid">
      <!-- 最近7天订单统计 -->
      <el-card class="chart-card">
        <template #header>
          <div class="card-header">
            <h3>最近7天订单统计</h3>
          </div>
        </template>
        
        <div class="chart-container">
          <div v-if="dashboardData.recentOrders.length === 0" class="empty-chart">
            <el-empty description="暂无数据" />
          </div>
          <div v-else class="order-chart">
            <div v-for="item in dashboardData.recentOrders" :key="item.date" class="chart-item">
              <div class="chart-bar">
                <div 
                  class="bar-fill" 
                  :style="{ height: getBarHeight(item.count) + '%' }"
                ></div>
              </div>
              <div class="chart-label">{{ formatDate(item.date) }}</div>
              <div class="chart-value">{{ item.count }}</div>
            </div>
          </div>
        </div>
      </el-card>
      
      <!-- 订单状态分布 -->
      <el-card class="chart-card">
        <template #header>
          <div class="card-header">
            <h3>订单状态分布</h3>
          </div>
        </template>
        
        <div class="status-distribution">
          <div class="status-item">
            <div class="status-dot pending"></div>
            <span class="status-label">待支付</span>
            <span class="status-count">{{ dashboardData.pendingOrders }}</span>
          </div>
          <div class="status-item">
            <div class="status-dot paid"></div>
            <span class="status-label">已支付</span>
            <span class="status-count">{{ dashboardData.paidOrders }}</span>
          </div>
          <div class="status-item">
            <div class="status-dot completed"></div>
            <span class="status-label">已完成</span>
            <span class="status-count">{{ dashboardData.completedOrders }}</span>
          </div>
        </div>
      </el-card>
    </div>
    
    <!-- 快速操作 -->
    <el-card class="quick-actions">
      <template #header>
        <div class="card-header">
          <h3>快速操作</h3>
        </div>
      </template>
      
      <div class="actions-grid">
        <el-button type="primary" @click="$router.push('/admin/orders')">
          <el-icon><List /></el-icon>
          查看所有订单
        </el-button>
        
        <el-button type="success" @click="$router.push('/admin/products')">
          <el-icon><Goods /></el-icon>
          管理商品
        </el-button>
        
        <el-button type="warning" @click="refreshData">
          <el-icon><Refresh /></el-icon>
          刷新数据
        </el-button>
      </div>
    </el-card>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { List, Clock, Money, Goods, Refresh } from '@element-plus/icons-vue'
import { getDashboardData } from '@/api'

const dashboardData = ref({
  totalOrders: 0,
  pendingOrders: 0,
  paidOrders: 0,
  completedOrders: 0,
  totalProducts: 0,
  totalUsers: 0,
  totalRevenue: 0,
  recentOrders: []
})

// 获取仪表板数据
const fetchDashboardData = async () => {
  try {
    const response = await getDashboardData()
    dashboardData.value = response.data
  } catch (error) {
    console.error('获取仪表板数据失败:', error)
    ElMessage.error('获取数据失败')
  }
}

// 刷新数据
const refreshData = async () => {
  await fetchDashboardData()
  ElMessage.success('数据已刷新')
}

// 格式化日期
const formatDate = (dateString) => {
  const date = new Date(dateString)
  return `${date.getMonth() + 1}/${date.getDate()}`
}

// 计算柱状图高度
const getBarHeight = (count) => {
  const maxCount = Math.max(...dashboardData.value.recentOrders.map(item => item.count))
  return maxCount > 0 ? (count / maxCount) * 100 : 0
}

onMounted(() => {
  fetchDashboardData()
})
</script>

<style scoped>
.admin-dashboard {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.stats-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 20px;
}

.stat-card {
  border: none;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);
}

.stat-content {
  display: flex;
  align-items: center;
  gap: 16px;
}

.stat-icon {
  width: 60px;
  height: 60px;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 24px;
  color: white;
}

.stat-icon.orders {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}

.stat-icon.pending {
  background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
}

.stat-icon.revenue {
  background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
}

.stat-icon.products {
  background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
}

.stat-info {
  flex: 1;
}

.stat-value {
  font-size: 2rem;
  font-weight: 700;
  color: #333;
  line-height: 1;
}

.stat-label {
  color: #666;
  font-size: 0.9rem;
  margin-top: 4px;
}

.charts-grid {
  display: grid;
  grid-template-columns: 2fr 1fr;
  gap: 20px;
}

.chart-card {
  border: none;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);
}

.card-header h3 {
  margin: 0;
  color: #333;
  font-size: 1.1rem;
}

.chart-container {
  height: 300px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.empty-chart {
  text-align: center;
}

.order-chart {
  display: flex;
  align-items: end;
  justify-content: space-around;
  height: 100%;
  width: 100%;
  padding: 20px 0;
}

.chart-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 8px;
  flex: 1;
}

.chart-bar {
  width: 30px;
  height: 200px;
  background: #f0f0f0;
  border-radius: 4px;
  position: relative;
  overflow: hidden;
}

.bar-fill {
  position: absolute;
  bottom: 0;
  width: 100%;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border-radius: 4px;
  transition: height 0.3s ease;
}

.chart-label {
  font-size: 0.8rem;
  color: #666;
}

.chart-value {
  font-weight: 600;
  color: #333;
}

.status-distribution {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.status-item {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 12px;
  background: #f9f9f9;
  border-radius: 8px;
}

.status-dot {
  width: 12px;
  height: 12px;
  border-radius: 50%;
}

.status-dot.pending {
  background: #e6a23c;
}

.status-dot.paid {
  background: #409eff;
}

.status-dot.completed {
  background: #67c23a;
}

.status-label {
  flex: 1;
  color: #333;
  font-weight: 500;
}

.status-count {
  font-weight: 600;
  color: #666;
}

.quick-actions {
  border: none;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);
}

.actions-grid {
  display: flex;
  gap: 16px;
  flex-wrap: wrap;
}

.actions-grid .el-button {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 12px 24px;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .stats-grid {
    grid-template-columns: 1fr;
  }
  
  .charts-grid {
    grid-template-columns: 1fr;
  }
  
  .actions-grid {
    flex-direction: column;
  }
  
  .actions-grid .el-button {
    width: 100%;
  }
}
</style> 