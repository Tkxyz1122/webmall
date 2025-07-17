<script setup>
import { RouterLink, RouterView } from 'vue-router'
import HelloWorld from './components/HelloWorld.vue'
</script>

<template>
  <router-view></router-view>
</template>

<style>
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

html, body {
  width: 100%;
  height: 100%;
  margin: 0;
  padding: 0;
}

body {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen,
    Ubuntu, Cantarell, 'Open Sans', 'Helvetica Neue', sans-serif;
  background-color: #f5f7fa;
  color: #333;
  line-height: 1.6;
}

#app {
  min-height: 100vh;
  width: 100%;
}

.el-button {
  font-weight: 500;
}

.el-card {
  border: none;
  border-radius: 8px;
}

.el-card__header {
  border-bottom: 1px solid #eee;
  padding: 12px 20px;
}

.el-menu {
  border-right: none;
}

.el-menu-item.is-active {
  background-color: #ecf5ff;
}

/* 自定义滚动条样式 */
::-webkit-scrollbar {
  width: 8px;
  height: 8px;
}

::-webkit-scrollbar-track {
  background: #f1f1f1;
  border-radius: 4px;
}

::-webkit-scrollbar-thumb {
  background: #ccc;
  border-radius: 4px;
}

::-webkit-scrollbar-thumb:hover {
  background: #999;
}
</style>
