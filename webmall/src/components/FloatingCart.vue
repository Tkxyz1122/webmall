<template>
  <transition name="cart-bounce">
    <div 
      class="floating-cart" 
      v-show="cartItemCount > 0"
      @click="handleCartClick"
      :class="{ 'cart-shake': isShaking }"
    >
      <el-badge :value="cartItemCount" :hidden="cartItemCount === 0" :max="99" class="cart-badge">
        <el-button 
          type="primary" 
          :icon="ShoppingCart" 
          circle 
          size="large"
          class="cart-button"
        />
      </el-badge>
      
      <!-- 购物车金额显示 -->
      <div class="cart-amount" v-if="cartTotal > 0">
        ¥{{ cartTotal.toLocaleString() }}
      </div>
    </div>
  </transition>
</template>

<script setup>
import { computed, ref, watch } from 'vue'
import { useStore } from 'vuex'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { ShoppingCart } from '@element-plus/icons-vue'
import { requireUserLogin } from '@/utils/auth'

const store = useStore()
const router = useRouter()

const isShaking = ref(false)

const cartItemCount = computed(() => store.getters.cartItemCount)
const cartTotal = computed(() => store.getters.cartTotal)
const isLoggedIn = computed(() => store.getters.isLoggedIn)

// 监听购物车数量变化，触发动画
watch(cartItemCount, (newCount, oldCount) => {
  if (newCount > oldCount) {
    triggerShakeAnimation()
  }
})

const triggerShakeAnimation = () => {
  isShaking.value = true
  setTimeout(() => {
    isShaking.value = false
  }, 600)
}

const handleCartClick = () => {
  if (requireUserLogin('请先登录后再查看购物车')) {
    router.push('/cart')
  }
}
</script>

<style scoped>
.floating-cart {
  position: fixed;
  bottom: 30px;
  right: 30px;
  z-index: 1000;
  cursor: pointer;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 8px;
}

.cart-button {
  width: 60px !important;
  height: 60px !important;
  box-shadow: 0 4px 20px rgba(64, 158, 255, 0.3);
  border: none;
  background: linear-gradient(135deg, #409EFF 0%, #67C23A 100%);
  transition: all 0.3s ease;
}

.cart-button:hover {
  transform: scale(1.1);
  box-shadow: 0 6px 25px rgba(64, 158, 255, 0.4);
}

.cart-badge {
  position: relative;
}

.cart-badge :deep(.el-badge__content) {
  background: #f56c6c;
  border: 2px solid white;
  font-weight: bold;
  font-size: 12px;
  min-width: 20px;
  height: 20px;
  line-height: 16px;
  border-radius: 10px;
}

.cart-amount {
  background: rgba(0, 0, 0, 0.8);
  color: white;
  padding: 4px 12px;
  border-radius: 12px;
  font-size: 12px;
  font-weight: 500;
  white-space: nowrap;
  backdrop-filter: blur(10px);
}

/* 震动动画 */
.cart-shake {
  animation: shake 0.6s ease-in-out;
}

@keyframes shake {
  0%, 100% { transform: translateX(0); }
  10%, 30%, 50%, 70%, 90% { transform: translateX(-3px); }
  20%, 40%, 60%, 80% { transform: translateX(3px); }
}

/* 进入离开动画 */
.cart-bounce-enter-active {
  animation: bounceIn 0.6s ease;
}

.cart-bounce-leave-active {
  animation: bounceOut 0.3s ease;
}

@keyframes bounceIn {
  0% {
    opacity: 0;
    transform: scale(0.3) translateY(100px);
  }
  50% {
    opacity: 1;
    transform: scale(1.05);
  }
  70% {
    transform: scale(0.9);
  }
  100% {
    opacity: 1;
    transform: scale(1) translateY(0);
  }
}

@keyframes bounceOut {
  0% {
    transform: scale(1);
  }
  100% {
    opacity: 0;
    transform: scale(0.3) translateY(100px);
  }
}

/* 脉冲效果 */
.cart-button::before {
  content: '';
  position: absolute;
  top: -2px;
  left: -2px;
  right: -2px;
  bottom: -2px;
  background: linear-gradient(135deg, #409EFF, #67C23A);
  border-radius: 50%;
  z-index: -1;
  animation: pulse 2s infinite;
  opacity: 0.6;
}

@keyframes pulse {
  0% {
    transform: scale(0.95);
    opacity: 0.6;
  }
  50% {
    transform: scale(1.05);
    opacity: 0.3;
  }
  100% {
    transform: scale(0.95);
    opacity: 0.6;
  }
}

/* 响应式设计 */
@media (max-width: 768px) {
  .floating-cart {
    bottom: 20px;
    right: 20px;
  }
  
  .cart-button {
    width: 50px !important;
    height: 50px !important;
  }
  
  .cart-amount {
    font-size: 11px;
    padding: 3px 8px;
  }
}
</style> 