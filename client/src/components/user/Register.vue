<template>
  <div class="container">
    <div class="loginForm">
      <div class="home" @click="goHome">
        <Icon type="camera" size="70"></Icon>
      </div>
      <div class="login">
        <span>新用户注册</span>
      </div>
      <div class="account">
        <span><Icon type="email"></Icon> 邮 箱</span>
        <input type="text" maxlength="50" v-model='email'>
      </div>
      <div class="username">
        <span><Icon type="person"></Icon> 昵 称</span>
        <input type="text" maxlength="20" v-model='username'>
      </div>
      <div class="password">
        <span><Icon type="locked"></Icon> 密 码 <span class="info">(6-20位数字/字母/下划线/中划线)</span></span>
        <input type="password" maxlength="20" v-model='password' @keyup.enter='goRegister'>
      </div>
      <div class="submit">
        <input type="button" value="注 册" @click='goRegister'>
      </div>
      <div class="goRegister">
        <span>已经有账号？ 前往<router-link to='/login'>登录</router-link></span>
      </div>
    </div>
  </div>
</template>

<script>
  import userOp from '../../../api/user'
  export default {
    name: 'register',
    data () {
      return {
        email: '',
        username: '',
        password: '',
        showError: false,
        errorMsg: ''
      }
    },
    methods: {
      error (nodesc) {
        this.$Notice.error({
          title: this.notifyMsg,
          desc: nodesc ? '' : ''
        })
      },
      goHome () {
        this.$router.push('/')
      },
      goRegister () {
        if (!this.email || !this.username || !this.password) {
          this.notifyMsg = '邮箱和昵称不能为空！'
          this.error(true)
          this.showError = true
          this.errorMsg = '请填写完整的注册信息！'
          return
        }
        let emailPattern = /^[a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+(\.[a-zA-Z0-9_-]+)+$/
        let namePattern = /[\u4e00-\u9fa5_a-zA-Z0-9_]{1,20}/
        let passwordPattern = /[a-zA-Z0-9_-]{6,20}/
        if (!emailPattern.exec(this.email)) {
          this.notifyMsg = '请填写有效的邮箱！'
          this.error(true)
          return
        }
        if (!namePattern.exec(this.username)) {
          this.notifyMsg = '用户名支持中英文和数字！'
          this.error(true)
          return
        }
        if (!passwordPattern.exec(this.password)) {
          this.notifyMsg = '密码格式不正确！'
          this.error(true)
          return
        }
        let data = {
          user_name: this.username,
          email: this.email,
          password: this.password
        }
        userOp.register(data, (res) => {
          if (res.data.code === '1') {
            this.notifyMsg = res.data.desc
            this.error(true)
            return
          }
          userOp.login(data, (res) => {
            this.$router.push('/')
          })
        })
      }
    }
  }
</script>

<style scoped>
  .container {
    width: 100%;
    min-height: 100vh;
    position: fixed;
    top: 0;
    z-index: 3;
    background-color: #fff;
  }
  .home {
    width: 100px;
    margin: auto;
    text-align: center;
    cursor: pointer;
  }
  .loginForm {
    position: fixed;
    width: 530px;
    height: 520px;
    top: calc(50% - 300px);
    left: calc(50% - 265px);
  }
  .login {
    text-align: center;
    font-size: 25px;
    font-family: '微软';
    font-weight: bolder;
  }
  .account > span, .password > span, .username > span {
    display: block;
    font-size: 18px;
    font-weight: bolder;
  }
  .account {
    margin-bottom: 30px;
    margin-top: 30px;
  }
  .username {
    margin-bottom: 30px;
  }
  input {
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
  .goRegister {
    margin-top: 20px;
    text-align: center;
    font-size: 14px;
  }
  .info {
    font-size: 14px;
    color: #979797;
  }
  .error {
    text-align: center;
    color: orangered;
    margin-top: 5px;
  }
  @media screen and (max-width: 809px) {
    .loginForm {
      width: 96%;
      height: 520px;
      top: calc(50% - 300px);
      left: 2%;
    }
  }
</style>