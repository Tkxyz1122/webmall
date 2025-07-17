import { createRouter, createWebHistory } from 'vue-router'
import { isUserLoggedIn, isAdminLoggedIn } from '@/utils/auth'
import MainLayout from '../components/layout/MainLayout.vue'
import Home from '../views/Home.vue'

const routes = [
  {
    path: '/login',
    name: 'Login',
    component: () => import('../views/Login.vue')
  },
  {
    path: '/register',
    name: 'Register', 
    component: () => import('../views/Register.vue')
  },
  {
    path: '/admin/login',
    name: 'AdminLogin',
    component: () => import('../views/AdminLogin.vue')
  },
  {
    path: '/',
    component: MainLayout,
    children: [
      {
        path: '',
        name: 'Home',
        component: Home
      },
      {
        path: 'products',
        name: 'Products',
        component: () => import('../views/Products.vue')
      },
      {
        path: 'categories',
        name: 'Categories',
        component: () => import('../views/Categories.vue')
      },
      {
        path: 'cart',
        name: 'Cart',
        component: () => import('../views/Cart.vue'),
        meta: { requiresAuth: true }
      },
      {
        path: 'user',
        name: 'User',
        component: () => import('../views/User.vue'),
        meta: { requiresAuth: true }
      },
      {
        path: 'product/:id',
        name: 'ProductDetail',
        component: () => import('../views/ProductDetail.vue')
      },
      {
        path: 'orders',
        name: 'OrderList',
        component: () => import('../views/OrderList.vue'),
        meta: { requiresAuth: true }
      },
      {
        path: 'order/:id',
        name: 'OrderDetail',
        component: () => import('../views/OrderDetail.vue'),
        meta: { requiresAuth: true }
      },
      {
        path: 'payment/:orderId',
        name: 'Payment',
        component: () => import('../views/Payment.vue'),
        meta: { requiresAuth: true }
      }
    ]
  },
  {
    path: '/admin',
    component: () => import('../components/layout/AdminLayout.vue'),
    meta: { requiresAdmin: true },
    children: [
      {
        path: '',
        redirect: '/admin/dashboard'
      },
      {
        path: 'dashboard',
        name: 'AdminDashboard',
        component: () => import('../views/AdminDashboard.vue'),
        meta: { requiresAdmin: true }
      },
      {
        path: 'orders',
        name: 'AdminOrders',
        component: () => import('../views/AdminOrders.vue'),
        meta: { requiresAdmin: true }
      },
      {
        path: 'products',
        name: 'AdminProducts',
        component: () => import('../views/AdminProducts.vue'),
        meta: { requiresAdmin: true }
      }
    ]
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

// 全局路由守卫
router.beforeEach((to, from, next) => {
  console.log('路由守卫检查:', to.path, '需要认证:', to.meta.requiresAuth) // 添加调试信息
  
  // 检查是否需要用户登录
  if (to.meta.requiresAuth) {
    const isLoggedIn = isUserLoggedIn()
    console.log('用户登录状态:', isLoggedIn) // 添加调试信息
    if (!isLoggedIn) {
      console.log('未登录，重定向到登录页') // 添加调试信息
      // 未登录，重定向到登录页
      next({
        path: '/login',
        query: { redirect: to.fullPath }
      })
      return
    }
  }
  
  // 检查是否需要管理员权限
  if (to.meta.requiresAdmin) {
    if (!isAdminLoggedIn()) {
      // 未登录管理员，重定向到管理员登录页
      next({
        path: '/admin/login',
        query: { redirect: to.fullPath }
      })
      return
    }
  }
  
  // 如果已登录用户访问登录页，重定向到首页
  if (to.path === '/login') {
    if (isUserLoggedIn()) {
      next('/')
      return
    }
  }
  
  // 如果已登录管理员访问管理员登录页，重定向到管理后台
  if (to.path === '/admin/login') {
    if (isAdminLoggedIn()) {
      next('/admin/dashboard')
      return
    }
  }
  
  next()
})

export default router
