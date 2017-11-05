<template>
  <div class="container">
    <div class="cancel" @click="closeBox">
      <Icon type="android-cancel" size="40" color="#fff" id='cancel'></Icon>
    </div>
    <div class="loginForm">
      
    </div>
  </div>
</template>

<script>
  export default {
    name: 'login',
    data () {
      return {

      }
    },
    methods: {
      closeBox () {
        console.log(this.$store)
        this.$store.commit('showLogin', false)
      }
    }
  }
</script>

<style scoped>
  .container {
    background-color: rgba(0,0,0,0.3);
    width: 100%;
    min-height: 100vh;
    position: fixed;
    top: 0;
    z-index: 3;
  }
  .cancel {
    width: 50px;
    float: right;
    margin-right: 4%;
    margin-top: 10px;
    text-align: center;
  }
  .loginForm {
    position: fixed;
    width: 430px;
    height: 430px;
    top: calc(50% - 215px);
    left: calc(50% - 215px);
    background-color: #fff;
  }
  #cancel {
    cursor: pointer;
  }
</style>