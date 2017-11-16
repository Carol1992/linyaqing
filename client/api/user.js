module.exports = {
	register (data, callback) {
		var md5 = require('md5')
		axios.post('/api/register', {
			user_name: data.user_name,
			email: data.email,
			password: md5(data.password)
		})
		.then(function (response) {
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
			localStorage.removeItem('token')
		  localStorage.token = info.token
		  callback(response)
		})
		.catch(function (error) {
		  console.log(error)
		});
	},
	getUserInfo (data, callback) {
		data.token = localStorage.token
		axios.post('/api/getUserInfo', data)
		.then(function (response) {
		  callback(response)
		})
		.catch(function (error) {
		  console.log(error)
		});
	},
	updateUserAccount: {
		info (data, callback) {
			axios.post('/api/updateUserAccount/info', data)
			.then(function (response) {
			  callback(response)
			})
			.catch(function (error) {
			  console.log(error)
			});
		},
		password (data, callback) {
			var md5 = require('md5')
			axios.post('/api/updateUserAccount/password', {
				token:localStorage.token,
				password:md5(data.password)
			})
			.then(function (response) {
			  callback(response)
			})
			.catch(function (error) {
			  console.log(error)
			});
		},
		delete (callback) {
			axios.post('/api/updateUserAccount/delete', {
				token:localStorage.token
			})
			.then(function (response) {
			  callback(response)
			})
			.catch(function (error) {
			  console.log(error)
			});
		},
		emailSettings (data, callback) {
			axios.post('/api/updateUserAccount/emailSettings', {
				token:localStorage.token,
				email_settings: data
			})
			.then(function (response) {
			  callback(response)
			})
			.catch(function (error) {
			  console.log(error)
			});
		},
		avatar (avatar, callback) {
			axios.post('/api/updateUserAccount/avatar', {
				token:localStorage.token,
				image_md5:avatar
			})
			.then(function (response) {
			  callback(response)
			})
			.catch(function (error) {
			  console.log(error)
			});
		},
		developer (data, callback) {
			axios.post('/api/updateUserAccount/developer', {
				token:localStorage.token,
				url: data.url,
				description: data.desc 
			})
			.then(function (response) {
			  callback(response)
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
