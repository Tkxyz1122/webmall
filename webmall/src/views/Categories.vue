<template>
  <div class="categories">
    <div class="categories-header">
      <h2 class="page-title">商品分类</h2>
      <el-breadcrumb separator="/">
        <el-breadcrumb-item :to="{ path: '/' }">首页</el-breadcrumb-item>
        <el-breadcrumb-item>商品分类</el-breadcrumb-item>
      </el-breadcrumb>
    </div>

    <el-row :gutter="20">
      <el-col :lg="6" :md="8" :sm="12" :xs="24" v-for="category in categories" :key="category.id">
        <el-card class="category-card" :body-style="{ padding: '0px' }">
          <div class="category-image-container">
            <img :src="category.image" class="category-image">
            <div class="category-overlay">
              <span class="category-count">{{ category.productCount }}个商品</span>
            </div>
          </div>
          <div class="category-info">
            <h3>{{ category.name }}</h3>
            <div class="subcategories">
              <el-tag
                v-for="sub in category.subcategories"
                :key="sub.id"
                size="small"
                class="subcategory-tag"
              >
                {{ sub.name }}
              </el-tag>
            </div>
            <el-button type="primary" class="view-btn">查看全部</el-button>
          </div>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script setup>
import { ref } from 'vue'

const categories = ref([
  {
    id: 1,
    name: '手机数码',
    image: 'https://via.placeholder.com/300x200',
    productCount: 128,
    subcategories: [
      { id: 11, name: '手机' },
      { id: 12, name: '平板' },
      { id: 13, name: '笔记本' },
      { id: 14, name: '智能配件' }
    ]
  },
  {
    id: 2,
    name: '电脑办公',
    image: 'https://via.placeholder.com/300x200',
    productCount: 96,
    subcategories: [
      { id: 21, name: '台式机' },
      { id: 22, name: '显示器' },
      { id: 23, name: '外设产品' },
      { id: 24, name: '办公设备' }
    ]
  },
  {
    id: 3,
    name: '家用电器',
    image: 'https://via.placeholder.com/300x200',
    productCount: 64,
    subcategories: [
      { id: 31, name: '电视' },
      { id: 32, name: '空调' },
      { id: 33, name: '洗衣机' },
      { id: 34, name: '冰箱' }
    ]
  },
  {
    id: 4,
    name: '服装鞋包',
    image: 'https://via.placeholder.com/300x200',
    productCount: 256,
    subcategories: [
      { id: 41, name: '男装' },
      { id: 42, name: '女装' },
      { id: 43, name: '鞋靴' },
      { id: 44, name: '箱包' }
    ]
  },
  {
    id: 5,
    name: '食品生鲜',
    image: 'https://via.placeholder.com/300x200',
    productCount: 192,
    subcategories: [
      { id: 51, name: '零食' },
      { id: 52, name: '饮料' },
      { id: 53, name: '生鲜' },
      { id: 54, name: '粮油' }
    ]
  },
  {
    id: 6,
    name: '美妆护肤',
    image: 'https://via.placeholder.com/300x200',
    productCount: 160,
    subcategories: [
      { id: 61, name: '面部护理' },
      { id: 62, name: '彩妆' },
      { id: 63, name: '香水' },
      { id: 64, name: '个护清洁' }
    ]
  },
  {
    id: 7,
    name: '运动户外',
    image: 'https://via.placeholder.com/300x200',
    productCount: 144,
    subcategories: [
      { id: 71, name: '运动服' },
      { id: 72, name: '健身器材' },
      { id: 73, name: '户外装备' },
      { id: 74, name: '运动鞋' }
    ]
  },
  {
    id: 8,
    name: '图书文娱',
    image: 'https://via.placeholder.com/300x200',
    productCount: 208,
    subcategories: [
      { id: 81, name: '小说' },
      { id: 82, name: '文学' },
      { id: 83, name: '童书' },
      { id: 84, name: '教材' }
    ]
  }
])
</script>

<style scoped>
.categories {
  width: 100%;
}

.categories-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 24px;
}

.page-title {
  margin: 0;
  font-size: 24px;
  color: #333;
}

.category-card {
  margin-bottom: 20px;
  transition: all 0.3s;
  height: 100%;
}

.category-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 4px 12px rgba(0,0,0,0.1);
}

.category-image-container {
  height: 200px;
  overflow: hidden;
  position: relative;
}

.category-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.3s;
}

.category-overlay {
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  padding: 10px;
  background: linear-gradient(transparent, rgba(0,0,0,0.7));
  color: white;
}

.category-count {
  font-size: 14px;
}

.category-card:hover .category-image {
  transform: scale(1.05);
}

.category-info {
  padding: 16px;
}

.category-info h3 {
  margin: 0 0 12px 0;
  font-size: 18px;
  color: #333;
}

.subcategories {
  margin-bottom: 16px;
  min-height: 56px;
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}

.subcategory-tag {
  cursor: pointer;
  margin: 0;
}

.subcategory-tag:hover {
  background-color: #409EFF;
  color: white;
}

.view-btn {
  width: 100%;
}

@media (max-width: 768px) {
  .categories-header {
    flex-direction: column;
    align-items: flex-start;
    gap: 12px;
  }
}
</style> 