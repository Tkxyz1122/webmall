<template>
  <div class="product-detail">
    <div class="container">
      <!-- 面包屑导航 -->
      <nav class="breadcrumb">
        <router-link to="/" class="breadcrumb-item">首页</router-link>
        <span class="separator">/</span>
        <router-link to="/products" class="breadcrumb-item">商品</router-link>
        <span class="separator">/</span>
        <span class="breadcrumb-current">{{ product?.name }}</span>
      </nav>

      <div v-if="product" class="product-info">
        <!-- 商品主要信息区域 -->
        <div class="product-main">
          <!-- 左侧图片区域 -->
          <div class="product-images">
            <div class="main-image">
              <img :src="selectedImage" :alt="product.name" />
            </div>
            <div class="thumbnail-list" v-if="product.images && product.images.length > 1">
              <div 
                v-for="(image, index) in product.images" 
                :key="index"
                class="thumbnail"
                :class="{ active: selectedImage === image }"
                @click="selectedImage = image"
              >
                <img :src="image" :alt="`${product.name} ${index + 1}`" />
              </div>
            </div>
          </div>

          <!-- 右侧信息区域 -->
          <div class="product-info-right">
            <h1 class="product-title">{{ product.name }}</h1>
            
            <!-- 评分和品牌 -->
            <div class="product-meta">
              <div class="rating">
                <div class="stars">
                  <i 
                    v-for="n in 5" 
                    :key="n" 
                    class="star" 
                    :class="{ filled: n <= Math.floor(product.rating) }"
                  ></i>
                </div>
                <span class="rating-text">{{ product.rating }}</span>
                <span class="reviews-count">({{ product.reviews }}条评价)</span>
              </div>
              <div class="brand">品牌：{{ product.brand }}</div>
            </div>

            <!-- 价格信息 -->
            <div class="price-section">
              <div class="current-price">¥{{ product.price.toLocaleString() }}</div>
              <div v-if="product.originalPrice && product.originalPrice > product.price" class="original-price">
                ¥{{ product.originalPrice.toLocaleString() }}
              </div>
              <div v-if="product.originalPrice && product.originalPrice > product.price" class="discount">
                省 ¥{{ (product.originalPrice - product.price).toLocaleString() }}
              </div>
            </div>

            <!-- 标签 -->
            <div class="tags" v-if="product.tags && product.tags.length">
              <span v-for="tag in product.tags" :key="tag" class="tag">{{ tag }}</span>
            </div>

            <!-- 商品描述 -->
            <div class="description">
              <p>{{ product.description }}</p>
            </div>

            <!-- 库存信息 -->
            <div class="stock-info">
              <span class="stock-label">库存：</span>
              <span class="stock-count" :class="{ 'low-stock': product.stock < 10 }">
                {{ product.stock > 0 ? `${product.stock}件` : '暂无库存' }}
              </span>
            </div>

            <!-- 购买操作 -->
            <div class="purchase-actions">
              <div class="quantity-selector">
                <label>数量：</label>
                <div class="quantity-controls">
                  <button @click="decreaseQuantity" :disabled="quantity <= 1">-</button>
                  <input v-model.number="quantity" type="number" min="1" :max="product.stock" />
                  <button @click="increaseQuantity" :disabled="quantity >= product.stock">+</button>
                </div>
              </div>
              
              <div class="action-buttons">
                <button 
                  class="btn-cart" 
                  @click="addToCartHandler"
                  :disabled="product.stock === 0"
                >
                  <i class="cart-icon"></i>
                  加入购物车
                </button>
                <button 
                  class="btn-buy" 
                  @click="buyNow"
                  :disabled="product.stock === 0"
                >
                  立即购买
                </button>
              </div>
            </div>
          </div>
        </div>

        <!-- 详细信息标签页 -->
        <div class="product-details-tabs">
          <div class="tabs-header">
            <div 
              class="tab-item" 
              :class="{ active: activeTab === 'features' }"
              @click="activeTab = 'features'"
            >
              产品特色
            </div>
            <div 
              class="tab-item" 
              :class="{ active: activeTab === 'specs' }"
              @click="activeTab = 'specs'"
            >
              规格参数
            </div>
            <div 
              class="tab-item" 
              :class="{ active: activeTab === 'reviews' }"
              @click="activeTab = 'reviews'"
            >
              用户评价
            </div>
          </div>

          <div class="tabs-content">
            <!-- 产品特色 -->
            <div v-if="activeTab === 'features'" class="tab-content">
              <div class="features-list">
                <div v-for="feature in product.features" :key="feature" class="feature-item">
                  <i class="check-icon"></i>
                  <span>{{ feature }}</span>
                </div>
              </div>
            </div>

            <!-- 规格参数 -->
            <div v-if="activeTab === 'specs'" class="tab-content">
              <div class="specs-table">
                <div class="spec-row">
                  <div class="spec-label">品牌</div>
                  <div class="spec-value">{{ product.brand }}</div>
                </div>
                <div class="spec-row">
                  <div class="spec-label">型号</div>
                  <div class="spec-value">{{ product.name }}</div>
                </div>
                <div class="spec-row">
                  <div class="spec-label">评分</div>
                  <div class="spec-value">{{ product.rating }}/5.0</div>
                </div>
                <div class="spec-row">
                  <div class="spec-label">用户评价</div>
                  <div class="spec-value">{{ product.reviews }}条</div>
                </div>
              </div>
            </div>

            <!-- 用户评价 -->
            <div v-if="activeTab === 'reviews'" class="tab-content">
              <div class="reviews-summary">
                <div class="reviews-stats">
                  <div class="average-rating">
                    <span class="rating-number">{{ product.rating }}</span>
                    <div class="stars">
                      <i 
                        v-for="n in 5" 
                        :key="n" 
                        class="star" 
                        :class="{ filled: n <= Math.floor(product.rating) }"
                      ></i>
                    </div>
                    <span class="total-reviews">共{{ product.reviews }}条评价</span>
                  </div>
                </div>
              </div>
              
              <!-- 模拟评价列表 -->
              <div class="reviews-list">
                <div v-for="review in mockReviews" :key="review.id" class="review-item">
                  <div class="review-header">
                    <div class="reviewer-info">
                      <div class="reviewer-avatar">{{ review.name.charAt(0) }}</div>
                      <div class="reviewer-name">{{ review.name }}</div>
                    </div>
                    <div class="review-rating">
                      <div class="stars">
                        <i 
                          v-for="n in 5" 
                          :key="n" 
                          class="star" 
                          :class="{ filled: n <= review.rating }"
                        ></i>
                      </div>
                      <span class="review-date">{{ review.date }}</span>
                    </div>
                  </div>
                  <div class="review-content">{{ review.content }}</div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- 商品未找到 -->
      <div v-else class="product-not-found">
        <div class="not-found-content">
          <h2>商品未找到</h2>
          <p>抱歉，您要查看的商品不存在或已下架。</p>
          <router-link to="/products" class="btn-back">返回商品列表</router-link>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useStore } from 'vuex'
import { ElMessage } from 'element-plus'
import { requireUserLogin } from '@/utils/auth'
import { getProductDetail } from '@/api'

const route = useRoute()
const router = useRouter()
const store = useStore()

const product = ref(null)
const selectedImage = ref('')
const quantity = ref(1)
const activeTab = ref('features')
const loading = ref(false)

const mockReviews = ref([
  {
    id: 1,
    name: '张先生',
    rating: 5,
    date: '2024-01-15',
    content: '产品质量很好，物流快速，包装精美，非常满意！'
  },
  {
    id: 2,
    name: '李女士',
    rating: 4,
    date: '2024-01-10',
    content: '整体不错，性价比很高，推荐购买。'
  },
  {
    id: 3,
    name: '王先生',
    rating: 5,
    date: '2024-01-08',
    content: '超出预期，功能齐全，使用体验很棒！'
  }
])

// 加载商品详情
const loadProduct = async () => {
  loading.value = true
  try {
    const productId = route.params.id
    const response = await getProductDetail(productId)
    product.value = response.data
    if (product.value) {
      selectedImage.value = product.value.image
    }
  } catch (error) {
    console.error('获取商品详情失败:', error)
    ElMessage.error('获取商品详情失败')
  } finally {
    loading.value = false
  }
}

// 增加数量
const increaseQuantity = () => {
  if (quantity.value < product.value.stock) {
    quantity.value++
  }
}

// 减少数量
const decreaseQuantity = () => {
  if (quantity.value > 1) {
    quantity.value--
  }
}

// 添加到购物车
const addToCartHandler = () => {
  if (requireUserLogin('请先登录后再添加商品到购物车')) {
    if (product.value && product.value.stock > 0) {
      store.commit('addToCart', {
        ...product.value,
        quantity: quantity.value
      })
      ElMessage.success(`成功加入购物车 ${quantity.value} 件`)
    }
  }
}

// 立即购买
const buyNow = () => {
  if (requireUserLogin('请先登录后再购买商品')) {
    if (product.value && product.value.stock > 0) {
      addToCartHandler()
      router.push('/cart')
    }
  }
}

// 监听路由变化
watch(() => route.params.id, () => {
  loadProduct()
})

// 初始化
onMounted(() => {
  loadProduct()
})
</script>

<style scoped>
.product-detail {
  min-height: 100vh;
  background: #f5f5f5;
  padding: 20px 0;
}

.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 20px;
}

/* 面包屑导航 */
.breadcrumb {
  background: white;
  padding: 15px 20px;
  border-radius: 8px;
  margin-bottom: 20px;
  font-size: 14px;
}

.breadcrumb-item {
  color: #666;
  text-decoration: none;
}

.breadcrumb-item:hover {
  color: #e74c3c;
}

.separator {
  margin: 0 10px;
  color: #ccc;
}

.breadcrumb-current {
  color: #333;
  font-weight: 500;
}

/* 商品主要信息 */
.product-info {
  background: white;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);
}

.product-main {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 40px;
  padding: 40px;
}

/* 图片区域 */
.product-images {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.main-image {
  width: 100%;
  aspect-ratio: 1;
  border-radius: 12px;
  overflow: hidden;
  background: #f8f9fa;
}

.main-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.thumbnail-list {
  display: flex;
  gap: 10px;
  flex-wrap: wrap;
}

.thumbnail {
  width: 80px;
  height: 80px;
  border-radius: 8px;
  overflow: hidden;
  cursor: pointer;
  border: 2px solid transparent;
  transition: all 0.3s ease;
}

.thumbnail.active {
  border-color: #e74c3c;
}

.thumbnail img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

/* 商品信息右侧 */
.product-info-right {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.product-title {
  font-size: 28px;
  font-weight: 600;
  color: #333;
  margin: 0;
  line-height: 1.3;
}

.product-meta {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.rating {
  display: flex;
  align-items: center;
  gap: 10px;
}

.stars {
  display: flex;
  gap: 2px;
}

.star {
  width: 16px;
  height: 16px;
  background: #ddd;
  clip-path: polygon(50% 0%, 61% 35%, 98% 35%, 68% 57%, 79% 91%, 50% 70%, 21% 91%, 32% 57%, 2% 35%, 39% 35%);
}

.star.filled {
  background: #ffc107;
}

.rating-text {
  font-weight: 600;
  color: #333;
}

.reviews-count {
  color: #666;
  font-size: 14px;
}

.brand {
  color: #666;
  font-size: 16px;
}

/* 价格区域 */
.price-section {
  display: flex;
  align-items: center;
  gap: 15px;
  padding: 20px 0;
  border-top: 1px solid #eee;
  border-bottom: 1px solid #eee;
}

.current-price {
  font-size: 32px;
  font-weight: 600;
  color: #e74c3c;
}

.original-price {
  font-size: 18px;
  color: #999;
  text-decoration: line-through;
}

.discount {
  background: #e74c3c;
  color: white;
  padding: 4px 8px;
  border-radius: 4px;
  font-size: 12px;
  font-weight: 500;
}

/* 标签 */
.tags {
  display: flex;
  gap: 8px;
  flex-wrap: wrap;
}

.tag {
  background: #f8f9fa;
  color: #666;
  padding: 6px 12px;
  border-radius: 20px;
  font-size: 14px;
  border: 1px solid #e9ecef;
}

/* 商品描述 */
.description p {
  color: #666;
  line-height: 1.6;
  margin: 0;
  font-size: 16px;
}

/* 库存信息 */
.stock-info {
  display: flex;
  align-items: center;
  gap: 10px;
}

.stock-label {
  color: #666;
  font-weight: 500;
}

.stock-count {
  color: #28a745;
  font-weight: 600;
}

.stock-count.low-stock {
  color: #ffc107;
}

/* 购买操作 */
.purchase-actions {
  display: flex;
  flex-direction: column;
  gap: 20px;
  padding-top: 20px;
}

.quantity-selector {
  display: flex;
  align-items: center;
  gap: 15px;
}

.quantity-selector label {
  font-weight: 500;
  color: #333;
}

.quantity-controls {
  display: flex;
  align-items: center;
  border: 1px solid #ddd;
  border-radius: 6px;
  overflow: hidden;
}

.quantity-controls button {
  width: 36px;
  height: 36px;
  border: none;
  background: #f8f9fa;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: background 0.3s ease;
}

.quantity-controls button:hover:not(:disabled) {
  background: #e9ecef;
}

.quantity-controls button:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.quantity-controls input {
  width: 60px;
  height: 36px;
  border: none;
  text-align: center;
  font-size: 14px;
  outline: none;
}

.action-buttons {
  display: flex;
  gap: 15px;
}

.btn-cart,
.btn-buy {
  flex: 1;
  height: 48px;
  border: none;
  border-radius: 8px;
  font-size: 16px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
}

.btn-cart {
  background: #fff;
  color: #e74c3c;
  border: 2px solid #e74c3c;
}

.btn-cart:hover:not(:disabled) {
  background: #e74c3c;
  color: white;
}

.btn-buy {
  background: #e74c3c;
  color: white;
}

.btn-buy:hover:not(:disabled) {
  background: #c0392b;
}

.btn-cart:disabled,
.btn-buy:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.cart-icon {
  width: 16px;
  height: 16px;
  background: currentColor;
  mask: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' fill='currentColor' viewBox='0 0 16 16'%3E%3Cpath d='M0 1.5A.5.5 0 0 1 .5 1H2a.5.5 0 0 1 .485.379L2.89 3H14.5a.5.5 0 0 1 .49.598l-1 5a.5.5 0 0 1-.465.401l-9.397.472L4.415 11H13a.5.5 0 0 1 0 1H4a.5.5 0 0 1-.491-.408L2.01 3.607 1.61 2H.5a.5.5 0 0 1-.5-.5zM3.102 4l.84 4.479 9.144-.459L13.89 4H3.102zM5 12a2 2 0 1 0 0 4 2 2 0 0 0 0-4zm7 0a2 2 0 1 0 0 4 2 2 0 0 0 0-4zm-7 1a1 1 0 1 1 0 2 1 1 0 0 1 0-2zm7 0a1 1 0 1 1 0 2 1 1 0 0 1 0-2z'/%3E%3C/svg%3E") no-repeat center;
}

/* 详细信息标签页 */
.product-details-tabs {
  border-top: 1px solid #eee;
}

.tabs-header {
  display: flex;
  background: #f8f9fa;
}

.tab-item {
  flex: 1;
  padding: 20px;
  text-align: center;
  cursor: pointer;
  font-weight: 500;
  color: #666;
  border-bottom: 3px solid transparent;
  transition: all 0.3s ease;
}

.tab-item:hover {
  color: #e74c3c;
}

.tab-item.active {
  color: #e74c3c;
  border-bottom-color: #e74c3c;
  background: white;
}

.tabs-content {
  padding: 40px;
}

/* 产品特色 */
.features-list {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 20px;
}

.feature-item {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 15px;
  background: #f8f9fa;
  border-radius: 8px;
}

.check-icon {
  width: 20px;
  height: 20px;
  background: #28a745;
  border-radius: 50%;
  position: relative;
}

.check-icon::after {
  content: '✓';
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  color: white;
  font-size: 12px;
  font-weight: bold;
}

/* 规格参数表 */
.specs-table {
  max-width: 600px;
}

.spec-row {
  display: grid;
  grid-template-columns: 150px 1fr;
  padding: 15px 0;
  border-bottom: 1px solid #eee;
}

.spec-row:last-child {
  border-bottom: none;
}

.spec-label {
  font-weight: 500;
  color: #666;
}

.spec-value {
  color: #333;
}

/* 用户评价 */
.reviews-summary {
  margin-bottom: 30px;
  padding: 20px;
  background: #f8f9fa;
  border-radius: 12px;
}

.reviews-stats {
  text-align: center;
}

.average-rating {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 15px;
}

.rating-number {
  font-size: 36px;
  font-weight: 600;
  color: #e74c3c;
}

.total-reviews {
  color: #666;
}

.reviews-list {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.review-item {
  padding: 20px;
  border: 1px solid #eee;
  border-radius: 12px;
  background: white;
}

.review-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 15px;
}

.reviewer-info {
  display: flex;
  align-items: center;
  gap: 12px;
}

.reviewer-avatar {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  background: #e74c3c;
  color: white;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: 600;
}

.reviewer-name {
  font-weight: 500;
  color: #333;
}

.review-rating {
  display: flex;
  align-items: center;
  gap: 10px;
  font-size: 14px;
  color: #666;
}

.review-content {
  color: #666;
  line-height: 1.6;
}

/* 商品未找到 */
.product-not-found {
  text-align: center;
  padding: 60px 20px;
  background: white;
  border-radius: 12px;
}

.not-found-content h2 {
  color: #333;
  margin-bottom: 15px;
}

.not-found-content p {
  color: #666;
  margin-bottom: 30px;
}

.btn-back {
  display: inline-block;
  padding: 12px 24px;
  background: #e74c3c;
  color: white;
  text-decoration: none;
  border-radius: 8px;
  font-weight: 500;
  transition: background 0.3s ease;
}

.btn-back:hover {
  background: #c0392b;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .product-main {
    grid-template-columns: 1fr;
    gap: 30px;
    padding: 20px;
  }

  .product-title {
    font-size: 24px;
  }

  .current-price {
    font-size: 28px;
  }

  .action-buttons {
    flex-direction: column;
  }

  .tabs-header .tab-item {
    padding: 15px 10px;
    font-size: 14px;
  }

  .tabs-content {
    padding: 20px;
  }

  .features-list {
    grid-template-columns: 1fr;
  }

  .spec-row {
    grid-template-columns: 1fr;
    gap: 5px;
  }

  .average-rating {
    flex-direction: column;
    gap: 10px;
  }
}
</style> 