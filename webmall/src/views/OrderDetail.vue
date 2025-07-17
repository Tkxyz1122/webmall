<template>
  <div class="order-detail">
    <div class="page-header">
      <el-button @click="$router.back()" :icon="ArrowLeft" type="text">返回</el-button>
      <h1>订单详情</h1>
    </div>

    <div v-loading="loading" class="order-content">
      <div v-if="order" class="order-info">
        <!-- 订单状态 -->
        <el-card class="status-card" shadow="never">
          <div class="order-status-section">
            <div class="status-header">
              <el-tag :type="getStatusType(order.status)" size="large">
                {{ order.status }}
              </el-tag>
              <span class="order-id">订单号：{{ order.id }}</span>
            </div>
            
            <!-- 订单状态流程 -->
            <div class="status-timeline">
              <el-steps :active="getStatusStep(order.status)" finish-status="success">
                <el-step title="提交订单" description="订单已提交"></el-step>
                <el-step title="支付完成" description="支付成功"></el-step>
                <el-step title="商品出库" description="商品已发货"></el-step>
                <el-step title="确认收货" description="订单完成"></el-step>
              </el-steps>
            </div>

            <!-- 订单操作按钮 -->
            <div class="order-actions">
              <el-button 
                v-if="order.status === '待支付'" 
                type="primary" 
                size="large"
                @click="payOrder(order.id)"
              >
                立即支付
              </el-button>
              <el-button 
                v-if="order.status === '已发货'" 
                type="success" 
                size="large"
                @click="confirmOrder(order.id)"
              >
                确认收货
              </el-button>
              <el-button 
                v-if="order.status === '待支付'" 
                type="danger" 
                size="large"
                @click="cancelOrder(order.id)"
              >
                取消订单
              </el-button>
            </div>
          </div>
        </el-card>

        <!-- 商品信息 -->
        <el-card class="items-card" shadow="never">
          <template #header>
            <div class="card-header">
              <h3>商品信息</h3>
            </div>
          </template>
          
          <div class="order-items">
            <div v-for="item in order.items" :key="item.productId" class="item-row">
              <div class="item-image">
                <img :src="item.image" :alt="item.name">
              </div>
              <div class="item-info">
                <h4 class="item-name">{{ item.name }}</h4>
                <div class="item-details">
                  <span class="item-price">¥{{ item.price.toLocaleString() }}</span>
                  <span class="item-quantity">x{{ item.quantity }}</span>
                </div>
              </div>
              <div class="item-subtotal">
                ¥{{ item.subtotal.toLocaleString() }}
              </div>
            </div>
          </div>

          <!-- 价格汇总 -->
          <div class="price-summary">
            <div class="summary-row">
              <span class="label">商品总价：</span>
              <span class="value">¥{{ order.totalAmount.toLocaleString() }}</span>
            </div>
            <div class="summary-row">
              <span class="label">运费：</span>
              <span class="value">¥{{ order.shippingFee.toLocaleString() }}</span>
            </div>
            <div class="summary-row total-row">
              <span class="label">实付金额：</span>
              <span class="value">¥{{ order.finalAmount.toLocaleString() }}</span>
            </div>
          </div>
        </el-card>

        <!-- 收货信息 -->
        <el-card class="address-card" shadow="never">
          <template #header>
            <div class="card-header">
              <h3>收货信息</h3>
            </div>
          </template>
          
          <div class="address-info">
            <div class="address-row">
              <el-icon class="address-icon"><User /></el-icon>
              <span class="address-text">{{ order.shippingAddress.name }}</span>
            </div>
            <div class="address-row">
              <el-icon class="address-icon"><Phone /></el-icon>
              <span class="address-text">{{ order.shippingAddress.phone }}</span>
            </div>
            <div class="address-row">
              <el-icon class="address-icon"><Location /></el-icon>
              <span class="address-text">{{ order.shippingAddress.address }}</span>
            </div>
          </div>
        </el-card>

        <!-- 订单信息 -->
        <el-card class="order-meta-card" shadow="never">
          <template #header>
            <div class="card-header">
              <h3>订单信息</h3>
            </div>
          </template>
          
          <div class="order-meta">
            <div class="meta-row">
              <span class="meta-label">订单编号：</span>
              <span class="meta-value">{{ order.id }}</span>
            </div>
            <div class="meta-row">
              <span class="meta-label">下单时间：</span>
              <span class="meta-value">{{ formatDate(order.createTime) }}</span>
            </div>
            <div class="meta-row">
              <span class="meta-label">支付方式：</span>
              <span class="meta-value">{{ order.paymentMethod }}</span>
            </div>
            <div class="meta-row" v-if="order.remark">
              <span class="meta-label">订单备注：</span>
              <span class="meta-value">{{ order.remark }}</span>
            </div>
          </div>
        </el-card>
      </div>

      <!-- 订单不存在 -->
      <div v-else-if="!loading" class="empty-state">
        <el-empty description="订单不存在或已被删除">
          <el-button type="primary" @click="$router.push('/orders')">返回订单列表</el-button>
        </el-empty>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import { ArrowLeft, User, Phone, Location } from '@element-plus/icons-vue'
import { getOrderDetail, cancelOrder as cancelOrderApi, confirmOrder as confirmOrderApi } from '@/api'

const route = useRoute()
const router = useRouter()

// 响应式数据
const order = ref(null)
const loading = ref(false)

// 获取订单详情
const fetchOrderDetail = async () => {
  loading.value = true
  try {
    const response = await getOrderDetail(route.params.id)
    order.value = response.data
  } catch (error) {
    console.error('获取订单详情失败:', error)
    ElMessage.error('获取订单详情失败')
  } finally {
    loading.value = false
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

// 获取状态步骤
const getStatusStep = (status) => {
  const stepMap = {
    '待支付': 0,
    '已支付': 1,
    '已发货': 2,
    '已完成': 3,
    '已取消': 0
  }
  return stepMap[status] || 0
}

// 格式化日期
const formatDate = (dateString) => {
  return new Date(dateString).toLocaleString('zh-CN')
}

// 支付订单
const payOrder = async (orderId) => {
  try {
    ElMessage.success('跳转到支付页面...')
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
    fetchOrderDetail()
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
    fetchOrderDetail()
  } catch (error) {
    if (error !== 'cancel') {
      console.error('确认收货失败:', error)
      ElMessage.error('确认收货失败')
    }
  }
}

// 初始化
onMounted(() => {
  fetchOrderDetail()
})
</script>

<style scoped>
.order-detail {
  max-width: 1000px;
  margin: 0 auto;
  padding: 20px;
}

.page-header {
  display: flex;
  align-items: center;
  gap: 16px;
  margin-bottom: 30px;
}

.page-header h1 {
  font-size: 1.5rem;
  color: #333;
  margin: 0;
}

.order-content {
  min-height: 400px;
}

.order-info {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.status-card {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
}

.status-card :deep(.el-card__body) {
  padding: 30px;
}

.order-status-section {
  text-align: center;
}

.status-header {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 10px;
  margin-bottom: 30px;
}

.order-id {
  font-size: 1.1rem;
  opacity: 0.9;
}

.status-timeline {
  margin-bottom: 30px;
}

.status-timeline :deep(.el-steps) {
  justify-content: center;
}

.status-timeline :deep(.el-step__title) {
  color: rgba(255, 255, 255, 0.8);
}

.status-timeline :deep(.el-step__description) {
  color: rgba(255, 255, 255, 0.6);
}

.order-actions {
  display: flex;
  justify-content: center;
  gap: 16px;
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

.order-items {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.item-row {
  display: flex;
  align-items: center;
  gap: 16px;
  padding: 16px;
  background: #f9f9f9;
  border-radius: 8px;
}

.item-image {
  width: 80px;
  height: 80px;
  border-radius: 8px;
  overflow: hidden;
  flex-shrink: 0;
}

.item-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.item-info {
  flex: 1;
}

.item-name {
  font-size: 1.1rem;
  font-weight: 500;
  color: #333;
  margin: 0 0 8px 0;
}

.item-details {
  display: flex;
  align-items: center;
  gap: 16px;
}

.item-price {
  font-size: 1rem;
  color: #e74c3c;
  font-weight: 500;
}

.item-quantity {
  color: #666;
}

.item-subtotal {
  font-size: 1.2rem;
  font-weight: 600;
  color: #e74c3c;
  text-align: right;
}

.price-summary {
  border-top: 2px solid #f0f0f0;
  padding-top: 20px;
  margin-top: 20px;
}

.summary-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 8px;
}

.summary-row.total-row {
  border-top: 1px solid #f0f0f0;
  padding-top: 12px;
  margin-top: 12px;
  font-size: 1.2rem;
  font-weight: 600;
}

.summary-row .label {
  color: #666;
}

.summary-row .value {
  color: #333;
}

.total-row .value {
  color: #e74c3c;
}

.address-info {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.address-row {
  display: flex;
  align-items: center;
  gap: 12px;
}

.address-icon {
  color: #409eff;
  font-size: 1.2rem;
}

.address-text {
  color: #333;
  font-size: 1rem;
}

.order-meta {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.meta-row {
  display: flex;
  align-items: center;
  gap: 16px;
}

.meta-label {
  color: #666;
  font-weight: 500;
  min-width: 80px;
}

.meta-value {
  color: #333;
  flex: 1;
}

.empty-state {
  text-align: center;
  padding: 60px 0;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .order-detail {
    padding: 15px;
  }
  
  .status-timeline :deep(.el-steps) {
    flex-direction: column;
  }
  
  .order-actions {
    flex-direction: column;
    align-items: stretch;
  }
  
  .item-row {
    flex-direction: column;
    text-align: center;
  }
  
  .item-details {
    justify-content: center;
  }
  
  .summary-row {
    flex-direction: column;
    align-items: flex-start;
    gap: 4px;
  }
  
  .meta-row {
    flex-direction: column;
    align-items: flex-start;
    gap: 4px;
  }
}
</style> 