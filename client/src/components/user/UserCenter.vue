<template>
  <div class="container">
    <div class="top">
      <div class="user">
        <div class="avatar">
          <img :src='avatar' alt="">
        </div>
        <div class="name">
          <span>{{user_name}}</span>
          <span class="more" @click='gotoProfile'><Icon type="ios-more-outline"></Icon></span>
        </div>
      </div>
    </div>
    <div class="bottom">
      
    </div>
  </div>
</template>

<script>
  export default {
    name: 'userCenter',
    data () {
      return {
        avatar: localStorage.lq_image_md5,
        user_name: localStorage.lq_user_name
      }
    },
    methods: {
      gotoProfile () {
        this.$router.push({path: `/userProfile/${localStorage.lq_user_name}`})
      }
    }
  }
</script>

<style scoped>
  .top {
   margin-top: 130px;
   text-align: center;
  }
  .avatar {
    width: 150px;
    height: 150px;
    border-radius: 50%;
    overflow: hidden;
    margin: auto;
  }
  .avatar img {
    width: 150px;
    height: 150px;
  }
  .name {
    font-size: 36px;
    margin-top: 15px;
    font-weight: bolder;
  }
  .more {
    font-size: 30px;
    position: absolute;
    margin-left: 20px;
    margin-top: 2px;
    display: inline-block;
    width: 50px;
    height: 42px;
    border: 1px solid #ddd;
    border-radius: 10px;
    cursor: pointer;
  }
  .more:hover {
    border: 1px solid #979797;
  }
</style>