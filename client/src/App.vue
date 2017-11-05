<template>
  <div id="app">
    <div class="myheader">
      <LHeader></LHeader>
    </div>
    <div class="introduction">
      <h1>Sharing Life</h1>
      <h3>图片分享，免费下载，好友互赞，记录生活点点滴滴。</h3>
    </div>
    <div class="navigate">
      <span class="nav" :class="{activated: isActivated}" @click='getHot'>最热</span>
      <span class="nav" :class="{activated: isActivated2}" @click='getNew'>最新</span>
      <span class="nav" :class="{activated: isActivated3}" @click='getFollowing'>关注</span>
    </div>
    <Photos :photos="photos"></Photos>
    <router-view/>
  </div>
</template>

<script>
// import $ from 'jquery'
import photosOp from '../api/photos'
import LHeader from './components/LHeader'
import Photos from './components/photos/Photos'
export default {
  name: 'app',
  components: {
    LHeader,
    Photos
  },
  data () {
    return {
      isActivated: true,
      isActivated2: false,
      isActivated3: false,
      currentPage1: 1,
      currentPage2: 1,
      currentPage3: 1,
      pageSize: 18,
      photos: {
        group_a: [],
        group_b: [],
        group_c: []
      }
    }
  },
  methods: {
    changeTitle () {
      document.title = 'Sharing Life'
    },
    onScroll () {
      let documentHeight = document.body.clientHeight
      let pos = 0
      if (document.body.clientWidth < 809) {
        pos = documentHeight * 0.5
      } else {
        pos = documentHeight * 0.7
      }
      if (window.scrollY > pos) {
        if (this.isActivated) {
          this.currentPage1 ++
          this.getList_hot()
        }
        if (this.isActivated2) {
          this.currentPage2 ++
          this.getList_new()
        }
        if (this.isActivated3) {
          this.currentPage3 ++
          this.getList_following()
        }
      }
    },
    getHot () {
      this.currentPage1 = 1
      this.clearData()
      this.getList_hot()
    },
    getNew () {
      this.currentPage2 = 1
      this.clearData()
      this.getList_new()
    },
    getFollowing () {
      this.currentPage3 = 1
      this.clearData()
      this.getList_following()
    },
    clearData () {
      this.photos.group_a = []
      this.photos.group_b = []
      this.photos.group_c = []
    },
    getList_hot () {
      this.isActivated = true
      this.isActivated2 = false
      this.isActivated3 = false
      let data = {
        pageNo: this.currentPage1,
        pageSize: this.pageSize
      }
      photosOp.getList.hot(data, (res) => {
        let lists = res.data.data.lists
        for (let i = 0; i < lists.length; i++) {
          if (i % 3 === 0) {
            this.photos.group_a.push(lists[i])
          }
          if ((i - 1) % 3 === 0) {
            this.photos.group_b.push(lists[i])
          }
          if ((i - 2) % 3 === 0) {
            this.photos.group_c.push(lists[i])
          }
        }
      })
    },
    getList_new () {
      this.isActivated = false
      this.isActivated2 = true
      this.isActivated3 = false
      let data = {
        pageNo: this.currentPage2,
        pageSize: this.pageSize
      }
      photosOp.getList.new(data, (res) => {
        let lists = res.data.data.lists
        for (let i = 0; i < lists.length; i++) {
          if (i % 3 === 0) {
            this.photos.group_a.push(lists[i])
          }
          if ((i - 1) % 3 === 0) {
            this.photos.group_b.push(lists[i])
          }
          if ((i - 2) % 3 === 0) {
            this.photos.group_c.push(lists[i])
          }
        }
      })
    },
    getList_following () {
      this.isActivated = false
      this.isActivated2 = false
      this.isActivated3 = true
      let data = {
        token: localStorage.token,
        pageNo: this.currentPage3,
        pageSize: this.pageSize
      }
      photosOp.getList.following(data, (res) => {
        let lists = res.data.data.lists
        for (let i = 0; i < lists.length; i++) {
          if (i % 3 === 0) {
            this.photos.group_a.push(lists[i])
          }
          if ((i - 1) % 3 === 0) {
            this.photos.group_b.push(lists[i])
          }
          if ((i - 2) % 3 === 0) {
            this.photos.group_c.push(lists[i])
          }
        }
      })
    }
  },
  mounted () {
    this.$nextTick(function () {
      window.addEventListener('scroll', this.onScroll)
    })
    this.changeTitle()
    this.getHot()
  }
}
</script>

<style>
#app {
  font-family: 'Avenir', Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  color: #111;
}
.myheader {
  padding-top: 1%;
  padding-bottom: 1%;
  background-color: #fff;
  position: fixed;
  width: 100%;
  top: 0;
}
.introduction {
  width: 90%;
  margin: auto;
  margin-top: 100px;
  margin-bottom: 70px;
}
.introduction h1 {
  font-size: 46px;
}
.introduction h3 {
  font-size: 18px;
}
.navigate {
  width: 90%;
  margin: auto;
  margin-bottom: 20px;
}
.nav {
  font-size: 20px;
  display: inline-block;
  width: 80px;
  color: #999;
  cursor: pointer;
  font-weight: bolder;
}
.activated {
  color: #111;
  cursor: auto;
}
.nav:hover {
  color: #111;
}
@media screen and (max-width: 809px) {
  .introduction h1 {
    font-size: 36px;
  }
  .introduction h3 {
    font-size: 14px;
  }
}
</style>
