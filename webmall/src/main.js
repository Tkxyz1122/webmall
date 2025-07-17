import './assets/main.css'
import { createApp } from 'vue'
import { createStore } from 'vuex'
import ElementPlus from 'element-plus'
import 'element-plus/dist/index.css'
import * as ElementPlusIconsVue from '@element-plus/icons-vue'
import App from './App.vue'
import router from './router'

// 创建 Vuex store
const store = createStore({
  state() {
    return {
      cart: [],
      user: null,
      isLoggedIn: false
    }
  },
  mutations: {
    addToCart(state, product) {
      const existingItem = state.cart.find(item => item.id === product.id)
      if (existingItem) {
        existingItem.quantity++
      } else {
        state.cart.push({
          ...product,
          quantity: 1
        })
      }
    },
    removeFromCart(state, productId) {
      const index = state.cart.findIndex(item => item.id === productId)
      if (index > -1) {
        state.cart.splice(index, 1)
      }
    },
    updateCartItemQuantity(state, { productId, quantity }) {
      const item = state.cart.find(item => item.id === productId)
      if (item) {
        if (quantity <= 0) {
          const index = state.cart.findIndex(item => item.id === productId)
          state.cart.splice(index, 1)
        } else {
          item.quantity = quantity
        }
      }
    },
    clearCart(state) {
      state.cart = []
    },
    setUser(state, user) {
      state.user = user
      state.isLoggedIn = !!user
      // 保存到localStorage
      if (user) {
        localStorage.setItem('user', JSON.stringify(user))
        localStorage.setItem('isLoggedIn', 'true')
        // 确保token也被保存
        if (user.token) {
          localStorage.setItem('token', user.token)
        }
      } else {
        localStorage.removeItem('user')
        localStorage.removeItem('isLoggedIn')
        localStorage.removeItem('token')
      }
    },
    logout(state) {
      state.user = null
      state.isLoggedIn = false
      state.cart = []
      localStorage.removeItem('user')
      localStorage.removeItem('isLoggedIn')
      localStorage.removeItem('token')
    },
    // 从localStorage恢复状态
    restoreState(state) {
      const savedUser = localStorage.getItem('user')
      const savedLoginStatus = localStorage.getItem('isLoggedIn')
      if (savedUser && savedLoginStatus === 'true') {
        state.user = JSON.parse(savedUser)
        state.isLoggedIn = true
      }
    }
  },
  getters: {
    cartTotal: state => {
      return state.cart.reduce((total, item) => total + (item.price * item.quantity), 0)
    },
    cartItemCount: state => {
      return state.cart.reduce((total, item) => total + item.quantity, 0)
    },
    isLoggedIn: state => state.isLoggedIn,
    currentUser: state => state.user
  }
})

const app = createApp(App)

// 注册所有 Element Plus 图标
for (const [key, component] of Object.entries(ElementPlusIconsVue)) {
  app.component(key, component)
}

app.use(router)
app.use(store)
app.use(ElementPlus)

// 恢复登录状态
store.commit('restoreState')

app.mount('#app')
