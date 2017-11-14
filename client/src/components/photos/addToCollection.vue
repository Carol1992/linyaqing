<template>
  <div class="container">
    <div class="addTo">
     <!--  <div class="bigImg">
        <img :src='imgInfo.photoUrl' alt="">
      </div> -->
      <div class="collections">
        <p>请选择存放该图片的相册</p>
        <RadioGroup v-model="selected" vertical>
          <Radio label="collection.collection_name" v-for='collection in imgInfo.userCollections'>
            <span>{{collection.collection_name}}</span>
          </Radio>
        </RadioGroup>
      </div>
    </div>
  </div>
</template>

<script>
  export default {
    name: 'addToCollection',
    data () {
      return {
        selected: ''
      }
    },
    props: ['imgInfo']
  }
</script>

<style scoped>
  .container {
    position: absolute;
    top: 0;
    left: 0;
    background-color: rgba(0,0,0,0.3);
    width: 100%;
    height: 100vh;
  }
  .addTo {
    position: absolute;
    width: 800px;
    height: 600px;
    top: calc(50% - 300px);
    left: calc(50% - 400px);
    background-color: #fff;
    z-index: 10;
  }
  .bigImg {
    width: 65%;
    display: inline-block;
    float: left;
    margin-right: 5%;
    background-color: #999999;
    height: 100%;
  }
  .collections {
    width: 30%;
    display: inline-block;
  }
  .bigImg img {
    width: 100%;
    height: 100%;
  }
</style>