<template>
  <div class="container">
    <div class="loginForm">
    <div class="home" @click="goHome">
      <Icon type="camera" size="70"></Icon>
    </div>
      <div class="login">
        <span>欢迎回来</span>
      </div>
      <div class="account">
        <span><Icon type="email"></Icon> 邮 箱</span>
        <input type="text" maxlength="50" v-model='email'>
      </div>
      <div class="password">
        <span><Icon type="locked"></Icon> 密 码</span>
        <input type="password" maxlength="20" v-model='password' @keyup.enter='goLogin'>
      </div>
      <div class="submit">
        <input type="button" value="登 录" @click='goLogin'>
      </div>
      <div class="goRegister">
        <span>尚未注册？ 前往<router-link to='/register'>注册</router-link></span>
      </div>
    </div>
  </div>
</template>

<script>
  import userOp from '../../../api/user'
  export default {
    name: 'login',
    data () {
      return {
        email: '',
        password: ''
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
      goLogin () {
        if (!this.email || !this.password) {
          this.notifyMsg = '邮箱和昵称不能为空！'
          this.error(true)
          return
        }
        let emailPattern = /^[a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+(\.[a-zA-Z0-9_-]+)+$/
        let passwordPattern = /[a-zA-Z0-9_-]{6,20}/
        if (!emailPattern.exec(this.email)) {
          this.notifyMsg = '请填写有效的邮箱！'
          this.error(true)
          return
        }
        if (!passwordPattern.exec(this.password)) {
          this.notifyMsg = '密码格式不正确！'
          this.error(true)
          return
        }
        let data = {
          email: this.email,
          password: this.password
        }
        userOp.login(data, (res) => {
          if (res.data.code === '1') {
            this.notifyMsg = res.data.desc
            this.error(true)
            return
          }
          this.$router.push('/')
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
    height: 420px;
    top: calc(50% - 250px);
    left: calc(50% - 265px);
  }
  .login {
    text-align: center;
    font-size: 25px;
    font-family: '微软';
    font-weight: bolder;
  }
  .account > span, .password > span {
    display: block;
    font-size: 18px;
    font-weight: bolder;
  }
  .account {
    margin-bottom: 30px;
    margin-top: 30px;
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
  .error {
    text-align: center;
    color: orangered;
    margin-top: 5px;
  }
  @media screen and (max-width: 809px) {
    .loginForm {
      width: 96%;
      height: 420px;
      top: calc(50% - 250px);
      left: 2%;
    }
  }
</style>