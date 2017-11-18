<template>
  <div class="container">
    <div class="introduction">
      <h1>Sharing Life</h1>
      <h3>相册分享，免费下载，好友互赞，记录生活点点滴滴。</h3>
    </div>
    <Collections :collections='collections' @showCovers='showCovers'></Collections>
    <BackTop></BackTop>
  </div>
</template>

<script>
  import photoOp from '../../api/photos'
  import Collections from './photos/Collections'
  import $ from 'jquery'
  export default {
    name: 'collection_home',
    components: {
      Collections
    },
    data () {
      return {
        collections: [],
        currentPageNo: 1,
        pageSize: 20
      }
    },
    methods: {
      onScroll () {
        if ($(window).scrollTop() + $(window).height() > $(document).height() - 100) {
          $(window).unbind('scroll')
          this.currentPageNo ++
          this.getCollection_all().then(() => {
            $(window).bind('scroll', this.onScroll)
          })
        }
      },
      showCovers (c) {
        c.showCover = !c.showCover
      },
      getCollection_all () {
        let data = {
          pageNo: this.currentPageNo,
          pageSize: this.pageSize
        }
        return new Promise((resolve, reject) => {
          photoOp.getCollection.all(data, (res) => {
            let lists = res.data.data.lists
            for (let l of lists) {
              let newArr = []
              for (let image of l.images_list) {
                image = this.$store.state.urlBase + image + this.$store.state.viewBase
                newArr.push(image)
              }
              l.images_list = newArr
              l.showCover = false
              this.collections.push(l)
            }
          })
        })
      }
    },
    computed: {
      info () {
        return this.$store.state.userInfo
      },
      login () {
        return this.$store.state.alreadyLogin
      }
    },
    mounted () {
      if (localStorage.token) {
        this.$store.commit('isLogin', true)
      } else {
        this.$store.commit('isLogin', false)
      }
      if (this.login) {
        this.$store.dispatch('getUserInfo')
      }
      this.collections = []
      this.getCollection_all()
      this.$nextTick(function () {
      // window.addEventListener('scroll', this.onScroll)
        $(window).scroll(this.onScroll)
      })
    }
  }
</script>

<style scoped>
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
  @media screen and (max-width: 809px) {
    .introduction h1 {
      font-size: 36px;
    }
    .introduction h3 {
      font-size: 14px;
    }
  }
</style>