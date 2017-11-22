module.exports = {
	getCategories () {
		axios.post('/getCategories', {})
		.then(function (response) {
		  console.log(response)
		})
		.catch(function (error) {
		  console.log(error)
		});	
	},
	updateUserCategories () {
		axios.post('/updateUserCategories', {
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
		axios.post('/getPhotographers', {})
		.then(function (response) {
		  console.log(response)
		})
		.catch(function (error) {
		  console.log(error)
		});	
	},
	updatePhotographers (data, callback) {
		axios.post('/updatePhotographers/add', {
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
		axios.post('/updatePhotographers/rm', {
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
		axios.post('/uploadUserPhoto', {
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
		axios.post('/updatePhoto', data)
		.then(function (response) {
		  callback(response)
		})
		.catch(function (error) {
		  console.log(error)
		});
	},
	deleteUserPhoto (data, callback) {
		axios.post('/deleteUserPhoto', {
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
		axios.post('/deleteCollection', {
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
		axios.get('/download/photo', {
			params: {
				filename: data.filename
			}
		})
		.then(function (response) {
		  window.location.href = '/download/photo?filename=' + data.filename
		})
		.catch(function (error) {
		  console.log(error)
		});
	},
	getCollection: {
		all (data, callback) {
			axios.post('/getCollection/all', data)
			.then(function (response) {
			  callback(response)
			})
			.catch(function (error) {
			  console.log(error)
			});	
		},
		user (data, callback) {
			axios.post('/getCollection/user', data)
			.then(function (response) {
			  callback(response)
			})
			.catch(function (error) {
			  console.log(error)
			});	
		},
		one (data, callback) {
			data.token = localStorage.token
			axios.post('/getCollection/one', data)
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
		axios.post('/updateCollection', data)
		.then(function (response) {
		  callback(response)
		})
		.catch(function (error) {
		  console.log(error)
		});	
	},
	addToCollection (data, callback) {
		data.token = localStorage.token
		axios.post('/addToCollection', data)
		.then(function (response) {
		  callback(response)
		})
		.catch(function (error) {
		  console.log(error)
		});	
	},
	getCollectionInfo (data, callback) {
		axios.post('/getCollectionInfo', data)
		.then(function (response) {
		  callback(response)
		})
		.catch(function (error) {
		  console.log(error)
		});	
	},
	getList: {
		new (data, callback) {
			axios.post('/getList/new', data)
			.then(function (response) {
			  callback(response)
			})
			.catch(function (error) {
			  console.log(error)
			});	
		},
		hot (data, callback) {
			axios.post('/getList/hot', data)
			.then(function (response) {
			  callback(response)
			})
			.catch(function (error) {
			  console.log(error)
			});	
		},
		following (data, callback) {
			axios.post('/getList/following', data)
			.then(function (response) {
			  callback(response)
			})
			.catch(function (error) {
			  console.log(error)
			});	
		},
		liked (data, callback) {
			axios.post('/getList/liked', data)
			.then(function (response) {
			  callback(response)
			})
			.catch(function (error) {
			  console.log(error)
			});	
		},
		user (data, callback) {
			axios.post('/getList/user', data)
			.then(function (response) {
			  callback(response)
			})
			.catch(function (error) {
			  console.log(error)
			});	
		},
	},
	search (data, callback) {
		axios.post('/search', {
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
		axios.post('/photoLike', {
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
		axios.post('/alreadyLike', {
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