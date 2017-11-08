<template>
  <div class="container">
    <div class="top">
      <div class="user">
        <div class="avatar">
          <img :src='info.image_md5' alt="">
        </div>
        <div class="name">
          <span>{{info.user_name}}</span>
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
      return {}
    },
    methods: {
      gotoProfile () {
        this.$router.push({path: `/userProfile/${this.info.user_name}`})
      }
    },
    computed: {
      info () {
        return this.$store.state.userInfo
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