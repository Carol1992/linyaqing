<template>
  <div class="container">
    <div class="info">
      <h1>oooh...页面好像丢失了，回到主页吧:)</h1>
      <br><br>
      <div class="logo" @click='goHome'>
        <Icon type="camera" size="50"></Icon>
      </div>
    </div>
  </div>
</template>

<script>
  export default {
    name: 'notFound',
    methods: {
      goHome () {
        this.$router.push('/')
      }
    }
  }
</script>

<style scoped>
  .container {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100vh;
    background-color: #fff;
    z-index: 20;
    background-image: url('../assets/img/500_large.jpg');
    background-repeat: no-repeat;
    background-size: 100% 100%;
  }
  .info {
    text-align: center;
    width: 100%;
    height: 200px;
    position: absolute;
    top:calc(50% - 100px);
    color: #fff;
  }
  .logo {
    cursor: pointer;
  }
  @media screen and (max-width: 809px) {
    .container {
      background-image: none;
    }
    .info {
      color: #000;
    }
  }
</style>