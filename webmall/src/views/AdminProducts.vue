<template>
  <div class="admin-products">
    <!-- 页面头部 -->
    <div class="page-header">
      <h2>商品管理</h2>
      <div class="header-actions">
        <el-button type="primary" @click="showAddDialog = true">
          <el-icon><Plus /></el-icon>
          添加商品
        </el-button>
        <el-button @click="refreshProducts">
          <el-icon><Refresh /></el-icon>
          刷新
        </el-button>
      </div>
    </div>

    <!-- 商品列表 -->
    <el-card class="products-card">
      <div v-loading="loading" class="products-content">
        <div v-if="products.length === 0 && !loading" class="empty-state">
          <el-empty description="暂无商品数据">
            <el-button type="primary" @click="showAddDialog = true">添加商品</el-button>
          </el-empty>
        </div>

        <div v-else>
          <el-table :data="products" style="width: 100%" stripe>
            <el-table-column prop="id" label="ID" width="80" />
            
            <el-table-column prop="image" label="图片" width="100">
              <template #default="{ row }">
                <img 
                  :src="row.image" 
                  :alt="row.name"
                  class="product-image"
                  @error="$event.target.src='https://via.placeholder.com/80x80?text=No+Image'"
                />
              </template>
            </el-table-column>
            
            <el-table-column prop="name" label="商品名称" min-width="200">
              <template #default="{ row }">
                <div class="product-info">
                  <div class="product-name">{{ row.name }}</div>
                  <div class="product-desc">{{ row.description }}</div>
                </div>
              </template>
            </el-table-column>
            
            <el-table-column prop="price" label="价格" width="120">
              <template #default="{ row }">
                <div class="price-info">
                  <div class="current-price">¥{{ row.price.toLocaleString() }}</div>
                  <div v-if="row.originalPrice" class="original-price">
                    ¥{{ row.originalPrice.toLocaleString() }}
                  </div>
                </div>
              </template>
            </el-table-column>
            
            <el-table-column prop="stock" label="库存" width="100" align="center">
              <template #default="{ row }">
                <el-tag :type="row.stock > 0 ? 'success' : 'danger'" size="small">
                  {{ row.stock }}
                </el-tag>
              </template>
            </el-table-column>
            
            <el-table-column prop="brand" label="品牌" width="120">
              <template #default="{ row }">
                <el-tag type="info" size="small">
                  {{ row.brand || '未设置' }}
                </el-tag>
              </template>
            </el-table-column>
            
            <el-table-column prop="createTime" label="创建时间" width="180">
              <template #default="{ row }">
                <span>{{ formatDate(row.createTime) }}</span>
              </template>
            </el-table-column>
            
            <el-table-column label="操作" width="200" fixed="right">
              <template #default="{ row }">
                <div class="table-actions">
                  <el-button 
                    size="small" 
                    @click="editProduct(row)"
                  >
                    编辑
                  </el-button>
                  
                  <el-button 
                    size="small" 
                    type="info"
                    @click="editProduct(row)"
                  >
                    查看
                  </el-button>
                  
                  <el-button 
                    size="small" 
                    type="danger"
                    @click="deleteProduct(row)"
                  >
                    删除
                  </el-button>
                </div>
              </template>
            </el-table-column>
          </el-table>

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
    </el-card>

    <!-- 添加/编辑商品对话框 -->
    <el-dialog
      v-model="showAddDialog"
      :title="editingProduct ? '编辑商品' : '添加商品'"
      width="600px"
    >
      <el-form
        ref="productFormRef"
        :model="productForm"
        :rules="productRules"
        label-width="100px"
      >
        <el-form-item label="商品名称" prop="name">
          <el-input v-model="productForm.name" placeholder="请输入商品名称" />
        </el-form-item>
        
        <el-form-item label="商品描述" prop="description">
          <el-input 
            v-model="productForm.description" 
            type="textarea" 
            :rows="3"
            placeholder="请输入商品描述" 
          />
        </el-form-item>
        
        <el-form-item label="商品价格" prop="price">
          <el-input-number 
            v-model="productForm.price" 
            :min="0" 
            :precision="2"
            placeholder="请输入价格" 
          />
        </el-form-item>
        
        <el-form-item label="原价">
          <el-input-number 
            v-model="productForm.originalPrice" 
            :min="0" 
            :precision="2"
            placeholder="请输入原价（可选）" 
          />
        </el-form-item>
        
        <el-form-item label="库存数量" prop="stock">
          <el-input-number 
            v-model="productForm.stock" 
            :min="0"
            placeholder="请输入库存数量" 
          />
        </el-form-item>
        
        <el-form-item label="商品图片">
          <el-input 
            v-model="productForm.image" 
            placeholder="请输入图片URL" 
          />
        </el-form-item>
        
        <el-form-item label="商品品牌">
          <el-input 
            v-model="productForm.brand" 
            placeholder="请输入品牌名称" 
          />
        </el-form-item>
        
        <el-form-item label="商品分类">
          <el-select v-model="productForm.categoryId" placeholder="请选择分类">
            <el-option label="手机" :value="1" />
            <el-option label="电脑" :value="2" />
            <el-option label="平板" :value="3" />
            <el-option label="耳机" :value="4" />
            <el-option label="智能手表" :value="5" />
          </el-select>
        </el-form-item>
      </el-form>
      
      <template #footer>
        <div class="dialog-footer">
          <el-button @click="showAddDialog = false">取消</el-button>
          <el-button type="primary" @click="saveProduct" :loading="saving">
            {{ saving ? '保存中...' : '保存' }}
          </el-button>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Plus, Refresh } from '@element-plus/icons-vue'
import { getAdminProducts, createProduct, updateProduct, deleteProduct as deleteProductApi } from '@/api'

// 响应式数据
const products = ref([])
const loading = ref(false)
const saving = ref(false)
const currentPage = ref(1)
const pageSize = ref(10)
const total = ref(0)
const showAddDialog = ref(false)
const editingProduct = ref(null)
const productFormRef = ref()

const productForm = reactive({
  name: '',
  description: '',
  price: 0,
  originalPrice: null,
  stock: 0,
  image: '',
  brand: '',
  categoryId: null
})

const productRules = {
  name: [
    { required: true, message: '请输入商品名称', trigger: 'blur' }
  ],
  price: [
    { required: true, message: '请输入商品价格', trigger: 'blur' },
    { type: 'number', min: 0, message: '价格不能小于0', trigger: 'blur' }
  ],
  stock: [
    { required: true, message: '请输入库存数量', trigger: 'blur' },
    { type: 'number', min: 0, message: '库存不能小于0', trigger: 'blur' }
  ],
  categoryId: [
    { required: true, message: '请选择商品分类', trigger: 'change' }
  ]
}

// 获取商品列表
const fetchProducts = async () => {
  loading.value = true
  try {
    const params = {
      page: currentPage.value,
      limit: pageSize.value
    }

    const response = await getAdminProducts(params)
    products.value = response.data.products
    total.value = response.data.total
  } catch (error) {
    console.error('获取商品列表失败:', error)
    ElMessage.error('获取商品列表失败')
  } finally {
    loading.value = false
  }
}

// 分页处理
const handleSizeChange = (size) => {
  pageSize.value = size
  currentPage.value = 1
  fetchProducts()
}

const handleCurrentChange = (page) => {
  currentPage.value = page
  fetchProducts()
}

// 刷新商品
const refreshProducts = () => {
  fetchProducts()
  ElMessage.success('商品列表已刷新')
}

// 格式化日期
const formatDate = (dateString) => {
  if (!dateString) return '-'
  return new Date(dateString).toLocaleString('zh-CN')
}

// 编辑商品
const editProduct = (product) => {
  editingProduct.value = product
  Object.assign(productForm, {
    name: product.name,
    description: product.description,
    price: product.price,
    originalPrice: product.originalPrice,
    stock: product.stock,
    image: product.image,
    brand: product.brand,
    categoryId: product.categoryId
  })
  showAddDialog.value = true
}

// 保存商品
const saveProduct = async () => {
  try {
    await productFormRef.value.validate()
    saving.value = true
    
    if (editingProduct.value) {
      // 更新商品
      await updateProduct(editingProduct.value.id, productForm)
      ElMessage.success('商品更新成功')
    } else {
      // 创建商品
      await createProduct(productForm)
      ElMessage.success('商品创建成功')
    }
    
    showAddDialog.value = false
    resetForm()
    fetchProducts()
    
  } catch (error) {
    console.error('保存商品失败:', error)
    ElMessage.error('保存商品失败')
  } finally {
    saving.value = false
  }
}

// 切换商品状态（已移除，因为数据库中没有status字段）

// 删除商品
const deleteProduct = async (product) => {
  try {
    await ElMessageBox.confirm('确定要删除这个商品吗？删除后无法恢复。', '提示', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    })

    await deleteProductApi(product.id)
    ElMessage.success('商品删除成功')
    fetchProducts()
    
  } catch (error) {
    if (error !== 'cancel') {
      console.error('删除商品失败:', error)
      ElMessage.error('删除商品失败')
    }
  }
}

// 重置表单
const resetForm = () => {
  editingProduct.value = null
  Object.assign(productForm, {
    name: '',
    description: '',
    price: 0,
    originalPrice: null,
    stock: 0,
    image: '',
    brand: '',
    categoryId: null
  })
  productFormRef.value?.resetFields()
}

// 监听对话框关闭
const handleDialogClose = () => {
  resetForm()
}

// 初始化
onMounted(() => {
  fetchProducts()
})
</script>

<style scoped>
.admin-products {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.page-header h2 {
  margin: 0;
  color: #333;
  font-size: 1.5rem;
}

.header-actions {
  display: flex;
  gap: 12px;
}

.products-card {
  border: none;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);
}

.products-content {
  min-height: 400px;
}

.empty-state {
  text-align: center;
  padding: 60px 0;
}

.product-image {
  width: 60px;
  height: 60px;
  object-fit: cover;
  border-radius: 4px;
  border: 1px solid #eee;
}

.product-info {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.product-name {
  font-weight: 500;
  color: #333;
}

.product-desc {
  font-size: 0.8rem;
  color: #666;
  line-height: 1.4;
}

.price-info {
  display: flex;
  flex-direction: column;
  gap: 2px;
}

.current-price {
  font-weight: 600;
  color: #e74c3c;
}

.original-price {
  font-size: 0.8rem;
  color: #999;
  text-decoration: line-through;
}

.table-actions {
  display: flex;
  gap: 8px;
}

.pagination-container {
  display: flex;
  justify-content: center;
  margin-top: 20px;
}

.dialog-footer {
  display: flex;
  justify-content: flex-end;
  gap: 12px;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .page-header {
    flex-direction: column;
    align-items: flex-start;
    gap: 16px;
  }
  
  .header-actions {
    width: 100%;
    justify-content: flex-end;
  }
  
  .table-actions {
    flex-direction: column;
  }
}
</style> 