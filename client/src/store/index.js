import Vue from 'vue'
import Vuex from 'vuex'
import userOp from '../../api/user'
import photoOp from '../../api/photos'

Vue.use(Vuex)

const store = new Vuex.Store({
  state: {
    emailSettings: '',
    userInfo: {},
    alreadyLogin: false,
    photoInfo: {},
    photoUrl: '',
    headerInfo: {
      isStore: false,
      isCollections: false
    },
    showAddToCollection: false,
    userCollections: []
  },
  mutations: {
    UpdateEmailSettings (state, settings) {
      state.emailSettings = settings
    },
    updateUserInfo (state, info) {
      state.userInfo = info
    },
    isLogin (state, flag) {
      state.alreadyLogin = flag
    },
    getPhotoInfo (state, info) {
      state.photoInfo = info
    },
    getPhotoUrl (state, url) {
      state.photoUrl = url
    },
    getHeaderInfo (state, flag) {
      state.headerInfo.isStore = flag.isStore
      state.headerInfo.isCollections = flag.isCollections
    },
    updateShowAddToCollection (state, flag) {
      state.showAddToCollection = flag
    },
    updateUserCollections (state, collections) {
      state.userCollections = collections
    }
  },
  actions: {
    getUserInfo ({ commit }) {
      userOp.getUserInfo((res) => {
        let info = res.data.data
        if (info.image_md5 === 'null' || !info.image_md5) {
          info.image_md5 = require('@/assets/img/user_default.jpg')
        }
        commit('UpdateEmailSettings', info.email_settings)
        commit('updateUserInfo', info)
      })
    },
    getUserCollections ({commit, state}) {
      let data = {
        user_id: state.userInfo.user_id,
        request_user_id: state.userInfo.user_id,
        pageNo: 1,
        pageSize: 18000
      }
      photoOp.getCollection.user(data, (res) => {
        let collections = res.data.data.lists
        commit('updateUserCollections', collections)
      })
    }
  },
  getters: {}
})

export default store
