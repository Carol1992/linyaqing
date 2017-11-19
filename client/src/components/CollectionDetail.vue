<template>
  <div class="container">
    <div class="intro">
      <div class="collection_name">
        {{collectionInfo.collection_name}} <Icon type="locked" v-if='collectionInfo.isPrivate' class='private-lock'></Icon>
        <span class="edit" v-if='!notMe' @click='editCollection'><Icon type="edit"></Icon> 编辑</span>
      </div>
      <div class="collection_owner">
        <img :src='collectionInfo.owner_avatar' alt="" @click='gotoUserCenter'>
        <span class="name" @click='gotoUserCenter'>{{collectionInfo.collection_owner}}</span>
        <span class='follow' v-if='notMe && !followed && login' @click='followMe'><Icon type="person-add"></Icon> 关注</span>
        <span class='follow followed' v-if='notMe && followed && login' @click='notFollowMe'><Icon type="person"></Icon> 取消关注</span>
      </div>
    </div>
    <div class="photos">
      <div class="counts">{{totalCount}} 张照片</div>
      <Photos :photos="photos" @showCovers='showCovers' @photoLike='photoLike' 
    @addToCollection='addToCollection'></Photos>
    </div>
    <Edit v-if='showEdit' :collectionInfo='collectionInfo' @closeBox='closeBox' 
    @updateCollectionInfo='successModify' @deleteCollection='successDelete' @changePrivate='changePrivate'></Edit>
    <add-to-collection v-if='showDialog' @addTo='addTo' @closeCollection='closeCollection'></add-to-collection>
  </div>
</template>

<script>
  import photoOp from '../../api/photos'
  import Photos from './photos/Photos'
  import Edit from './photos/editCollection'
  import addToCollection from './photos/addToCollection'
  import $ from 'jquery'
  export default {
    name: 'CollectionDetail',
    data () {
      return {
        photos: {
          group_a: [],
          group_b: [],
          group_c: []
        },
        totalCount: '',
        currentPageNo: 1,
        currentPageSize: 20,
        notMe: false,
        followMsg: ' 关注',
        followed: false,
        showEdit: false,
        collectionInfo: {
          collection_id: '',
          collection_owner: '',
          owner_id: '',
          owner_avatar: '',
          owner_email: '',
          collection_name: '',
          isPrivate: false,
          collection_desc: ''
        },
        notifyMsg: '',
        showDialog: false,
        addToImgId: ''
      }
    },
    components: {
      Photos,
      Edit,
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
      changePrivate (c) {
        c.isPrivate = !c.isPrivate
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
      gotoUserCenter () {
        this.$router.push({path: `/userCenter/${this.collectionInfo.owner_id}`})
      },
      closeBox () {
        this.showEdit = false
      },
      successModify (data) {
        data.is_private = data.isPrivate ? 0 : 1
        photoOp.updateCollection(data, (res) => {
          if (res.data.code === '0') {
            this.showEdit = false
            this.notifyMsg = '相册信息更新成功！'
            this.success(true)
          } else {
            this.notifyMsg = '相册信息更新失败！'
            this.error(true)
          }
        })
      },
      successDelete (collectionInfo) {
        let data = {
          collection_id: collectionInfo.collection_id
        }
        photoOp.deleteCollection(data, (res) => {
          if (res.data.code === '1') {
            this.notifyMsg = '相册删除失败！'
            this.error(true)
            return
          }
          this.notifyMsg = '成功删除相册！'
          this.success(true)
          this.$router.push({path: `/userCenter/${this.info.user_id}`})
        })
      },
      followMe () {
        photoOp.updatePhotographers({followings: this.collectionInfo.owner_id.toString()}, (res) => {
          if (res.data.code === '1') {
            this.notifyMsg = '关注失败！'
            this.error(true)
            return
          }
          this.followed = true
          this.followMsg = '已关注'
        })
      },
      notFollowMe () {
        photoOp.updatePhotographers_rm({following_id: this.collectionInfo.owner_id}, (res) => {
          if (res.data.code === '1') {
            this.notifyMsg = '取消关注失败！'
            this.error(true)
            return
          }
          this.followed = false
        })
      },
      editCollection () {
        this.showEdit = true
      },
      getCollectionInfo () {
        let params = this.$route.params[0]
        this.collectionInfo.collection_id = params.split('/')[1]
        photoOp.getCollectionInfo({collection_id: params.split('/')[1]}, (res) => {
          let results = res.data.data
          this.collectionInfo.collection_owner = results.user_name
          this.collectionInfo.collection_name = results.collection_name
          this.collectionInfo.owner_id = results.user_id
          this.collectionInfo.isPrivate = results.is_private === '0'
          this.collectionInfo.collection_desc = results.collection_desc
          if (!results.avatar) {
            this.collectionInfo.owner_avatar = require('@/assets/img/user_default.jpg')
          } else {
            this.collectionInfo.owner_avatar = this.$store.state.urlBase + results.avatar +
            this.$store.state.viewBase
          }
          if (this.collectionInfo.owner_id === this.info.user_id) {
            this.notMe = false
          } else {
            this.notMe = true
          }
          for (let f of this.followings) {
            if (f === this.collectionInfo.owner_id.toString()) {
              this.followed = true
              this.followMsg = '已关注'
            }
          }
        })
      },
      getPhotos () {
        let params = this.$route.params[0]
        this.collectionInfo.collection_id = params.split('/')[1]
        let data = {
          user_id: params.split('/')[0],
          collection_id: params.split('/')[1],
          pageNo: this.currentPageNo,
          pageSize: this.currentPageSize
        }
        return new Promise((resolve, reject) => {
          photoOp.getCollection.one(data, (res) => {
            this.totalCount = res.data.data.totalCount
            let lists = res.data.data.lists
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
            resolve()
          })
        })
      },
      onScroll () {
        if ($(window).scrollTop() + $(window).height() > $(document).height() - 100) {
          $(window).unbind('scroll')
          this.currentPageNo ++
          this.getPhotos().then(() => {
            $(window).bind('scroll', this.onScroll)
          })
        }
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
      this.photos.group_a = []
      this.photos.group_b = []
      this.photos.group_c = []
      this.getCollectionInfo()
      $(window).unbind('scroll')
      this.getPhotos().then(() => {
        $(window).scroll(this.onScroll)
      })
      // this.$nextTick(function () {
      // // window.addEventListener('scroll', this.onScroll)
      //   $(window).scroll(this.onScroll)
      // })
    },
    computed: {
      info () {
        return this.$store.state.userInfo
      },
      login () {
        return this.$store.state.alreadyLogin
      },
      followings () {
        return this.$store.state.followings.split(',')
      },
      alreadyLiked () {
        return this.$store.state.alreadyLiked
      }
    }
  }
</script>

<style scoped>
  .intro {
    width: 100%;
    margin-top: 100px;
    margin-bottom: 70px;
  }
  .photos {
    width: 100%;
  }
  .counts {
    font-size: 18px;
    font-weight: 600;
    width: 90%;
    margin: auto;
    margin-bottom: 20px;
  }
  .collection_name {
    width: 90%;
    margin: auto;
    font-size: 36px;
    font-weight: 800;
  }
  .collection_owner {
    width: 90%;
    margin: auto;
    font-size: 20px;
    margin-top: 30px;
  }
  .collection_owner img {
    width: 40px;
    height: 40px;
    border-radius: 50%;
    overflow: hidden;
    vertical-align: middle;
  }
  .name {
    vertical-align: middle;
    line-height: 40px;
    overflow: hidden;
    white-space: nowrap;
    text-overflow: ellipsis;
    text-decoration: underline;
    color:#999;
    cursor: pointer;
    margin-left: 10px;
    margin-right: 10px;
  }
  .name:hover {
    color:#111;
  }
  .follow {
    vertical-align: middle;
    cursor: pointer;
    color: #fff;
    display: inline-block;
    border-radius: 5px;
    padding: 2px 8px;
    background-color: #3CB46E;
    font-size: 16px;
  }
  .follow:hover {
    background-color: #44ce7d;
  }
  .followed {
    background-color: grey;
    color: #fff;
  }
  .followed:hover {
    background-color: #979797;
  }
  .private-lock {
    font-size: 20px;
  }
  .edit {
    font-size: 18px;
    display: inline-block;
    border-radius: 5px;
    border: 1px solid #999;
    vertical-align: middle;
    padding: 2px 5px;
    cursor: pointer;
    color: #999;
  }
  .edit:hover {
    border-color: #111;
    color: #111;
  }
  @media screen and (max-width: 809px) {
    .collection_name {
      font-size: 28px;
    }
    .edit {
      margin-left: 0;
      display: block;
      margin-top: 10px;
    }
  }
</style>