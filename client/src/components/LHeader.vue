<template>
  <div class="container">
    <div class="logo" @click='goHome'>
      <Icon type="camera" size="50"></Icon>
    </div>
    <div class="search">
      <span><Icon type="ios-search-strong" size="30" color="#999"></Icon></span>
      <input type="text" placeholder="输入关键字搜索图片" @focus='changeBorder' @blur='changeBorder2'>
    </div>
    <div class="hideMore" v-if='!showMore'><span><Icon type="more"></Icon></span></div>
    <div class="more" v-if='showMore'>
      <div class="collection">
        <span>相册</span>
      </div>
      <div class="store">
        <span>Store</span>
      </div>
      <div class="upload" @click='uploadPhoto'>
        <span>上传图片</span>
        <input type="file" id='uploadPhoto' @change='uploadPhoto2'>
      </div>
      <div class="user" @click='tryLogin' v-if='!login'>
        <span >登录</span>
      </div>
      <div class="loginUser" v-if='login' @click='gotoUserCenter'>
        <img :src='info.image_md5' height="49" width="49" alt="">
      </div>
    </div>
  </div>
</template>

<script>
  import aliyunOp from '../../api/aliyun'
  import {mapState} from 'vuex'
  var EXIF = require('exif-js')
  export default {
    name: 'Lheader',
    data () {
      return {
        showMore: true
      }
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
      goHome () {
        this.$router.push('/')
      },
      changeBorder (e) {
        e.target.style.border = '1px solid #ddd'
        e.target.style.backgroundColor = '#fff'
      },
      changeBorder2 (e) {
        e.target.style.border = 'none'
        e.target.style.backgroundColor = '#f1f1f1'
      },
      tryLogin () {
        this.$router.push('/login')
      },
      onResize () {
        if (document.body.clientWidth < 809) {
          this.showMore = false
        } else {
          this.showMore = true
        }
      },
      gotoUserCenter () {
        this.$router.push({path: `/userCenter/${this.info.user_name}`})
      },
      uploadPhoto () {
        document.getElementById('uploadPhoto').click()
      },
      uploadPhoto2 () {
        let fd = new FormData()
        let file = document.getElementById('uploadPhoto').files[0]
        if (!file) {
          this.notifyMsg = '请选择文件！'
          this.error(true)
          return
        }
        if (file.type.indexOf('image/') === -1) {
          this.notifyMsg = '文件格式不正确！'
          this.error(true)
          return
        }
        aliyunOp.getAliyunKey((res) => {
          const {accessKeyId, host_user, policy, signature, saveName, startsWith} = res.data.data
          fd.append('OSSAccessKeyId', accessKeyId)
          fd.append('policy', policy)
          fd.append('signature', signature)
          fd.append('key', startsWith + saveName)
          fd.append('success_action_status', 200)
          fd.append('file', file, saveName)
          this.saveImgToAliyun(fd, file, host_user, startsWith, saveName)
        })
      },
      saveImgToAliyun (formData, file, host, startsWith, saveName) {
        let self = this
        let reader = new FileReader()
        reader.onload = function (e) {
          let data = e.target.result
          let image = new Image()
          image.onload = function () {
            EXIF.getData(image, function () {
              self.$store.commit('getPhotoInfo', EXIF.getAllTags(this))
            })
            let width = image.width
            let height = image.height
            if (width < 960 || height < 960) {
              this.notifyMsg = '图片尺寸不小于960*960！'
              this.error(true)
              return
            }
            aliyunOp.myPromise(host, formData).then((xhr) => {
              if (xhr.status !== 200) {
                this.notifyMsg = '操作失败！'
                this.error(true)
                return
              }
              if (xhr.status === 200) {
                let imgUrl = host + '/' + startsWith + saveName
                // 将图片设置为背景图片，组件上面有浮动层，用户可以填写照片的相关信息
                self.$store.commit('getPhotoUrl', imgUrl)
                self.$router.push('/addPhoto')
              }
            })
            .catch((err) => {
              console.log(err)
            })
          }
          image.src = data
        }
        reader.readAsDataURL(file)
      }
    },
    mounted () {
      this.$nextTick(function () {
        window.addEventListener('resize', this.onResize)
      })
      if (document.body.clientWidth < 809) {
        this.showMore = false
      }
    },
    computed: {
      localComputed () { /* ... */ },
      ...mapState({
        info: 'userInfo',
        login: 'alreadyLogin'
      })
    }
  }
</script>

<style scoped>
  .container {
    width: 96%;
    margin: auto;
    text-align: left;
  }
  .container > div {
    display: inline-block;
  }
  .logo {
    margin-right: 1%;
    cursor: pointer;
  }
  .search {
    width: 50%;
  }
  .search > input {
    width: 100%;
    height: 49px;
    border: none;
    border-radius: 20px;
    background-color: #f1f1f1;
    outline: none;
    vertical-align: bottom;
    padding-left: 40px;
    font-size: 18px;
    text-align: left;
  }
  .search span {
    position: absolute;
    margin-top: 10px;
    margin-left: 10px;
    cursor: pointer;
  }
  .more {
    width: 30%;
    float: right;
  }
  .more > div {
    display: inline-block;
    float: left;
    width: 25%;
    text-align: center;
    cursor: pointer;
  }
  .collection {
    color: #999;
    font-weight: bolder;
  }
  .store {
    color: #999;
    font-weight: bolder;
  }
  .collection:hover, .store:hover {
    color:#111;
  }
  .user {
    background-color: #3cb46e;
    border:none;
    border-radius: 10px;
    color: #fff;
    width: 20% !important;
    margin-left: 5%;
  }
  .user:hover {
    background-color: #37a866;
  }
  .more span {
    line-height: 49px;
    vertical-align: middle;
    font-size: 18px;
  }
  .upload {
    border:1px solid #ddd;
    border-radius: 10px;
  }
  .upload:hover {
    border: 1px solid #979797;
  }
  .hideMore span {
    line-height: 49px;
    font-size: 40px;
  }
  .hideMore {
    float: right;
  }
  .loginUser {
    border-radius: 50%;
    overflow: hidden;
    width: 49px !important;
    height: 49px;
    margin-left: calc(25% - 49px);
  }
  #uploadPhoto {
    display: none;
  }
  @media screen and (max-width: 809px) {
    .search {
      width: 70%;
    }
  }
  @media screen and (max-width: 1280px) and (min-width: 810px){
    .more {
      width: 40%;
    }
    .more span {
      font-size: 17px;
    }
  }
  @media screen and (min-width: 992px) {

  }
  @media screen and (min-width: 1280px) {
    
  }
</style>