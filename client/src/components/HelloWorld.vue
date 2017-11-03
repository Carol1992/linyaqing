<template>
  <div class="hello">
    
  </div>
</template>

<script>
// import $ from 'jquery'
import userOp from '../../api/user'
export default {
  name: 'HelloWorld',
  data () {
    return {
      msg: ''
    }
  },
  methods: {
    register () {
      userOp.register()
    },
    login () {
      userOp.login()
    },
    updateUserAccount_info () {
      userOp.updateUserAccount.info()
    },
    updateUserAccount_password () {
      userOp.updateUserAccount.password()
    },
    updateUserAccount_delete () {
      userOp.updateUserAccount.delete()
    },
    getUserApplication () {
      userOp.getUserApplication()
    },
    deleteUserPhoto () {
      userOp.deleteUserPhoto()
    },
    emailSettings () {
      userOp.updateUserAccount.emailSettings()
    },
    developer () {
      userOp.updateUserAccount.developer()
    },
    addNewApp () {
      userOp.addNewApp()
    },
    getUntagedPhoto () {
      userOp.getUntagedPhoto()
    },
    updatePhotoTag () {
      userOp.updatePhotoTag()
    },
    uploadPhotoToAliyun () {
      userOp.uploadPhotoToAliyun()
    },
    uploadProductImageToAliyun () {
      userOp.uploadProductImageToAliyun()
    }
  },
  mounted () {
    // this.register()
    // this.login()
    // this.updateUserAccount_info()
    // this.updateUserAccount_password()
    // this.updateUserAccount_delete()
    // this.getUserApplication()
    // this.deleteUserPhoto()
    // this.emailSettings()
    // this.developer()
    // this.addNewApp()
    // this.getUntagedPhoto()
    // this.updatePhotoTag()
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>

</style>
