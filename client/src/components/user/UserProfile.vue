<template>
  <div class="container">
    <div class="left">
      <div class="title">
        <span>账户设置</span>
      </div>
      <div class="details">
        <div class="profile" @click='isProfile = true; isPhoto = false; isEmail = false; isPwd = false; isApp = false; isDelete = false; nowEdit = "个人信息"' >
          <span :class='{activated: isProfile}'>个人信息</span>
        </div>
        <div class="password" @click='isProfile = false; isPhoto = false; isEmail = false; isPwd = true; isApp = false; isDelete = false; nowEdit = "更改密码"'>
          <span :class='{activated: isPwd}'>更改密码</span>
        </div>
        <!-- <div class="photos" @click='isProfile = false; isPhoto = true; isEmail = false; isPwd = false; isApp = false; isDelete = false; nowEdit = "照片信息"'>
          <span :class='{activated: isPhoto}'>照片信息</span>
        </div>
        <div class="email" @click='isProfile = false; isPhoto = false; isEmail = true; isPwd = false; isApp = false; isDelete = false; nowEdit = "邮件设置"'>
          <span :class='{activated: isEmail}'>邮件设置</span>
        </div>
        <div class="app" @click='isProfile = false; isPhoto = false; isEmail = false; isPwd = false; isApp = true; isDelete = false; nowEdit = "添加应用"'>
          <span :class='{activated: isApp}'>添加应用</span>
        </div> -->
        <div class="delete" @click='isProfile = false; isPhoto = false; isEmail = false; isPwd = false; isApp = false; isDelete = true; nowEdit = "删除账户"'>
          <span :class='{activated: isDelete}'>删除账户</span>
        </div>
      </div>
    </div>
    <div class="right">
      <div class="setting_title">{{nowEdit}}</div>
      <div class="isProfile" v-if='isProfile'>
        <div class="part1">
          <div class="user_avatar">
            <div class="myavatar">
              <img :src='avatar' alt="">
            </div>
            <span id="changeIco">更换头像</span>
          </div>
          <div class="user_info">
            <div class="account">
              <span><Icon type="email"></Icon> 邮 箱</span>
              <input type="text" maxlength="50" v-model='email'>
            </div>
            <div class="username">
              <span><Icon type="person"></Icon> 昵 称</span>
              <input type="text" maxlength="20" v-model='username'>
            </div>
            <div class="website">
              <span><Icon type="link"></Icon> 个人网站</span>
              <input type="text" maxlength="100" v-model='website'>
            </div>
          </div>
        </div>
        <div class="part2">
          <div class="user_loc">
            <span><Icon type="location"></Icon> 住 址</span>
            <input type="text" maxlength="100" v-model='localtion'>
          </div>
          <div class="user_bio">
            <span><Icon type="information-circled"></Icon> 个人简介</span>
            <textarea name="" id="" cols="30" rows="10" v-model='bio'></textarea>
          </div>
          <div class="submit">
            <input type="button" value='提 交'>
          </div>
        </div>
      </div>
      <div class="isDelete" v-if='isDelete'>
        <div class="warm">
          <p>确定要删除账户吗？删除账户后与账户关联的所有信息都将被清除！</p>
          <p>如果只是要删除部分信息，请导航到具体模块进行删除。</p>
        </div>
        <div class="confirmed">
          <input type="button" value='删除账户'>
        </div>
      </div>
      <div class="isPwd" v-if='isPwd'>
        <div class="newpassword">
          <span><Icon type="locked"></Icon> 新密码 <span class="info">(6-20位数字/字母/下划线/中划线)</span></span>
          <input type="password" maxlength="20" v-model='password'>
        </div>
        <div class="newpassword">
          <span><Icon type="locked"></Icon> 确认密码 <span class="info"></span></span>
          <input type="password" maxlength="20" v-model='password'>
        </div>
         <div class="submit">
           <input type="button" value='提 交'>
         </div>
      </div>
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
        isDelete: false,
        nowEdit: '个人信息',
        avatar: localStorage.lq_image_md5,
        email: '',
        username: '',
        website: '',
        location: '',
        bio: ''
      }
    }
  }
</script>

<style scoped>
  .container {
    width: 78%;
    margin: auto;
    margin-top: 130px;
  }
  .left {
    width: 25%;
    display: inline-block;
    float: left;
  }
  .right {
    width: 75%;
    display: inline-block;
  }
  .title {
    font-size: 22px;
    font-weight: bolder;
    margin-bottom: 30px;
  }
  .details > div {
    font-size: 18px;
    height: 50px;
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
  .part1 > div {
    display: inline-block;
    float: left;
  }
  .setting_title {
    font-size: 18px;
    font-weight: bolder;
  }
  .user_avatar {
    width: 40%;
    text-align: center;
    padding-top: 30px;
  }
  .user_info {
    width: 60%;
  }
  .account > span, .website > span, .newpassword > span, .username > span, .user_bio > span, .user_loc > span {
    display: block;
    font-size: 18px;
    font-weight: bolder;
  }
  .account {
    margin-bottom: 30px;
  }
  .username {
    margin-bottom: 30px;
  }
  .user_loc {
    margin-bottom: 30px;
  }
  input, textarea {
    width: 100%;
    height: 40px;
    padding: 6px 12px;
    font-size: 15px;
    line-height: 1.6;
    color: #111111;
    background-color: transparent;
    background-image: none;
    border: 1px solid #999999;
    border-radius: 3px;
    -webkit-transition: border-color ease-in-out 0.15s;
    transition: border-color ease-in-out 0.15s;
  }
  .submit{
    margin-top: 30px;
    text-align: center;
  }
  .submit >input {
    background-color: #000;
    color: #fff;
    font-size: 18px;
    font-weight: bolder;
    cursor: pointer;
  }
  .myavatar {
    width: 150px;
    height: 150px;
    border-radius: 50%;
    overflow: hidden;
    margin: auto;
  }
  .myavatar > img {
    width: 150px;
    height: 150px;
  }
  textarea {
    height: 160px;
  }
  #changeIco {
    margin-top: 10px;
    font-size: 16px;
    display: inline-block;
    border-bottom: 1px solid #979797;
    color: #979797;
    cursor: pointer;
  }
  .confirmed input {
    background-color: #E25C3D;
    color: #fff;
    outline: none;
    border: none;
    font-size: 17px;
    cursor: pointer;
  }
  .warm {
    font-size: 17px;
    margin-top: 30px;
    margin-bottom: 30px;
  }
  .warm p {
    line-height: 30px;
  }
  .newpassword{
    margin-top: 30px;
  }
</style>