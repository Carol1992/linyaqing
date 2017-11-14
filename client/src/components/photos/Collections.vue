<template>
  <div class="container">
    <div class="images">
      <div class="image" v-for='collection in collections'>
        <div class="left">
          <img :src='collection.images_list[0]' alt="" @error='imgError'>
        </div>
        <div class="right">
          <div class="right-top">
            <img :src='collection.images_list[1]' alt="" @error='imgError' 
            v-if='collection.images_list.length >= 2'>
          </div>
          <div class="right-bottom">
            <img :src='collection.images_list[2]' alt="" @error='imgError' 
            v-if='collection.images_list.length >= 3'>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
  export default {
    name: 'collections',
    data () {
      return {
        msg: ''
      }
    },
    props: ['collections'],
    methods: {
      imgError (e) {
        e.target.src = require('../../assets/img/white.png')
      }
    }
  }
</script>

<style scoped>
  .images {
    width: 90%;
    margin: auto;
    display: -webkit-flex; /* Safari */
    display: flex;
    flex-direction: row;
    flex-wrap: wrap;
    justify-content: space-between;
    align-items: flex-center;
  }
  .image {
    width: calc(100% / 3 - 20px);
    margin-bottom: 30px;
    background-color: #fff;
    height: 310px;
    border-radius: 8px;
    overflow: hidden;
  }
  .left {
    width: 70%;
    display: inline-block;
    float: left;
    height: 100%;
    background-color: #f5f5f5;
  }
  .right {
    width: 30%;
    display: inline-block;
    float: left;
    height: 100%;
  }
  .right-top, .right-bottom {
    height: 49.5%;
    background-color: #f5f5f5;
  }
  .right-bottom {
    margin-top: 2%;
  }
  .image img {
    width: 99%;
    min-height: 100%;
  }
  @media screen and (max-width: 809px) {
    .image {
      width: 100%;
    }
  }
</style>