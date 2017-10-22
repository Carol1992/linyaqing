let {express, router, connection, formater} = require('./common');
let crypto = require('crypto');
// 用户注册
router.post('/register', function(req, res, next) {
	let _user = req.body;
	let md5 = crypto.createHash("md5");
	console.log('post data:\n', _user);
	let post = {
		first_name : _user.firstName,
		last_name : _user.lastName,
		user_name : _user.userName,
		email : _user.email,
		password : _user.password
	}
	if(!post.user_name) {
		res.json(formater({code:'1', desc:'用户名不能为空！'}));
		return;
	}
	if(!post.email) {
		res.json(formater({code:'1', desc:'邮件不能为空！'}));
		return;
	}
	if(!post.password) {
		res.json(formater({code:'1', desc:'密码不能为空'}));
		return;
	} else {
		post.password = md5.update(post.password).digest("hex")
	}
	connection.query('SELECT * FROM users WHERE email = ?', post.email, function(error, results, fields) {
		if (error) {
			formater({success:'false', code:'-1', desc:'mysql select error.'});
			throw error;
		}
		if(results.length > 0) {
			console.log('user existed, insert failed.')
			res.json(formater({code:'1', desc:'使用该邮件注册的用户已经存在'}))
		} else {
			connection.query('INSERT INTO users SET ?', post, function (error, results, fields) {
				if(error) {
					formater({success:'false', code:'-1', desc:'mysql insert error.'});
					throw error;
				}
			  console.log('insert user:\n', post);
			  connection.query('SELECT * FROM users WHERE email = ?', post.email, function(error, results, fileds) {
			  	if(error) {
			  		formater({success:'false', code:'-1', desc:'mysql select error.'});
			  		throw error;
			  	}
			  	res.json(formater({code:'0', data:results[0]}))
			  })
			});
		}
	});
});
// 用户登录
router.post('/login', function(req, res, next) {
	let _user = req.body;
	let md5 = crypto.createHash("md5");
	console.log('post data:\n', _user);
	let post = {
		email : _user.email,
		password : _user.password
	}
	if(!post.email) {
		res.json(formater({code:'1', desc:'邮件不能为空！'}));
		return;
	}
	if(!post.password) {
		res.json(formater({code:'1', desc:'密码不能为空'}));
		return;
	}
	connection.query('SELECT * FROM users WHERE email = ?', post.email, function(error, results, fields) {
		if (error) {
			formater({success:'false', code:'-1', desc:'mysql select error.'});
			throw error;
		}
		if(results.length > 0) {
			connection.query('SELECT * FROM users WHERE email = ?', post.email, function(error, results, fileds) {
		  	if(error) {
		  		formater({success:'false', code:'-1', desc:'mysql select error.'});
		  		throw error;
		  	}
		  	if(post.password === results[0].password) {
		  		// 登录成功返回该用户的token，之后需要用到权限的地方都要带上token到后台查询
		  		res.json(formater({code:'0', desc:'登录成功！', data:results[0]}))
		  	} else {
		  		res.json(formater({code:'1', desc:'密码错误！'}))
		  	}
		  })
		} else {
			console.log('user not existed.')
			res.json(formater({code:'1', desc:'该邮箱尚未注册，请先注册！'}));
		}
	});
});
// 修改用户信息
router.post('/updateUserAccount/info', (req, res, next) => {

});
// 修改用户密码
router.post('/updateUserAccount/password', (req, res, next) => {

});
// 修改用户关联账户
router.post('/updateUserAccount/social', (req, res, next) => {

});
// 删除账户
router.post('/updateUserAccount/delete', (req, res, next) => {

});

module.exports = router;
