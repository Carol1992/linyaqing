<template>
  <div class="container">
    <div class="images left">
      <div class="image" v-for='photo in photos.group_a'>
        <img :src='photo.image_md5' alt="">
      </div>
    </div>
    <div class="images middle">
      <div class="image" v-for='photo in photos.group_b'>
        <img :src='photo.image_md5' alt="">
      </div>
    </div>
    <div class="images right">
      <div class="image" v-for='photo in photos.group_c'>
        <img :src='photo.image_md5' alt="">
      </div>
    </div>
  </div>
</template>

<script>
  export default {
    name: 'Photos',
    data () {
      return {

      }
    },
    props: ['photos'],
    methods: {

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
  }
</style>