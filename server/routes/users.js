let express = require('express');
let router = express.Router();
// 连接到数据库
let formater = require('../database/format');
let query = require('../database/connection');
// 密码加密
let crypto = require('crypto');
// 登录用户token管理
let jwt = require('jsonwebtoken');
let verify_token= require('./verify_token');
// 阿里云OSS
var co = require('co');
var OSS = require('ali-oss');
var client = new OSS({
  region: 'oss-cn-beijing',
  accessKeyId: 'LTAIwPMitAtsf3Zu',
  accessKeySecret: 'h2PVOlE9nHXfe4JHI1CXBwGTGm9dnq'
});
// 处理表单上传
var formidable = require('formidable');
var util = require('util');
// 用户注册
router.post('/register', function(req, res, next) {
	let _user = req.body;
	let md5 = crypto.createHash("md5");
	let post = {
		first_name : _user.first_name,
		last_name : _user.last_name,
		user_name : _user.user_name,
		email : _user.email,
		password : _user.password
	};
	if(!post.user_name) {
		return res.json(formater({code:'1', desc:'用户名不能为空哦！'}));
	}
	if(!post.email) {
		return res.json(formater({code:'1', desc:'邮件不能为空！'}));
	}
	if(!post.password) {
		return res.json(formater({code:'1', desc:'密码不能为空'}));
	} else {
		post.password = md5.update(post.password).digest("hex")
	}
	query('SELECT * FROM users WHERE email = ?', [post.email])
		.then(function(data) {
			if(data.results.length > 0) {
				console.log('user existed, insert failed.')
				return res.json(formater({code:'1', desc:'使用该邮件注册的用户已经存在'}));
			} else {
				query('INSERT INTO users SET ?', [post])
					.then(function() {
						query('SELECT * FROM users WHERE email = ?', [post.email])
							.then(function(data) {
								res.json(formater({code:'0', data:data.results[0]}));
							})
					})
			}
		})
		.catch(function(error) {
			res.json(formater({success:'false', code:'-1', desc:'sql operation error.'}));
			throw error;
		});
});
// 用户登录
router.post('/login', function(req, res, next) {
	let _user = req.body;
	let md5 = crypto.createHash("md5");
	let post = {
		email : _user.email,
		password : _user.password
	}
	if(!post.email) {
		return res.json(formater({code:'1', desc:'邮件不能为空！'}));
	}
	if(!post.password) {
		return res.json(formater({code:'1', desc:'密码不能为空'}));
	}
	query('SELECT * FROM users WHERE email = ?', [post.email])
		.then(function(data) {
			if(data.results.length === 0) {
				console.log('user not existed.')
				return res.json(formater({code:'1', desc:'该邮箱尚未注册，请先注册！'}));
			}
			if(post.password === data.results[0].password) {
	  		// 登录成功返回该用户的token，之后需要用到权限的地方都要带上token到后台查询
	  		data.results[0].token = jwt.sign({data: data.results[0]}, 'secret', { expiresIn: '24h' });
	  		res.json(formater({code:'0', desc:'登录成功！', data:data.results[0]}))
	  	} else {
	  		res.json(formater({code:'1', desc:'密码错误！'}))
	  	}
		})
		.catch(function(error) {
			res.json(formater({success:'false', code:'-1', desc:'sql operation error.'}));
			throw error;
		});
});
// 修改用户信息
router.post('/updateUserAccount/info', verify_token, (req, res, next) => {
	let _user = req.body;
	let post = {
		user_id: req.api_user.data.user_id,
		image_md5: _user.image_md5,
		first_name: _user.first_name,
		last_name: _user.last_name,
		email: _user.email,
		user_name: _user.user_name,
		personal_site: _user.personal_site,
		instagram: _user.personal_site,
		twitter: _user.twitter,
		location: _user.location,
		bio: _user.bio,
		province: _user.province,
		city: _user.city,
		town: _user.town
	};
	if(!post.user_name) {
		return res.json(formater({code:'1', desc:'用户名不能为空！'}));
	}
	if(!post.email) {
		return res.json(formater({code:'1', desc:'邮件不能为空！'}));
	}
	// 拿province，city，town去查库确定对应的code，然后存入users表
	// 这里有一个异步执行的坑，执行最后一个query的时候town还未更新为town_code.
	query('SELECT id FROM sa_region WHERE name LIKE "' + post.town + '%"' + 'AND type = 2', '')
		.then(function(data) {
			if(data.results.length === 1) {
		  	post.town = data.results[0].id;
		  }
		})
		.then(function() {
			query('SELECT id FROM sa_region WHERE name LIKE "' + post.city + '%"' + 'AND type = 1', '')
				.then(function(data) {
					if(data.results.length === 1) {
			  		post.city = data.results[0].id;
			  	}
				})
				.then(function() {
					query('SELECT id FROM sa_region WHERE name LIKE "' + post.province + '%"' + 'AND type = 0', '')
						.then(function(data) {
							if(data.results.length === 1) {
					  		post.province = data.results[0].id;
					  	}
						})
						.then(function() {
							query('UPDATE users SET image_md5=?, first_name=?, last_name=?, email=?, user_name=?,' +
							 'personal_site=?, instagram=?, twitter=?, location=?, bio=?, province_code=?, city_code=?, town_code=? WHERE user_id=?', 
							 [post.image_md5, post.first_name, post.last_name, post.email, post.user_name, post.personal_site,
					 			post.instagram, post.twitter, post.location, post.bio, post.province, post.city, post.town, post.user_id])
							.then(function(data) {
								res.json(formater({code:'0', desc:'修改成功！'}))
							})
						})
				})
		})
		.catch(function(error) {
			res.json(formater({success:'false', code:'-1', desc:'sql operation error.'}));
			throw error;
		});
});
// 修改用户密码
router.post('/updateUserAccount/password', verify_token, (req, res, next) => {
	let _user = req.body;
	let post = {
		user_id: req.api_user.data.user_id,
		password: _user.password
	};
	if(!post.password) return res.json(formater({code:'1', desc:'密码不能为空！'}));
	query('SELECT * FROM users WHERE user_id = ?', [post.user_id])
		.then(function(data) {
			if(data.results.length === 0) {
				console.log('user not existed.');
				return res.json(formater({code:'1', desc:'该用户不存在！'}));
			}
		})
		.then(function() {
			query('UPDATE users SET password = ? WHERE user_id = ?', [post.password, post.user_id])
				.then(function(data) {
					res.json(formater({code:'0', desc:'修改成功！'}));
				})
		})
		.catch(function(error) {
			res.json(formater({success:'false', code:'-1', desc:'sql operation error.'}));
			throw error;
		});
});
// 删除账户, 用户存储在其他表格的信息，如添加的应用、邮件设置、关注的category和摄像师等资料，也需要删除。外键的删除规则
// 设置为层叠(cascade)
router.post('/updateUserAccount/delete', verify_token, (req, res, next) => {
	let post = {
		user_id: req.api_user.data.user_id
	};
	query('DELETE FROM users WHERE user_id = ?', [post.user_id])
		.then(function(data) {
			if(data.results.affectedRows === 1) {
	  		res.json(formater({code:'0', desc:'删除成功！'}));
	  	} else {
	  		console.log('user not existed.');
	  		res.json(formater({code:'1', desc:'该用户不存在！'}));
	  	}
		})
		.catch(function(error) {
			res.json(formater({success:'false', code:'-1', desc:'sql operation error.'}));
			throw error;
		});
});
// 修改邮件设置
router.post('/updateUserAccount/emailSettings', verify_token, (req, res, next) => {
	let _user = req.body;
	let user_id = req.api_user.data.user_id;
	let settings = _user.email_settings.split(',');
	let user_settings = [];
	for(let setting of settings) {
		let s = [user_id, setting];
		user_settings.push(s);
	}
	query('DELETE FROM user_email WHERE user_id = ?', [user_id])
		.then(function() {
			query('INSERT INTO user_email(user_id, settings_id) VALUES ?', [user_settings])
				.then(function(data) {
					res.json(formater({code:'0', desc:'邮件设置成功！'}));
				})
		})
		.catch(function(error) {
			res.json(formater({success:'false', code:'-1', desc:'sql operation error.'}));
			throw error;
		});
});
// 用户注册成为developer
router.post('/updateUserAccount/developer', verify_token, (req, res, next) => {
	let _user = req.body;
	let user_id = req.api_user.data.user_id;
	let post = {
		url: _user.url,
		description: _user.description
	};
	query('SELECT is_developer FROM users WHERE user_id = ?', [user_id])
		.then(function(data) {
			if(data.results[0].is_developer === '0') {
				console.log('already register as a developer.');
				return res.json(formater({code:'1', desc:'该用户已经注册为开发者！'}));
			} else {
				query('UPDATE users SET is_developer = ?, dev_url = ?, dev_desc = ? WHERE user_id = ?', ['0', post.url, post.description, user_id])
					.then(function() {
						res.json(formater({code:'0', desc:'开发者注册成功！'}));
					})
			}
		})
		.catch(function(error) {
			res.json(formater({success:'false', code:'-1', desc:'sql operation error.'}));
			throw error;
		});
});
// 获取用户连接的应用
router.post('/getUserApplication', verify_token, (req, res, next) => {
	let _user = req.body;
	let user_id = req.api_user.data.user_id;
	let pageNo = _user.pageNo || 1;
	let pageSize = _user.pageSize || 50;
	let _left = (pageNo - 1) * pageSize;
	let q1 = query('SELECT COUNT(*) AS totalPage FROM applications WHERE user_id = ?', [user_id]);
	Promise.all([q1]).then(values => {
		query('SELECT * FROM (SELECT * FROM applications WHERE user_id = ?) a LIMIT ?,?', [user_id, _left, pageSize])
			.then(data => {
				console.log(data)
				let new_data = {
					pageNo: pageNo,
					pageSize: pageSize,
					totalPage: Math.ceil(values[0].results[0].totalPage / pageSize),
					lists: data.results
				};
				res.json(formater({code:'0', data:new_data}));
			})
	})
	.catch(function(error) {
			res.json(formater({success:'false', code:'-1', desc:'sql operation error.'}));
			throw error;
		});
});
// 删除用户图片
router.post('/deleteUserPhoto', verify_token, (req, res, next) => {
	let _user = req.body;
	let user_id = req.api_user.data.user_id;
	let post = {
		image_id: _user.image_id
	};
	if(!post.image_id) {
		return res.json(formater({code:'0', desc:'请提供所要删除图片的id！'}));
	}
	query('DELETE FROM images WHERE image_id = ?', [post.image_id])
		.then(function(data) {
			console.log(data.results);
			if(data.results.affectedRows === 1) {
				res.json(formater({code:'0', desc:'图片删除成功！'}));
			} else {
				res.json(formater({code:'0', desc:'图片不存在！'}));
			}
		})
		.catch(function(error) {
			res.json(formater({success:'false', code:'-1', desc:'sql operation error.'}));
			throw error;
		});
});
// 用户添加应用
router.post('/addNewApp', verify_token, (req, res, next) => {
	let _user = req.body;
	let post = {
		user_id: req.api_user.data.user_id,
		app_name: _user.app_name,
		app_desc: _user.app_desc,
		callback_url: _user.callback_url
	};
	let permissions = _user.permissions.split(',');
	query('SELECT is_developer FROM users WHERE user_id = ?', [post.user_id])
		.then(function(data) {
			if(data.results[0].is_developer === '1') {
				return res.json(formater({code:'0', desc:'该用户不是开发者，无法添加应用！'}));
			}
			query('INSERT INTO applications SET ?', [post])
				.then(function(data) {
					let inserted_id = data.results.insertId;
					let app_pers = [];
					for(let per of permissions) {
						let app_per = [inserted_id, per];
						app_pers.push(app_per);
					}
					query('INSERT INTO app_permission(app_id, permission_id) VALUES ?', [app_pers])
						.then(function(){
							res.json(formater({code:'0', desc:'添加应用成功！'}));
						})
				})
		})
		.catch(function(error) {
			res.json(formater({success:'false', code:'-1', desc:'sql operation error.'}));
			throw error;
		});
});
// 获取给用户标注的图片
router.post('/getUntagedPhoto', (req, res, next) => {
	query('SELECT * FROM images WHERE enough_tags = "1" LIMIT 1', '')
		.then(function(data) {
			res.json(formater({code:'0', data: data.results[0]}));
		})
		.catch(function(error) {
			res.json(formater({success:'false', code:'-1', desc:'sql operation error.'}));
			throw error;
		});
});
// 提交用户对图片的标注结果
router.post('/updatePhotoTag', (req, res, next) => {
	let _user = req.body;
	let post = {
		image_id: _user.image_id,
		tag: _user.tag // 以逗号分隔
	};
	query('SELECT image_tags FROM images WHERE image_id = ?', [post.image_id])
		.then(function(data) {
			let old_tags = data.results[0].image_tags;
			let new_tags = '';
			if(old_tags) {
				new_tags = data.results[0].image_tags + ',' + post.tag;
			} else {
				new_tags = post.tag;
			}
			query('UPDATE images SET image_tags = ? WHERE image_id = ?', [new_tags, post.image_id])
				.then(function() {
					res.json(formater({code:'0', desc:'标签更新成功！'}));
				})
		})
		.catch(function(error) {
			res.json(formater({success:'false', code:'-1', desc:'sql operation error.'}));
			throw error;
		});
});
// 更新用户关注的摄影师
router.post('/updatePhotographers', verify_token, (req, res, next) => {
	let _user = req.body;
	let user_id = req.api_user.data.user_id;
	let settings = req.body.followings.split(',');
	let user_settings = [];
	for(let setting of settings) {
		let s = [user_id, setting];
		user_settings.push(s);
	}
	query('DELETE FROM relationships WHERE user_id = ?', [user_id])
		.then(function() {
			query('INSERT IGNORE INTO relationships(user_id, follower_id) VALUES ?', [user_settings])
				.then(function(data) {
					res.json(formater({code:'0', desc:'摄影师列表更新成功！'}));
				})
		})
		.catch(function(error) {
			res.json(formater({success:'false', code:'-1', desc:'sql operation error.'}));
			throw error;
		});
});
// 获取推荐的摄影师
router.post('/getPhotographers', (req, res, next) => {
	query('SELECT users.user_id, users.user_name, users.image_md5, users.instagram, ' + 
			'a.follower_nums FROM users, (SELECT user_id, COUNT(follower_id) AS follower_nums ' + 
				' FROM relationships GROUP BY user_id ORDER BY follower_nums DESC LIMIT 0,25) a WHERE a.user_id = users.user_id', '')
		.then(function(data) {
			res.json(formater({code:'0', data: data.results}));
	})
	.catch(function(error) {
			res.json(formater({success:'false', code:'-1', desc:'sql operation error.'}));
			throw error;
		});
});
// 关键字搜索
router.post('/search', (req, res, next) => {
	let _user = req.body;
	let keyword = _user.keyword;
	let q1 = query('SELECT COUNT(DISTINCT user_id) AS all_users, COUNT(DISTINCT image_id) AS all_images, ' + 
		'COUNT(DISTINCT collection_id) AS all_collections ' + 
		'FROM images WHERE image_tags LIKE "%' + keyword + '%"', '');
	let q2 = query('SELECT images.image_id, images.image_md5, images.liked, users.user_id, users.user_name, ' + 
		'users.image_md5 FROM images, users WHERE images.user_id = users.user_id AND image_tags LIKE "%' + keyword + '%"', '');
	Promise.all([q1, q2]).then(values => {
		let response = {
			basic_info: {
				photos: values[0].results[0].all_images,
				collections: values[0].results[0].all_collections,
				users: values[0].results[0].all_users
			},
			lists: values[1].results
		};
		res.json(formater({code:'0', data:response}));
	})
	.catch(function(error) {
			res.json(formater({success:'false', code:'-1', desc:'sql operation error.'}));
			throw error;
		});
});
// 获取所有类别
router.post('/getCategories', (req, res, next) => {
	query('SELECT * FROM categories', '')
		.then(function(data) {
			res.json(formater({code:'0', data: data.results}));
		})
	.catch(function(error) {
			res.json(formater({success:'false', code:'-1', desc:'sql operation error.'}));
			throw error;
		});
});
// 更新用户关注的类别
router.post('/updateUserCategories', verify_token, (req, res, next) => {
	let _user = req.body;
	let user_id = req.api_user.data.user_id;
	let settings = _user.categories.split(',');
	let user_settings = [];
	for(let setting of settings) {
		let s = [user_id, setting];
		user_settings.push(s);
	}
	query('DELETE FROM user_category WHERE user_id = ?', [user_id])
		.then(function() {
			query('INSERT INTO user_category(user_id, category_id) VALUES ?', [user_settings])
				.then(function(data) {
					res.json(formater({code:'0', desc:'用户关注的类别更新成功！'}));
				})
		})
		.catch(function(error) {
			res.json(formater({success:'false', code:'-1', desc:'sql operation error.'}));
			throw error;
		});
});
// 获取最新图片列表
router.post('/getList/new', (req, res, next) => {
	let _user = req.body;
	let pageNo = _user.pageNo || 1;
	let pageSize = _user.pageSize || 50;
	let _left = (pageNo - 1) * pageSize;
	let q1 = query('SELECT COUNT(*) AS totalPage FROM images', '');
	let q2 = query('SELECT * FROM (SELECT * FROM images ORDER BY created_time DESC) a LIMIT ?,?', [_left, pageSize]);
	Promise.all([q1, q2]).then(values => {
		let new_data = {
				pageNo: pageNo,
				pageSize: pageSize,
				totalPage: Math.ceil(values[0].results[0].totalPage / pageSize),
				lists: values[1].results
			};
			res.json(formater({code:'0', data:new_data}))
	})
	.catch(function(error) {
			res.json(formater({success:'false', code:'-1', desc:'sql operation error.'}));
			throw error;
		});
});
// 获取最热图片列表
router.post('/getList/hot', (req, res, next) => {
	let _user = req.body;
	let pageNo = _user.pageNo || 1;
	let pageSize = _user.pageSize || 50;
	let _left = (pageNo - 1) * pageSize;
	let q1 = query('SELECT COUNT(*) AS totalPage FROM images', '');
	let q2 = query('SELECT * FROM (SELECT * FROM images ORDER BY liked DESC) a LIMIT ?,?', [_left, pageSize]);
	Promise.all([q1, q2]).then(values => {
		let new_data = {
				pageNo: pageNo,
				pageSize: pageSize,
				totalPage: Math.ceil(values[0].results[0].totalPage / pageSize),
				lists: values[1].results
			};
			res.json(formater({code:'0', data:new_data}))
	})
	.catch(function(error) {
			res.json(formater({success:'false', code:'-1', desc:'sql operation error.'}));
			throw error;
		});
});
// 已登录用户，获取其所关注的作者的图片列表
router.post('/getList/following', verify_token, (req, res, next) => {
	let _user = req.body;
	let user_id = req.api_user.data.user_id;
	let pageNo = _user.pageNo || 1;
	let pageSize = _user.pageSize || 50;
	let _left = (pageNo - 1) * pageSize;
	let q1 = query('SELECT COUNT(*) AS totalPage FROM images, (SELECT follower_id FROM relationships WHERE user_id = ?) a WHERE images.user_id = a.follower_id', [user_id]);
	let q2 = query('SELECT * FROM (SELECT * FROM images, (SELECT follower_id FROM relationships WHERE user_id = ?) a WHERE images.user_id = a.follower_id) b LIMIT ?,?', [user_id, _left, pageSize]);
	Promise.all([q1, q2]).then(values => {
		let new_data = {
				pageNo: pageNo,
				pageSize: pageSize,
				totalPage: Math.ceil(values[0].results[0].totalPage / pageSize),
				lists: values[1].results
			};
			res.json(formater({code:'0', data:new_data}));
	})
	.catch(function(error) {
			res.json(formater({success:'false', code:'-1', desc:'sql operation error.'}));
			throw error;
		});
});
// 获取所有图片集
router.post('/getCollection/all', (req, res, next) => {
	let _user = req.body;
	let pageNo = _user.pageNo || 1;
	let pageSize = _user.pageSize || 50;
	let _left = (pageNo - 1) * pageSize;
	let q1 = query('SELECT * FROM collections');
	let q2 = query('SELECT * FROM collections LIMIT ?,?', [_left, pageSize]);
	Promise.all([q1, q2]).then(values => {
		console.log(values);
		let new_data = {
			pageNo: pageNo,
			pageSize: pageSize,
			totalPage: Math.ceil(values[0].results[0].totalPage / pageSize),
			lists: values[1].results
		};
		res.json(formater({code:'0', data:new_data}));
	})
	.catch(function(error) {
			res.json(formater({success:'false', code:'-1', desc:'sql operation error.'}));
			throw error;
	});
});
// 获取用户自己的图片集
router.post('/getCollection/user', verify_token, (req, res, next) => {
	let _user = req.body;
	let user_id = req.api_user.data.user_id;
	let pageNo = _user.pageNo || 1;
	let pageSize = _user.pageSize || 50;
	let _left = (pageNo - 1) * pageSize;
	let q1 = query('SELECT COUNT(collection_id) AS totalPage FROM images WHERE user_id = ? GROUP BY collection_id', [user_id]);
	let q2 = query('SELECT * FROM (SELECT collection_id FROM images WHERE user_id = ? GROUP BY collection_id) a LIMIT ?,?', [user_id, _left, pageSize]);
	Promise.all([q1, q2]).then(values => {
		let new_data = {
			pageNo: pageNo,
			pageSize: pageSize,
			totalPage: Math.ceil(values[0].results[0].totalPage / pageSize),
			lists: values[1].results
		};
		res.json(formater({code:'0', data:new_data}));
	})
	.catch(function(error) {
			res.json(formater({success:'false', code:'-1', desc:'sql operation error.'}));
			throw error;
	});
});
// 获取每个图片集里面的图片
router.post('/getCollection/one', (req, res, next) => {
	let _user = req.body;
	//let user_id = req.api_user.data.user_id;
	let collection_id = _user.collection_id;
	let pageNo = _user.pageNo || 1;
	let pageSize = _user.pageSize || 50;
	let _left = (pageNo - 1) * pageSize;
	let q1 = query('SELECT COUNT(*) AS totalPage FROM images WHERE collection_id = ?', [collection_id]);
	let q2 = query('SELECT * FROM (SELECT * FROM images WHERE collection_id = ?) a LIMIT ?,?', [collection_id, _left, pageSize]);
	Promise.all([q1, q2]).then(values => {
		let new_data = {
			pageNo: pageNo,
			pageSize: pageSize,
			totalPage: Math.ceil(values[0].results[0].totalPage / pageSize),
			lists: values[1].results
		};
		res.json(formater({code:'0', data:new_data}));
	})
	.catch(function(error) {
			res.json(formater({success:'false', code:'-1', desc:'sql operation error.'}));
			throw error;
	});
});
// 用户上传图片
router.post('/uploadUserPhoto', verify_token, (req, res, next) => {
	let _user = req.body;
	let user_id = req.api_user.data.user_id;
	let post = {
		user_id: user_id,
		image_md5: _user.image_md5,
		image_tags: _user.image_tags,
		make: _user.make,
		model: _user.model,
		focalLength: _user.focalLength,
		aperture: _user.aperture,
		iso: _user.iso,
		shutterSpeed: _user.shutterSpeed,
		story_title: _user.title,
		story_detail: _user.story,
		location: _user.address,
		display_location: _user.display,
		collection_id: _user.collection_id
	};
	if(!post.collection_id) {
		query('INSERT INTO collections SET collection_image_md5 = ?', [post.image_md5])
		  .then(data => {
				post.collection_id = data.results.insertId;
				query('INSERT INTO images SET ?', [post])
					.then(values => {
						res.json(formater({code:'0', desc:'图片上传成功！', data:{collection_id: data.results.insertId}}));
					})
			})
			.catch(function(error) {
				res.json(formater({success:'false', code:'-1', desc:'sql operation error.'}));
				throw error;
			});
	} else {
		query('SELECT collection_id FROM collections WHERE collection_id = ?', [post.collection_id])
			.then(data => {
				if(data.results.length === 0) {
					return res.json(formater({code:'0', desc:'插入失败，该id对应的图片集不存在！'}));
				} else {
					query('INSERT INTO images SET ?', [post])
					.then(values => {
						res.json(formater({code:'0', desc:'图片上传成功！', data:{collection_id: post.collection_id}}));
					})
				}
			})
			.catch(function(error) {
				res.json(formater({success:'false', code:'-1', desc:'sql operation error.'}));
				throw error;
			});
	}
});
// 上传图片到服务器
router.post('/uploadPhotoToAliyun', verify_token, (req, res, next) => {
	let ext = req.headers["content-type"].split("/")[1];
	let _user = req.body;
	let user_id = req.api_user.data.user_id;
	var chunks = [];
	var size = 0;
	req.on('data' , function(chunk){
	    chunks.push(chunk);
	    size += chunk.length;
	});
	req.on("end",function(){
	    var buffer = Buffer.concat(chunks, size);
	    co(function* () {
				// 获取bucket列表
			  var result = yield client.listBuckets();
			  var buckets = result.buckets;
			  // 获取第一个bucket内的文件列表
			  client.useBucket(buckets[0].name);
			  var result2 = yield client.list({
			    'max-keys': 5
			  });
		  	var lists = result2.objects;
		  	// 上传图片
		  	var result3 = yield client.put(new Date().getTime() + '.' + ext, buffer);
		  	var url = result3.url;
		  	// 下载文件
		  	// var result4 = yield client.get('object-key', 'local file');
		  	// console.log(result4);
		  	// 删除文件
		  	// var result4 = yield client.delete('object-key');
		  	// console.log(result4);
			  res.json(formater({code:'0', desc:'hi', data:{buckets:buckets, lists:lists, url:url}}));
			}).catch(function (err) {
			  console.log(err);
			});
	});
});

// 获取store中的最新产品列表
router.post('/getProducts/new', (req, res, next) => {

});
// 获取store中的最热产品列表
router.post('/getProducts/hot', (req, res, next) => {

});
// 获取store中所有产品列表
router.post('/getProducts/all', (req, res, next) => {

});
// 获取store中自营的产品列表
router.post('/getProducts/self', (req, res, next) => {

});
// 获取store中友情赞助的产品列表
router.post('/getProducts/friends', (req, res, next) => {

});
// 登录用户将商品加入购物车
router.post('/addToCart', verify_token, (req, res, next) => {

});
// 登录用户获取购物车中的所有商品列表
router.post('/getProductsInCart', verify_token, (req, res, next) => {

});
// 获取单件商品的具体信息
router.post('/getProductDetails', (req, res, next) => {

});
// 用户提交订单步骤1
router.post('/submitOrder/step1', verify_token, (req, res, next) => {

});
// 用户提交订单步骤2
router.post('/submitOrder/step12', verify_token, (req, res, next) => {

});

module.exports = router;


