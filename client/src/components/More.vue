<template>
  <div class="container">
     <div class="content">
       <div class="cancel" @click='closeBox'><Icon type="camera"></Icon></div>
       <div class="albums item" @click='gotoCollections'>
         <span><Icon type="ios-albums"></Icon></span>
         <span>相册</span>
       </div>
       <div class="store item" @click='gotoStore'>
         <span><Icon type="android-cart"></Icon></span>
         <span>Store</span>
       </div>
       <div class="upload item" @click='uploadPhoto'>
         <span><Icon type="upload"></Icon></span>
         <span>上传图片</span>
       </div>
       <div class="login item" v-if='!login' @click='gotoLogin'>
         <span><Icon type="android-person"></Icon></span>
         <span>登录</span>
       </div>
       <div class="user item" v-if='login' @click='gotoUserCenter'>
          <img :src='info.image_md5' alt="">
          <span>用户中心</span>
       </div>
     </div>
  </div>
</template>

<script>
  export default {
    name: 'more',
    methods: {
      closeBox (e) {
        this.$emit('closeBox', e)
      },
      gotoCollections (e) {
        this.$emit('gotoCollections', e)
      },
      gotoStore (e) {
        this.$emit('gotoStore', e)
      },
      uploadPhoto (e) {
        this.$emit('uploadPhoto', e)
      },
      gotoUserCenter (e) {
        this.$emit('gotoUserCenter', e)
      },
      gotoLogin (e) {
        this.$emit('gotoLogin', e)
      }
    },
    computed: {
      login () {
        return this.$store.state.alreadyLogin
      },
      info () {
        return this.$store.state.userInfo
      }
    }
  }
</script>

<style scoped>
  .container {
    background-color: rgba(255,255,255,1);
    width: 100%;
    height: 100vh;
    position: fixed;
    z-index: 30;
    top:0;
    left: 0;
  }
  .content {
    color: #111;
    width: 90%;
    margin: auto;
    margin-top: 70px;
    position: relative;
  }
  .cancel {
     /*position: absolute;
     right: 0px;*/
     font-size: 80px;
     color: #000;
     text-align: center;
     margin-bottom: 60px;
  }
  .cancel:hover {
    color: #333;
    cursor: pointer;
  }
  .item {
    font-size: 36px;
    display: inline-block;
    float: left;
    width: 25%;
    text-align: center;
    cursor: pointer;
  }
  .item:hover {
    color: #444;
    border-radius: 5px;
    border: 1px solid #999;
  }
  .item span:nth-child(1) {
    display: block;
  }
  .item span:nth-child(2) {
    font-size: 12px;
    font-weight: bold;
  }
  .user img {
    width: 52px;
    height: 52px;
    border-radius: 50%;
    overflow: hidden;
    display: block;
    margin: auto;
    padding: 8px;
  }
</style>