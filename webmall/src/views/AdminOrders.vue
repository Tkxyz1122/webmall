<template>
  <div class="admin-orders">
    <!-- 页面头部 -->
    <div class="page-header">
      <h2>订单管理</h2>
      <div class="header-actions">
        <el-button type="primary" @click="refreshOrders">
          <el-icon><Refresh /></el-icon>
          刷新
        </el-button>
      </div>
    </div>

    <!-- 筛选和搜索 -->
    <el-card class="filter-card">
      <div class="filter-content">
        <div class="filter-item">
          <span class="filter-label">订单状态：</span>
          <el-select v-model="filterStatus" placeholder="全部状态" clearable @change="handleFilterChange">
            <el-option label="全部" value=""></el-option>
            <el-option label="待支付" value="待支付"></el-option>
            <el-option label="已支付" value="已支付"></el-option>
            <el-option label="已发货" value="已发货"></el-option>
            <el-option label="已完成" value="已完成"></el-option>
            <el-option label="已取消" value="已取消"></el-option>
          </el-select>
        </div>
      </div>
    </el-card>

    <!-- 订单列表 -->
    <el-card class="orders-card">
      <div v-loading="loading" class="orders-content">
        <div v-if="orders.length === 0 && !loading" class="empty-state">
          <el-empty description="暂无订单数据" />
        </div>

        <div v-else>
          <el-table :data="orders" style="width: 100%" stripe>
            <el-table-column prop="id" label="订单号" width="180">
              <template #default="{ row }">
                <span class="order-id">{{ row.id }}</span>
              </template>
            </el-table-column>
            
            <el-table-column prop="userName" label="用户" width="150">
              <template #default="{ row }">
                <div class="user-info">
                  <div class="username">{{ row.userName }}</div>
                  <div class="email">{{ row.userEmail }}</div>
                </div>
              </template>
            </el-table-column>
            
            <el-table-column prop="finalAmount" label="金额" width="120">
              <template #default="{ row }">
                <span class="amount">¥{{ row.finalAmount.toLocaleString() }}</span>
              </template>
            </el-table-column>
            
            <el-table-column prop="status" label="状态" width="120">
              <template #default="{ row }">
                <el-tag :type="getStatusType(row.status)" size="small">
                  {{ row.status }}
                </el-tag>
              </template>
            </el-table-column>
            
            <el-table-column prop="itemCount" label="商品数量" width="100" align="center">
              <template #default="{ row }">
                <span>{{ row.itemCount }}件</span>
              </template>
            </el-table-column>
            
            <el-table-column prop="createTime" label="下单时间" width="180">
              <template #default="{ row }">
                <span>{{ formatDate(row.createTime) }}</span>
              </template>
            </el-table-column>
            
            <el-table-column label="操作" width="200" fixed="right">
              <template #default="{ row }">
                <div class="table-actions">
                  <el-button 
                    size="small" 
                    @click="viewOrderDetail(row.id)"
                  >
                    查看详情
                  </el-button>
                  
                  <el-dropdown @command="(command) => handleOrderAction(command, row)">
                    <el-button size="small" type="primary">
                      操作
                      <el-icon class="el-icon--right"><arrow-down /></el-icon>
                    </el-button>
                    <template #dropdown>
                      <el-dropdown-menu>
                        <el-dropdown-item 
                          v-if="row.status === '已支付'" 
                          command="ship"
                        >
                          发货
                        </el-dropdown-item>
                        <el-dropdown-item 
                          v-if="row.status === '已发货'" 
                          command="complete"
                        >
                          标记完成
                        </el-dropdown-item>
                        <el-dropdown-item 
                          v-if="row.status === '待支付'" 
                          command="cancel"
                        >
                          取消订单
                        </el-dropdown-item>
                      </el-dropdown-menu>
                    </template>
                  </el-dropdown>
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
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Refresh, ArrowDown } from '@element-plus/icons-vue'
import { getAdminOrders, adminUpdateOrderStatus } from '@/api'

const router = useRouter()

// 响应式数据
const orders = ref([])
const loading = ref(false)
const filterStatus = ref('')
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
    
    if (filterStatus.value) {
      params.status = filterStatus.value
    }

    const response = await getAdminOrders(params)
    orders.value = response.data.orders
    total.value = response.data.total
  } catch (error) {
    console.error('获取订单列表失败:', error)
    ElMessage.error('获取订单列表失败')
  } finally {
    loading.value = false
  }
}

// 筛选变化处理
const handleFilterChange = () => {
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

// 刷新订单
const refreshOrders = () => {
  fetchOrders()
  ElMessage.success('订单列表已刷新')
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

// 处理订单操作
const handleOrderAction = async (command, order) => {
  try {
    let newStatus = ''
    let confirmMessage = ''
    
    switch (command) {
      case 'ship':
        newStatus = '已发货'
        confirmMessage = '确定要发货这个订单吗？'
        break
      case 'complete':
        newStatus = '已完成'
        confirmMessage = '确定要标记这个订单为已完成吗？'
        break
      case 'cancel':
        newStatus = '已取消'
        confirmMessage = '确定要取消这个订单吗？'
        break
    }
    
    if (newStatus) {
      await ElMessageBox.confirm(confirmMessage, '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      })

      await adminUpdateOrderStatus(order.id, newStatus)
      ElMessage.success('订单状态更新成功')
      fetchOrders()
    }
  } catch (error) {
    if (error !== 'cancel') {
      console.error('更新订单状态失败:', error)
      ElMessage.error('更新订单状态失败')
    }
  }
}

// 初始化
onMounted(() => {
  fetchOrders()
})
</script>

<style scoped>
.admin-orders {
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

.filter-card {
  border: none;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);
}

.filter-content {
  display: flex;
  gap: 20px;
  align-items: center;
}

.filter-item {
  display: flex;
  align-items: center;
  gap: 8px;
}

.filter-label {
  color: #666;
  font-weight: 500;
}

.orders-card {
  border: none;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);
}

.orders-content {
  min-height: 400px;
}

.empty-state {
  text-align: center;
  padding: 60px 0;
}

.order-id {
  font-family: monospace;
  font-weight: 600;
  color: #409eff;
}

.user-info {
  display: flex;
  flex-direction: column;
  gap: 2px;
}

.username {
  font-weight: 500;
  color: #333;
}

.email {
  font-size: 0.8rem;
  color: #666;
}

.amount {
  font-weight: 600;
  color: #e74c3c;
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

/* 响应式设计 */
@media (max-width: 768px) {
  .page-header {
    flex-direction: column;
    align-items: flex-start;
    gap: 16px;
  }
  
  .filter-content {
    flex-direction: column;
    align-items: flex-start;
  }
  
  .table-actions {
    flex-direction: column;
  }
}
</style> 