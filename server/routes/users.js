let express = require('express');
let router = express.Router();
let formater = require('../database/format');
let query = require('../database/connection');
let crypto = require('crypto');
let jwt = require('jsonwebtoken');
let verify_token= require('./verify_token');
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
		//post.password = md5.update(post.password).digest("hex")
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
// 删除账户
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
	let post = {
		email_settings: _user.email_settings
	};
	query('UPDATE users SET email_settings = ? WHERE user_id = ?', [post.email_settings, user_id])
		.then(function(data) {
			res.json(formater({code:'0', desc:'邮件设置成功！'}));
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
	query('SELECT * FROM applications WHERE user_id = ?', [user_id])
		.then(function(data) {
			res.json(formater({code:'0', data:data.results[0]}))
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
		then(function(data) {
			res.json(formater({code:'0', desc:'图片删除成功！'}));
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
		callback_url: _user.callback_url,
		permissions: _user.permissions // id 之间用逗号隔开
	};
	query('SELECT is_developer FROM users WHERE user_id = ?', [post.user_id])
		.then(function(data) {
			if(data.results[0].is_developer === '1') {
				return res.json(formater({code:'0', desc:'该用户不是开发者，无法添加应用！'}));
			}
			query('INSERT INTO applications SET ?', [post])
				.then(function(data) {
					res.json(formater({code:'0', desc:'添加应用成功！', data: data.results[0]}));
				})
		})
		.catch(function(error) {
			res.json(formater({success:'false', code:'-1', desc:'sql operation error.'}));
			throw error;
		});
});
// 获取给用户标注的图片
router.post('/getUntagedPhoto', (req, res, next) => {
	query('SELECT * FROM images WHERE enough_tags = "1"  LIMIT 1', '')
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
			let new_tags = data.results[0].image_tags + ',' + post.tag;
			query('UPDATE images SET image_tags = ?', [new_tags])
				.then(function() {
					res.json(formater({code:'0', desc:'标签更新成功！'}));
				})
		})
		.catch(function(error) {
			res.json(formater({success:'false', code:'-1', desc:'sql operation error.'}));
			throw error;
		});
});

// 获取推荐的摄影师
router.post('/getPhotographers', (req, res, next) => {
	let recommends = [];
	let q1 = query('SELECT user_id, count(followers) FROM relationships GROUP BY user_id ORDER BY count(followers) DESC LIMIT 25', '');
	let q2 = query('SELECT user_id, liked FROM images ORDER BY liked DESC LIMIT 25', '');
	Promise.all([q1, q2]).then(values => {
		let a = values[0];
		let b = values[1];
		let jsons = [];
		query('SELECT users.user_id, users.user_name, users.image_md5, users.instagram, a.count(followers) FROM users, a WHERE a.user_id = users.user_id', '')
				.then(function(data) {
					res.json(formater({code:'0', data: data.results}));
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
	let followings = req.body.followings.split(',');
	for(let f in followings) {
		query('INSERT INTO relationships SET', [{user_id: user_id, follower_id: f}]);
	}
	res.json(formater({code:'0', desc:'更新成功！'}))
});
// 关键字搜索
router.post('/search', (req, res, next) => {
	let _user = req.body;
	let keyword = _user.keyword;
	let q1 = query('SELECT COUNT(DISTINCT user_id) AS all_users, COUNT(DISTINCT image_id) AS all_images, ' + 
		'COUNT(DISTINCT collection_id) AS all_collections ' + 
		'FROM images WHERE image_tags LIKE "' + keyword + '%"', '');
	let q2 = query('SELECT images.image_id, images.image_md5, images.liked, users.user_id, users.name, ' + 
		'users.image_md5 FROM images, users WHERE images.user_id = users.user_id');
	Promise.all([q1, q2]).then(values => {
		let response = {
			basic_info: {
				photos: values[0].all_images,
				collections: values[0].all_collections,
				users: values[0].all_users
			},
			lists: values[1]
		};
		res.json(formater({code:'0', data:response}));
	})
	.catch(function(error) {
			res.json(formater({success:'false', code:'-1', desc:'sql operation error.'}));
			throw error;
		});
});

// todo: 修改用户关联账户
router.post('/updateUserAccount/social', verify_token, (req, res, next) => {
	
});

router.post('/uploadPhotoToZimg', verify_token, (req, res, next) => {

});

router.post('/getCategories/all', (req, res, next) => {

});

router.post('/updateUserCategories', verify_token, (req, res, next) => {

});

// 获取最新图片列表
router.post('/getList/new', (req, res, next) => {

});

// 已登录用户，获取其所关注的作者的图片列表
router.post('/getList/following', verify_token, (req, res, next) => {

});

// 获取所有图片集
router.post('/getCollection/all', (req, res, next) => {

});

// 获取所有画展图片
router.post('/getCollection/curated', (req, res, next) => {

});

// 获取所有专题图片集
router.post('/getCollection/featured', (req, res, next) => {

});

// 获取用户自己的图片集
router.post('/getCollection/user', verify_token, (req, res, next) => {

});

// 用户上传图片
router.post('/uploadUserPhoto/new', verify_token, (req, res, next) => {

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


