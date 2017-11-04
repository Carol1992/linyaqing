<template>
  <div class="hello">
    
  </div>
</template>

<script>
// import $ from 'jquery'
import userOp from '../../api/user'
import storeOp from '../../api/store'
import photosOp from '../../api/photos'
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
      photosOp.uploadPhotoToAliyun()
    },
    uploadProductImageToAliyun () {
      photosOp.uploadProductImageToAliyun()
    },
    getProducts_new () {
      storeOp.getProducts.new()
    },
    getProducts_hot () {
      storeOp.getProducts.hot()
    },
    getProducts_all () {
      storeOp.getProducts.all()
    },
    getProducts_self () {
      storeOp.getProducts.self()
    },
    addToCart () {
      storeOp.addToCart()
    },
    getProductsInCart () {
      storeOp.getProductsInCart()
    },
    getProductDetails () {
      storeOp.getProductDetails()
    },
    getCategories () {
      photosOp.getCategories()
    },
    updateUserCategories () {
      photosOp.updateUserCategories()
    },
    getPhotographers () {
      photosOp.getPhotographers()
    },
    updatePhotographers () {
      photosOp.updatePhotographers()
    },
    getAllImages () {
      storeOp.getAllImages()
    },
    search () {
      photosOp.search()
    },
    uploadProducts () {
      storeOp.uploadProducts()
    },
    addProductImages () {
      storeOp.addProductImages()
    },
    removeFromCart () {
      storeOp.removeFromCart()
    },
    getDeliveryAddress () {
      storeOp.getDeliveryAddress()
    },
    changeStocks () {
      storeOp.changeStocks()
    },
    uploadUserPhoto () {
      photosOp.uploadUserPhoto()
    },
    placeOrder () {
      storeOp.placeOrder()
    },
    updateUserAccount_delivery () {
      storeOp.updateUserAccount.delivery()
    },
    getCollection_all () {
      photosOp.getCollection.all()
    },
    getCollection_user () {
      photosOp.getCollection.user()
    },
    getCollection_one () {
      photosOp.getCollection.one()
    },
    getList_new () {
      photosOp.getList.new()
    },
    getList_hot () {
      photosOp.getList.hot()
    },
    getList_following () {
      photosOp.getList.following()
    },
    photoLike () {
      photosOp.photoLike()
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
    // this.photoLike()
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>

</style>
