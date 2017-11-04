module.exports = {
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
	getCategories () {
		axios.post('/api/getCategories', {})
		.then(function (response) {
		  console.log(response)
		})
		.catch(function (error) {
		  console.log(error)
		});	
	},
	updateUserCategories () {
		axios.post('/api/updateUserCategories', {
			token:localStorage.token,
			categories:'1,2,3,4'
		})
		.then(function (response) {
		  console.log(response)
		})
		.catch(function (error) {
		  console.log(error)
		});	
	},
	getPhotographers () {
		axios.post('/api/getPhotographers', {})
		.then(function (response) {
		  console.log(response)
		})
		.catch(function (error) {
		  console.log(error)
		});	
	},
	updatePhotographers () {
		axios.post('/api/updatePhotographers', {
			token:localStorage.token,
			followings:'1,2,3,4'
		})
		.then(function (response) {
		  console.log(response)
		})
		.catch(function (error) {
		  console.log(error)
		});	
	},
	uploadUserPhoto () {
		axios.post('/api/uploadUserPhoto', {
			token:localStorage.token,
			image_md5:'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509425905335.jpeg',
			image_tags:'pig, animals',
			make: '2222',
			model: '2222',
			focalLength: '2222',
			aperture: '2222',
			iso: '2222',
			shutterSpeed: '2222',
			story_title: '雅阁',
			story_detail: '照片拍摄于今天早上，天气有点冷',
			location: '广东省深圳市龙华区',
			display_location: '0',
			collection_id: ''
		})
		.then(function (response) {
		  console.log(response)
		})
		.catch(function (error) {
		  console.log(error)
		});	
	},
	getCollection: {
		all () {
			axios.post('/api/getCollection/all', {
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
		user () {
			axios.post('/api/getCollection/user', {
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
		one () {
			axios.post('/api/getCollection/one', {
				collection_id:'19',
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
	getList: {
		new () {
			axios.post('/api/getList/new', {
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
			axios.post('/api/getList/hot', {
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
		following () {
			axios.post('/api/getList/following', {
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
		}
	},
	search () {
		axios.post('/api/search', {
			keyword:'carol'
		})
		.then(function (response) {
		  console.log(response)
		})
		.catch(function (error) {
		  console.log(error)
		});	
	},
	photoLike () {
		axios.post('/api/photoLike', {
			image_id:'8',
			like:'1' // 1代表喜欢该图片，0取消该喜欢
		})
		.then(function (response) {
		  console.log(response)
		})
		.catch(function (error) {
		  console.log(error)
		});	
	}
}