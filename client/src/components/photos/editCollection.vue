<template>
  <div class="container">
    <div class="content">
      <div class="cancel" @click='cancel'>
        <Icon type="android-cancel" size='40'></Icon>
      </div>
      <div class="title">
        <span>修改相册信息</span>
      </div>
      <div class="collection_name c-info">
        <span>相册名称</span>
        <input type="text" maxlength="50" v-model='collectionInfo.collection_name'>
      </div>
      <div class="collection_desc c-info">
        <span>相册简介</span>
        <textarea maxlength="300" v-model='collectionInfo.collection_desc'></textarea>
      </div>
      <div class="private">
        <input type="checkbox" :checked='collectionInfo.isPrivate' 
        @change='changePrivate(collectionInfo)'>
        <span>设置为私密相册</span>
        <span class="deleteCollection" @click='deleteCollection(collectionInfo)'>删除相册</span>
      </div>
      <div class="submit" @click='submit(collectionInfo)'>
        <input type="button" value="提交">
      </div>
    </div>
  </div>
</template>

<script>
  export default {
    name: 'editCollection',
    data () {
      return {
        isPrivate: true
      }
    },
    props: ['collectionInfo'],
    methods: {
      cancel (e) {
        this.$emit('closeBox', e)
      },
      changePrivate (c) {
        this.$emit('changePrivate', c)
      },
      submit (collectionInfo) {
        this.$emit('updateCollectionInfo', collectionInfo)
      },
      deleteCollection (collectionInfo) {
        this.$emit('deleteCollection', collectionInfo)
      }
    }
  }
</script>

<style scoped>
  .container {
    width: 100%;
    height: 100vh;
    background-color: rgba(0,0,0,0.4);
    position: fixed;
    top: 0;
    left: 0;
    z-index: 10;
  }
  .content {
    width: 650px;
    height: 500px;
    position: fixed;
    z-index: 11;
    top: calc(50% - 300px);
    left: calc(50% - 325px);
    background-color: #fff;
    border-radius: 5px;
    box-shadow: 0 0 5px #999;
    padding: 10px 20px;
  }
  .cancel {
    position: absolute;
    right: 20px;
    cursor: pointer;
    color: #999;
  }
  .cancel:hover {
    color:#111;
  }
  .title {
    margin: 20px 0;
    font-size: 30px;
    font-weight: 800;
  }
  input, textarea {
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
  .collection_name {
    margin: 20px 0;
  }
  .private {
    margin: 10px 0;
    position: relative;
  }
  .private input {
    width: 20px;
    height: 20px;
    vertical-align: top;
  }
  .c-info > span {
    font-size: 16px;
    font-weight: 600;
  }
  .private span {
    font-size: 16px;
    color: #999;
  }
  textarea {
    height: 140px;
    resize: none;
  }
  .submit {
    margin-top: 30px;
  }
  .submit input {
    font-size: 18px;
    font-weight: bolder;
    background-color: #111;
    color: #fff;
    cursor: pointer;
  }
  .deleteCollection {
    position: absolute;
    right: 0;
    text-decoration: underline;
    color: orangered !important;
    cursor: pointer;
  }
  @media screen and (max-width: 809px) {
    .content {
      width: 96%;
      height: 500px;
      position: fixed;
      z-index: 11;
      top: calc(50% - 300px);
      left: 2%;
      background-color: #fff;
      border-radius: 5px;
      box-shadow: 0 0 5px #999;
      padding: 10px 20px;
    }
  }
</style>