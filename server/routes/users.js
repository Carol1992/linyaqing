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
	}
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
			console.log(data);
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
// 修改用户关联账户
router.post('/updateUserAccount/social', verify_token, (req, res, next) => {

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

router.post('/getUserApplication', verify_token, (req, res, next) => {

});

router.post('/deleteUserPhoto', verify_token, (req, res, next) => {

});

router.post('/updateUserEmailSettings', verify_token, (req, res, next) => {

});

router.post('/registerAsDeveloper', verify_token, (req, res, next) => {

});

router.post('/addNewApp', verify_token, (req, res, next) => {

});

router.post('/getUntagedPhoto', verify_token, (req, res, next) => {

});

router.post('/updatePhotoTag', verify_token, (req, res, next) => {

});

router.post('/uploadPhotoToZimg', verify_token, (req, res, next) => {

});

router.post('/getCategories/all', verify_token, (req, res, next) => {

});

router.post('/updateUserCategories', verify_token, (req, res, next) => {

});

router.post('/getPhotographers/all', verify_token, (req, res, next) => {

});

router.post('/updatePhotographers', verify_token, (req, res, next) => {

});
module.exports = router;


