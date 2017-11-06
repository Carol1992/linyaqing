module.exports = {
	register (data, callback) {
		var md5 = require('md5')
		axios.post('/api/register', {
			user_name: data.user_name,
			email: data.email,
			password: md5(data.password)
		})
		.then(function (response) {
			localStorage.clear()
		  callback(response)
		})
		.catch(function (error) {
		  console.log(error)
		});
	},
	login (data, callback) {
		var md5 = require('md5')
		axios.post('/api/login', {
			email: data.email,
			password: md5(data.password)
		})
		.then(function (response) {
			let info = response.data.data
			if (JSON.stringify(info) === '{}') {
				callback(response)
				return
			}
			localStorage.clear()
		  localStorage.token = info.token
		  localStorage.lq_userId = info.user_id
	    localStorage.lq_is_developer = info.is_developer,
			localStorage.lq_is_admin = info.is_admin,
			localStorage.lq_user_name = info.user_name,
			localStorage.lq_phone = info.phone,
			localStorage.lq_email = info.email,
			localStorage.lq_password = info.password,
			localStorage.lq_province = info.province,
			localStorage.lq_city = info.city,
			localStorage.lq_town = info.town,
			localStorage.lq_image_md5 = info.image_md5,
			localStorage.lq_personal_site = info.personal_site,
			localStorage.lq_wechat = info.wechat,
			localStorage.lq_address = info.address,
			localStorage.lq_bio = info.bio,
			localStorage.lq_created_time = info.created_time,
			localStorage.lq_dev_url = info.dev_url,
			localStorage.lq_dev_desc = info.dev_desc,
			localStorage.lq_delivery_address = info.delivery_address,
			localStorage.lq_delivery_city = info.delivery_city,
			localStorage.lq_delivery_province = info.delivery_province,
			localStorage.lq_delivery_town = info.delivery_town,
			localStorage.lq_consignee = info.consignee,
			localStorage.lq_consignee_phone = info.consignee_phone,
		  callback(response)
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
		avatar () {
			axios.post('/api/updateUserAccount/avatar', {
				token:localStorage.token,
				image_md5:'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509421900187.png'
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
			axios.post('/api/updateUserAccount/delivery', {
				token:localStorage.token,
				delivery_id:'',//不传或为空则默认为新建收货地址，有则为更改该条收货信息
				delivery_address:'1866蓝湾半岛',
				delivery_province:'广西',
				delivery_city:'北海',
				delivery_town:'',
				consignee:'林晴',
				consignee_phone:'18826417583'
			})
			.then(function (response) {
			  console.log(response)
			})
			.catch(function (error) {
			  console.log(error)
			});
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
	}
}
