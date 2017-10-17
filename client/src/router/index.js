import Vue from 'vue'
import Router from 'vue-router'
import HelloWorld from '@/components/HelloWorld'

Vue.use(Router)

export default new Router({
  routes: [
    {
      path: '*',
      name: 'four0four',
      component: HelloWorld
    },
    {
      path: '/',
      name: 'Hello',
      component: HelloWorld
    }
  ]
})
