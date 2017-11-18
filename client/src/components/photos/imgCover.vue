<template>
  <div class="container">
    <div class="top">
      <span class="likes" 
      :class='{likedLikes: alreadyLiked}' 
      @click='photoLike(photoInfo)'><Icon type="android-favorite"></Icon><span class="likes-nums" 
      :class='{likedNums: alreadyLiked}'> {{photoInfo.total_likes}}</span></span>
      <span class="add" @click='addToCollection'><Icon type="plus-round"></Icon>添加到相册</span>
    </div>
    <div class="bottom">
      <div class="users">
        <img :src='photoInfo.avatar' alt="" @click='gotoUserCenter'>
        <span @click='gotoUserCenter'>{{photoInfo.user_name}}</span>
      </div>
      <div class="download" @click='downloadPic'>
        <Icon type="ios-download-outline"></Icon>
      </div>
    </div>
  </div>
</template>

<script>
  import photoOp from '../../../api/photos'
  export default {
    name: 'imgCover',
    props: ['photoInfo'],
    methods: {
      photoLike () {
        this.$emit('photoLike', this.photoInfo)
      },
      addToCollection () {
        this.$emit('addToCollection', this.photoInfo)
      },
      gotoUserCenter () {
        this.$router.push({path: `/userCenter/${this.photoInfo.user_id}`})
      },
      downloadPic () {
        photoOp.downloadPhoto({filename: this.photoInfo.aliyun_name})
        // window.location.href = '/api/download/photo?filename=' + this.photoInfo.aliyun_name
      }
    },
    computed: {
      alreadyLiked () {
        return this.$store.state.alreadyLiked
      }
    }
  }
</script>

<style scoped>
  .container {
    position: absolute;
    top:0;
    left: 0;
    width: 100%;
    height: 100%;
    background-color: rgba(0,0,0,0.2);
  }
  .top {
    position: absolute;
    top:20px;
    width: 90%;
    left: 5%;
    text-align: right;
  }
  .top .likes {
    color: #f15151;
    font-size: 18px;
    margin-right: 20px;
    cursor: pointer;
    border-radius: 4px;
    padding: 8px 8px;
    background-color: #f1f1f1;
  }
  .top .likes:hover {
    color: #ef3737;
  }
  .likes-nums {
    color: #999;
  }
  .likedLikes{
    background-color: #f15151 !important;
    color: #fff !important;
  }
  .likedNums {
    color: #fff !important;
  }
  .top .add {
    font-size: 18px;
    border-radius: 4px;
    padding: 8px 8px;
    background-color: #f1f1f1;
    color: #999;
    cursor: pointer;
  }
  .top .add:hover {
    color: #676767;
  }
  .bottom {
    position: absolute;
    bottom: 10px;
    width: 90%;
    left: 5%;
  }
  .users {
    display: inline-block;
    float: left;
    color: #fff;
    font-size: 18px;
  }
  .users img {
    width: 50px;
    height: 50px;
    border-radius: 50%;
    overflow: hidden;
    vertical-align: middle;
    margin-right: 10px;
    cursor: pointer;
  }
  .users span {
    text-decoration: underline;
    cursor: pointer;
  }
  .users span:hover {
    color:#999;
  }
  .download{
    display: inline-block;
    float: right;
    color: #fff;
    font-size: 30px !important;
    cursor: pointer;
    font-weight: bolder;
  }
  .download:hover {
    color: #999;
  }

</style>