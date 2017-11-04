<template>
  <div class="hello">
    
  </div>
</template>

<script>
// import $ from 'jquery'
import userOp from '../../api/user'
// import storeOp from '../../api/store'
// import photosOp from '../../api/photos'
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
    },
    getProducts_new () {
      userOp.getProducts.new()
    },
    getProducts_hot () {
      userOp.getProducts.hot()
    },
    getProducts_all () {
      userOp.getProducts.all()
    },
    getProducts_self () {
      userOp.getProducts.self()
    },
    addToCart () {
      userOp.addToCart()
    },
    getProductsInCart () {
      userOp.getProductsInCart()
    },
    getProductDetails () {
      userOp.getProductDetails()
    },
    getCategories () {
      userOp.getCategories()
    },
    updateUserCategories () {
      userOp.updateUserCategories()
    },
    getPhotographers () {
      userOp.getPhotographers()
    },
    updatePhotographers () {
      userOp.updatePhotographers()
    },
    getAllImages () {
      userOp.getAllImages()
    },
    search () {
      userOp.search()
    },
    uploadProducts () {
      userOp.uploadProducts()
    },
    addProductImages () {
      userOp.addProductImages()
    },
    removeFromCart () {
      userOp.removeFromCart()
    },
    getDeliveryAddress () {
      userOp.getDeliveryAddress()
    },
    changeStocks () {
      userOp.changeStocks()
    },
    uploadUserPhoto () {
      userOp.uploadUserPhoto()
    },
    placeOrder () {
      userOp.placeOrder()
    },
    updateUserAccount_delivery () {
      userOp.updateUserAccount.delivery()
    },
    getCollection_all () {
      userOp.getCollection.all()
    },
    getCollection_user () {
      userOp.getCollection.user()
    },
    getCollection_one () {
      userOp.getCollection.one()
    },
    getList_new () {
      userOp.getList.new()
    },
    getList_hot () {
      userOp.getList.hot()
    },
    getList_following () {
      userOp.getList.following()
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
    // this.getProducts_new()
    // this.getProducts_hot()
    // this.getProducts_all()
    // this.getProducts_self()
    // this.addToCart()
    // this.getProductsInCart()
    // this.getProductDetails()
    // this.getCategories()
    // this.updateUserCategories()
    // this.getPhotographers()
    // this.updatePhotographers()
    // this.getAllImages()
    // this.search()
    // this.updateUserAccount_delivery()
    // this.uploadProducts()
    // this.addProductImages()
    // this.getDeliveryAddress()
    // this.changeStocks()
    // this.uploadUserPhoto()
    // this.placeOrder()
    // this.getCollection_all()
    // this.getCollection_user()
    // this.getCollection_one()
    // this.getList_new()
    // this.getList_hot()
    // this.getList_following()
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>

</style>
