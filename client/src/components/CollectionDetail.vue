<template>
  <div class="container">
    <div class="intro">
      <div class="collection_name">
        {{collection_name}}
      </div>
      <div class="collection_owner">
        <img :src='owner_avatar' alt="">
        <span>{{collection_owner}}</span>
        <Icon type="person-add" class='follow'></Icon>
      </div>
    </div>
    <div class="photos">
      <div class="counts">{{totalCount}} 张照片</div>
      <Photos :photos="photos"></Photos>
    </div>
  </div>
</template>

<script>
  import photoOp from '../../api/photos'
  import Photos from './photos/Photos.vue'
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
        collection_owner: '',
        owner_id: '',
        owner_avatar: '',
        owner_email: '',
        collection_name: ''
      }
    },
    components: {
      Photos
    },
    methods: {
      getPhotos () {
        let data = {
          user_id: this.info.user_id,
          collection_id: this.$route.params[0],
          pageNo: this.currentPageNo,
          pageSize: this.currentPageSize
        }
        photoOp.getCollection.one(data, (res) => {
          this.totalCount = res.data.data.totalCount
          let lists = res.data.data.lists
          this.collection_owner = lists[0].collection_owner
          this.collection_name = lists[0].collection_name
          this.owner_email = lists[0].owner_email
          this.owner_id = lists[0].owner_id
          if (!lists[0].owner_avatar) {
            this.owner_avatar = require('@/assets/img/user_default.jpg')
          } else {
            this.owner_avatar = lists[0].owner_avatar
          }
          for (let i = 0; i < lists.length; i++) {
            lists[i].image_md5 += '?x-oss-process=image/auto-orient,1'
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
        this.$store.dispatch('getUserInfo')
      }
      this.getPhotos()
    },
    computed: {
      info () {
        return this.$store.state.userInfo
      },
      login () {
        return this.$store.state.alreadyLogin
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
  .collection_owner span {
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
  .collection_owner span:hover {
    color:#111;
  }
  .follow {
    vertical-align: middle;
    cursor: pointer;
    color: #999;
  }
  .follow:hover {
    color:#111;
  }
</style>