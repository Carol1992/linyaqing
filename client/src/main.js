// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
import Vue from 'vue'
import App from './App'
import router from './router'
import axios from 'axios'
import VueAxios from 'vue-axios'
import iView from 'iview'
import '../my-theme/index.less'
import store from './store/index.js'

Vue.config.debug = true // debug
Vue.use(VueAxios, axios)
Vue.use(iView)

Vue.config.productionTip = false

// 引入mockjs
require('./mock.js')
const faker = require('faker')
faker.locale = 'zh_CN'

router.beforeEach((to, from, next) => {
  if (to.meta.requireAuth) {  // 判断该路由是否需要登录权限
    if (localStorage.token) {  // 通过vuex state获取当前的token是否存在
      next()
    } else {
      next({
        path: '/login',
        query: {redirect: to.fullPath}  // 将跳转的路由path作为参数，登录成功后跳转到该路由
      })
    }
  } else {
    next()
  }
})

// http response 拦截器
axios.interceptors.response.use(
  response => {
    return response
  },
  error => {
    if (error.response) {
      switch (error.response.status) {
        case 403:
          // 返回 403 清除token信息并跳转到登录页面
          localStorage.removeItem('token')
          router.replace({
            path: '/login',
            query: {redirect: router.currentRoute.fullPath}
          })
          break
        default:
          router.replace({
            path: '/500',
            query: {redirect: router.currentRoute.fullPath}
          })
      }
    }
    return Promise.reject(error)   // 返回接口返回的错误信息
  })

/* eslint-disable no-new */
new Vue({
  el: '#app',
  router,
  store,
  template: '<App/>',
  components: { App }
})
