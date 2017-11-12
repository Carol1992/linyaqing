<template>
  <div id="container">
    <div class="cover">
      <div class="tags">
        <div class="tag" :class='{activated: isTag}'>
          <span>标签</span>
        </div>
        <div class="exif" :class='{activated: isExif}'>
          <span>EXIF</span>
        </div>
        <div class="gps" :class='{activated: isGps}'>
          <span>GPS</span>
        </div>
        <div class="story" :class='{activated: isStory}'>
          <div>简介</div>
        </div>
      </div>
      <div class="details detail-tag" v-if='isTag'>
        <span>给图片添加一些标签：</span>
        <input type="text" maxlength="100" v-model='photoInfo.image_tags' 
        @focus='changeBorder' @blur='changeBorder2'>
      </div>
      <div class="details detail-exif" v-if='isExif'>
        <span>从照片中获取的EXIF信息：</span>
        <div class="exif-info">
          <span>Make and Model: </span>
          <span>{{photoInfo.Make}} {{photoInfo.Model}}</span>
        </div>
        <div class="exif-info">
          <span>DateTimeOriginal: </span>
          <span>{{photoInfo.DateTimeOriginal}}</span>
        </div>
        <div class="exif-info">
          <span>Shutter Speed (s): </span>
          <span>{{photoInfo.ShutterSpeedValue}}</span>
        </div>
        <div class="exif-info">
          <span>Focal Length (mm): </span>
          <span>{{photoInfo.FocalLength}}</span>
        </div>
        <div class="exif-info">
          <span>Aperture (ƒ): </span>
          <span>{{photoInfo.ApertureValue}}</span>
        </div>
        <div class="exif-info">
          <span>ISO: </span>
          <span>{{photoInfo.ISOSpeedRatings}}</span>
        </div>
      </div>
      <div class="details detail-gps" v-if='isGps'>
        <span>从照片中获取的地理位置信息：</span>
        <div class="latitude loc">
          <span>纬度：</span>
          <span>{{photoInfo.GPSTimeStamp[0]}}</span>
        </div>
        <div class="longitude loc">
          <span>经度：</span>
          <span>{{photoInfo.GPSTimeStamp[1]}}</span>
        </div>
        <div class="height loc">
          <span>高度：</span>
          <span>{{photoInfo.GPSTimeStamp[2]}}</span>
        </div>
        <div class="inputLocation loc">
          <span>拍摄地点：</span>
          <input type="text" maxlength="50" v-model='photoInfo.location' 
          @focus='changeBorder' @blur='changeBorder2'>
        </div>
      </div>
      <div class="details detail-story" v-if='isStory'>
        <p class="intro">
          跟大家分享关于这张照片的故事吧，一句话，一段文字，好久没写过800字作文的你，是否还保持当年的文采？
        </p>
        <div class="story-title">
          <span>标题：</span>
          <input type="text" maxlength="50" v-model='photoInfo.story_title' 
          @focus='changeBorder' @blur='changeBorder2'>
        </div>
        <div class="story-detail">
          <span>关于照片:</span>
          <textarea name="" id="" cols="30" rows="10" maxlength="600" v-model='photoInfo.story_detail' 
          @focus='changeBorder' @blur='changeBorder2'></textarea>
        </div>
      </div>
      <div class="next">
        <span @click='goNext'>{{btnMsg}}</span>
      </div>
    </div>
  </div>
</template>

<script>
  import photoOp from '../../../api/photos'
  export default {
    name: 'photo',
    data () {
      return {
        isTag: true,
        isExif: false,
        isGps: false,
        isStory: false,
        btnMsg: '下一项'
      }
    },
    methods: {
      setBackground () {
        document.getElementById('container').style.backgroundImage = 'url(' + this.imgUrl + '?x-oss-process=image/auto-orient,1)'
      },
      error (nodesc) {
        this.$Notice.error({
          title: this.notifyMsg,
          desc: nodesc ? '' : ''
        })
      },
      goNext () {
        if (this.isTag && !this.isExif) {
          this.isTag = false
          this.isExif = true
          return
        }
        if (this.isExif && !this.isGps) {
          this.isExif = false
          this.isGps = true
          return
        }
        if (this.isGps && !this.isStory) {
          this.isGps = false
          this.isStory = true
          this.btnMsg = '提 交'
          return
        }
        if (this.isStory) {
          this.$store.commit('getPhotoInfo', this.photoInfo)
          this.photoInfo.image_md5 = this.imgUrl
          photoOp.uploadUserPhoto(this.photoInfo, (res) => {
            this.$router.push({path: `/userCenter/${this.info.user_name}`})
          })
        }
      },
      changeBorder (e) {
        e.target.style.borderColor = '#f1f1f1'
      },
      changeBorder2 (e) {
        e.target.style.borderColor = '#999999'
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
      },
      photoInfo () {
        let photoInfo = this.$store.state.photoInfo
        if (!photoInfo.GPSTimeStamp) photoInfo.GPSTimeStamp = ['未知', '未知', '未知']
        return photoInfo
      },
      info () {
        return this.$store.state.userInfo
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
    color: #fff;
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
    font-size: 16px;
    width: 800px;
    margin: auto;
    min-height: 200px;
  }
  .detail-tag span {
    display: block;
    margin-top: 60px;
    color: #fff;
  }
  input, textarea{
    width: 100%;
    margin: auto;
    height: 40px;
    border: none;
    outline: none;
    border-bottom: 1px solid #999999;
    background: transparent;
    color: #ddd;
    margin-top: 20px;
    padding: 0 6px;
  }
  .next {
    width: 800px;
    margin: auto;
    margin-top: 50px;
    display: block;
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
  .detail-exif > span, .detail-gps > span {
    margin-top: 60px;
    margin-bottom: 30px;
    color: #fff;
    display: block;
  }
  .exif-info {
    display: inline-block;
    width: 50%;
    height: 60px;
    font-size: 16px;
    color: #fff;
    float: left;
  }
  .exif-info > span:first-child {
    font-weight: bolder;
  }
  .detail-gps .loc {
    display: inline-block;
    width: 50%;
    height: 50px;
    line-height: 50px;
    font-size: 16px;
    color: #fff;
    float: left;
  }
  .detail-gps .inputLocation {
    display: block;
    width: 100%;
  }
  .inputLocation > input {
    width: 80%;
  }
  .inputLocation > span {
    vertical-align: text-top;
  }
  .detail-story .intro {
    margin-top: 60px;
  }
  .story-title {
    margin-top: 30px;
    margin-bottom: 30px;
  }
  .story-detail textarea{
    border: 1px solid #999999;
    border-radius: 6px;
    height: 140px;
    resize: none;
  }
  .story-title input {
    border: 1px solid #999999;
    border-radius: 6px;
  }
  @media screen and (max-width: 809px) {
    .details, .next {
      width: 90%;
    }
    .exif-info {
      width: 90%;
      margin: auto;
    }
    .next span{
      width: 80px;
      height: 40px;
      font-size: 18px;
      line-height: 40px;
    }
    .tags > div {
      font-size: 18px;
    }
  }
</style>