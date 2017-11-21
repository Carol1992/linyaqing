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
    alreadyLiked: false,
    keywordData: {
      basic_info: {
        photos: 0,
        collections: 0,
        users: 0
      },
      lists: {
        photos: '',
        collections: '',
        users: ''
      }
    }
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
    updatePhotoLike (state, flag) {
      state.alreadyLiked = flag
    },
    updateKeywordData (state, info) {
      state.keywordData.basic_info.photos = info.basic_info.photos
      state.keywordData.basic_info.collections = info.basic_info.collections
      state.keywordData.basic_info.users = info.basic_info.users
      let photos = info.lists.photos
      let collections = info.lists.collections
      let users = info.lists.users
      for (let photo of photos) {
        photo.aliyun_name = photo.image_md5
        photo.image_md5 = state.urlBase + photo.image_md5 + state.viewBase
        photo.showCover = false
        if (photo.avatar === 'null' || !photo.avatar) {
          photo.avatar = require('@/assets/img/user_default.jpg')
        } else {
          photo.avatar = state.urlBase + photo.avatar + state.viewBase
        }
      }
      for (let collection of collections) {
        collection.showCover = false
        let newArr = []
        for (let image of collection.images_list) {
          image = state.urlBase + image + state.viewBase
          newArr.push(image)
        }
        collection.images_list = newArr
      }
      for (let user of users) {
        if (user.avatar === 'null' || !user.avatar) {
          user.avatar = require('@/assets/img/user_default.jpg')
        } else {
          user.avatar = state.urlBase + user.avatar + state.viewBase
        }
        user.showCover = false
      }
      state.keywordData.lists.photos = info.lists.photos
      state.keywordData.lists.collections = info.lists.collections
      state.keywordData.lists.users = info.lists.users
    }
  },
  actions: {
    getUserInfo ({ commit, state }) {
      return new Promise((resolve, reject) => {
        userOp.getUserInfo({token: localStorage.token}, (res) => {
          if (res.data.code === '1') {
            return
          }
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
        if (res.data.code === '1') {
          return
        }
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
    },
    likedPhoto ({commit, state}, info) {
      return new Promise((resolve, reject) => {
        photoOp.alreadyLike(info, (res) => {
          if (res.data.code === '1') {
            return
          }
          commit('updatePhotoLike', res.data.data.alreadyLike)
          resolve(res)
        })
      })
    },
    searchKeyword ({commit, state}, info) {
      return new Promise((resolve, reject) => {
        photoOp.search(info, (res) => {
          if (res.data.code === '1') {
            return
          }
          commit('updateKeywordData', res.data.data)
          resolve()
        })
      })
    }
  },
  getters: {}
})

export default store
