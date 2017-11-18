<template>
  <div class="container">
    <div class="images left">
      <div class="image" v-for='photo in photos.group_a' 
      @mouseenter='showCovers(photo)'
      @mouseleave='showCovers(photo)'>
        <Cover :photoInfo='photo' v-if='photo.showCover' @photoLike='photoLike' 
        @addToCollection='addToCollection'></Cover>
        <img :src='photo.image_md5' alt="">
      </div>
    </div>
    <div class="images middle">
      <div class="image" v-for='photo in photos.group_b' 
      @mouseenter='showCovers(photo)'
      @mouseleave='showCovers(photo)'>
        <Cover :photoInfo='photo' v-if='photo.showCover' @photoLike='photoLike' 
        @addToCollection='addToCollection'></Cover>
        <img :src='photo.image_md5' alt="">
      </div>
    </div>
    <div class="images right">
      <div class="image" v-for='photo in photos.group_c' 
      @mouseenter='showCovers(photo)'
      @mouseleave='showCovers(photo)'>
        <Cover :photoInfo='photo' v-if='photo.showCover' @photoLike='photoLike' 
        @addToCollection='addToCollection'></Cover>
        <img :src='photo.image_md5' alt="">
      </div>
    </div>
  </div>
</template>

<script>
  import Cover from './imgCover'
  export default {
    name: 'Photos',
    data () {
      return {

      }
    },
    props: ['photos'],
    components: {
      Cover
    },
    methods: {
      showCovers (c) {
        this.$emit('showCovers', c)
      },
      photoLike (photo) {
        this.$emit('photoLike', photo)
      },
      addToCollection (photo) {
        this.$emit('addToCollection', photo)
      }
    }
  }
</script>

<style scoped>
  .container {
    width: 90%;
    margin: auto;
    display: -webkit-flex; /* Safari */
    display: flex;
    flex-direction: row;
    flex-wrap: wrap;
    justify-content: space-between;
    align-items: flex-center;
  }
  .images {
    width: calc(33.33% - 1.5%);
  }
  .image img {
    width: 100%;
  }
  .image {
    margin-bottom: 4.5%;
    width: 100%;
    background-color: #f5f5f5;
    position: relative;
  }
  .imageCover {
    background-color: rgba(0,0,0,0.1);
    position: absolute;
    margin-top: 0;
    margin-left: 0;
    width: 100%;
    height: 100%;
  }
  @media screen and (max-width: 809px) {
    .images {
      width: 100%;
    }
  }
</style>