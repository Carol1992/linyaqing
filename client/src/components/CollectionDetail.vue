<template>
  <div class="container">
    <div class="intro">
      <div class="collection_name">
        {{collectionInfo.collection_name}} <Icon type="locked" v-if='collectionInfo.is_private' class='private-lock'></Icon>
        <span class="edit" v-if='!notMe' @click='editCollection'><Icon type="edit"></Icon> 编辑</span>
      </div>
      <div class="collection_owner">
        <img :src='collectionInfo.owner_avatar' alt="" @click='gotoUserCenter'>
        <span class="name" @click='gotoUserCenter'>{{collectionInfo.collection_owner}}</span>
        <span class='follow' v-if='notMe && !followed' @click='followMe'><Icon type="person-add"></Icon> 关注</span>
        <span class='follow followed' v-if='notMe && followed' @click='notFollowMe'><Icon type="person"></Icon> 取消关注</span>
      </div>
    </div>
    <div class="photos">
      <div class="counts">{{totalCount}} 张照片</div>
      <Photos :photos="photos"></Photos>
    </div>
    <Edit v-if='showEdit' :collectionInfo='collectionInfo' @closeBox='closeBox' 
    @successModify='successModify' @successDelete='successDelete'></Edit>
  </div>
</template>

<script>
  import photoOp from '../../api/photos'
  import Photos from './photos/Photos'
  import Edit from './photos/editCollection'
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
        currentPageSize: 18000,
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
          is_private: false,
          collection_desc: ''
        },
        notifyMsg: ''
      }
    },
    components: {
      Photos,
      Edit
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
      gotoUserCenter () {
        this.$router.push({path: `/userCenter/${this.collectionInfo.owner_id}`})
      },
      closeBox () {
        this.showEdit = false
      },
      successModify () {
        this.showEdit = false
        this.notifyMsg = '相册信息更新成功！'
        this.success(true)
      },
      successDelete () {
        this.notifyMsg = '成功删除相册！'
        this.success(true)
        this.$router.push({path: `/userCenter/${this.info.user_id}`})
      },
      followMe () {
        photoOp.updatePhotographers({followings: this.collectionInfo.owner_id.toString()}, (res) => {
          this.followed = true
          this.followMsg = '已关注'
        })
      },
      notFollowMe () {
        photoOp.updatePhotographers_rm({following_id: this.collectionInfo.owner_id}, (res) => {
          this.followed = false
        })
      },
      editCollection () {
        this.showEdit = true
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
        photoOp.getCollection.one(data, (res) => {
          this.totalCount = res.data.data.totalCount
          let lists = res.data.data.lists
          this.collectionInfo.collection_owner = lists[0].collection_owner
          this.collectionInfo.collection_name = lists[0].collection_name
          this.collectionInfo.owner_email = lists[0].owner_email
          this.collectionInfo.owner_id = lists[0].owner_id
          this.collectionInfo.is_private = lists[0].is_private === '0'
          this.collectionInfo.collection_desc = lists[0].collection_desc
          if (!lists[0].owner_avatar) {
            this.collectionInfo.owner_avatar = require('@/assets/img/user_default.jpg')
          } else {
            this.collectionInfo.owner_avatar = this.$store.state.urlBase + lists[0].owner_avatar +
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
          for (let i = 0; i < lists.length; i++) {
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
        })
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
          this.getPhotos()
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
      followings () {
        return this.$store.state.followings.split(',')
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