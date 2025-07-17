<template>
  <div class="payment-page">
    <div class="page-header">
      <el-button @click="$router.back()" :icon="ArrowLeft" type="text">返回</el-button>
      <h1>订单支付</h1>
    </div>

    <div v-loading="loading" class="payment-content">
      <div v-if="order" class="payment-wrapper">
        <!-- 订单信息卡片 -->
        <el-card class="order-info-card" shadow="never">
          <template #header>
            <div class="card-header">
              <h3>订单信息</h3>
              <el-tag :type="getStatusType(order.status)" size="large">
                {{ order.status }}
              </el-tag>
            </div>
          </template>
          
          <div class="order-summary">
            <div class="order-id">
              <span class="label">订单号：</span>
              <span class="value">{{ order.id }}</span>
            </div>
            <div class="order-time">
              <span class="label">下单时间：</span>
              <span class="value">{{ formatDate(order.createTime) }}</span>
            </div>
            <div class="order-amount">
              <span class="label">支付金额：</span>
              <span class="value amount">¥{{ order.finalAmount.toLocaleString() }}</span>
            </div>
          </div>

          <!-- 商品列表 -->
          <div class="order-items">
            <h4>商品清单</h4>
            <div class="items-list">
              <div v-for="item in order.items" :key="item.productId" class="item">
                <img :src="item.image" :alt="item.name" class="item-image">
                <div class="item-info">
                  <div class="item-name">{{ item.name }}</div>
                  <div class="item-price">¥{{ item.price.toLocaleString() }} × {{ item.quantity }}</div>
                </div>
                <div class="item-subtotal">¥{{ item.subtotal.toLocaleString() }}</div>
              </div>
            </div>
          </div>
        </el-card>

        <!-- 支付方式选择 -->
        <el-card class="payment-method-card" shadow="never">
          <template #header>
            <h3>选择支付方式</h3>
          </template>
          
          <div class="payment-methods">
            <el-radio-group v-model="selectedPaymentMethod" class="payment-options">
              <el-radio-button value="alipay" class="payment-option">
                <div class="payment-icon">
                  <svg viewBox="0 0 24 24" class="alipay-icon">
                    <path d="M22.319 4.431H1.68c-.414 0-.75.336-.75.75v13.438c0 .414.336.75.75.75h20.639c.414 0 .75-.336.75-.75V5.181c0-.414-.336-.75-.75-.75z" fill="#1677FF"/>
                    <path d="M7.5 8.25h9v1.5h-9zM7.5 11.25h9v1.5h-9z" fill="white"/>
                  </svg>
                </div>
                <div class="payment-info">
                  <div class="payment-name">支付宝</div>
                  <div class="payment-desc">推荐使用支付宝支付</div>
                </div>
              </el-radio-button>
              
              <el-radio-button value="wechat" class="payment-option">
                <div class="payment-icon">
                  <svg viewBox="0 0 24 24" class="wechat-icon">
                    <path d="M8.691 2.188C3.891 2.188 0 5.476 0 9.53c0 2.212 1.17 4.203 3.002 5.55a.59.59 0 0 1 .213.665l-.39 1.48c-.019.07-.048.141-.048.213 0 .163.13.295.29.295a.326.326 0 0 0 .167-.054l1.903-1.114a.864.864 0 0 1 .717-.098 10.16 10.16 0 0 0 2.837.403c.276 0 .543-.027.811-.05-.857-2.578.157-4.972 1.932-6.446 1.703-1.415 4.882-1.932 7.621-.116-.302-3.88-3.611-6.89-7.621-6.89z" fill="#07C160"/>
                    <path d="M15.785 12.752c-.276 0-.543.027-.811.05.857 2.578-.157 4.972-1.932 6.446-1.703 1.415-4.882 1.932-7.621.116.302 3.88 3.611 6.89 7.621 6.89 4.8 0 8.691-3.288 8.691-7.342 0-2.212-1.17-4.203-3.002-5.55a.59.59 0 0 0-.665.213l-1.48.39c-.07.019-.141.048-.213.048a.295.295 0 0 0-.295.29c0 .163.054.326.054.167z" fill="#07C160"/>
                  </svg>
                </div>
                <div class="payment-info">
                  <div class="payment-name">微信支付</div>
                  <div class="payment-desc">使用微信扫码支付</div>
                </div>
              </el-radio-button>
              
              <el-radio-button value="unionpay" class="payment-option">
                <div class="payment-icon">
                  <svg viewBox="0 0 24 24" class="unionpay-icon">
                    <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 15l-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9z" fill="#E60012"/>
                  </svg>
                </div>
                <div class="payment-info">
                  <div class="payment-name">银联支付</div>
                  <div class="payment-desc">支持各大银行</div>
                </div>
              </el-radio-button>
            </el-radio-group>
          </div>
        </el-card>

        <!-- 支付按钮 -->
        <el-card class="payment-action-card" shadow="never">
          <div class="payment-summary">
            <div class="summary-row">
              <span class="label">商品总价：</span>
              <span class="value">¥{{ order.totalAmount.toLocaleString() }}</span>
            </div>
            <div class="summary-row">
              <span class="label">运费：</span>
              <span class="value">¥{{ order.shippingFee.toLocaleString() }}</span>
            </div>
            <div class="summary-row total">
              <span class="label">实付金额：</span>
              <span class="value total-amount">¥{{ order.finalAmount.toLocaleString() }}</span>
            </div>
          </div>
          
          <div class="payment-actions">
            <el-button 
              type="primary" 
              size="large" 
              class="pay-button"
              :loading="paying"
              :disabled="!selectedPaymentMethod"
              @click="handlePayment"
            >
              <template v-if="!paying">
                立即支付 ¥{{ order.finalAmount.toLocaleString() }}
              </template>
              <template v-else>
                支付处理中...
              </template>
            </el-button>
            
            <el-button 
              type="danger" 
              size="large" 
              plain
              @click="cancelPayment"
            >
              取消支付
            </el-button>
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

    <!-- 支付结果对话框 -->
    <el-dialog
      v-model="showPaymentResult"
      title="支付结果"
      width="400px"
      :close-on-click-modal="false"
      :close-on-press-escape="false"
      :show-close="false"
    >
      <div class="payment-result">
        <div class="result-icon">
          <el-icon v-if="paymentSuccess" class="success-icon"><CircleCheckFilled /></el-icon>
          <el-icon v-else class="error-icon"><CircleCloseFilled /></el-icon>
        </div>
        <div class="result-message">
          {{ paymentSuccess ? '支付成功！' : '支付失败，请重试' }}
        </div>
        <div class="result-details" v-if="paymentSuccess">
          <p>订单号：{{ order?.id }}</p>
          <p>支付金额：¥{{ order?.finalAmount.toLocaleString() }}</p>
          <p>支付时间：{{ formatDate(new Date()) }}</p>
        </div>
      </div>
      
      <template #footer>
        <div class="dialog-footer">
          <el-button 
            v-if="paymentSuccess" 
            type="primary" 
            @click="goToOrderDetail"
          >
            查看订单
          </el-button>
          <el-button 
            v-else 
            type="primary" 
            @click="retryPayment"
          >
            重新支付
          </el-button>
          <el-button @click="goToOrderList">返回订单列表</el-button>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import { ArrowLeft, CircleCheckFilled, CircleCloseFilled } from '@element-plus/icons-vue'
import { getOrderDetail, updateOrderStatus } from '@/api'

const route = useRoute()
const router = useRouter()

// 响应式数据
const order = ref(null)
const loading = ref(false)
const paying = ref(false)
const selectedPaymentMethod = ref('alipay')
const showPaymentResult = ref(false)
const paymentSuccess = ref(false)

// 获取订单详情
const fetchOrderDetail = async () => {
  loading.value = true
  try {
    const response = await getOrderDetail(route.params.orderId)
    order.value = response.data
    
    // 检查订单状态
    if (order.value.status !== '待支付') {
      ElMessage.warning('该订单已支付或状态异常')
      router.push(`/order/${order.value.id}`)
    }
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
    '已支付': 'success',
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

// 处理支付
const handlePayment = async () => {
  if (!selectedPaymentMethod.value) {
    ElMessage.warning('请选择支付方式')
    return
  }
  
  try {
    paying.value = true
    
    // 模拟支付过程
    await new Promise(resolve => setTimeout(resolve, 2000))
    
    // 更新订单状态为已支付
    await updateOrderStatus(order.value.id, '已支付')
    
    paymentSuccess.value = true
    showPaymentResult.value = true
    
    // 更新本地订单状态
    order.value.status = '已支付'
    
  } catch (error) {
    console.error('支付失败:', error)
    paymentSuccess.value = false
    showPaymentResult.value = true
    ElMessage.error('支付失败，请重试')
  } finally {
    paying.value = false
  }
}

// 取消支付
const cancelPayment = async () => {
  try {
    await ElMessageBox.confirm('确定要取消支付吗？', '提示', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    })
    
    router.push(`/order/${order.value.id}`)
  } catch {
    // 用户取消
  }
}

// 查看订单详情
const goToOrderDetail = () => {
  showPaymentResult.value = false
  router.push(`/order/${order.value.id}`)
}

// 返回订单列表
const goToOrderList = () => {
  showPaymentResult.value = false
  router.push('/orders')
}

// 重新支付
const retryPayment = () => {
  showPaymentResult.value = false
  selectedPaymentMethod.value = 'alipay'
}

// 初始化
onMounted(() => {
  fetchOrderDetail()
})
</script>

<style scoped>
.payment-page {
  max-width: 800px;
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

.payment-content {
  min-height: 400px;
}

.payment-wrapper {
  display: flex;
  flex-direction: column;
  gap: 20px;
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

.order-summary {
  display: flex;
  flex-direction: column;
  gap: 12px;
  margin-bottom: 20px;
}

.order-id, .order-time, .order-amount {
  display: flex;
  align-items: center;
  gap: 8px;
}

.label {
  color: #666;
  font-weight: 500;
  min-width: 80px;
}

.value {
  color: #333;
}

.amount {
  font-size: 1.2rem;
  font-weight: 600;
  color: #e74c3c;
}

.order-items {
  border-top: 1px solid #f0f0f0;
  padding-top: 20px;
}

.order-items h4 {
  margin: 0 0 16px 0;
  color: #333;
}

.items-list {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.item {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 12px;
  background: #f9f9f9;
  border-radius: 8px;
}

.item-image {
  width: 50px;
  height: 50px;
  object-fit: cover;
  border-radius: 4px;
}

.item-info {
  flex: 1;
}

.item-name {
  font-weight: 500;
  color: #333;
  margin-bottom: 4px;
}

.item-price {
  color: #666;
  font-size: 0.9rem;
}

.item-subtotal {
  font-weight: 600;
  color: #e74c3c;
}

.payment-methods {
  padding: 20px 0;
}

.payment-options {
  display: flex;
  flex-direction: column;
  gap: 12px;
  width: 100%;
}

.payment-option {
  display: flex !important;
  align-items: center;
  gap: 16px;
  padding: 16px !important;
  border: 2px solid #e4e7ed !important;
  border-radius: 8px !important;
  background: white !important;
  transition: all 0.3s ease;
}

.payment-option:hover {
  border-color: #409eff !important;
  background: #f0f9ff !important;
}

.payment-option.is-checked {
  border-color: #409eff !important;
  background: #f0f9ff !important;
}

.payment-icon {
  width: 40px;
  height: 40px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.payment-icon svg {
  width: 32px;
  height: 32px;
}

.payment-info {
  flex: 1;
}

.payment-name {
  font-weight: 600;
  color: #333;
  margin-bottom: 4px;
}

.payment-desc {
  color: #666;
  font-size: 0.9rem;
}

.payment-summary {
  margin-bottom: 24px;
}

.summary-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 8px;
}

.summary-row.total {
  border-top: 1px solid #f0f0f0;
  padding-top: 12px;
  margin-top: 12px;
  font-size: 1.2rem;
  font-weight: 600;
}

.total-amount {
  color: #e74c3c;
  font-size: 1.4rem;
}

.payment-actions {
  display: flex;
  gap: 16px;
}

.pay-button {
  flex: 1;
  height: 48px;
  font-size: 1.1rem;
  font-weight: 600;
}

.payment-result {
  text-align: center;
  padding: 20px 0;
}

.result-icon {
  margin-bottom: 16px;
}

.success-icon {
  font-size: 4rem;
  color: #67c23a;
}

.error-icon {
  font-size: 4rem;
  color: #f56c6c;
}

.result-message {
  font-size: 1.2rem;
  font-weight: 600;
  color: #333;
  margin-bottom: 16px;
}

.result-details {
  text-align: left;
  background: #f9f9f9;
  padding: 16px;
  border-radius: 8px;
}

.result-details p {
  margin: 8px 0;
  color: #666;
}

.dialog-footer {
  display: flex;
  justify-content: center;
  gap: 12px;
}

.empty-state {
  text-align: center;
  padding: 60px 0;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .payment-page {
    padding: 15px;
  }
  
  .payment-actions {
    flex-direction: column;
  }
  
  .payment-option {
    flex-direction: column;
    text-align: center;
  }
  
  .payment-icon {
    margin-bottom: 8px;
  }
}
</style> 