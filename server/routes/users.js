//let {express, router, connection, formater} = require('./common');
let express = require('express');
let router = express.Router();
let formater = require('../database/format');
let query = require('../database/query');
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
		post.password = md5.update(post.password).digest("hex")
	}
	let query_str = {
		sql: 'SELECT * FROM users WHERE email = ?',
		data: post.email,
		handler: (results) => {
			if(results.length > 0) {
				console.log('user existed, insert failed.')
				res.json(formater({code:'1', desc:'使用该邮件注册的用户已经存在'}))
			} else {
				let query_str2 = {
					sql: 'INSERT INTO users SET ?',
					data: post,
					handler: (results) => {
						console.log('insert user:\n', post);
						let query_str3 = {
							sql: 'SELECT * FROM users WHERE email = ?',
							data: post.email,
							handler: (results) => {
								res.json(formater({code:'0', data:results[0]}))
							}
						};
						query(query_str3.sql, query_str3.data, query_str3.handler, res);
					}
				};
				query(query_str2.sql, query_str2.data, query_str2.handler, res);
			}
		}
	};
	query(query_str.sql, query_str.data, query_str.handler, res);
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
	let query_str = {
		sql: 'SELECT * FROM users WHERE email = ?',
		data: post.email,
		handler: (results) => {
			if(results.length > 0) {
				let query_str2 = {
					sql: 'SELECT * FROM users WHERE email = ?',
					data: post.email,
					handler: (results) => {
						if(post.password === results[0].password) {
				  		// 登录成功返回该用户的token，之后需要用到权限的地方都要带上token到后台查询
				  		results[0].token = jwt.sign({data: results[0]}, 'secret', { expiresIn: '24h' });
				  		res.json(formater({code:'0', desc:'登录成功！', data:results[0]}))
				  	} else {
				  		res.json(formater({code:'1', desc:'密码错误！'}))
				  	}
					}
				};
				query(query_str2.sql, query_str2.data, query_str2.handler, res);
			} else {
				console.log('user not existed.')
				res.json(formater({code:'1', desc:'该邮箱尚未注册，请先注册！'}));
			}
		}
	};
	query(query_str.sql, query_str.data, query_str.handler, res);
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
	}
	if(!post.user_name) {
		return res.json(formater({code:'1', desc:'用户名不能为空！'}));
	}
	if(!post.email) {
		return res.json(formater({code:'1', desc:'邮件不能为空！'}));
	}
	// 拿province，city，town去查库确定对应的code，然后存入users表
	let query_str = {
		sql: 'UPDATE users SET image_md5=?, first_name=?, last_name=?, email=?, user_name=?,' +
	 'personal_site=?, instagram=?, twitter=?, location=?, bio=?, province_code=?, city_code=?, town_code=? WHERE user_id=?',
	 data: [post.image_md5, post.first_name, post.last_name, post.email, post.user_name, post.personal_site,
	 post.instagram, post.twitter, post.location, post.bio, '', '', '', post.user_id],
	 handler: () => {
	 	res.json(formater({code:'0', desc:'修改成功！'}))
	 }
	};
	query(query_str.sql, query_str.data, query_str.handler, res);
});
// 修改用户密码
router.post('/updateUserAccount/password', verify_token, (req, res, next) => {
	let _user = req.body;
	let post = {
		user_id: req.api_user.data.user_id,
		password: _user.password
	};
	if(!post.password) return res.json(formater({code:'1', desc:'密码不能为空！'}));
	let query_str = {
		sql: 'SELECT * FROM users WHERE user_id = ?',
	  data: [post.user_id],
	  handler: (results) => {
	  	if(results.length > 0) {
	  		let query_str2 = {
					sql: 'UPDATE users SET password = ? WHERE user_id = ?',
				  data: [post.password, post.user_id],
				  handler: (results) => {
				  	res.json(formater({code:'0', desc:'修改成功！'}));
				  }
				};
				query(query_str2.sql, query_str2.data, query_str2.handler, res);
	  	} else {
	  		console.log('user not existed.');
				res.json(formater({code:'1', desc:'该用户不存在！'}));
	  	}
	  }
	};
	query(query_str.sql, query_str.data, query_str.handler, res);
});
// 修改用户关联账户
router.post('/updateUserAccount/social', verify_token, (req, res, next) => {

});
// 删除账户
router.post('/updateUserAccount/delete', verify_token, (req, res, next) => {
	let post = {
		user_id: req.api_user.data.user_id
	};
	let query_str = {
		sql: 'DELETE FROM users WHERE user_id = ?',
	  data: [post.user_id],
	  handler: (results) => {
	  	if(results.affectedRows === 1) {
	  		res.json(formater({code:'0', desc:'删除成功！'}));
	  	} else {
	  		console.log('user not existed.');
	  		res.json(formater({code:'1', desc:'该用户不存在！'}));
	  	}
	  }
	};
	query(query_str.sql, query_str.data, query_str.handler, res);
});

module.exports = router;
