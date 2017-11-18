<template>
  <div class="container">
    <div class="details">
      <p><Icon type="ios-albums"></Icon> 请选择存放该图片的相册</p>
      <Icon type="android-cancel" id='cancel' @click='closeCollection'></Icon>
      <div class="select-collection">
        <div class="collection" v-for='collection in userCollections' 
        @click='selectCollection($event, collection)'>
          <div class="collection-img">
            <img :src='collection.images_list_new[0]' alt="">
          </div>
          <div class="collection-name">
            <span>{{collection.collection_name}}</span>
          </div>
        </div>
        <div class="collection" @click='selectCollection($event)'>
          <div class="collection-img">
            <img src='../../assets/img/album.jpg' alt="">
          </div>
          <div class="collection-name">
            <span>创建新相册</span>
          </div>
        </div>
      </div>
      <div class="submit">
        <input type="button" value="提 交" @click='addTo'>
      </div>
    </div>
  </div>
</template>

<script>
  export default {
    name: 'addToCollection',
    data () {
      return {
        collectionId: ''
      }
    },
    methods: {
      addTo () {
        this.$emit('addTo', this.collectionId)
      },
      closeCollection (e) {
        this.$emit('closeCollection', e)
      },
      selectCollection (e, collection) {
        let collections = document.getElementsByClassName('collection')
        for (let c of collections) {
          c.style.backgroundColor = '#f5f5f5'
          c.style.color = '#111'
        }
        e.target.style.backgroundColor = '#ddd'
        e.target.style.color = '#f5f5f5'
        if (collection) this.collectionId = collection.collection_id
        else this.collectionId = ''
      }
    },
    computed: {
      userCollections () {
        let lists = this.$store.state.userCollections
        let collections = []
        for (let l of lists) {
          let newArr = []
          for (let image of l.images_list) {
            image = this.$store.state.urlBase + image + this.$store.state.viewBase
            newArr.push(image)
          }
          l.images_list_new = newArr
          collections.push(l)
        }
        return collections
      }
    },
    mounted () {
      this.$store.dispatch('getUserCollections')
    }
  }
</script>

<style scoped>
  .container {
    position: fixed;
    top: 0;
    left: 0;
    background-color: rgba(0,0,0,0.3);
    width: 100%;
    min-height: 100vh;
    z-index: 10;
  }
  .details {
    text-align: left;
    font-size: 16px;
    width: 800px;
    margin: auto;
    margin-top: 100px;
    min-height: 200px;
    background-color: #fff;
    padding: 20px;
  }
  .details p {
    padding-left: 20px;
    display: inline-block;
  }
  #cancel {
    float: right;
    font-size: 22px;
    cursor: pointer;
  }
  #cancel:hover {
    color: #676767;
  }
  .select-collection {
    max-height: 400px;
    margin-top: 20px;
    overflow-y: auto;
    border-radius: 10px 0px 0px 10px;
    padding: 10px 20px;
  }
  .select-collection::-webkit-scrollbar{
    width: 10px;
    height: 0px;
  }
  /* 设置滚动条的滑轨 */
  .select-collection::-webkit-scrollbar-track {
    background-color: white;
  }
  /* 滑块 */
  .select-collection::-webkit-scrollbar-thumb {
    background-color: #999;
  }
  /* 滑轨两头的监听按钮 */
  .select-collection::-webkit-scrollbar-button {
    background-color: #999;
    display: none;
  }
  .collection {
    height: 50px;
    margin-bottom: 10px;
    color: #111;
    font-style: italic;
    cursor: pointer;
    background-color: #f5f5f5;
  }
  .collection:hover{
    background-color: #ddd;
    color: #f5f5f5;
  }
  .collection-img {
    width: 50px;
    display: inline-block;
    float: left;
  }
  .collection-img img {
    width: 50px;
    height: 50px;
  }
  .collection-name {
    display: inline-block;
  }
  .collection-name span {
    line-height: 50px;
    margin-left: 30px;
  }
  input{
    width: 80px;
    margin-left: calc(100% - 100px);
    height: 40px;
    outline: none;
    background-color: #444;
    color: #fff;
    padding: 0 6px;
    margin-top: 20px;
    border-radius: 5px;
    border: none;
    cursor: pointer;
  }
  input:hover {
    background-color: #111;
  }
  @media screen and (max-width: 809px) {
    .select-collection {
      max-height: 300px;
    }
  }
</style>