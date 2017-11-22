module.exports = {
	getProducts: {
		new () {
			axios.post('/getProducts/new', {
				pageNo:1,
				pageSize:3
			})
			.then(function (response) {
			  console.log(response)
			})
			.catch(function (error) {
			  console.log(error)
			});
		},
		hot () {
			axios.post('/getProducts/hot', {
				pageNo:1,
				pageSize:3
			})
			.then(function (response) {
			  console.log(response)
			})
			.catch(function (error) {
			  console.log(error)
			});
		},
		all () {
			axios.post('/getProducts/all', {
				pageNo:1,
				pageSize:3
			})
			.then(function (response) {
			  console.log(response)
			})
			.catch(function (error) {
			  console.log(error)
			});
		},
		self () {
			axios.post('/getProducts/self', {
				pageNo:1,
				pageSize:3
			})
			.then(function (response) {
			  console.log(response)
			})
			.catch(function (error) {
			  console.log(error)
			});
		}
	},
	addToCart () {
		axios.post('/addToCart', {
			token: localStorage.token, // 如果是非登录用户将商品放入购物车，则用localStorage在本地记住就好
			product_id: 2,
			quantity: 20 //如果是删减则传负数，比如用户删减了2件，则传-2
		})
		.then(function (response) {
		  console.log(response)
		})
		.catch(function (error) {
		  console.log(error)
		});
	},
	getProductsInCart () {
		axios.post('/getProductsInCart', {
			token:localStorage.token,
			pageNo:1,
			pageSize:3
		})
		.then(function (response) {
		  console.log(response)
		})
		.catch(function (error) {
		  console.log(error)
		});
	},
	getProductDetails () {
		axios.post('/getProductDetails', {
			product_id: 1
		})
		.then(function (response) {
		  console.log(response)
		})
		.catch(function (error) {
		  console.log(error)
		});
	},
	getAllImages () {
		axios.post('/getAllImages', {
			product_id:'1'
		})
		.then(function (response) {
		  console.log(response)
		})
		.catch(function (error) {
		  console.log(error)
		});	
	},	
	uploadProducts () {
		axios.post('/uploadProducts', {
			token:localStorage.token,
			product_md5:'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509425429031.jpeg',
			product_name:'pic-1',
			product_unit:'件',
			product_price:30,
			produst_desc:'good one',
		})
		.then(function (response) {
		  console.log(response)
		})
		.catch(function (error) {
		  console.log(error)
		});	
	},
	addProductImages () {
		axios.post('/addProductImages', {
			token:localStorage.token,
			product_id:8,
			image_name:'pic-2',
			image_url:'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509425272934.jpeg',
			image_desc:'just for good sales',
		})
		.then(function (response) {
		  console.log(response)
		})
		.catch(function (error) {
		  console.log(error)
		});	
	},
	removeFromCart () {
		axios.post('/removeFromCart', {
			token:localStorage.token,
			product_id:1
		})
		.then(function (response) {
		  console.log(response)
		})
		.catch(function (error) {
		  console.log(error)
		});	
	},
	getDeliveryAddress () {
		axios.post('/getDeliveryAddress', {
			token:localStorage.token,
			pageNo:1,
			pageSize:3
		})
		.then(function (response) {
		  console.log(response)
		})
		.catch(function (error) {
		  console.log(error)
		});	
	},
	changeStocks () {
		axios.post('/changeStocks', {
			token:localStorage.token,
			product_id:1,
			stocks:1000,
			unit:'件',
			province:'河南',
			city:'石家庄',
			town:'',
			address:'ss',
			inventory_id:'' //有则修改，无则新增
		})
		.then(function (response) {
		  console.log(response)
		})
		.catch(function (error) {
		  console.log(error)
		});	
	},
	placeOrder () {
		axios.post('/placeOrder', {
			token:localStorage.token,
			delivery_id:1,
			orders: [
				{
					product_id:'12',
					product_quantity:20
				},
				{
					product_id:'1',
					product_quantity:200
				},
			]
		})
		.then(function (response) {
		  console.log(response)
		})
		.catch(function (error) {
		  console.log(error)
		});	
	}
}