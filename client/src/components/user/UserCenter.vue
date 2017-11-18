<template>
  <div class="container">
    <div class="top">
      <div class="user">
        <div class="avatar">
          <img :src='ownerInfo.image_md5' alt="">
        </div>
        <div class="name">
          <span>{{ownerInfo.user_name}}</span>
          <span class="more" @click='gotoProfile' v-if='isMe'><span>账户设置</span></span>
        </div>
      </div>
    </div>
    <div class="bottom">
      <div class="choices">
        <span :class='{activated: isActivated1}' @click='getListUser'>{{summary.photos}} 张照片</span>
        <span :class='{activated: isActivated2}' @click='getListLiked'>{{summary.liked}} 张赞过的照片</span>
        <span :class='{activated: isActivated3}' @click='getCollectionUser'>{{summary.collections}} 本相册</span>
      </div>
      <div class="photos">
        <Photos :photos="photos" v-if='!isActivated3' 
        @showCovers='showCovers2' @photoLike='photoLike' 
        @addToCollection='addToCollection'></Photos>
        <Collections :collections='collections' v-if='isActivated3' @showCovers='showCovers'></Collections>
      </div>
      <div class="noData" v-if='noData'>
        <span>{{noDataMsg}}</span>
      </div>
    </div>
    <BackTop></BackTop>
  </div>
</template>

<script>
  import photoOp from '../../../api/photos'
  import Photos from '../photos/Photos'
  import Collections from '../photos/Collections'
  import addToCollection from '../photos/addToCollection'
  export default {
    name: 'userCenter',
    data () {
      return {
        summary: {
          photos: 0,
          liked: 0,
          collections: 0
        },
        isActivated1: true,
        isActivated2: false,
        isActivated3: false,
        photos: {
          group_a: [],
          group_b: [],
          group_c: []
        },
        currentPage1: 1,
        currentPage2: 1,
        currentPage3: 1,
        pageSize: 18000,
        collections: [],
        noData: false,
        noDataMsg: '您还没有上传过照片:)',
        isMe: false,
        showDialog: false,
        addToImgId: ''
      }
    },
    components: {
      Photos,
      Collections,
      addToCollection
    },
    methods: {
      clearData () {
        this.photos.group_a = []
        this.photos.group_b = []
        this.photos.group_c = []
      },
      gotoProfile () {
        this.$router.push({path: `/userProfile/${this.info.user_name}`})
      },
      getListUser () {
        this.isActivated1 = true
        this.isActivated2 = false
        this.isActivated3 = false
        this.clearData()
        this.getList_user()
      },
      getListLiked () {
        this.isActivated1 = false
        this.isActivated2 = true
        this.isActivated3 = false
        this.clearData()
        this.getList_liked()
      },
      getCollectionUser () {
        this.isActivated1 = false
        this.isActivated2 = false
        this.isActivated3 = true
        this.collections = []
        this.getCollection_user()
      },
      getList_user () {
        let data = {
          token: localStorage.token,
          request_user_id: this.$route.params[0],
          pageNo: this.currentPage1,
          pageSize: this.pageSize
        }
        photoOp.getList.user(data, (res) => {
          this.summary.photos = res.data.data.totalCount
          let lists = res.data.data.lists
          if (lists.length === 0) {
            this.noData = true
            this.noDataMsg = '您还没有上传过照片哦:)'
            return
          }
          this.noData = false
          for (let i = 0; i < lists.length; i++) {
            lists[i].showCover = false
            lists[i].aliyun_name = lists[i].image_md5
            lists[i].image_md5 = this.$store.state.urlBase + lists[i].image_md5 + this.$store.state.viewBase
            if (lists[i].avatar === 'null' || !lists[i].avatar) {
              lists[i].avatar = require('@/assets/img/user_default.jpg')
            } else {
              lists[i].avatar = this.$store.state.urlBase + lists[i].avatar + this.$store.state.viewBase
            }
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
        })
      },
      getList_liked () {
        let data = {
          token: localStorage.token,
          request_user_id: this.$route.params[0],
          pageNo: this.currentPage2,
          pageSize: this.pageSize
        }
        photoOp.getList.liked(data, (res) => {
          this.summary.liked = res.data.data.totalCount
          let lists = res.data.data.lists
          if (lists.length === 0) {
            this.noData = true
            this.noDataMsg = '您还没有赞过任何一张照片:)'
            return
          }
          this.noData = false
          for (let i = 0; i < lists.length; i++) {
            lists[i].showCover = false
            lists[i].aliyun_name = lists[i].image_md5
            lists[i].image_md5 = this.$store.state.urlBase + lists[i].image_md5 + this.$store.state.viewBase
            if (lists[i].avatar === 'null' || !lists[i].avatar) {
              lists[i].avatar = require('@/assets/img/user_default.jpg')
            } else {
              lists[i].avatar = this.$store.state.urlBase + lists[i].avatar + this.$store.state.viewBase
            }
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
        })
      },
      getCollection_user () {
        let data = {
          token: localStorage.token,
          request_user_id: this.$route.params[0],
          pageNo: this.currentPage3,
          pageSize: this.pageSize
        }
        photoOp.getCollection.user(data, (res) => {
          this.summary.collections = res.data.data.totalCount
          let lists = res.data.data.lists
          if (lists.length === 0) {
            this.noData = true
            this.noDataMsg = '您还没有新建过相册:)'
            return
          }
          this.noData = false
          for (let l of lists) {
            let newArr = []
            for (let image of l.images_list) {
              image = this.$store.state.urlBase + image + this.$store.state.viewBase
              newArr.push(image)
            }
            l.showCover = false
            l.images_list = newArr
            this.collections.push(l)
          }
        })
      },
      showCovers (c) {
        c.showCover = !c.showCover
      },
      showCovers2 (c) {
        if (!c.showCover) {
          this.$store.dispatch('likedPhoto', {image_id: c.image_id}).then(() => {
            c.showCover = !c.showCover
          })
        } else {
          c.showCover = !c.showCover
        }
      },
      photoLike (photo) {
        let data = {
          image_id: photo.image_id,
          like: this.alreadyLiked ? '0' : '1'
        }
        photoOp.photoLike(data, (res) => {
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
        photoOp.addToCollection(data, (res) => {
          if (res.data.code === '0') {
            this.notifyMsg = '成功将图片加入相册！'
            this.success(true)
          } else {
            this.notifyMsg = '暂时无法将图片加入相册！'
            this.error(true)
          }
        })
      },
      getBasicData () {
        let data = {
          token: localStorage.token,
          request_user_id: this.$route.params[0],
          pageNo: this.currentPage2,
          pageSize: this.pageSize
        }
        photoOp.getList.liked(data, (res) => {
          this.summary.liked = res.data.data.totalCount
        })
        photoOp.getCollection.user(data, (res) => {
          this.summary.collections = res.data.data.totalCount
        })
      }
    },
    computed: {
      info () {
        return this.$store.state.userInfo
      },
      login () {
        return this.$store.state.alreadyLogin
      },
      ownerInfo () {
        return this.$store.state.ownerInfo
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
        this.$store.dispatch('getUserInfo').then(() => {
          if (this.info.user_id === +this.$route.params[0]) {
            this.isMe = true
          } else {
            this.isMe = false
          }
        })
      }
      this.getList_user()
      this.getBasicData()
      this.$store.dispatch('getOwnerInfo', this.$route.params[0])
    }
  }
</script>

<style scoped>
  .top {
   margin-top: 130px;
   text-align: center;
  }
  .avatar {
    width: 150px;
    height: 150px;
    border-radius: 50%;
    overflow: hidden;
    margin: auto;
  }
  .avatar img {
    width: 150px;
    height: 150px;
  }
  .name {
    font-size: 36px;
    margin-top: 15px;
    font-weight: bolder;
  }
  .more {
    font-size: 16px;
    position: absolute;
    margin-left: 20px;
    margin-top: 20px;
    display: inline-block;
    width: 100px;
    cursor: pointer;
    color: #979797;
    text-decoration: underline;
    font-style: italic;
  }
  .more:hover {
    color:#111;
  }
  .bottom {
    width: 100%;
    margin: auto;
    margin-top: 30px;
  }
  .choices > span {
    font-size: 20px;
    margin-right: 20px;
    font-weight: bolder;
    color: #999999;
    cursor: pointer;
  }
  .activated {
    color: #111 !important;
  }
  .choices {
    margin-left: 5%;
    margin-top: 40px;
    margin-bottom: 30px;
  }
  .noData {
    width: 100%;
    height: 200px;
    text-align: center;
  }
  .noData > span {
    line-height: 200px;
    font-size: 18px;
  }
  @media screen and (max-width: 809px) {
    .top {
      margin-top: 110px;
    }
    .avatar {
      width: 120px;
      height: 120px;
    }
    .avatar img {
      width: 120px;
      height: 120px;
    }
    .name {
      font-size: 30px;
    }
    .choices > span {
      font-size: 18px;
    }
    .more{
      margin-top: 15px;
    }
  }
</style>