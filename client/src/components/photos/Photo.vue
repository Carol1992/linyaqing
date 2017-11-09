<template>
  <div id="container">
    <div class="cover">
      <div class="tags">
        <div class="tag activated">
          <span>标签</span>
        </div>
        <div class="exif">
          <span>EXIF</span>
        </div>
        <div class="gps">
          <span>GPS</span>
        </div>
        <div class="story">
          <div>简介</div>
        </div>
      </div>
      <div class="details">
        <span>给图片添加一些标签：</span>
        <input type="text" maxlength="100">
      </div>
      <div class="next">
        <span>下一项</span>
      </div>
    </div>
  </div>
</template>

<script>
  export default {
    name: 'photo',
    data () {
      return {
      }
    },
    methods: {
      setBackground () {
        document.getElementById('container').style.backgroundImage = 'url(' + this.imgUrl + ')'
      },
      error (nodesc) {
        this.$Notice.error({
          title: this.notifyMsg,
          desc: nodesc ? '' : ''
        })
      }
    },
    mounted () {
      this.setBackground()
    },
    computed: {
      imgUrl () {
        let imgUrl = this.$store.state.photoUrl
        if (!imgUrl) {
          this.notifyMsg = '噢噢，出错了，请重新上传！'
          this.error(true)
          this.$router.push('/')
          return
        }
        return imgUrl
      }
    }
  }
</script>

<style scoped>
  #container {
    position: absolute;
    top: 0;
    left: 0;
    z-index: 5;
    background-color: #111;
    width: 100%;
    min-height: 100vh;
    height: 100%;
    background-size: cover;
    background-repeat: no-repeat;
    background-position: center center;
  }
  .cover {
    background-color: rgba(0,0,0,0.5);
    width: 100%;
    min-height: 100vh;
    height: 100%;
    position: absolute;
    z-index: 6;
    text-align: center;
  }
  .tags {
    margin-top: 130px;
  }
  .tags > div {
    display: inline-block;
    width: 80px;
    height: 35px;
    border-radius: 8px;
    border: none;
    background-color: #fff;
    opacity: 0.4;
    color: #111;
    padding: 0 6px;
    margin-right: 20px;
    font-size: 20px;
    line-height: 35px;
  }
  .activated {
    opacity: 1 !important;
  }
  .details {
    text-align: left;
    font-size: 18px;
    width: 800px;
    margin: auto;
  }
  .details span {
    display: block;
    margin-top: 60px;
    color: #fff;
  }
  .details > input {
    width: 100%;
    margin: auto;
    height: 40px;
    border: none;
    outline: none;
    border-bottom: 1px solid #eee;
    background: transparent;
    color: #ddd;
    margin-top: 20px;
  }
  .next {
    width: 800px;
    margin: auto;
    margin-top: 30px;
  }
  .next span{
    background-color: #3cb46e;
    border:none;
    border-radius: 10px;
    color: #fff;
    width: 90px;
    float: right;
    height: 50px;
    font-size: 20px;
    line-height: 50px;
    cursor: pointer;
  }
  .next span:hover {
    background-color: #37a866;
  }
  @media screen and (max-width: 809px) {
    .details, .next {
      width: 90%;
    }
  }
</style>