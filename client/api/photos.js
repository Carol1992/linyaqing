module.exports = {
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
	updatePhotographers (data, callback) {
		axios.post('/api/updatePhotographers/add', {
			token:localStorage.token,
			followings:data.followings
		})
		.then(function (response) {
		  callback(response)
		})
		.catch(function (error) {
		  console.log(error)
		});	
	},
	updatePhotographers_rm (data, callback) {
		axios.post('/api/updatePhotographers/rm', {
			token:localStorage.token,
			following_id:data.following_id
		})
		.then(function (response) {
		  callback(response)
		})
		.catch(function (error) {
		  console.log(error)
		});	
	},
	uploadUserPhoto (data, callback) {
		axios.post('/api/uploadUserPhoto', {
			token:localStorage.token,
			image_md5:data.image_md5,
			image_tags:data.image_tags,
			make: data.Make,
			model: data.Model,
			dateTimeOriginal: data.DateTimeOriginal,
			focalLength: data.FocalLength,
			aperture: data.ApertureValue,
			iso: data.ISOSpeedRatings,
			shutterSpeed: data.ShutterSpeedValue,
			story_title: data.story_title,
			story_detail: data.story_detail,
			location: data.location,
			display: '0',
			collection_id: data.collection_id
		})
		.then(function (response) {
		  callback(response)
		})
		.catch(function (error) {
		  console.log(error)
		})	
	},
	updatePhoto (data, callback) {
		data.token = localStorage.token
		axios.post('/api/updatePhoto', data)
		.then(function (response) {
		  callback(response)
		})
		.catch(function (error) {
		  console.log(error)
		});
	},
	deleteUserPhoto (data, callback) {
		axios.post('/api/deleteUserPhoto', {
			token:localStorage.token,
			image_id: data.image_id
		})
		.then(function (response) {
		  callback(response)
		})
		.catch(function (error) {
		  console.log(error)
		});
	},
	deleteCollection (data, callback) {
		axios.post('/api/deleteCollection', {
			token:localStorage.token,
			collection_id: data.collection_id
		})
		.then(function (response) {
		  callback(response)
		})
		.catch(function (error) {
		  console.log(error)
		});
	},
	downloadPhoto (data) {
		axios.get('/api/download/photo', {
			params: {
				filename: data.filename
			}
		})
		.then(function (response) {
		  window.location.href = '/api/download/photo?filename=' + data.filename
		})
		.catch(function (error) {
		  console.log(error)
		});
	},
	getCollection: {
		all (data, callback) {
			axios.post('/api/getCollection/all', data)
			.then(function (response) {
			  callback(response)
			})
			.catch(function (error) {
			  console.log(error)
			});	
		},
		user (data, callback) {
			axios.post('/api/getCollection/user', data)
			.then(function (response) {
			  callback(response)
			})
			.catch(function (error) {
			  console.log(error)
			});	
		},
		one (data, callback) {
			data.token = localStorage.token
			axios.post('/api/getCollection/one', data)
			.then(function (response) {
			  callback(response)
			})
			.catch(function (error) {
			  console.log(error)
			});	
		}
	},
	updateCollection (data, callback) {
		data.token = localStorage.token
		axios.post('/api/updateCollection', data)
		.then(function (response) {
		  callback(response)
		})
		.catch(function (error) {
		  console.log(error)
		});	
	},
	addToCollection (data, callback) {
		data.token = localStorage.token
		axios.post('/api/addToCollection', data)
		.then(function (response) {
		  callback(response)
		})
		.catch(function (error) {
		  console.log(error)
		});	
	},
	getCollectionInfo (data, callback) {
		axios.post('/api/getCollectionInfo', data)
		.then(function (response) {
		  callback(response)
		})
		.catch(function (error) {
		  console.log(error)
		});	
	},
	getList: {
		new (data, callback) {
			axios.post('/api/getList/new', data)
			.then(function (response) {
			  callback(response)
			})
			.catch(function (error) {
			  console.log(error)
			});	
		},
		hot (data, callback) {
			axios.post('/api/getList/hot', data)
			.then(function (response) {
			  callback(response)
			})
			.catch(function (error) {
			  console.log(error)
			});	
		},
		following (data, callback) {
			axios.post('/api/getList/following', data)
			.then(function (response) {
			  callback(response)
			})
			.catch(function (error) {
			  console.log(error)
			});	
		},
		liked (data, callback) {
			axios.post('/api/getList/liked', data)
			.then(function (response) {
			  callback(response)
			})
			.catch(function (error) {
			  console.log(error)
			});	
		},
		user (data, callback) {
			axios.post('/api/getList/user', data)
			.then(function (response) {
			  callback(response)
			})
			.catch(function (error) {
			  console.log(error)
			});	
		},
	},
	search (data, callback) {
		axios.post('/api/search', {
			keyword:data.keyword
		})
		.then(function (response) {
		  callback(response)
		})
		.catch(function (error) {
		  console.log(error)
		});	
	},
	photoLike (data, callback) {
		axios.post('/api/photoLike', {
			token: localStorage.token,
			image_id: data.image_id,
			like: data.like // 1代表喜欢该图片，0取消该喜欢
		})
		.then(function (response) {
		  callback(response)
		})
		.catch(function (error) {
		  console.log(error)
		});	
	},
	alreadyLike (data, callback) {
		axios.post('/api/alreadyLike', {
			token: localStorage.token,
			image_id: data.image_id
		})
		.then(function (response) {
		  callback(response)
		})
		.catch(function (error) {
		  console.log(error)
		});	
	}
}