<template>
  <div class="container">
    <div class="top">
      <span class="likes" @click='photoLike'><Icon type="android-favorite"></Icon><span class="likes-nums">{{photoInfo.total_likes}}</span></span>
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
        // this.like = !this.like
        // let data = {
        //   image_id: this.photoInfo.image_id,
        //   like: this.like ? '1' : '0'
        // }
        // photoOp.photoLike(data, (res) => {
        //   console.log(res)
        // })
      },
      addToCollection () {
        let data = {
          image_id: this.photoInfo.image_id,
          collection_id: 83
        }
        photoOp.addToCollection(data, (res) => {
          console.log(res)
        })
      },
      gotoUserCenter () {
        this.$router.push({path: `/userCenter/${this.photoInfo.user_id}`})
      },
      downloadPic () {
        photoOp.downloadPhoto({filename: this.photoInfo.aliyun_name})
        // window.location.href = '/api/download/photo?filename=' + this.photoInfo.aliyun_name
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
    font-size: 40px;
    margin-right: 20px;
    vertical-align: middle;
    cursor: pointer;
  }
  .top .likes:hover {
    color: #ef3737;
  }
  .top .add {
    font-size: 18px;
    font-weight: bolder;
    border-radius: 4px;
    padding: 8px 8px;
    background-color: #979797;
    color: #fff;
    cursor: pointer;
  }
  .top .add:hover {
    background-color: #888;
  }
  .bottom {
    position: absolute;
    bottom: 20px;
    width: 90%;
    left: 5%;
  }
  .users {
    display: inline-block;
    float: left;
    color: #fff;
    font-size: 22px;
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
    font-size: 40px;
    cursor: pointer;
    font-weight: bolder;
  }
  .download:hover {
    color: #999;
  }
  .likes-nums {
    font-size: 16px !important;
    color: #fff !important;
  }
</style>