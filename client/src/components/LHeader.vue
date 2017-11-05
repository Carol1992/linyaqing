<template>
  <div class="container">
    <div class="logo">
      <Icon type="camera" size="50"></Icon>
    </div>
    <div class="search">
      <span><Icon type="ios-search-strong" size="30" color="#999"></Icon></span>
      <input type="text" placeholder="输入关键字搜索图片" @focus='changeBorder' @blur='changeBorder2'>
    </div>
    <div class="hideMore"><span><Icon type="more"></Icon></span></div>
    <div class="more">
      <div class="collection">
        <span>相册</span>
      </div>
      <div class="store">
        <span>Store</span>
      </div>
      <div class="upload">
        <span>上传图片</span>
      </div>
      <div class="user">
        <span>登录</span>
      </div>
    </div>
  </div>
</template>

<script>
  import $ from 'jquery'
  export default {
    name: 'Lheader',
    data () {
      return {
      }
    },
    methods: {
      changeBorder (e) {
        $(e.target).css({
          'border': '1px solid #ddd',
          'background-color': '#fff'
        })
      },
      changeBorder2 (e) {
        $(e.target).css({
          'border': 'none',
          'background-color': '#f1f1f1'
        })
      }
    },
    mounted () {}
  }
</script>

<style scoped>
  .container {
    width: 96%;
    margin: auto;
    text-align: left;
  }
  .container > div {
    display: inline-block;
  }
  .logo {
    margin-right: 1%;
    cursor: pointer;
  }
  .search {
    width: 50%;
  }
  .search > input {
    width: 100%;
    height: 49px;
    border: none;
    border-radius: 20px;
    background-color: #f1f1f1;
    outline: none;
    vertical-align: bottom;
    padding-left: 40px;
    font-size: 18px;
    text-align: left;
  }
  .search span {
    position: absolute;
    margin-top: 10px;
    margin-left: 10px;
    cursor: pointer;
  }
  .more {
    width: 30%;
    float: right;
  }
  .more > div {
    display: inline-block;
    float: left;
    width: 25%;
    text-align: center;
    cursor: pointer;
  }
  .collection {
    color: #999;
    font-weight: bolder;
  }
  .store {
    color: #999;
    font-weight: bolder;
  }
  .collection:hover, .store:hover {
    color:#111;
  }
  .user {
    background-color: #3cb46e;
    border:none;
    border-radius: 10px;
    color: #fff;
    width: 20% !important;
    margin-left: 5%;
  }
  .user:hover {
    background-color: #37a866;
  }
  .more span {
    line-height: 49px;
    vertical-align: middle;
    font-size: 18px;
  }
  .upload {
    border:1px solid #ddd;
    border-radius: 10px;
  }
  .upload:hover {
    border: 1px solid #979797;
  }
  .hideMore span {
    line-height: 49px;
    font-size: 40px;
    display: none;
  }
  .hideMore {
    float: right;
  }
  @media screen and (max-width: 809px) {
    .more span {
      display: none;
    }
    .hideMore span{
      display: inline-block;
    }
    .search {
      width: 70%;
    }
  }
  @media screen and (max-width: 1280px) and (min-width: 810px){
    .more {
      width: 40%;
    }
    .more span {
      font-size: 17px;
    }
  }
  @media screen and (min-width: 992px) {

  }
  @media screen and (min-width: 1280px) {
    
  }
</style>