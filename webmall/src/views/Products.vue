<template>
  <div class="products">
    <div class="filters">
      <el-card>
        <template #header>
          <div class="filter-header">
            <span>筛选</span>
            <el-button type="text" @click="resetFilters">重置</el-button>
          </div>
        </template>
        
        <div class="filter-section">
          <h4>价格区间</h4>
          <el-slider
            v-model="priceRange"
            range
            :min="0"
            :max="500000"
            :step="1000"
          />
          <div class="price-display">
            ¥{{ priceRange[0].toLocaleString() }} - ¥{{ priceRange[1].toLocaleString() }}
          </div>
        </div>

        <div class="filter-section">
          <h4>商品分类</h4>
          <el-checkbox-group v-model="selectedCategories">
            <el-checkbox v-for="cat in categories" :key="cat.id" :label="cat.id">
              {{ cat.name }}
            </el-checkbox>
          </el-checkbox-group>
        </div>
      </el-card>
    </div>

    <div class="product-list">
      <div class="toolbar">
        <el-input
          v-model="searchQuery"
          placeholder="搜索商品"
          prefix-icon="Search"
          class="search-input"
        />
        <el-select v-model="sortBy" placeholder="排序方式" class="sort-select">
          <el-option label="默认排序" value="default" />
          <el-option label="价格从低到高" value="price-asc" />
          <el-option label="价格从高到低" value="price-desc" />
          <el-option label="最新上架" value="newest" />
        </el-select>
      </div>

      <el-row :gutter="20">
        <el-col :lg="6" :md="8" :sm="12" :xs="24" v-for="product in paginatedProducts" :key="product.id">
          <el-card class="product-card" :body-style="{ padding: '0px' }" @click="goToProductDetail(product.id)">
            <div class="product-image-container">
              <img :src="product.image" class="product-image" @error="handleImageError">
              <div class="product-overlay">
                <el-button 
                  type="primary" 
                  :icon="ShoppingCart" 
                  circle
                  size="large"
                  @click.stop="addToCart(product)"
                />
              </div>
              <div class="product-tags">
                <el-tag v-for="tag in product.tags" :key="tag" size="small" :type="getTagType(tag)">
                  {{ tag }}
                </el-tag>
              </div>
              <div class="product-discount" v-if="product.originalPrice">
                {{ Math.round((1 - product.price / product.originalPrice) * 100) }}% OFF
              </div>
            </div>
            <div class="product-info">
              <div class="product-brand">{{ product.brand }}</div>
              <h3 class="product-name">{{ product.name }}</h3>
              <p class="product-description">{{ product.description }}</p>
              
              <div class="product-rating">
                <el-rate 
                  v-model="product.rating" 
                  disabled 
                  show-score 
                  text-color="#ff9900"
                  :max="5"
                />
                <span class="review-count">({{ product.reviews }})</span>
              </div>
              
              <div class="product-features">
                <el-tag 
                  v-for="feature in product.features.slice(0, 2)" 
                  :key="feature" 
                  size="small" 
                  type="info"
                  effect="plain"
                >
                  {{ feature }}
                </el-tag>
              </div>
              
              <div class="product-price-section">
                <div class="price-container">
                  <span class="current-price">¥{{ product.price.toLocaleString() }}</span>
                  <span v-if="product.originalPrice" class="original-price">
                    ¥{{ product.originalPrice.toLocaleString() }}
                  </span>
                </div>
                <div class="stock-info">
                  <span :class="{ 'low-stock': product.stock < 10 }">
                    库存: {{ product.stock }}
                  </span>
                </div>
              </div>
              
              <div class="product-actions">
                <el-button 
                  type="primary" 
                  size="small" 
                  :icon="ShoppingCart"
                  @click.stop="addToCart(product)"
                  class="add-to-cart-btn"
                >
                  加入购物车
                </el-button>
                <el-button type="text" size="small" class="view-details" @click.stop="goToProductDetail(product.id)">查看详情</el-button>
              </div>
            </div>
          </el-card>
        </el-col>
      </el-row>

      <div class="pagination">
        <el-pagination
          v-model:current-page="currentPage"
          v-model:page-size="pageSize"
          :total="total"
          :page-sizes="[12, 24, 36, 48]"
          layout="total, sizes, prev, pager, next"
        />
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch } from 'vue'
import { useStore } from 'vuex'
import { useRouter, useRoute } from 'vue-router'
import { ElMessage } from 'element-plus'
import { Search, ShoppingCart, Star } from '@element-plus/icons-vue'
import { requireUserLogin } from '@/utils/auth'
import { getProducts, getCategories } from '@/api'

const store = useStore()
const router = useRouter()
const route = useRoute()

const priceRange = ref([0, 500000])
const selectedCategories = ref([])
const searchQuery = ref('')
const sortBy = ref('default')
const currentPage = ref(1)
const pageSize = ref(12)

const categories = ref([])
const products = ref([])
const loading = ref(false)
const total = ref(0)

// 获取商品数据
const fetchProducts = async () => {
  loading.value = true
  try {
    const params = {
      page: currentPage.value,
      limit: pageSize.value
    }
    
    // 添加筛选条件
    if (selectedCategories.value.length > 0) {
      params.category = selectedCategories.value[0] // 暂时只支持单分类
    }
    
    if (searchQuery.value) {
      params.search = searchQuery.value
    }
    
    if (priceRange.value[0] > 0) {
      params.minPrice = priceRange.value[0]
    }
    
    if (priceRange.value[1] < 500000) {
      params.maxPrice = priceRange.value[1]
    }
    
    if (sortBy.value !== 'default') {
      params.sort = sortBy.value
    }

    const response = await getProducts(params)
    products.value = response.data.products
    total.value = response.data.total
  } catch (error) {
    console.error('获取商品失败:', error)
    ElMessage.error('获取商品失败')
  } finally {
    loading.value = false
  }
}

// 获取分类数据
const fetchCategories = async () => {
  try {
    const response = await getCategories()
    categories.value = response.data
  } catch (error) {
    console.error('获取分类失败:', error)
    ElMessage.error('获取分类失败')
  }
}

// 显示的商品就是从API获取的商品
const paginatedProducts = computed(() => products.value)

const resetFilters = () => {
  priceRange.value = [0, 500000]
  selectedCategories.value = []
  searchQuery.value = ''
  sortBy.value = 'default'
  currentPage.value = 1
  fetchProducts()
}

// 监听筛选条件变化
watch([selectedCategories, searchQuery, sortBy, priceRange], () => {
  currentPage.value = 1
  fetchProducts()
}, { deep: true })

// 监听分页变化
watch(currentPage, () => {
  fetchProducts()
})

const addToCart = (product) => {
  if (requireUserLogin('请先登录后再添加商品到购物车')) {
    store.commit('addToCart', product)
    ElMessage.success(`${product.name} 已加入购物车！`)
  }
}

const goToProductDetail = (productId) => {
  router.push(`/product/${productId}`)
}

const getTagType = (tag) => {
  const tagTypes = {
    '热销': 'danger',
    '新品': 'success',
    '推荐': 'warning',
    '降噪': 'info',
    '音质': 'info',
    '游戏': 'primary',
    '便携': 'success',
    '清洁': 'info',
    '智能': 'warning',
    '电动': 'success',
    '新能源': 'success',
    '摄影': 'primary',
    '专业': 'danger',
    '4K': 'warning',
    'OLED': 'info',
    'Android': 'success',
    '创意': 'primary'
  }
  return tagTypes[tag] || 'default'
}

const handleImageError = (event) => {
  event.target.src = 'https://via.placeholder.com/300x300?text=No+Image'
}

// 初始化数据
onMounted(() => {
  fetchCategories()
  fetchProducts()
})
</script>

<style scoped>
.products {
  display: flex;
  gap: 20px;
}

.filters {
  width: 240px;
  flex-shrink: 0;
}

.filter-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.filter-section {
  margin-bottom: 20px;
}

.filter-section h4 {
  margin: 0 0 10px 0;
  font-size: 14px;
  color: #606266;
}

.price-display {
  margin-top: 10px;
  text-align: center;
  color: #409EFF;
}

.product-list {
  flex: 1;
}

.toolbar {
  margin-bottom: 20px;
  display: flex;
  gap: 10px;
}

.search-input {
  width: 200px;
}

.sort-select {
  width: 140px;
}

.product-card {
  margin-bottom: 20px;
  transition: all 0.3s;
  border-radius: 12px;
  overflow: hidden;
  height: 100%;
  display: flex;
  flex-direction: column;
  cursor: pointer;
}

.product-card:hover {
  transform: translateY(-8px);
  box-shadow: 0 8px 25px rgba(0,0,0,0.15);
}

.product-image-container {
  position: relative;
  overflow: hidden;
  height: 250px;
}

.product-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.3s;
}

.product-card:hover .product-image {
  transform: scale(1.05);
}

.product-overlay {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0,0,0,0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  opacity: 0;
  transition: opacity 0.3s;
}

.product-card:hover .product-overlay {
  opacity: 1;
}

.product-tags {
  position: absolute;
  top: 12px;
  left: 12px;
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.product-discount {
  position: absolute;
  top: 12px;
  right: 12px;
  background: #f56c6c;
  color: white;
  padding: 4px 8px;
  border-radius: 12px;
  font-size: 12px;
  font-weight: bold;
}

.product-info {
  padding: 16px;
  flex: 1;
  display: flex;
  flex-direction: column;
}

.product-brand {
  font-size: 12px;
  color: #909399;
  margin-bottom: 4px;
  font-weight: 500;
}

.product-name {
  margin: 0 0 8px 0;
  font-size: 16px;
  color: #333;
  font-weight: 600;
  line-height: 1.4;
  height: 44px;
  overflow: hidden;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
}

.product-description {
  margin: 0 0 12px 0;
  font-size: 13px;
  color: #666;
  line-height: 1.4;
  height: 36px;
  overflow: hidden;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
}

.product-rating {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 12px;
}

.review-count {
  font-size: 12px;
  color: #909399;
}

.product-features {
  display: flex;
  gap: 6px;
  margin-bottom: 12px;
  flex-wrap: wrap;
}

.product-price-section {
  margin-bottom: 16px;
}

.price-container {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 4px;
}

.current-price {
  color: #f56c6c;
  font-size: 20px;
  font-weight: bold;
}

.original-price {
  color: #909399;
  font-size: 14px;
  text-decoration: line-through;
}

.stock-info {
  font-size: 12px;
  color: #67c23a;
}

.low-stock {
  color: #f56c6c !important;
}

.product-actions {
  display: flex;
  gap: 8px;
  margin-top: auto;
}

.add-to-cart-btn {
  flex: 1;
  border-radius: 8px;
}

.view-details {
  color: #409EFF;
  font-size: 12px;
}

.pagination {
  margin-top: 20px;
  display: flex;
  justify-content: center;
}
</style> 