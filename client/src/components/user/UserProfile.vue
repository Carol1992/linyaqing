<template>
  <div class="container">
    <div class="left">
      <div class="title">
        <span>账户设置</span>
      </div>
      <div class="details">
        <div class="profile" @click='isProfile = true; isPhoto = false; isEmail = false; isPwd = false; isApp = false; isDelete = false'>
          <span :class='{activated: isProfile}'>个人信息</span>
        </div>
        <div class="photos" @click='isProfile = false; isPhoto = true; isEmail = false; isPwd = false; isApp = false; isDelete = false'>
          <span :class='{activated: isPhoto}'>照片信息</span>
        </div>
        <div class="email" @click='isProfile = false; isPhoto = false; isEmail = true; isPwd = false; isApp = false; isDelete = false'>
          <span :class='{activated: isEmail}'>邮件设置</span>
        </div>
        <div class="password" @click='isProfile = false; isPhoto = false; isEmail = false; isPwd = true; isApp = false; isDelete = false'>
          <span :class='{activated: isPwd}'>更改密码</span>
        </div>
        <div class="app" @click='isProfile = false; isPhoto = false; isEmail = false; isPwd = false; isApp = true; isDelete = false'>
          <span :class='{activated: isApp}'>添加应用</span>
        </div>
        <div class="delete" @click='isProfile = false; isPhoto = false; isEmail = false; isPwd = false; isApp = false; isDelete = true'>
          <span :class='{activated: isDelete}'>删除账户</span>
        </div>
      </div>
    </div>
    <div class="right">
      
    </div>
  </div>
</template>

<script>
  export default {
    name: 'userProfile',
    data () {
      return {
        isProfile: true,
        isPhoto: false,
        isEmail: false,
        isPwd: false,
        isApp: false,
        isDelete: false
      }
    }
  }
</script>

<style scoped>
  .container{
    width: 90%;
    margin: auto;
    margin-top: 130px;
  }
  .left {
    width: 35%;
    display: inline-block;
    float: left;
  }
  .right {
    width: 65%;
    display: inline-block;
  }
  .title {
    font-size: 22px;
    font-weight: bolder;
    margin-bottom: 30px;
    text-align: center;
  }
  .details > div {
    font-size: 18px;
    height: 50px;
    text-align: center;
    color: #979797;
    cursor: pointer;
  }
  .details > div > span {
    display: inline-block;
    border-bottom: 1px solid #979797
  }
  .activated {
    color: #000;
    font-weight: bolder;
    border-bottom: 1px solid #ddd !important;
  }
</style>