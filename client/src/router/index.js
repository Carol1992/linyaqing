import Vue from 'vue'
import Router from 'vue-router'
import Home from '@/components/Home'
import Login from '@/components/user/Login'
import Register from '@/components/user/Register'
import NotFound from '@/components/NotFound'
import ServerError from '@/components/ServerError'
import UserCenter from '@/components/user/UserCenter'
import UserProfile from '@/components/user/UserProfile'

Vue.use(Router)

export default new Router({
  routes: [
    {
      path: '*',
      name: 'notFound',
      component: NotFound
    },
    {
      path: '/500',
      name: 'serverError',
      component: ServerError
    },
    {
      path: '/',
      name: 'home',
      component: Home
    },
    {
      path: '/login',
      name: 'login',
      component: Login
    },
    {
      path: '/register',
      name: 'register',
      component: Register
    },
    {
      path: '/userCenter/*',
      name: 'userCenter',
      component: UserCenter
    },
    {
      path: '/userProfile/*',
      name: 'userProfile',
      component: UserProfile
    }
  ]
})
