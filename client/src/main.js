// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
import Vue from 'vue'
import App from './App'
import router from './router'
import Vuex from 'vuex'
import axios from 'axios'
import iView from 'iview'
import '../my-theme/index.less'

Vue.config.debug = true // debug
Vue.use(axios)
Vue.use(Vuex)
Vue.use(iView)

Vue.config.productionTip = false

router.beforeEach((to, from, next) => {
  if (to.meta.requireAuth) {  // 判断该路由是否需要登录权限
    if (localStorage.token) {  // 通过vuex state获取当前的token是否存在
      next()
    } else {
      next({
        path: '/',
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
        case 401:
          // 返回 401 清除token信息并跳转到登录页面
          localStorage.removeItem('token')
          router.replace({
            path: '/',
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

const store = new Vuex.Store({
  state: {
    apiUrl: 'http://localhost:3000',
    isShowLogin: true,
    userInfo: null,
    permissions: null,
    notice: null,
    expired: false
  },
  mutations: {
    showLogin (state, flag) {
      state.isShowLogin = flag
    },
    updateUserInfo (state, data) {
      state.userInfo = data
    },
    updatePermission (state, data) {
      state.permissions = data
    },
    updateNotice (state, data) {
      state.notice = data
    }
  }
})
/* eslint-disable no-new */
new Vue({
  el: '#app',
  router,
  store,
  template: '<App/>',
  components: { App }
})
