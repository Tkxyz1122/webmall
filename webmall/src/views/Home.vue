<template>
  <div class="home">
    <!-- Banner区域 -->
    <div class="banner-container">
      <el-carousel height="500px" class="banner" :interval="5000" indicator-position="outside">
        <el-carousel-item v-for="banner in banners" :key="banner.id">
          <div 
            class="banner-item" 
            :style="{ 
              backgroundImage: `linear-gradient(rgba(0,0,0,0.4), rgba(0,0,0,0.4)), url(${banner.image})`,
              backgroundSize: 'cover',
              backgroundPosition: 'center'
            }"
            @click="goToBanner(banner)"
          >
            <div class="banner-content">
              <h2>{{ banner.title }}</h2>
              <p>{{ banner.subtitle }}</p>
              <el-button type="primary" size="large">{{ banner.buttonText }}</el-button>
            </div>
          </div>
        </el-carousel-item>
      </el-carousel>
    </div>

    <!-- 商品分类 -->
    <div class="section categories">
      <div class="section-header">
        <h2 class="section-title">热门分类</h2>
        <el-button type="text">查看全部分类 ></el-button>
      </div>
      <el-row :gutter="20">
        <el-col :lg="3" :md="6" :sm="8" :xs="12" v-for="category in categories" :key="category.id">
          <el-card class="category-card" :body-style="{ padding: '0px' }" @click="goToCategory(category.id)">
            <div class="category-image-container">
              <img :src="category.image" class="category-image">
              <div class="category-overlay">
                <div class="category-count">{{ category.productCount }} 件商品</div>
              </div>
            </div>
            <div class="category-info">
              <h3>{{ category.name }}</h3>
              <p class="category-description">{{ category.description }}</p>
            </div>
          </el-card>
        </el-col>
      </el-row>
    </div>

    <!-- 精选商品 -->
    <div class="section featured">
      <div class="section-header">
        <h2 class="section-title">精选商品</h2>
        <el-button type="text">更多商品 ></el-button>
      </div>
      <el-row :gutter="20">
        <el-col :lg="6" :md="8" :sm="12" :xs="24" v-for="product in featuredProducts" :key="product.id">
          <el-card class="product-card" :body-style="{ padding: '0px' }" @click="goToProductDetail(product.id)">
            <div class="product-image-container">
              <img :src="product.image" class="product-image">
              <div class="product-hover">
                <el-button 
                  type="primary" 
                  size="large" 
                  circle 
                  :icon="ShoppingCart"
                  @click.stop="addToCart(product)"
                />
              </div>
              <div class="product-tags-home">
                <el-tag v-for="tag in product.tags" :key="tag" size="small" type="danger">
                  {{ tag }}
                </el-tag>
              </div>
            </div>
            <div class="product-info">
              <div class="product-brand-home">{{ product.brand }}</div>
              <h3>{{ product.name }}</h3>
              <p class="description">{{ product.description }}</p>
              <div class="price-section">
                <span class="current-price">¥{{ product.price.toLocaleString() }}</span>
                <span v-if="product.originalPrice" class="original-price">
                  ¥{{ product.originalPrice.toLocaleString() }}
                </span>
              </div>
              <div class="product-rating-home">
                <el-rate 
                  v-model="product.rating" 
                  disabled 
                  show-score 
                  text-color="#ff9900"
                  :max="5"
                  size="small"
                />
              </div>
            </div>
          </el-card>
        </el-col>
      </el-row>
    </div>

    <!-- 管理员入口 -->
    <div class="section admin-section">
      <div class="section-header">
        <h2 class="section-title">管理入口</h2>
      </div>
      <div class="admin-entry">
        <el-button type="primary" size="large" @click="$router.push('/admin/login')">
          <el-icon><Setting /></el-icon>
          管理员登录
        </el-button>
      </div>
    </div>

    <!-- 品牌推荐 -->
    <div class="section brands">
      <div class="section-header">
        <h2 class="section-title">品牌推荐</h2>
      </div>
      <el-row :gutter="20">
        <el-col :lg="4" :md="6" :sm="8" :xs="12" v-for="brand in brands" :key="brand.id">
          <el-card class="brand-card" shadow="hover">
            <div class="brand-content">
              <img :src="brand.logo" class="brand-logo">
              <div class="brand-info">
                <h4>{{ brand.name }}</h4>
                <p>{{ brand.description }}</p>
                <div class="brand-count">{{ brand.productCount }} 件商品</div>
              </div>
            </div>
          </el-card>
        </el-col>
      </el-row>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useStore } from 'vuex'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { ShoppingCart, Setting } from '@element-plus/icons-vue'
import { requireUserLogin } from '@/utils/auth'
import { getBanners, getCategories, getBrands, getProducts } from '@/api'

const store = useStore()
const router = useRouter()

const banners = ref([])
const categories = ref([])
const brands = ref([])
const products = ref([])
const loading = ref(false)

const featuredProducts = computed(() => {
  return products.value.filter(product => 
    product.tags && product.tags.includes('推荐')
  ).slice(0, 8)
})

// 获取首页数据
const fetchHomeData = async () => {
  loading.value = true
  try {
    // 并行获取所有数据
    const [bannersRes, categoriesRes, brandsRes, productsRes] = await Promise.all([
      getBanners(),
      getCategories(),
      getBrands(),
      getProducts({ limit: 20 })
    ])
    
    banners.value = bannersRes.data
    categories.value = categoriesRes.data.slice(0, 8)
    brands.value = brandsRes.data
    products.value = productsRes.data.products
  } catch (error) {
    console.error('获取首页数据失败:', error)
    ElMessage.error('获取首页数据失败')
  } finally {
    loading.value = false
  }
}

const addToCart = (product) => {
  if (requireUserLogin('请先登录后再添加商品到购物车')) {
    store.commit('addToCart', product)
    ElMessage.success(`${product.name} 已加入购物车！`)
  }
}

const goToCategory = (categoryId) => {
  router.push(`/products?category=${categoryId}`)
}

const goToBanner = (banner) => {
  if (banner.link) {
    router.push(banner.link)
  }
}

const goToProductDetail = (productId) => {
  router.push(`/product/${productId}`)
}

// 初始化数据
onMounted(() => {
  fetchHomeData()
})
</script>

<style scoped>
.home {
  width: 100%;
}

.banner-container {
  margin: -20px -20px 40px -20px;
}

.banner {
  width: 100%;
}

.banner-item {
  height: 100%;
  display: flex;
  justify-content: center;
  align-items: center;
  color: #fff;
  cursor: pointer;
  transition: all 0.3s;
}

.banner-item:hover {
  transform: scale(1.02);
}

.banner-content {
  text-align: center;
  z-index: 2;
}

.banner-content h2 {
  font-size: 3rem;
  margin-bottom: 16px;
  font-weight: 700;
  text-shadow: 2px 2px 4px rgba(0,0,0,0.5);
}

.banner-content p {
  font-size: 1.2rem;
  margin-bottom: 32px;
  opacity: 0.95;
  text-shadow: 1px 1px 2px rgba(0,0,0,0.5);
}

.section {
  margin-bottom: 60px;
}

.section-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 24px;
}

.section-title {
  font-size: 24px;
  margin: 0;
  color: #333;
}

.category-card, .product-card {
  margin-bottom: 20px;
  transition: all 0.3s;
  height: 100%;
  cursor: pointer;
  border-radius: 12px;
  overflow: hidden;
}

.category-card:hover, .product-card:hover {
  transform: translateY(-8px);
  box-shadow: 0 8px 25px rgba(0,0,0,0.15);
}

.category-image-container {
  position: relative;
  overflow: hidden;
  height: 160px;
}

.category-image, .product-image {
  width: 100%;
  height: 200px;
  object-fit: cover;
  transition: transform 0.3s;
}

.category-card:hover .category-image,
.product-card:hover .product-image {
  transform: scale(1.1);
}

.category-overlay {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: linear-gradient(to bottom, rgba(0,0,0,0), rgba(0,0,0,0.7));
  display: flex;
  align-items: flex-end;
  padding: 12px;
  opacity: 0;
  transition: opacity 0.3s;
}

.category-card:hover .category-overlay {
  opacity: 1;
}

.category-count {
  color: white;
  font-size: 12px;
  font-weight: 500;
}

.product-image-container {
  position: relative;
  overflow: hidden;
}

.product-hover {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0,0,0,0.5);
  display: flex;
  justify-content: center;
  align-items: center;
  opacity: 0;
  transition: opacity 0.3s;
}

.product-card:hover .product-hover {
  opacity: 1;
}

.category-info, .product-info {
  padding: 16px;
  display: flex;
  flex-direction: column;
}

.category-info h3, .product-info h3 {
  margin: 0 0 8px 0;
  font-size: 16px;
  color: #333;
  font-weight: 600;
  line-height: 1.4;
}

.category-description {
  margin: 0;
  font-size: 12px;
  color: #666;
  line-height: 1.4;
}

.product-brand-home {
  font-size: 12px;
  color: #909399;
  margin-bottom: 4px;
  font-weight: 500;
}

.product-tags-home {
  position: absolute;
  top: 12px;
  left: 12px;
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.description {
  margin: 8px 0;
  font-size: 13px;
  color: #666;
  height: 36px;
  overflow: hidden;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  line-height: 1.4;
}

.price-section {
  display: flex;
  align-items: center;
  gap: 8px;
  margin: 12px 0;
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

.product-rating-home {
  margin-top: auto;
}

.brand-card {
  transition: all 0.3s;
  border-radius: 12px;
  overflow: hidden;
}

.brand-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 6px 20px rgba(0,0,0,0.1);
}

.brand-content {
  display: flex;
  align-items: center;
  padding: 20px;
  gap: 16px;
}

.brand-logo {
  width: 60px;
  height: 40px;
  object-fit: contain;
  flex-shrink: 0;
}

.brand-info {
  flex: 1;
}

.brand-info h4 {
  margin: 0 0 4px 0;
  font-size: 16px;
  color: #333;
  font-weight: 600;
}

.brand-info p {
  margin: 0 0 8px 0;
  font-size: 12px;
  color: #666;
  line-height: 1.4;
}

.brand-count {
  font-size: 12px;
  color: #409EFF;
  font-weight: 500;
}

.admin-section {
  background: #f8f9fa;
  padding: 40px 0;
  text-align: center;
}

.admin-entry {
  display: flex;
  justify-content: center;
  margin-top: 20px;
}

.admin-entry .el-button {
  padding: 12px 32px;
  font-size: 1.1rem;
}

@media (max-width: 768px) {
  .banner-container {
    margin: -20px -20px 20px -20px;
  }

  .banner {
    height: 300px !important;
  }

  .banner-content h2 {
    font-size: 24px;
  }

  .banner-content p {
    font-size: 16px;
  }

  .section {
    margin-bottom: 40px;
  }
}
</style> 