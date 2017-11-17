import Vue from 'vue'
import Vuex from 'vuex'
import userOp from '../../api/user'
import photoOp from '../../api/photos'

Vue.use(Vuex)

const store = new Vuex.Store({
  state: {
    urlBase: 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/users/',
    viewBase: '?x-oss-process=image/auto-orient,1',
    emailSettings: '',
    followers: [],
    followings: [],
    userInfo: {},
    alreadyLogin: false,
    photoInfo: {},
    photoUrl: '',
    headerInfo: {
      isStore: false,
      isCollections: false
    },
    showAddToCollection: false,
    userCollections: [],
    ownerInfo: {
      user_name: '',
      image_md5: ''
    },
    likeThePhoto: false
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
    },
    updateFollowings (state, info) {
      state.followings = info
    },
    updateFollowers (state, info) {
      state.followers = info
    },
    updateOwnerInfo (state, info) {
      state.ownerInfo.user_name = info.user_name
      state.ownerInfo.image_md5 = info.image_md5
    },
    updatePhotoLike (state) {
      state.likeThePhoto = !state.likeThePhoto
    }
  },
  actions: {
    getUserInfo ({ commit, state }) {
      return new Promise((resolve, reject) => {
        userOp.getUserInfo({}, (res) => {
          let info = res.data.data
          info.saveName = info.image_md5
          if (info.image_md5 === 'null' || !info.image_md5) {
            info.image_md5 = require('@/assets/img/user_default.jpg')
            info.defaultImg = true
          } else {
            info.image_md5 = state.urlBase + info.image_md5 + state.viewBase
            info.defaultImg = false
          }
          commit('UpdateEmailSettings', info.email_settings)
          commit('updateFollowings', info.followings)
          commit('updateFollowers', info.followers)
          commit('updateUserInfo', info)
          resolve()
        })
      })
    },
    getUserCollections ({commit, state}) {
      let data = {
        token: localStorage.token,
        request_user_id: state.userInfo.user_id,
        pageNo: 1,
        pageSize: 18000
      }
      photoOp.getCollection.user(data, (res) => {
        let collections = res.data.data.lists
        commit('updateUserCollections', collections)
      })
    },
    getOwnerInfo ({commit, state}, ownerId) {
      let data = {
        user_id: ownerId
      }
      userOp.getUserInfo(data, (res) => {
        let info = res.data.data[0]
        if (info.image_md5 === 'null' || !info.image_md5) {
          info.image_md5 = require('@/assets/img/user_default.jpg')
        } else {
          info.image_md5 = state.urlBase + info.image_md5 + state.viewBase
        }
        commit('updateOwnerInfo', info)
      })
    }
    // photoLike ({commit, state}, data) {
    //   let data = {
    //     image_id: data.image_id,
    //     like: this.like ? '1' : '0'
    //   }
    //   photoOp.photoLike(data, (res) => {
    //     console.log(res)
    //   })
    // }
  },
  getters: {}
})

export default store
