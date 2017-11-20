<template>
   <div id="home">
    <div class="introduction">
      <h1>Sharing Life</h1>
      <h3>图片分享，免费下载，好友互赞，记录生活点点滴滴。</h3>
    </div>
    <div class="navigate">
      <span class="nav" :class="{activated: isActivated}" @click='getHot'>最热</span>
      <span class="nav" :class="{activated: isActivated2}" @click='getNew'>最新</span>
      <span class="nav" v-if='login' :class="{activated: isActivated3}" @click='getFollowing'>关注</span>
    </div>
    <Photos :photos="photos" @showCovers='showCovers' @photoLike='photoLike' 
    @addToCollection='addToCollection'></Photos>
    <div class="noFollowing" v-if='noFollowing'>
      <span>目前没有关注任何人哦:）</span>
    </div>
    <add-to-collection v-if='showDialog' @addTo='addTo' @closeCollection='closeCollection'></add-to-collection>
    <BackTop></BackTop>
  </div>
</template>

<script>
import photosOp from '../../api/photos'
import Photos from './photos/Photos'
import addToCollection from './photos/addToCollection'
import $ from 'jquery'
export default {
  name: 'home',
  components: {
    Photos,
    addToCollection
  },
  data () {
    return {
      isActivated: true,
      isActivated2: false,
      isActivated3: false,
      currentPage1: 1,
      currentPage2: 1,
      currentPage3: 1,
      pageSize: 20000,
      photos: {
        group_a: [],
        group_b: [],
        group_c: []
      },
      noFollowing: false,
      showDialog: false,
      addToImgId: ''
    }
  },
  methods: {
    onScroll () {
      // let documentHeight = document.body.clientHeight
      // let pos = 0
      // if (document.body.clientWidth < 809) {
      //   pos = documentHeight * 0.5
      // } else {
      //   pos = documentHeight * 0.7
      // }
      if ($(window).scrollTop() + $(window).height() > $(document).height() - 100) {
        $(window).unbind('scroll')
        if (this.isActivated) {
          this.currentPage1 ++
          this.getList_hot().then(() => {
            $(window).bind('scroll', this.onScroll)
            // setTimeout(() => {
            //   $(window).bind('scroll', this.onScroll)
            // }, 2000)
          })
        }
        if (this.isActivated2) {
          this.currentPage2 ++
          this.getList_new().then(() => {
            $(window).bind('scroll', this.onScroll)
          })
        }
        if (this.isActivated3) {
          this.currentPage3 ++
          this.getList_following().then(() => {
            $(window).bind('scroll', this.onScroll)
          })
        }
      }
      // if (window.scrollY > pos) {
      //   if (this.isActivated) {
      //     this.currentPage1 ++
      //     this.getList_hot()
      //   }
      //   if (this.isActivated2) {
      //     this.currentPage2 ++
      //     this.getList_new()
      //   }
      //   if (this.isActivated3) {
      //     this.currentPage3 ++
      //     this.getList_following()
      //   }
      // }
    },
    showCovers (c) {
      if (!c.showCover) {
        if (this.login) {
          this.$store.dispatch('likedPhoto', {image_id: c.image_id}).then(() => {
            c.showCover = !c.showCover
          })
        } else {
          c.showCover = !c.showCover
        }
      } else {
        c.showCover = !c.showCover
      }
    },
    photoLike (photo) {
      let data = {
        image_id: photo.image_id,
        like: this.alreadyLiked ? '0' : '1'
      }
      if (!this.login) return
      photosOp.photoLike(data, (res) => {
        if (res.data.code === '1') return
        this.$store.dispatch('likedPhoto', {image_id: data.image_id}).then((res) => {
          photo.total_likes = res.data.data.total_likes
        })
      })
    },
    closeCollection () {
      this.showDialog = false
    },
    addToCollection (photo) {
      this.showDialog = true
      this.addToImgId = photo.image_id
    },
    addTo (collectionId) {
      this.showDialog = false
      let data = {
        image_id: this.addToImgId,
        collection_id: collectionId
      }
      photosOp.addToCollection(data, (res) => {
        if (res.data.code === '0') {
          this.notifyMsg = '成功将图片加入相册！'
          this.success(true)
        } else {
          this.notifyMsg = '暂时无法将图片加入相册！'
          this.error(true)
        }
      })
    },
    success (nodesc) {
      this.$Notice.success({
        title: this.notifyMsg,
        desc: nodesc ? '' : ''
      })
    },
    error (nodesc) {
      this.$Notice.error({
        title: this.notifyMsg,
        desc: nodesc ? '' : ''
      })
    },
    getHot () {
      this.isActivated = true
      this.isActivated2 = false
      this.isActivated3 = false
      this.currentPage1 = 1
      this.clearData()
      this.getList_hot()
    },
    getNew () {
      this.isActivated = false
      this.isActivated2 = true
      this.isActivated3 = false
      this.currentPage2 = 1
      this.clearData()
      this.getList_new()
    },
    getFollowing () {
      this.isActivated = false
      this.isActivated2 = false
      this.isActivated3 = true
      this.currentPage3 = 1
      this.clearData()
      this.getList_following()
    },
    clearData () {
      this.photos.group_a = []
      this.photos.group_b = []
      this.photos.group_c = []
    },
    getList_hot () {
      let data = {
        pageNo: this.currentPage1,
        pageSize: this.pageSize
      }
      return new Promise((resolve, reject) => {
        photosOp.getList.hot(data, (res) => {
          if (res.data.code === '1') {
            this.notifyMsg = '获取最热图片列表失败！'
            this.error(true)
            return
          }
          let lists = res.data.data.lists
          this.noFollowing = false
          for (let i = 0; i < lists.length; i++) {
            lists[i].showCover = false
            if (lists[i].avatar === 'null' || !lists[i].avatar) {
              lists[i].avatar = require('@/assets/img/user_default.jpg')
            } else {
              lists[i].avatar = this.$store.state.urlBase + lists[i].avatar + this.$store.state.viewBase
            }
            lists[i].aliyun_name = lists[i].image_md5
            lists[i].image_md5 = this.$store.state.urlBase + lists[i].image_md5 + this.$store.state.viewBase
            if (i % 3 === 0) {
              this.photos.group_a.push(lists[i])
            }
            if ((i - 1) % 3 === 0) {
              this.photos.group_b.push(lists[i])
            }
            if ((i - 2) % 3 === 0) {
              this.photos.group_c.push(lists[i])
            }
          }
          resolve()
        })
      })
    },
    getList_new () {
      let data = {
        pageNo: this.currentPage2,
        pageSize: this.pageSize
      }
      return new Promise((resolve, reject) => {
        photosOp.getList.new(data, (res) => {
          if (res.data.code === '1') {
            this.notifyMsg = '获取最新图片列表失败！'
            this.error(true)
            return
          }
          let lists = res.data.data.lists
          this.noFollowing = false
          for (let i = 0; i < lists.length; i++) {
            lists[i].showCover = false
            if (lists[i].avatar === 'null' || !lists[i].avatar) {
              lists[i].avatar = require('@/assets/img/user_default.jpg')
            } else {
              lists[i].avatar = this.$store.state.urlBase + lists[i].avatar + this.$store.state.viewBase
            }
            lists[i].aliyun_name = lists[i].image_md5
            lists[i].image_md5 = this.$store.state.urlBase + lists[i].image_md5 + this.$store.state.viewBase
            if (i % 3 === 0) {
              this.photos.group_a.push(lists[i])
            }
            if ((i - 1) % 3 === 0) {
              this.photos.group_b.push(lists[i])
            }
            if ((i - 2) % 3 === 0) {
              this.photos.group_c.push(lists[i])
            }
          }
          resolve()
        })
      })
    },
    getList_following () {
      let data = {
        token: localStorage.token,
        pageNo: this.currentPage3,
        pageSize: this.pageSize
      }
      return new Promise((resolve, reject) => {
        photosOp.getList.following(data, (res) => {
          if (res.data.code === '1') {
            this.notifyMsg = '获取关注图片列表失败！'
            this.error(true)
            return
          }
          let lists = res.data.data.lists
          for (let i = 0; i < lists.length; i++) {
            lists[i].showCover = false
            if (lists[i].avatar === 'null' || !lists[i].avatar) {
              lists[i].avatar = require('@/assets/img/user_default.jpg')
            } else {
              lists[i].avatar = this.$store.state.urlBase + lists[i].avatar + this.$store.state.viewBase
            }
            lists[i].aliyun_name = lists[i].image_md5
            lists[i].image_md5 = this.$store.state.urlBase + lists[i].image_md5 + this.$store.state.viewBase
            if (i % 3 === 0) {
              this.photos.group_a.push(lists[i])
            }
            if ((i - 1) % 3 === 0) {
              this.photos.group_b.push(lists[i])
            }
            if ((i - 2) % 3 === 0) {
              this.photos.group_c.push(lists[i])
            }
          }
          if (this.photos.group_a.length === 0 && this.photos.group_b.length === 0 && this.photos.group_c.length === 0) {
            this.noFollowing = true
            return
          }
          this.noFollowing = false
          resolve()
        })
      })
    }
  },
  computed: {
    login () {
      return this.$store.state.alreadyLogin
    },
    alreadyLiked () {
      return this.$store.state.alreadyLiked
    }
  },
  mounted () {
    if (localStorage.token) {
      this.$store.commit('isLogin', true)
    } else {
      this.$store.commit('isLogin', false)
    }
    if (this.login) {
      this.$store.dispatch('getUserInfo')
    }
    this.getHot()
    // $(window).unbind('scroll')
    // window.addEventListener('scroll', this.onScroll)
    // $(window).scroll(this.onScroll)
  }
}
</script>

<style scoped>
.introduction {
  width: 90%;
  margin: auto;
  margin-top: 100px;
  margin-bottom: 70px;
}
.introduction h1 {
  font-size: 46px;
}
.introduction h3 {
  font-size: 18px;
}
.navigate {
  width: 90%;
  margin: auto;
  margin-bottom: 20px;
}
.nav {
  font-size: 20px;
  display: inline-block;
  width: 80px;
  color: #999;
  cursor: pointer;
  font-weight: bolder;
}
.activated {
  color: #111;
  cursor: auto;
}
.nav:hover {
  color: #111;
}
.noFollowing {
  width: 100%;
  height: 200px;
  text-align: center;
}
.noFollowing > span {
  line-height: 200px;
  font-size: 18px;
}
@media screen and (max-width: 809px) {
  .introduction h1 {
    font-size: 36px;
  }
  .introduction h3 {
    font-size: 14px;
  }
}
</style>
