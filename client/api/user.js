module.exports = {
	register () {
		var md5 = require('md5')
		axios.post('/api/register', {
			user_name:'carol2',
			email:'carol2@gmail.com',
			password:md5('000000')
		})
		.then(function (response) {
		  console.log(response)
		})
		.catch(function (error) {
		  console.log(error)
		});
	},
	login () {
		var md5 = require('md5')
		axios.post('/api/login', {
			email:'carol2@gmail.com',
			password:md5('000000')
		})
		.then(function (response) {
		  console.log(response)
		  localStorage.token = response.data.data.token
		})
		.catch(function (error) {
		  console.log(error)
		});
	},
	updateUserAccount: {
		info () {
			axios.post('/api/updateUserAccount/info', {
				token:localStorage.token,
				image_md5: 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509425371413.jpeg', 
				email: 'carol2@gmail.com',
				user_name: 'carol2',
				personal_site: 'http://linyaqing.com',
				wechat: '18826417583',
				location: '1866绿景小区',
				bio: '读书多了，容颜自然改变，许多时候，自己可能以为许多看过的书籍都成了过眼云烟，不复记忆，其实他们仍是潜在的。在气质里，在谈吐上，在胸襟的无涯，当然也可能显露在生活和文字里。',
				province: '广东',
				city: '深圳',
				town: '龙华区'
			})
			.then(function (response) {
			  console.log(response)
			})
			.catch(function (error) {
			  console.log(error)
			});
		},
		password () {
			var md5 = require('md5')
			axios.post('/api/updateUserAccount/password', {
				token:localStorage.token,
				password:md5('aaaaaa')
			})
			.then(function (response) {
			  console.log(response)
			})
			.catch(function (error) {
			  console.log(error)
			});
		},
		delete () {
			axios.post('/api/updateUserAccount/delete', {
				token:localStorage.token
			})
			.then(function (response) {
			  console.log(response)
			})
			.catch(function (error) {
			  console.log(error)
			});
		},
		emailSettings () {
			axios.post('/api/updateUserAccount/emailSettings', {
				token:localStorage.token,
				email_settings:'1,2,3,4'
			})
			.then(function (response) {
			  console.log(response)
			})
			.catch(function (error) {
			  console.log(error)
			});
		},
		developer () {
			axios.post('/api/updateUserAccount/developer', {
				token:localStorage.token,
				url: 'http://baidu.com',
				description: '读书多了，容颜自然改变，许多时候，自己可能以为许多看过的书籍都成了过眼云烟，不复记忆，其实他们仍是潜在的。在气质里，在谈吐上，在胸襟的无涯，当然也可能显露在生活和文字里。'
			})
			.then(function (response) {
			  console.log(response)
			})
			.catch(function (error) {
			  console.log(error)
			});
		},
		delivery () {

		}
	},
	getUserApplication () {
		axios.post('/api/getUserApplication', {
			token:localStorage.token,
			pageNo:1,
			pageSize:5
		})
		.then(function (response) {
		  console.log(response)
		})
		.catch(function (error) {
		  console.log(error)
		});
	},
	deleteUserPhoto () {
		axios.post('/api/deleteUserPhoto', {
			token:localStorage.token,
			image_id:'1'
		})
		.then(function (response) {
		  console.log(response)
		})
		.catch(function (error) {
		  console.log(error)
		});
	},
	addNewApp () {
		axios.post('/api/addNewApp', {
			token:localStorage.token,
			app_name: 'my_first_app',
			app_desc: '我的第一个应用，展示hello world',
			callback_url:'http://linyaqing.com',
			permissions: '1,2' // id 之间用逗号隔开
		})
		.then(function (response) {
		  console.log(response)
		})
		.catch(function (error) {
		  console.log(error)
		});
	},
	getUntagedPhoto () {
		axios.post('/api/getUntagedPhoto', {})
		.then(function (response) {
		  console.log(response)
		})
		.catch(function (error) {
		  console.log(error)
		});
	},
	updatePhotoTag () {
		axios.post('/api/updatePhotoTag', {
			image_id:'7',
			tag:'carol,lynn,jsjsjs'
		})
		.then(function (response) {
		  console.log(response)
		})
		.catch(function (error) {
		  console.log(error)
		});
	},
	uploadPhotoToAliyun () {
		axios.post('/api/uploadPhotoToAliyun', {
			token:localStorage.token,
			processData: false,
			contentType: false
		})
		.then(function (response) {
		  console.log(response)
		})
		.catch(function (error) {
		  console.log(error)
		});
	},
	uploadProductImageToAliyun () {
		axios.post('/api/uploadProductImageToAliyun', {
			token:localStorage.token,
			processData: false,
			contentType: false
		})
		.then(function (response) {
		  console.log(response)
		})
		.catch(function (error) {
		  console.log(error)
		});
	},
	getProducts: {
		new () {
			axios.post('/api/getProducts/new', {
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
			axios.post('/api/getProducts/hot', {
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
			axios.post('/api/getProducts/all', {
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
			axios.post('/api/getProducts/self', {
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
		axios.post('/api/addToCart', {
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
		axios.post('/api/getProductsInCart', {
			token:localStorage.token
		})
		.then(function (response) {
		  console.log(response)
		})
		.catch(function (error) {
		  console.log(error)
		});
	},
	getProductDetails () {
		axios.post('/api/getProductDetails', {
			product_id: 1
		})
		.then(function (response) {
		  console.log(response)
		})
		.catch(function (error) {
		  console.log(error)
		});
	},
	getCategories () {

	},
	updateUserCategories () {

	},
	getPhotographers () {

	},
	updatePhotographers () {

	},
	getAllImages () {

	},
	uploadProducts () {

	},
	addProductImages () {

	},
	removeFromCart () {

	},
	getDeliveryAddress () {

	},
	changeStocks () {

	},
	uploadUserPhoto () {

	},
	placeOrder () {

	},
	getCollection: {
		all () {

		},
		user () {

		},
		one () {

		}
	},
	getList: {
		new () {

		},
		hot () {

		},
		following () {

		}
	},
	search () {

	}
}
