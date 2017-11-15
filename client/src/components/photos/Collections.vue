<template>
  <div class="container">
    <div class="images">
      <div class="image" v-for='collection in new_collections' 
      @mouseenter='showCovers(collection)'
      @mouseleave='hideCovers(collection)'
      @click='getPhotos(collection)'>
        <div class="cover" v-if='collection.showCover'></div>
        <div class="left">
          <img :src='collection.images_list[0]' alt="">
        </div>
        <div class="right">
          <div class="right-top">
            <img :src='collection.images_list[1]' alt="" 
            v-if='collection.images_list.length >= 2'>
          </div>
          <div class="right-bottom">
            <img :src='collection.images_list[2]' alt="" 
            v-if='collection.images_list.length >= 3'>
          </div>
        </div>
        <div class="collection-info">
          <div class="collection_name">
            {{collection.collection_name}} <Icon type="locked" v-if='collection.is_private == 0'></Icon>
          </div>
          <div class="photo_nums">
            {{collection.images_list.length}}张照片 · 由{{collection.user_name}}创建
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
      return {}
    },
    props: ['collections'],
    computed: {
      new_collections () {
        let nc = []
        for (let c of this.collections) {
          c.showCover = false
          nc.push(c)
        }
        return nc
      }
    },
    methods: {
      showCovers (c) {
        c.showCover = true
      },
      hideCovers (c) {
        c.showCover = false
      },
      getPhotos (c) {
        const collectionId = c.collection_id
        this.$router.push({path: `/collection/${collectionId}`})
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
    min-height: 300px;
    border-radius: 8px;
    overflow: hidden;
    position: relative;
  }
  .left {
    width: 70%;
    display: inline-block;
    float: left;
    height: calc(100% - 60px);
    background-color: #f5f5f5;
  }
  .right {
    width: 30%;
    display: inline-block;
    float: left;
    height: calc(100% - 60px);
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
    height: 100%;
  }
  .collection-info {
    clear: both;
    height: 60px;
    padding-top: 7px;
  }
  .collection_name {
    overflow: hidden;
    white-space: nowrap;
    font-size: 20px;
    font-weight: 600;
    line-height: 1.34;
  }
  .photo_nums {
    color: #979797;
    font-size: 16px;
  }
  .cover {
    width: 100%;
    height: calc(100% - 60px);
    position: absolute;
    margin-top: 0;
    margin-left: 0;
    z-index: 2;
    background-color: rgba(255,255,255,0.1);
  }
  @media screen and (max-width: 809px) {
    .image {
      width: 100%;
    }
  }
</style>