<template>
  <div class="order-list">
    <div class="page-header">
      <h1>我的订单</h1>
      <p>管理您的所有订单</p>
    </div>

    <!-- 订单状态筛选 -->
    <div class="order-tabs">
      <el-tabs v-model="activeStatus" @tab-change="handleStatusChange">
        <el-tab-pane label="全部" name="all"></el-tab-pane>
        <el-tab-pane label="待支付" name="待支付"></el-tab-pane>
        <el-tab-pane label="已支付" name="已支付"></el-tab-pane>
        <el-tab-pane label="已发货" name="已发货"></el-tab-pane>
        <el-tab-pane label="已完成" name="已完成"></el-tab-pane>
        <el-tab-pane label="已取消" name="已取消"></el-tab-pane>
      </el-tabs>
    </div>

    <!-- 订单列表 -->
    <div class="order-content" v-loading="loading">
      <div v-if="orders.length === 0 && !loading" class="empty-state">
        <el-empty description="暂无订单数据">
          <el-button type="primary" @click="$router.push('/')">去购物</el-button>
        </el-empty>
      </div>

      <div v-else>
        <el-card v-for="order in orders" :key="order.id" class="order-card" shadow="hover">
          <div class="order-header">
            <div class="order-info">
              <span class="order-id">订单号：{{ order.id }}</span>
              <span class="order-time">{{ formatDate(order.createTime) }}</span>
            </div>
            <div class="order-status">
              <el-tag :type="getStatusType(order.status)">{{ order.status }}</el-tag>
            </div>
          </div>

          <div class="order-items">
            <div class="item-preview">
              <img :src="order.firstItemImage" :alt="order.firstItemName" class="item-image">
              <div class="item-info">
                <span class="item-name">{{ order.firstItemName }}</span>
                <span class="item-count" v-if="order.itemCount > 1">等{{ order.itemCount }}件商品</span>
              </div>
            </div>
          </div>

          <div class="order-footer">
            <div class="order-amount">
              <span class="amount-label">实付款：</span>
              <span class="amount-value">¥{{ order.finalAmount.toLocaleString() }}</span>
              <span class="shipping-fee" v-if="order.shippingFee > 0">
                (含运费¥{{ order.shippingFee }})
              </span>
            </div>
            <div class="order-actions">
              <el-button 
                size="small" 
                @click="viewOrderDetail(order.id)"
              >
                查看详情
              </el-button>
              <el-button 
                v-if="order.status === '待支付'" 
                type="primary" 
                size="small"
                @click="payOrder(order.id)"
              >
                立即支付
              </el-button>
              <el-button 
                v-if="order.status === '已发货'" 
                type="success" 
                size="small"
                @click="confirmOrder(order.id)"
              >
                确认收货
              </el-button>
              <el-button 
                v-if="order.status === '待支付'" 
                type="danger" 
                size="small"
                @click="cancelOrder(order.id)"
              >
                取消订单
              </el-button>
              <el-button 
                v-if="order.status === '已完成'" 
                size="small"
                @click="deleteOrder(order.id)"
              >
                删除订单
              </el-button>
            </div>
          </div>
        </el-card>

        <!-- 分页 -->
        <div class="pagination-container">
          <el-pagination
            v-model:current-page="currentPage"
            v-model:page-size="pageSize"
            :page-sizes="[10, 20, 50]"
            :total="total"
            layout="total, sizes, prev, pager, next, jumper"
            @size-change="handleSizeChange"
            @current-change="handleCurrentChange"
          />
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import { getOrders, cancelOrder as cancelOrderApi, confirmOrder as confirmOrderApi, deleteOrder as deleteOrderApi } from '@/api'

const router = useRouter()

// 响应式数据
const orders = ref([])
const loading = ref(false)
const activeStatus = ref('all')
const currentPage = ref(1)
const pageSize = ref(10)
const total = ref(0)

// 获取订单列表
const fetchOrders = async () => {
  loading.value = true
  try {
    const params = {
      page: currentPage.value,
      limit: pageSize.value
    }
    
    if (activeStatus.value !== 'all') {
      params.status = activeStatus.value
    }

    const response = await getOrders(params)
    orders.value = response.data.orders
    total.value = response.data.total
  } catch (error) {
    console.error('获取订单列表失败:', error)
    ElMessage.error('获取订单列表失败')
  } finally {
    loading.value = false
  }
}

// 状态变化处理
const handleStatusChange = (status) => {
  activeStatus.value = status
  currentPage.value = 1
  fetchOrders()
}

// 分页处理
const handleSizeChange = (size) => {
  pageSize.value = size
  currentPage.value = 1
  fetchOrders()
}

const handleCurrentChange = (page) => {
  currentPage.value = page
  fetchOrders()
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
  return new Date(dateString).toLocaleString('zh-CN')
}

// 查看订单详情
const viewOrderDetail = (orderId) => {
  router.push(`/order/${orderId}`)
}

// 支付订单
const payOrder = async (orderId) => {
  try {
    // 这里应该调用支付接口
    ElMessage.success('跳转到支付页面...')
    // 实际项目中应该跳转到支付页面
    router.push(`/payment/${orderId}`)
  } catch (error) {
    console.error('支付失败:', error)
    ElMessage.error('支付失败')
  }
}

// 取消订单
const cancelOrder = async (orderId) => {
  try {
    await ElMessageBox.confirm('确定要取消这个订单吗？', '提示', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    })

    await cancelOrderApi(orderId)
    ElMessage.success('订单已取消')
    fetchOrders()
  } catch (error) {
    if (error !== 'cancel') {
      console.error('取消订单失败:', error)
      ElMessage.error('取消订单失败')
    }
  }
}

// 确认收货
const confirmOrder = async (orderId) => {
  try {
    await ElMessageBox.confirm('确定已收到货物吗？', '提示', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'info'
    })

    await confirmOrderApi(orderId)
    ElMessage.success('确认收货成功')
    fetchOrders()
  } catch (error) {
    if (error !== 'cancel') {
      console.error('确认收货失败:', error)
      ElMessage.error('确认收货失败')
    }
  }
}

// 删除订单
const deleteOrder = async (orderId) => {
  try {
    await ElMessageBox.confirm('确定要删除这个订单吗？删除后无法恢复。', '提示', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    })

    await deleteOrderApi(orderId)
    ElMessage.success('订单已删除')
    fetchOrders()
  } catch (error) {
    if (error !== 'cancel') {
      console.error('删除订单失败:', error)
      ElMessage.error('删除订单失败')
    }
  }
}

// 初始化
onMounted(() => {
  fetchOrders()
})
</script>

<style scoped>
.order-list {
  max-width: 1200px;
  margin: 0 auto;
  padding: 20px;
}

.page-header {
  text-align: center;
  margin-bottom: 30px;
}

.page-header h1 {
  font-size: 2rem;
  color: #333;
  margin-bottom: 8px;
}

.page-header p {
  color: #666;
  font-size: 1rem;
}

.order-tabs {
  margin-bottom: 20px;
}

.order-tabs :deep(.el-tabs__header) {
  margin-bottom: 0;
}

.order-content {
  min-height: 400px;
}

.empty-state {
  text-align: center;
  padding: 60px 0;
}

.order-card {
  margin-bottom: 20px;
}

.order-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-bottom: 15px;
  border-bottom: 1px solid #f0f0f0;
  margin-bottom: 15px;
}

.order-info {
  display: flex;
  flex-direction: column;
  gap: 5px;
}

.order-id {
  font-weight: 600;
  color: #333;
}

.order-time {
  color: #999;
  font-size: 0.9rem;
}

.order-items {
  margin-bottom: 15px;
}

.item-preview {
  display: flex;
  align-items: center;
  gap: 12px;
}

.item-image {
  width: 60px;
  height: 60px;
  object-fit: cover;
  border-radius: 4px;
}

.item-info {
  flex: 1;
}

.item-name {
  display: block;
  font-weight: 500;
  color: #333;
  margin-bottom: 4px;
}

.item-count {
  color: #999;
  font-size: 0.9rem;
}

.order-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-top: 15px;
  border-top: 1px solid #f0f0f0;
}

.order-amount {
  display: flex;
  align-items: center;
  gap: 8px;
}

.amount-label {
  color: #666;
}

.amount-value {
  font-size: 1.2rem;
  font-weight: 600;
  color: #e74c3c;
}

.shipping-fee {
  color: #999;
  font-size: 0.9rem;
}

.order-actions {
  display: flex;
  gap: 8px;
}

.pagination-container {
  display: flex;
  justify-content: center;
  margin-top: 30px;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .order-list {
    padding: 15px;
  }
  
  .order-header {
    flex-direction: column;
    align-items: flex-start;
    gap: 10px;
  }
  
  .order-footer {
    flex-direction: column;
    align-items: flex-start;
    gap: 15px;
  }
  
  .order-actions {
    width: 100%;
    justify-content: flex-end;
  }
}
</style> 