import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)

const store = new Vuex.Store({
  state: {
    apiUrl: 'http://localhost:3000',
    showHeader: true,
    email_setting_checkbox: '',
    isLogin: false
  },
  mutations: {
    set_showHeader (state, flag) {
      state.showHeader = flag
    },
    get_email_setting (state, settings) {
      state.email_setting_checkbox = settings
    },
    isLogin (state, flag) {
      state.isLogin = flag
    }
  }
})

export default store
