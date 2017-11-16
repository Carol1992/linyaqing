<template>
  <div class="container">
    <div class="left">
      <div class="title">
        <span>账户设置</span>
      </div>
      <div class="details">
        <div class="profile" @click='isProfile = true; isPhoto = false; isEmail = false; isPwd = false; isApp = false; isDelete = false; nowEdit = "个人信息"' >
          <span :class='{activated: isProfile}'>个人信息</span>
        </div>
        <div class="password" @click='isProfile = false; isPhoto = false; isEmail = false; isPwd = true; isApp = false; isDelete = false; nowEdit = "更改密码"'>
          <span :class='{activated: isPwd}'>更改密码</span>
        </div>
        <div class="photos" @click='getList_user'>
          <span :class='{activated: isPhoto}'>照片管理</span>
        </div>
        <div class="email" @click='isProfile = false; isPhoto = false; isEmail = true; isPwd = false; isApp = false; isDelete = false; nowEdit = "邮件设置"'>
          <span :class='{activated: isEmail}'>邮件设置</span>
        </div>
        <!-- <div class="app" @click='isProfile = false; isPhoto = false; isEmail = false; isPwd = false; isApp = true; isDelete = false; nowEdit = "添加应用"'>
          <span :class='{activated: isApp}'>添加应用</span>
        </div> -->
        <div class="delete" @click='isProfile = false; isPhoto = false; isEmail = false; isPwd = false; isApp = false; isDelete = true; nowEdit = "删除账户"'>
          <span :class='{activated: isDelete}'>删除账户</span>
        </div>
      </div>
    </div>
    <div class="right">
      <div class="setting_title">{{nowEdit}}</div>
      <div class="isProfile" v-if='isProfile'>
        <div class="part1">
          <div class="user_avatar">
            <div class="myavatar">
              <img :src='info.image_md5' alt="">
            </div>
            <span id="changeIco" @click='changeAvatar1'>更换头像</span>
            <input type="file" class="hidden-file-upload" id="uploadImg" @change='changeAvatar2'>
          </div>
          <div class="user_info">
            <div class="account">
              <span><Icon type="email"></Icon> 邮 箱</span>
              <input type="text" maxlength="50" v-model='info.email'>
            </div>
            <div class="username">
              <span><Icon type="person"></Icon> 昵 称</span>
              <input type="text" maxlength="20" v-model='info.user_name'>
            </div>
            <div class="website">
              <span><Icon type="link"></Icon> 微 信</span>
              <input type="text" maxlength="100" v-model='info.personal_site'>
            </div>
          </div>
        </div>
        <div class="part2">
          <div class="user_loc">
            <span><Icon type="location"></Icon> 住 址</span>
            <input type="text" maxlength="100" v-model='info.address'>
          </div>
          <div class="user_bio">
            <span><Icon type="information-circled"></Icon> 个人简介</span>
            <textarea name="" id="" cols="30" rows="10" v-model='info.bio' maxlength="300"></textarea>
          </div>
          <div class="submit" @click='changeInfo'>
            <input type="button" value='提 交'>
          </div>
        </div>
      </div>
      <div class="isDelete" v-if='isDelete'>
        <div class="warm">
          <p>确定要删除账户吗？删除账户后与账户关联的所有信息都将被清除！</p>
          <p>如果只是要删除部分信息，请导航到具体模块进行删除。</p>
        </div>
        <div class="confirmed" @click='deleteAccount'>
          <input type="button" value='删除账户'>
        </div>
      </div>
      <div class="isPwd" v-if='isPwd'>
        <div class="newpassword">
          <span><Icon type="locked"></Icon> 新密码 <span class="info">(6-20位数字/字母/下划线/中划线)</span></span>
          <input type="password" maxlength="20" v-model='password'>
        </div>
        <div class="newpassword">
          <span><Icon type="locked"></Icon> 确认密码 <span class="info"></span></span>
          <input type="password" maxlength="20" v-model='password_confirmed'>
        </div>
         <div class="submit" @click='changePwd'>
           <input type="button" value='提 交'>
         </div>
      </div>
      <div class="isEmail" v-if='isEmail'>
        <myCheckBox></myCheckBox>
        <div class="submit" @click='changeEmailSettings'>
           <input type="button" value='提 交'>
         </div>
      </div>
      <div class="ifPhoto" v-if='isPhoto'>
        <div class="noData" v-if='noData'>
          <span>您还没有上传过照片:)</span>
        </div>
        <div class="image-edit" v-for='photo in photos'>
          <div class="left-image">
            <img :src='photo.image_md5_new' alt="">
          </div>
          <div class="image-detail">
            <div class="image-choices">
              <span :class='{activated_pic: photo.isExif}' @click='getExif(photo)'>EXIF</span>
              <span :class='{activated_pic: photo.isPic}' @click='getPic(photo)'>关于照片</span>
              <span :class='{activated_pic: photo.isLoc}' @click='getLoc(photo)'>地理信息</span>
              <span :class='{activated_pic: photo.isTag}' @click='getTag(photo)'>标签</span>
              <span :class='{activated_pic: photo.isSet}' @click='getSet(photo)'>设置</span>
            </div>
            <div class="image-exif" v-if='photo.isExif'>
              <div class="image-make">
                <span>Make</span>
                <input type="text" maxlength="50" v-model='photo.make'>
              </div>
              <div class="image-model">
                <span>Model</span>
                <input type="text" maxlength="50" v-model='photo.model'>
              </div>
              <div class="image-focal">
                <span>Focal length (mm)</span>
                <input type="text" maxlength="50" v-model='photo.focalLength'>
              </div>
              <div class="image-aper">
                <span>Aperture (ƒ)</span>
                <input type="text" maxlength="50" v-model='photo.aperture'>
              </div>
              <div class="image-iso">
                <span>ISO</span>
                <input type="text" maxlength="50" v-model='photo.iso'>
              </div>
              <div class="image-shutter">
                <span>Shutter speed (s)</span>
                <input type="text" maxlength="50" v-model='photo.shutterSpeed'>
              </div>
              <div class="created">
                <span>DateTimeOriginal</span>
                <input type="text" maxlength="50" v-model='photo.dateTimeOriginal'>
              </div>
            </div>
            <div class="image-pic" v-if='photo.isPic'>
              <div class="image-title">
                <span>标题</span>
                <input type="text" maxlength="50" v-model='photo.story_title'>
              </div>
              <div class="image-story">
                <span>照片故事</span>
                <textarea name="" id="" cols="30" rows="10" maxlength="600" v-model='photo.story_detail'></textarea>
              </div>
            </div>
            <div class="image-loc" v-if='photo.isLoc'>
              <span>拍摄地址</span>
              <input type="text" maxlength="100" v-model='photo.location'>
            </div>
            <div class="image-tag" v-if='photo.isTag'>
              <span>照片标签</span>
              <input type="text" maxlength="100" v-model='photo.image_tags'>
            </div>
            <div class="image-set" v-if='photo.isSet'>
              <div class="confirmed deletePic" @click='deletePic(photo)'>
                <span>删除照片</span>
              </div>
            </div>
            <div class="submit" @click='updatePhoto(photo)' v-if='!photo.isSet'>
             <input type="button" value='更 新'>
           </div>
          </div>
        </div>
      </div>
    </div>
  <BackTop></BackTop>
  </div>
</template>

<script>
  import myCheckBox from './Settings/CheckBox'
  import userOp from '../../../api/user'
  import aliyunOp from '../../../api/aliyun'
  import photoOp from '../../../api/photos'
  export default {
    name: 'userProfile',
    data () {
      return {
        isProfile: true,
        isPhoto: false,
        isEmail: false,
        isPwd: false,
        isApp: false,
        isDelete: false,
        nowEdit: '个人信息',
        notifyMsg: '',
        password: '',
        password_confirmed: '',
        imgUrl: '',
        currentPage1: 1,
        pageSize: 18000,
        photos: [],
        noData: false
      }
    },
    components: {
      myCheckBox
    },
    methods: {
      success (nodesc) {
        this.$Notice.success({
          title: this.notifyMsg,
          desc: nodesc ? '' : ''
        })
      },
      error (nodesc) {
        this.$Notice.error({
          title: this.notifyMsg,
          desc: nodesc ? '' : ''
        })
      },
      getExif (photo) {
        photo.isExif = true
        photo.isPic = false
        photo.isLoc = false
        photo.isTag = false
        photo.isSet = false
      },
      getPic (photo) {
        photo.isExif = false
        photo.isPic = true
        photo.isLoc = false
        photo.isTag = false
        photo.isSet = false
      },
      getLoc (photo) {
        photo.isExif = false
        photo.isPic = false
        photo.isLoc = true
        photo.isTag = false
        photo.isSet = false
      },
      getTag (photo) {
        photo.isExif = false
        photo.isPic = false
        photo.isLoc = false
        photo.isTag = true
        photo.isSet = false
      },
      getSet (photo) {
        photo.isExif = false
        photo.isPic = false
        photo.isLoc = false
        photo.isTag = false
        photo.isSet = true
      },
      deletePic (photo) {
        photoOp.deleteUserPhoto({image_id: photo.image_id}, (res) => {
          this.getList_user()
          this.notifyMsg = '图片删除成功！'
          this.success(true)
        })
      },
      updatePhoto (photo) {
        photoOp.updatePhoto(photo, (res) => {
          this.notifyMsg = '图片信息更新成功！'
          this.success(true)
        })
      },
      getList_user () {
        this.isProfile = false
        this.isPhoto = true
        this.isEmail = false
        this.isPwd = false
        this.isApp = false
        this.isDelete = false
        this.nowEdit = '照片信息'
        let data = {
          token: localStorage.token,
          pageNo: this.currentPage1,
          pageSize: this.pageSize,
          request_user_id: this.info.user_id
        }
        photoOp.getList.user(data, (res) => {
          let lists = res.data.data.lists
          this.photos = []
          if (lists.length === 0) {
            this.noData = true
            return
          }
          this.noData = false
          for (let i = 0; i < lists.length; i++) {
            lists[i].image_md5_new = lists[i].image_md5 + '?x-oss-process=image/auto-orient,1'
            lists[i].isExif = true
            lists[i].isPic = false
            lists[i].isLoc = false
            lists[i].isTag = false
            lists[i].isSet = false
            this.photos.push(lists[i])
          }
        })
      },
      changeInfo () {
        let data = this.info
        data.token = localStorage.token
        if (!data.email || !data.user_name) {
          this.notifyMsg = '邮箱和昵称不能为空！'
          this.error(true)
          return
        }
        userOp.updateUserAccount.info(data, (res) => {
          if (res.data.code === '1') {
            this.notifyMsg = res.data.desc || '操作失败！'
            this.error(true)
            return
          }
          this.$store.dispatch('getUserInfo')
          this.notifyMsg = '修改成功！'
          this.success(true)
        })
      },
      saveImgToAliyun (formData, file, host, startsWith, saveName) {
        let self = this
        aliyunOp.myPromise(host, formData).then((xhr) => {
          if (xhr.status !== 200) {
            this.notifyMsg = '操作失败！'
            this.error(true)
            return
          }
          if (xhr.status === 200) {
            let imgUrl = host + '/' + startsWith + saveName
            userOp.updateUserAccount.avatar(imgUrl, () => {
              self.$store.dispatch('getUserInfo')
            })
          }
        })
        .catch((err) => {
          console.log(err)
        })
      },
      changePwd () {
        let data = {
          password: this.password,
          password2: this.password_confirmed
        }
        if (data.password !== data.password2) {
          this.notifyMsg = '密码不一致！'
          this.error(true)
          return
        }
        userOp.updateUserAccount.password(data, (res) => {
          if (res.data.code === '1') {
            this.notifyMsg = res.data.desc || '操作失败！'
            this.error(true)
            return
          }
          this.notifyMsg = '密码修改成功！'
          this.success(true)
        })
      },
      deleteAccount () {
        userOp.updateUserAccount.delete((res) => {
          if (res.data.code === '1') {
            this.notifyMsg = res.data.desc || '操作失败！'
            this.error(true)
            return
          }
          this.notifyMsg = '账户成功删除！'
          this.success(true)
          localStorage.removeItem('token')
          this.$store.commit('isLogin', false)
          this.$router.push('/')
        })
      },
      changeEmailSettings () {
        let emailSettings = this.$store.state.emailSettings
        userOp.updateUserAccount.emailSettings(emailSettings, (res) => {
          if (res.data.code === '1') {
            this.notifyMsg = res.data.desc || '操作失败！'
            this.error(true)
            return
          }
          this.$store.dispatch('getUserInfo')
          this.notifyMsg = '邮件提醒设置成功！'
          this.success(true)
        })
      },
      changeAvatar1 () {
        document.getElementById('uploadImg').click()
      },
      changeAvatar2 () {
        let fd = new FormData()
        let file = document.getElementById('uploadImg').files[0]
        if (!file) {
          this.notifyMsg = '请选择文件！'
          this.error(true)
          return
        }
        if (file.type.indexOf('image/') === -1) {
          this.notifyMsg = '文件格式不正确！'
          this.error(true)
          return
        }
        aliyunOp.getAliyunKey((res) => {
          const {accessKeyId, host_user, policy, signature, saveName, startsWith} = res.data.data
          fd.append('OSSAccessKeyId', accessKeyId)
          fd.append('policy', policy)
          fd.append('signature', signature)
          fd.append('key', startsWith + saveName)
          fd.append('success_action_status', 200)
          fd.append('file', file, saveName)
          this.saveImgToAliyun(fd, file, host_user, startsWith, saveName)
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
    }
  }
</script>

<style scoped>
  .container {
    width: 78%;
    margin: auto;
    margin-top: 130px;
  }
  .left {
    width: 25%;
    display: inline-block;
    float: left;
  }
  .right {
    width: 75%;
    display: inline-block;
  }
  .title {
    font-size: 22px;
    font-weight: bolder;
    margin-bottom: 30px;
  }
  .details > div {
    font-size: 18px;
    height: 50px;
    color: #979797;
    cursor: pointer;
  }
  .details > div > span {
    display: inline-block;
    border-bottom: 1px solid #979797
  }
  .activated {
    color: #000;
    font-weight: bolder;
    border-bottom: 1px solid #ddd !important;
  }
  .activated_pic {
    color: #000 !important;
    font-weight: bolder;
    border-bottom: 1px solid #111 !important;
  }
  .part1 > div {
    display: inline-block;
    float: left;
  }
  .setting_title {
    font-size: 18px;
    font-weight: bolder;
  }
  .user_avatar {
    width: 40%;
    text-align: center;
    padding-top: 30px;
  }
  .user_info {
    width: 60%;
  }
  .account > span, .website > span, .newpassword > span, .username > span, .user_bio > span, .user_loc > span {
    display: block;
    font-size: 18px;
    font-weight: bolder;
  }
  .account {
    margin-bottom: 30px;
  }
  .username {
    margin-bottom: 30px;
  }
  .user_loc {
    margin-bottom: 30px;
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
  .submit{
    margin-top: 30px;
    text-align: center;
  }
  .submit >input {
    background-color: #000;
    color: #fff;
    font-size: 18px;
    font-weight: bolder;
    cursor: pointer;
  }
  .myavatar {
    width: 150px;
    height: 150px;
    border-radius: 50%;
    overflow: hidden;
    margin: auto;
  }
  .myavatar > img {
    width: 150px;
    height: 150px;
  }
  textarea {
    height: 160px;
    resize: none;
  }
  #changeIco {
    margin-top: 10px;
    font-size: 16px;
    display: inline-block;
    border-bottom: 1px solid #979797;
    color: #979797;
    cursor: pointer;
  }
  .confirmed input {
    background-color: #E25C3D;
    color: #fff;
    outline: none;
    border: none;
    font-size: 17px;
    cursor: pointer;
  }
  .warm {
    font-size: 17px;
    margin-top: 30px;
    margin-bottom: 30px;
  }
  .warm p {
    line-height: 30px;
  }
  .newpassword{
    margin-top: 30px;
  }
  .isEmail {
    margin-top: 30px;
  }
  .error {
    text-align: center;
    color: orangered;
    margin-top: 5px;
  }
  .hidden-file-upload {
    display: none;
  }
  .ifPhoto {
    margin-top: 30px;
  }
  .image-edit {
    width: 100%;
    clear: both;
    margin-bottom: 40px;
  }
  .left-image {
    width: 35%;
    display: inline-block;
    float: left;
    margin-right: 5%;
  }
  .image-detail {
    width: 60%;
    display: inline-block;
  }
  .left-image img {
    width: 100%;
    margin-top: 5px;
  }
  .image-choices span {
    font-size: 16px;
    color: #979797;
    margin-right: 20px;
    cursor: pointer;
    border-bottom: 1px solid #979797;
  }
  .image-choices {
    margin-bottom: 20px;
  }
  .image-exif > div, .image-pic > div {
    margin-bottom: 10px;
  }
  span {
    font-size: 16px;
  }
  .deletePic span {
    color: orangered;
    text-decoration: underline;
    cursor: pointer;
  }
  .image-story textarea{
    min-height: 200px;
  }
  .noData {
    width: 100%;
    height: 200px;
    text-align: center;
  }
  .noData > span {
    line-height: 200px;
    font-size: 18px;
  }
  @media screen and (max-width: 809px) {
    .left {
      display: block;
      clear: both;
    }
    .right {
      display: block;
      clear: both;
      width: 100%;
    }
    .setting_title {
      visibility: hidden;
    }
    .myavatar {
      width: 120px;
      height: 120px;
      border-radius: 50%;
      overflow: hidden;
      margin: auto;
    }
    .myavatar > img {
      width: 120px;
      height: 120px;
    }
  }
  @media screen and (max-width: 1280px){
   .left-image {
      width: 100%;
      display: block;
      margin-right: 0
    }
    .image-detail {
      width: 100%;
    }
  }
</style>