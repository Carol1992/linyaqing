<template>
  <div class="container">
    <div class="introduction">
      <h1>Sharing Life</h1>
      <h3>图片分享，免费下载，好友互赞，记录生活点点滴滴。</h3>
    </div>
    <div class="bottom">
      <div class="choices">
        <span :class='{activated: isActivated1}' @click='getPhotos'>{{keywordData.basic_info.photos}} 张照片</span>
        <span :class='{activated: isActivated2}' @click='getCollections'>{{keywordData.basic_info.collections}} 本相册</span>
        <span :class='{activated: isActivated3}' @click='getUsers'>{{keywordData.basic_info.users}} 个用户</span>
      </div>
      <div class="photos">
        <Photos :photos="photos" v-if='isActivated1' 
        @showCovers='showCovers2' @photoLike='photoLike' 
        @addToCollection='addToCollection'></Photos>
        <Collections :collections='collections' v-if='isActivated2' @showCovers='showCovers'></Collections>
        <div class="users" v-if='isActivated3'>
          <div class="user" v-for='user in users'>
            <div class="content" @click='gotoUserCenter(user)'>
              <div class="user-left">
                <div class="left-top">
                  <img v-lazy='user.avatar' alt="">
                </div>
              </div>
              <div class="user-right">
                <div class="name-underline">{{user.user_name}}</div>
                <div class="user-details">
                  <div class="photoNums">
                    <span><Icon type="images"></Icon></span>
                    <span>{{user.image_nums}}</span>
                  </div>
                  <div class="collectionNums">
                    <span><Icon type="ios-albums"></Icon></span>
                    <span>{{user.collection_nums}}</span>
                  </div>
                  <div class="likesNums">
                    <span><Icon type="android-favorite"></Icon></span>
                    <span>{{user.likes}}</span>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div class="noData" v-if='noData'>
        <span>{{noDataMsg}}</span>
      </div>
      <add-to-collection v-if='showDialog' @addTo='addTo' @closeCollection='closeCollection'></add-to-collection>
    </div>
    <BackTop></BackTop>
  </div>
</template>

<script>
  import photoOp from '../../api/photos'
  import Photos from './photos/Photos'
  import Collections from './photos/Collections'
  import addToCollection from './photos/addToCollection'
  export default {
    name: 'SearchHome',
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
        pageSize: 20000,
        collections: [],
        noData: false,
        noDataMsg: '没有该关键字的相关照片:)',
        isMe: false,
        showDialog: false,
        addToImgId: '',
        users: []
      }
    },
    components: {
      Photos,
      Collections,
      addToCollection
    },
    methods: {
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
      gotoUserCenter (user) {
        this.$router.push({path: `/userCenter/${user.user_id}`})
      },
      getPhotos () {
        this.isActivated1 = true
        this.isActivated2 = false
        this.isActivated3 = false
      },
      getCollections () {
        this.isActivated1 = false
        this.isActivated2 = true
        this.isActivated3 = false
        if (this.collections.length === 0) {
          this.noData = true
          this.noDataMsg = '没有该关键字相关的相册:)'
        } else {
          this.noData = false
        }
      },
      getUsers () {
        this.isActivated1 = false
        this.isActivated2 = false
        this.isActivated3 = true
        if (this.users.length === 0) {
          this.noData = true
          this.noDataMsg = '没有该关键字相关的用户:)'
        } else {
          this.noData = false
        }
      },
      showCovers (c) {
        c.showCover = !c.showCover
      },
      showCovers2 (c) {
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
      }
    },
    computed: {
      info () {
        return this.$store.state.userInfo
      },
      login () {
        return this.$store.state.alreadyLogin
      },
      keywordData () {
        this.photos.group_a = []
        this.photos.group_b = []
        this.photos.group_c = []
        this.collections = []
        this.users = []
        let data = this.$store.state.keywordData
        this.collections = data.lists.collections
        this.users = data.lists.users
        let lists = data.lists.photos
        for (let i = 0; i < lists.length; i++) {
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
          this.noData = true
          this.noDataMsg = '没有该关键字相关的照片哦:)'
        } else {
          this.noData = false
        }
        return data
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
      this.$store.dispatch('searchKeyword', {keyword: this.$route.params[0]})
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
  .left-top img {
    width: 90px;
    height: 90px;
    border-radius: 50%;
    overflow: hidden;
    vertical-align: text-top;
  }
  .users {
    width: 94%;
    margin: auto;
  }
  .user{
    width: 25%;
    display: inline-block;
    padding: 30px 2%;
    height: 200px;
  }
  .content {
    border: 1px solid #999;
    border-radius: 5px;
    height: 100%;
    padding: 25px 2%;
    cursor: pointer;
  }
  .content:hover {
    border-color: #111;
  }
  .user-left {
    display: inline-block;
    margin-right: 5%;
  }
  .user-right {
    display: inline-block;
    height: 100%;
    width: calc(93% - 90px);
    text-align: center;
  }
  .name-underline {
    font-size: 18px;
    font-weight: bold;
    text-decoration: underline;
    color: #626262;
  }
  .name-underline:hover {
    color: #111;
  }
  .user-details {
    margin-top: 20px;
  }
  .user-details > div {
    display: inline-block;
    float: left;
    width: 33.3%;
    text-align: center;
  }
  .user-details span {
    font-size: 25px;
    display: block;
  }
  .user-details span:nth-child(2) {
    font-size: 12px;
    font-weight: bold;
  }
  .likesNums span:nth-child(1) {
    color: #f15151;
  }
  .photoNums span:nth-child(1) {
    color: #00CC99;
  }
  .collectionNums span:nth-child(1) {
    color: #3399FF;
  }
  @media screen and (max-width: 809px) {
    .choices > span {
      font-size: 18px;
    }
    .user {
      width: 100%
    }
  }
  @media screen and (max-width: 1480px) and (min-width: 810px) {
    .user {
      width: 50%
    }
  }
</style>