<template>
  <div class="cart">
    <div class="cart-header">
      <h2 class="page-title">购物车</h2>
      <div class="cart-actions" v-if="cartItems.length > 0">
        <el-button type="text" @click="clearCart" class="clear-btn">清空购物车</el-button>
      </div>
    </div>
    
    <div class="cart-content" v-if="cartItems.length > 0">
      <div class="cart-list">
        <!-- 全选区域 -->
        <el-card class="select-all-card">
          <div class="select-all">
            <el-checkbox 
              v-model="allSelected" 
              @change="selectAll"
              :indeterminate="selectedItems.length > 0 && selectedItems.length < cartItems.length"
            >
              全选 ({{ cartItems.length }}件商品)
            </el-checkbox>
          </div>
        </el-card>
        
        <!-- 商品列表 -->
        <el-card v-for="item in cartItems" :key="item.id" class="cart-item">
          <div class="item-content">
            <el-checkbox v-model="item.selected" />
            <img :src="item.image" class="item-image" @error="$event.target.src='https://via.placeholder.com/100x100?text=No+Image'" />
            <div class="item-info">
              <div class="item-brand">{{ item.brand }}</div>
              <h3>{{ item.name }}</h3>
              <p class="description">{{ item.description }}</p>
              <div class="price-section">
                <span class="current-price">¥{{ item.price.toLocaleString() }}</span>
                <span v-if="item.originalPrice" class="original-price">
                  ¥{{ item.originalPrice.toLocaleString() }}
                </span>
              </div>
              <div class="item-tags" v-if="item.tags">
                <el-tag v-for="tag in item.tags.slice(0, 2)" :key="tag" size="small">{{ tag }}</el-tag>
              </div>
            </div>
            <div class="item-actions">
              <el-input-number 
                v-model="item.quantity" 
                :min="1" 
                :max="99"
                size="small"
                @change="updateQuantity(item)"
              />
              <el-button 
                type="danger" 
                size="small" 
                plain
                @click="removeItem(item)"
              >
                删除
              </el-button>
            </div>
          </div>
        </el-card>
      </div>

      <div class="cart-summary">
        <el-card>
          <h3>订单摘要</h3>
          <div class="summary-item">
            <span>商品总价 ({{ selectedCount }}件)</span>
            <span>¥{{ totalPrice.toLocaleString() }}</span>
          </div>
          <div class="summary-item">
            <span>运费</span>
            <span class="shipping-info">
              <template v-if="actualShipping === 0">
                <span class="free-shipping">免费</span>
                <small v-if="totalPrice > 0 && totalPrice < 199">(满199包邮)</small>
              </template>
              <template v-else>
                ¥{{ actualShipping }}
                <small>(满199包邮，还差¥{{ (199 - totalPrice).toLocaleString() }})</small>
              </template>
            </span>
          </div>
          <div class="summary-item total">
            <span>总计</span>
            <span class="total-price">¥{{ totalWithShipping.toLocaleString() }}</span>
          </div>
          
          <!-- 登录状态提示 -->
          <div class="login-tip" v-if="!isLoggedIn">
            <el-alert
              title="结算需要登录"
              type="info"
              :closable="false"
              show-icon
            />
          </div>
          
          <el-button 
            type="primary" 
            size="large" 
            class="checkout-btn"
            @click="handleCheckout"
            :disabled="selectedCount === 0"
          >
            <template v-if="isLoggedIn">
              结算 ({{ selectedCount }}件商品)
            </template>
            <template v-else>
              登录后结算
            </template>
          </el-button>
        </el-card>
      </div>
    </div>

    <div class="empty-cart" v-else>
      <el-empty description="购物车是空的">
        <el-button type="primary" @click="goShopping">去购物</el-button>
      </el-empty>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useStore } from 'vuex'
import { useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import { createOrder } from '@/api'

const store = useStore()
const router = useRouter()

const cartItems = ref([])
const allSelected = ref(true)

const shipping = ref(0)

const isLoggedIn = computed(() => store.getters.isLoggedIn)
const currentUser = computed(() => store.getters.currentUser)

const selectedItems = computed(() => {
  return cartItems.value.filter(item => item.selected)
})

const selectedCount = computed(() => {
  return selectedItems.value.reduce((total, item) => total + item.quantity, 0)
})

const totalPrice = computed(() => {
  return selectedItems.value.reduce((total, item) => {
    return total + (item.price * item.quantity)
  }, 0)
})

const totalWithShipping = computed(() => {
  const subtotal = totalPrice.value
  return subtotal >= 199 ? subtotal : subtotal + shipping.value
})

const actualShipping = computed(() => {
  return totalPrice.value >= 199 ? 0 : shipping.value
})

// 初始化购物车数据
onMounted(() => {
  loadCartItems()
  // 满199包邮
  shipping.value = 15
})

const loadCartItems = () => {
  // 从Vuex获取购物车数据并添加选中状态
  const storeCart = store.state.cart
  cartItems.value = storeCart.map(item => ({
    ...item,
    selected: true
  }))
}

const selectAll = () => {
  cartItems.value.forEach(item => {
    item.selected = allSelected.value
  })
}

const updateQuantity = (item) => {
  // 更新Vuex中的购物车数量
  store.commit('updateCartItemQuantity', {
    productId: item.id,
    quantity: item.quantity
  })
}

const removeItem = async (item) => {
  try {
    await ElMessageBox.confirm(
      `确定要删除"${item.name}"吗？`,
      '删除商品',
      {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
      }
    )
    
    // 从本地数组移除
    const index = cartItems.value.findIndex(i => i.id === item.id)
    if (index !== -1) {
      cartItems.value.splice(index, 1)
    }
    
    // 从Vuex移除
    store.commit('removeFromCart', item.id)
    ElMessage.success('商品已删除')
  } catch {
    // 用户取消删除
  }
}

const clearCart = async () => {
  try {
    await ElMessageBox.confirm(
      '确定要清空购物车吗？',
      '清空购物车',
      {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
      }
    )
    
    cartItems.value = []
    store.commit('clearCart')
    ElMessage.success('购物车已清空')
  } catch {
    // 用户取消
  }
}

const handleCheckout = async () => {
  if (selectedItems.value.length === 0) {
    ElMessage.warning('请选择要结算的商品')
    return
  }
  
  // 检查登录状态
  if (!isLoggedIn.value) {
    try {
      await ElMessageBox.confirm(
        '结算需要登录，是否前往登录页面？',
        '需要登录',
        {
          confirmButtonText: '去登录',
          cancelButtonText: '取消',
          type: 'info',
        }
      )
      
      // 保存当前页面作为登录后的重定向地址
      router.push({
        path: '/login',
        query: { redirect: '/cart' }
      })
    } catch {
      // 用户取消登录
    }
    return
  }
  
  try {
    // 显示加载状态
    ElMessage.success(`正在为您生成订单，共 ${selectedCount.value} 件商品，总金额 ¥${totalWithShipping.value.toLocaleString()}`)
    
    // 准备订单数据
    const orderData = {
      items: selectedItems.value.map(item => ({
        productId: item.id,
        name: item.name,
        price: item.price,
        quantity: item.quantity,
        image: item.image,
        subtotal: item.price * item.quantity
      })),
      totalAmount: totalPrice.value,
      shippingFee: actualShipping.value,
      finalAmount: totalWithShipping.value,
      paymentMethod: '在线支付',
      shippingAddress: {
        name: currentUser.value.username || '收货人',
        phone: currentUser.value.phone || '13800000000',
        address: '默认收货地址' // 这里可以后续添加地址选择功能
      },
      remark: ''
    }
    
    // 调用创建订单API
    const response = await createOrder(orderData)
    
    ElMessage.success('订单创建成功！')
    
    // 清空已结算的商品
    const selectedIds = selectedItems.value.map(item => item.id)
    cartItems.value = cartItems.value.filter(item => !selectedIds.includes(item.id))
    
    // 更新Vuex
    selectedIds.forEach(id => {
      store.commit('removeFromCart', id)
    })
    
    // 跳转到订单详情页面
    router.push(`/order/${response.data.orderId}`)
    
  } catch (error) {
    console.error('创建订单失败:', error)
    ElMessage.error('创建订单失败，请重试')
  }
}

const goShopping = () => {
  router.push('/products')
}
</script>

<style scoped>
.cart {
  max-width: 1200px;
  margin: 0 auto;
  padding: 20px;
}

.cart-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.page-title {
  margin: 0;
  font-size: 24px;
  color: #333;
  font-weight: 600;
}

.clear-btn {
  color: #f56c6c;
  font-size: 14px;
}

.clear-btn:hover {
  color: #f78989;
}

.cart-content {
  display: grid;
  grid-template-columns: 1fr 300px;
  gap: 20px;
}

.select-all-card {
  margin-bottom: 16px;
  background: #f8f9fa;
}

.select-all {
  padding: 8px 0;
}

.cart-item {
  margin-bottom: 16px;
}

.item-content {
  display: flex;
  align-items: center;
  gap: 20px;
}

.item-image {
  width: 100px;
  height: 100px;
  object-fit: cover;
  border-radius: 8px;
  border: 1px solid #eee;
}

.item-info {
  flex: 1;
}

.item-brand {
  font-size: 12px;
  color: #909399;
  margin-bottom: 4px;
  font-weight: 500;
}

.item-info h3 {
  margin: 0 0 8px 0;
  font-size: 16px;
  color: #333;
  font-weight: 600;
  line-height: 1.4;
}

.description {
  margin: 0 0 8px 0;
  font-size: 13px;
  color: #666;
  line-height: 1.4;
}

.price-section {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 8px;
}

.current-price {
  color: #f56c6c;
  font-size: 18px;
  font-weight: bold;
}

.original-price {
  color: #909399;
  font-size: 14px;
  text-decoration: line-through;
}

.item-tags {
  display: flex;
  gap: 6px;
}

.item-actions {
  display: flex;
  flex-direction: column;
  gap: 8px;
  align-items: flex-end;
}

.cart-summary {
  position: sticky;
  top: 20px;
}

.summary-item {
  display: flex;
  justify-content: space-between;
  margin-bottom: 12px;
  color: #666;
  font-size: 14px;
}

.summary-item.total {
  margin-top: 16px;
  padding-top: 16px;
  border-top: 1px solid #eee;
  color: #333;
  font-weight: bold;
  font-size: 18px;
}

.total-price {
  color: #f56c6c;
  font-size: 20px;
}

.shipping-info {
  display: flex;
  flex-direction: column;
  align-items: flex-end;
  text-align: right;
}

.free-shipping {
  color: #67c23a;
  font-weight: 500;
}

.shipping-info small {
  font-size: 12px;
  color: #909399;
  margin-top: 2px;
}

.login-tip {
  margin: 16px 0;
}

.checkout-btn {
  width: 100%;
  margin-top: 16px;
  height: 48px;
  font-size: 16px;
  font-weight: 500;
  border-radius: 8px;
}

.checkout-btn:disabled {
  background: #f5f5f5;
  border-color: #e4e4e4;
  color: #c0c4cc;
}

.empty-cart {
  padding: 60px 0;
  text-align: center;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .cart-content {
    grid-template-columns: 1fr;
    gap: 16px;
  }
  
  .cart-summary {
    position: static;
    order: -1;
  }
  
  .item-content {
    flex-direction: column;
    align-items: flex-start;
    gap: 12px;
  }
  
  .item-image {
    width: 80px;
    height: 80px;
  }
  
  .item-actions {
    width: 100%;
    flex-direction: row;
    justify-content: space-between;
    align-items: center;
  }
}
</style> 