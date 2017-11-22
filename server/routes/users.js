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
var aliyun_folder = 'users/'
var my_secret = require('./secret');
var co = require('co');
var OSS = require('ali-oss');
var fs = require('fs');
var client = new OSS({
  region: my_secret.region,
  accessKeyId: my_secret.accessKeyId,
  accessKeySecret: my_secret.accessKeySecret,
  bucket: my_secret.bucket
});
// 邮箱
var nodemailer  = require('nodemailer');
var mailTransport = nodemailer.createTransport({
    host : 'smtp.mxhichina.com',
    secure: true, // 使用SSL方式（安全方式，防止被窃取信息)
    port: 465,
    auth : {
        user: my_secret.email.user,
        pass: my_secret.email.pass
    },
});
// websocket 推送消息给用户：点赞、关注、评论、私信、购买
var ws = require("nodejs-websocket");
var server = ws.createServer(function (conn) {
  console.log("New connection")
  let data = {
    name:'carol',
    email:'linqing@qq.com',
    bio:'hello world'
  }
  conn.send(JSON.stringify(data))
  conn.on("text", function (str) {
      console.log("Received "+str)
      conn.sendText(str.toUpperCase()+"!!!")
  })
  conn.on("close", function (code, reason) {
      console.log("Connection closed")
  })
}).listen(3001)
// 处理表单上传
var formidable = require('formidable');
var util = require('util');
router.all('/test', (req, res, next) => {
	res.send(__dirname)
})
// 发送邮件
router.all('/send', function(req, res, next) {
  var options = {
    from: '"林晴" <lq@linyaqing.com>',
    to: '1689597038@qq.com, yottalynn@gmail.com',
    cc: '1689597038@qq.com',    //抄送
    // bcc         : ''    //密送
    subject: '一封来自Node Mailer的邮件',
    text: '一封来自Node Mailer的邮件',
    html: '<h1>你好</h1><br/><img src="cid: lq@linyaqing.com"/><br/><img src="cid:lq@linyaqing.top"/>',
    attachments: [{
      filename: 'image.png',
      content: new Buffer(
          'iVBORw0KGgoAAAANSUhEUgAAABAAAAAQAQMAAAAlPW0iAAAABlBMVEUAAAD/' +
              '//+l2Z/dAAAAM0lEQVR4nGP4/5/h/1+G/58ZDrAz3D/McH8yw83NDDeNGe4U' +
              'g9C9zwz3gVLMDA/A6P9/AFGGFyjOXZtQAAAAAElFTkSuQmCC',
          'base64'
      ),
      cid: 'lq@linyaqing.top' // should be as unique as possible
    },
    {
      filename: 'cat.jpg',
      path: 'public/cat.jpg',
      cid: 'lq@linyaqing.com' // should be as unique as possible
    },
    {
        filename: 'notes.txt',
        content: 'Some notes about this e-mail',
        contentType: 'text/plain' // optional, would be detected from the filename
    }
    ]
  };
  mailTransport.sendMail(options, function(err, msg){
    if(err){
        console.log(err);
        res.send(err)
    }
    else {
        console.log(msg);
        res.send(msg)
    }
  });
});
// 用户注册
router.post('/register', function(req, res, next) {
	let _user = req.body;
	let md5 = crypto.createHash("md5");
	let post = {
		user_name : _user.user_name,
		email : _user.email,
		password : _user.password
	};
	if(!post.user_name || !post.email || !post.password) {
		return res.json(formater({code:'1', desc:'参数错误(缺失用户名或密码或邮箱)！'}));
	}
	query('SELECT * FROM users WHERE email = ?', [post.email])
	.then(function(data) {
		if(data.results.length > 0) {
			return res.json(formater({code:'1', desc:'使用该邮件注册的用户已经存在'}));
		} else {
			query('INSERT INTO users SET ?', [post])
			.then(data => {
				res.json(formater({code:'0', desc:'注册成功！', data:{user_id:data.results.insertId}}))
				var options = {
			    from: '"林晴" <lq@linyaqing.com>',
			    to: post.email,
			    cc: '1689597038@qq.com',    //抄送
			    // bcc         : ''    //密送
			    subject: '欢迎注册SharingLife!',
			    //text: '',
			    html: '<h1>你好!欢迎注册。</h1><br/>'+
			    '<h3>有些功能未完善，多多包涵，如下：</h3>'+
			    '<p>1. 注册欢迎信很简陋，还没有设计好模板，望谅:)</p>'+
			    '<p>2. 找回密码的页面还没有挂上去，忘记密码请直接回复该邮件:)</p>'+
			    '<p>3. Store的页面还没有实现，后台端口写得七七八八了，主要是我还没想好具体的操作方式:(</p>'+
			    '<p>4. 操作中遇到问题可以回复该邮件，或微信联系我：18826417583</p>'+
			    '<br/><img src="123"/>',
			    attachments: [
			    {
			      filename: 'cat.jpg',
			      path: 'public/cat.jpg',
			      cid: '123' // should be as unique as possible
			    }
			    ]
			  };
			  mailTransport.sendMail(options, function(err, msg){
			    if(err){
			        console.log(err);
			        res.send(err)
			    }
			    else {
			        console.log(msg);
			        res.send(msg)
			    }
			  });
			})
		}
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
	if(!post.email || !post.password) {
		return res.json(formater({code:'1', desc:'参数错误(缺失密码或邮箱)！'}));
	}
	query('SELECT * FROM users WHERE email = ?', [post.email])
	.then(function(data) {
		if(data.results.length === 0) {
			return res.json(formater({code:'1', desc:'该邮箱尚未注册，请先注册！'}));
		}
		if(post.password === data.results[0].password) {
  		// 登录成功返回该用户的token，之后需要用到权限的地方都要带上token到后台查询
  		data.results[0].token = jwt.sign({data: data.results[0]}, 'secret', { expiresIn: '720h' });
  		query('SELECT settings_id FROM user_email WHERE user_id = ?', [data.results[0].user_id])
  		.then((value) => {
  			let settings = []
  			for(s of value.results) {
  				settings.push(s.settings_id)
  			}
  			data.results[0].email_settings = settings.toString()
  			res.json(formater({code:'0', desc:'登录成功！', data:data.results[0]}))
  		})
  	} else {
  		res.json(formater({code:'1', desc:'密码错误！'}))
  	}
	});
});
// 获取用户信息
router.all('/getUserInfo', (req, res, next) => {
	let token = req.body.token || req.query.token || req.headers['x-access-token'] || '';
	let search_user_id = req.body.user_id || req.query.user_id
	jwt.verify(token, 'secret', function(err, decoded) {
    if (!err) {
      req.api_user = decoded;
      let user_id = req.api_user.data.user_id
      let q1 = query('SELECT * FROM users WHERE user_id = ?', [user_id]);
			let q2 = query('SELECT settings_id FROM user_email WHERE user_id = ?', [user_id]);
			let q3 = query('SELECT following_id FROM relationships WHERE user_id = ?', [user_id]);
			let q4 = query('SELECT user_id AS follower_id FROM relationships WHERE following_id = ?', [user_id]);
			Promise.all([q1, q2, q3, q4]).then(values => {
				let settings = []
				let followings = [] // 我的关注
				let followers = [] // 我的粉丝
				for(let s of values[1].results) {
					settings.push(s.settings_id)
				}
				for(let f of values[2].results) {
					followings.push(f.following_id)
				}
				for(let fr of values[3].results) {
					followers.push(fr.follower_id)
				}
				values[0].results[0].email_settings = settings.toString()
				values[0].results[0].followings = followings.toString()
				values[0].results[0].followers = followers.toString()
				res.json(formater({code:'0', data:values[0].results[0]}))
			})
    }
  })
	if (!token && search_user_id) {
		user_id = search_user_id
		query('SELECT user_name, email, image_md5, wechat, personal_site FROM users WHERE user_id = ?', [user_id])
		.then(data => {
			return res.json(formater({code:'0', data:data.results}))
		})
	}
})
// 修改用户信息
router.post('/updateUserAccount/info', verify_token, (req, res, next) => {
	let _user = req.body;
	let post = {
		user_id: req.api_user.data.user_id,
		email: _user.email,
		user_name: _user.user_name,
		// personal_site: _user.personal_site,
		wechat: _user.wechat,
		address: _user.address,
		bio: _user.bio
		// province: _user.province,
		// city: _user.city,
		// town: _user.town
	};
	if(!post.user_name || !post.email) {
		return res.json(formater({code:'1', desc:'参数错误(确实用户名或邮箱)！'}));
	}
	query('UPDATE users SET email = ?, user_name = ?, wechat = ?, address = ?, bio = ? WHERE user_id = ?', 
		 [post.email, post.user_name, post.wechat, post.address, post.bio, post.user_id])
	.then(function(data) {
		res.json(formater({code:'0', desc:'用户信息修改成功！'}))
	});
});
// 修改用户图片
router.post('/updateUserAccount/avatar', verify_token, (req, res, next) => {
	let user_id = req.api_user.data.user_id
	let avatar = req.body.image_md5
	let saveName = req.body.saveName
	let defaultImg = req.body.defaultImg
	if(!avatar) {
		return res.json(formater({code:'1', desc:'图片不能为空！'}));
	}
	query('UPDATE users SET image_md5 = ? WHERE user_id = ?', [avatar, user_id])
	.then((data) => {
		if (!defaultImg) {
			co(function* () {
			  var result = yield client.delete(aliyun_folder + saveName);
			}).catch(function (err) {
			  console.log(err);
			});
		}
		res.json(formater({code:'0', desc:'用户头像修改成功！'}));
	})
})
// 修改用户密码
router.post('/updateUserAccount/password', verify_token, (req, res, next) => {
	let _user = req.body;
	let post = {
		user_id: req.api_user.data.user_id,
		password: _user.password
	};
	if(!post.password) return res.json(formater({code:'1', desc:'参数错误(密码缺失)！'}));
	query('UPDATE users SET password = ? WHERE user_id = ?', [post.password, post.user_id])
	.then(function(data) {
		res.json(formater({code:'0', desc:'用户密码修改成功！'}));
	})
});
// 删除账户, 用户存储在其他表格的信息，如添加的应用、邮件设置、关注的category和摄像师等资料，也需要删除。
// 外键的删除规则设置为层叠(cascade)
router.all('/updateUserAccount/delete', verify_token, (req, res, next) => {
	let post = {
		user_id: req.api_user.data.user_id
	};
	query('SELECT i.image_md5, u.image_md5 AS avatar FROM images i, users u WHERE '+
		'i.user_id = u.user_id AND u.user_id = ?', [post.user_id])
	.then(data => {
		let results = data.results
		let arr = []
		if (results.length === 0) {
			query('SELECT u.image_md5 AS avatar FROM users u WHERE u.user_id = ?', [post.user_id])
			.then(data2 => {
				results = data2.results
				arr.push(aliyun_folder + results[0].avatar)
				co(function* () {
				  var result = yield client.deleteMulti(arr)
				}).catch(function (err) {
				  console.log(err);
				});
			})
		} else {
			for (r of results) {
				arr.push(aliyun_folder + r.image_md5)
			}
			arr.push(aliyun_folder + results[0].avatar)
			co(function* () {
			  var result = yield client.deleteMulti(arr)
			}).catch(function (err) {
			  console.log(err);
			});
		}
		query('DELETE FROM users WHERE user_id = ?', [post.user_id])
		.then(function(data) {
			if(data.results.affectedRows === 1) {
	  		res.json(formater({code:'0', desc:'账户删除成功！'}));
	  	}
		});
	})
});
// 修改邮件设置
router.post('/updateUserAccount/emailSettings', verify_token, (req, res, next) => {
	let _user = req.body;
	let user_id = req.api_user.data.user_id;
	let settings = _user.email_settings.toString();
	if (!settings) return res.json(formater({code:'1', desc:'参数错误(设置缺失)！'}));
	settings = settings.split(',');
	let user_settings = [];
	for(let setting of settings) {
		let s = [user_id, setting];
		user_settings.push(s);
	}
	query('DELETE FROM user_email WHERE user_id = ?', [user_id])
	.then(function() {
		query('INSERT INTO user_email(user_id, settings_id) VALUES ?', [user_settings])
		.then(function() {
			res.json(formater({code:'0', desc:'邮件设置成功！'}));
		})
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
			return res.json(formater({code:'1', desc:'该用户已经注册为开发者！'}));
		} else {
			query('UPDATE users SET is_developer = ?, dev_url = ?, dev_desc = ? WHERE user_id = ?', ['0', post.url, post.description, user_id])
			.then(function() {
				res.json(formater({code:'0', desc:'开发者注册成功！'}));
			})
		}
	});
});
// 获取用户连接的应用
router.all('/getUserApplication', verify_token, (req, res, next) => {
	let _user = req.body;
	let user_id = req.api_user.data.user_id;
	let pageNo = +_user.pageNo || +req.query.pageNo || 1;
	let pageSize = +_user.pageSize || +req.query.pageSize || 50;
	let _left = (pageNo - 1) * pageSize;
	query('SELECT * FROM applications WHERE user_id = ?', [user_id])
	.then(data => {
		let new_data = {
			pageNo: pageNo,
			pageSize: pageSize,
			totalPage: Math.ceil(data.results.length / pageSize),
			totalCounts: data.results.length,
			lists: data.results.slice(_left, _left+pageSize)
		};
		res.json(formater({code:'0', data:new_data}));
	})
});
// 删除用户图片
router.all('/deleteUserPhoto', verify_token, (req, res, next) => {
	let _user = req.body;
	let user_id = req.api_user.data.user_id;
	let post = {
		image_id: _user.image_id || req.query.image_id
	};
	if(!post.image_id) {
		return res.json(formater({code:'1', desc:'参数错误(缺失图片的id)！'}));
	}
	query('SELECT image_id, image_md5 FROM images WHERE image_id = ? AND user_id = ?', [post.image_id, user_id])
	.then(data => {
		if(data.results.length === 0) {
			return res.json(formater({code:'1', desc:'该图片不属于该用户！'}));
		} else {
			query('SELECT image_md5 FROM images WHERE image_id = ?', [post.image_id])
			.then(data => {
				if (data.results.length === 0) return res.json(formater({code:'1', desc:'图片不存在！'}));
				co(function* () {
				  var result = yield client.delete(aliyun_folder + data.results[0].image_md5);
				}).catch(function (err) {
				  console.log(err);
				});
				query('DELETE FROM images WHERE image_id = ?', [post.image_id])
				.then(function(data) {
					if(data.results.affectedRows === 1) {
						res.json(formater({code:'0', desc:'图片删除成功！'}));
					}
				});
			})
		}
	})
});
// 删除相册
router.all('/deleteCollection', verify_token, (req, res, next) => {
	let user_id = req.api_user.data.user_id;
	let collection_id = req.body.collection_id || req.query.collection_id;
	if(!collection_id) {
		return res.json(formater({code:'1', desc:'参数错误(缺失相册的id)！'}));
	}
	query('SELECT collection_id FROM collections WHERE collection_id = ? AND user_id = ?', [collection_id, user_id])
	.then(data => {
		if(data.results.length === 0) {
			return res.json(formater({code:'1', desc:'该相册不属于该用户！'}));
		}
		query('SELECT ic.image_id, i.image_md5 FROM image_collection ic, images i WHERE '+
			'ic.image_id = i.image_id AND ic.collection_id = ? AND i.user_id = ?', [collection_id, user_id])
		.then(data => {
			let results = data.results
			if (results.length === 0) return res.json(formater({code:'1', desc:'相册不存在！'}));
			let arr = []
			for (let r of results) {
				arr.push(aliyun_folder + r.image_md5)
			}
			co(function* () {
			  var result = yield client.deleteMulti(arr)
			}).catch(function (err) {
			  console.log(err);
			});
			query('DELETE FROM collections WHERE collection_id = ?', [collection_id])
			.then(function(data) {
				if(data.results.affectedRows === 1) {
					res.json(formater({code:'0', desc:'相册删除成功！'}));
				}
			});
		})
	})
})
// 用户添加应用
router.post('/addNewApp', verify_token, (req, res, next) => {
	let _user = req.body;
	let post = {
		user_id: req.api_user.data.user_id,
		app_name: _user.app_name,
		app_desc: _user.app_desc,
		callback_url: _user.callback_url
	};
	let permissions = _user.permissions;
	if (!post.app_name || !permissions) return res.json(formater({code:'1', desc:'参数错误(缺失应用名称或权限)！'}));
	permissions = permissions.split(',');
	query('SELECT is_developer FROM users WHERE user_id = ?', [post.user_id])
	.then(function(data) {
		if(data.results[0].is_developer === '1') {
			return res.json(formater({code:'1', desc:'该用户不是开发者，无法添加应用！'}));
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
	});
});
// 获取给用户标注的图片
router.all('/getUntagedPhoto', (req, res, next) => {
	query('SELECT * FROM images WHERE enough_tags = "1" LIMIT 1', '')
	.then(function(data) {
		res.json(formater({code:'0', data:{
			image_id: data.results[0].image_id,
			image_md5: data.results[0].image_md5,
			image_tags: data.results[0].image_tags
		}}));
	});
});
// 提交用户对图片的标注结果
router.post('/updatePhotoTag', (req, res, next) => {
	let _user = req.body;
	let post = {
		image_id: _user.image_id,
		tag: _user.tag // 以逗号分隔
	};
	if (!post.image_id || !post.tags) {
		return res.json(formater({code:'1', desc:'参数错误(缺失图像id或标签)！'}));
	}
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
	});
});
// 更新用户关注的摄影师
router.post('/updatePhotographers/add', verify_token, (req, res, next) => {
	let _user = req.body;
	let user_id = req.api_user.data.user_id;
	let settings = req.body.followings.toString().split(',');
	let user_settings = [];
	if (settings.length === 0) {
		return res.json(formater({code: '1', desc: '没有提供关注者的id'}))
	}
	for(let setting of settings) {
		if (user_id === setting) continue;
		let s = [user_id, setting];
		user_settings.push(s);
	}
	if (user_settings.length === 1) {
		query('DELETE FROM relationships WHERE user_id = ? AND following_id = ?', [user_id, user_settings[0][1]])
		.then(function() {
			query('INSERT INTO relationships(user_id, following_id) VALUES ?', [user_settings])
			.then(function(data) {
				res.json(formater({code:'0', desc:'摄影师列表更新成功！'}));
			})
		});
	} else {
		query('DELETE FROM relationships WHERE user_id = ?', [user_id])
		.then(function() {
			query('INSERT IGNORE INTO relationships(user_id, following_id) VALUES ?', [user_settings])
			.then(function(data) {
				res.json(formater({code:'0', desc:'摄影师列表更新成功！'}));
			})
		});
	}
});
// 获取推荐的摄影师
router.all('/getPhotographers', (req, res, next) => {
	let _user = req.body;
	let pageNo = +_user.pageNo || +req.query.pageNo || 1;
	let pageSize = +_user.pageSize || +req.query.pageSize || 25;
	let _left = (pageNo - 1) * pageSize;
	query('SELECT users.user_id, users.user_name, users.image_md5, users.wechat, a.follower_nums FROM '+
		'users LEFT OUTER JOIN (SELECT user_id, COUNT(following_id) AS follower_nums FROM relationships '+
		'GROUP BY user_id) a ON a.user_id = users.user_id ORDER BY a.follower_nums DESC LIMIT ?,?', [_left, pageSize])
	.then(function(data) {
		res.json(formater({code:'0', data: data.results}));
	});
});
// 取消关注
router.all('/updatePhotographers/rm', verify_token, (req, res, next) => {
	let _user = req.body;
	let user_id = req.api_user.data.user_id;
	let following_id = req.body.following_id || req.query.following_id;
	if (!following_id) {
		return res.json(formater({code: '1', desc: '没有提供关注者的id'}))
	}
	query('DELETE FROM relationships WHERE user_id = ? AND following_id = ?', [user_id, following_id])
	.then(function() {
		res.json(formater({code:'0', desc:'摄影师列表更新成功！'}));
	});
});
// 获取推荐的摄影师
router.all('/getPhotographers', (req, res, next) => {
	let _user = req.body;
	let pageNo = +_user.pageNo || +req.query.pageNo || 1;
	let pageSize = +_user.pageSize || +req.query.pageSize || 25;
	let _left = (pageNo - 1) * pageSize;
	query('SELECT users.user_id, users.user_name, users.image_md5, users.wechat, a.follower_nums FROM '+
		'users LEFT OUTER JOIN (SELECT user_id, COUNT(following_id) AS follower_nums FROM relationships '+
		'GROUP BY user_id) a ON a.user_id = users.user_id ORDER BY a.follower_nums DESC LIMIT ?,?', [_left, pageSize])
	.then(function(data) {
		res.json(formater({code:'0', data: data.results}));
	});
});
// 关键字搜索
router.all('/search', (req, res, next) => {
	let _user = req.body;
	let keyword = _user.keyword || req.query.keyword;
	if (!keyword) return res.json(formater({code:'1', desc: '请输入关键词！'}));
	let q1 = query('SELECT i.*, u.user_name, u.image_md5 AS avatar, u.email, c.is_private, '+
		'likes.total_likes FROM image_collection ic JOIN collections c ON '+
		'ic.collection_id = c.collection_id JOIN images i ON ic.image_id = i.image_id '+
		'JOIN users u ON i.user_id = u.user_id LEFT OUTER JOIN (SELECT l.image_id, COUNT(l.user_id) '+
		'AS total_likes FROM image_likes l GROUP BY image_id) likes ON '+
		'i.image_id = likes.image_id WHERE c.is_private = 1 AND i.image_tags '+
		'LIKE "%' + keyword + '%" OR i.story_title LIKE "%' + keyword + '%"', '')
	let q2 = query('SELECT u.user_id, u.user_name, u.image_md5 AS avatar, u.bio, c.collection_nums, '+
		'i.image_nums, lk.likes FROM (SELECT user_id, COUNT(collection_id) AS collection_nums '+
		'FROM collections GROUP BY user_id) c JOIN (SELECT user_id, COUNT(image_id) AS image_nums '+
		'FROM images GROUP BY user_id) i ON c.user_id = i.user_id JOIN (SELECT i.user_id, '+
		'COUNT(l.user_id) AS likes FROM image_likes l RIGHT OUTER JOIN images i ON i.image_id = l.image_id '+
		'GROUP BY i.user_id) lk ON lk.user_id = i.user_id RIGHT OUTER JOIN users u ON '+
		'c.user_id = u.user_id WHERE u.user_name LIKE "%' + keyword + '%" ORDER BY lk.likes DESC', '')
	let q3 = query('SELECT u.user_id, u.user_name, u.image_md5 AS avatar, ic.collection_id, '+
		'c.collection_name, ic.image_id, i.image_md5 FROM users u, image_collection ic, '+
		'collections c, images i WHERE ic.collection_id = c.collection_id AND ic.image_id = i.image_id '+
		'AND u.user_id = c.user_id AND c.is_private = 1 AND c.collection_name '+
		'LIKE "%' + keyword + '%" ORDER BY ic.collection_id DESC')
	Promise.all([q1, q2, q3]).then(values => {
		let collections = values[2].results
		let newCollections = []
		let hashTable = {};
		let newArr = [];
		if (collections.length > 0) {
	    for (let c1 of collections) {
	    	let newCollection = {}
	    	newCollection.collection_id = c1.collection_id
	    	newCollection.collection_name = c1.collection_name
	    	newCollection.user_id = c1.user_id
	    	newCollection.user_name = c1.user_name
	    	newCollection.avatar = c1.avatar
	    	newCollection.images_list = []
	    	for (let c2 of collections) {
	    		if (newCollection.collection_id === c2.collection_id) {
	    			newCollection.images_list.push(c2.image_md5)
	    		}
	    	}
	    	newCollections.push(newCollection)
	    }
		  for(let nc of newCollections) {
		    if(!hashTable[nc.collection_id]) {
		      hashTable[nc.collection_id] = true;
		      newArr.push(nc);
		    }
		  }
		}
		let response = {
			basic_info: {
				photos: values[0].results.length,
				collections: newArr.length,
				users: values[1].results.length
			},
			lists: {
				photos: values[0].results,
				collections: newArr,
				users: values[1].results
			}
		};
		res.json(formater({code:'0', data:response}));
	});
});
// 获取所有类别
router.all('/getCategories', (req, res, next) => {
	query('SELECT * FROM categories', '')
	.then(function(data) {
		res.json(formater({code:'0', data: data.results}));
	});
});
// 更新用户关注的类别
router.post('/updateUserCategories', verify_token, (req, res, next) => {
	let _user = req.body;
	let user_id = req.api_user.data.user_id;
	let settings = _user.categories;
	if (!settings) return res.json(formater({code:'1', desc:'参数错误(缺失设置)！'}));
	settings = settings.toString().split(',');
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
	});
});
// 获取最新图片列表
router.all('/getList/new', (req, res, next) => {
	let _user = req.body;
	let pageNo = +_user.pageNo || +req.query.pageNo || 1;
	let pageSize = +_user.pageSize || +req.query.pageSize || 50;
	let _left = (pageNo - 1) * pageSize;
	query('SELECT i.*, u.user_name, u.image_md5 AS avatar, '+
		'u.email, c.is_private, likes.total_likes FROM image_collection ic JOIN collections c ON '+
		'ic.collection_id = c.collection_id JOIN images i ON ic.image_id = i.image_id JOIN users u ON '+
		'i.user_id = u.user_id LEFT OUTER JOIN (SELECT l.image_id, COUNT(l.user_id) AS total_likes FROM '+
		'image_likes l GROUP BY image_id) likes ON i.image_id = likes.image_id WHERE c.is_private = 1 '+
		'GROUP BY ic.image_id ORDER BY i.created_time DESC', '')
	.then(data => {
		let new_data = {
			pageNo: pageNo,
			pageSize: pageSize,
			totalPage: Math.ceil(data.results.length / pageSize),
			totalCounts: data.results.length,
			lists: data.results.slice(_left, _left+pageSize)
		};
		res.json(formater({code:'0', data:new_data}))
	})
});
// 获取最热图片列表
router.all('/getList/hot', (req, res, next) => {
	let _user = req.body;
	let pageNo = +_user.pageNo || +req.query.pageNo || 1;
	let pageSize = +_user.pageSize || +req.query.pageSize || 50;
	let _left = (pageNo - 1) * pageSize;
	query('SELECT i.*, u.user_name, u.image_md5 AS avatar, '+
		'u.email, c.is_private, likes.total_likes FROM image_collection ic JOIN collections c ON '+
		'ic.collection_id = c.collection_id JOIN images i ON ic.image_id = i.image_id JOIN users u ON '+
		'i.user_id = u.user_id LEFT OUTER JOIN (SELECT l.image_id, COUNT(l.user_id) AS total_likes FROM '+
		'image_likes l GROUP BY image_id) likes ON i.image_id = likes.image_id WHERE c.is_private = 1 '+
		'GROUP BY ic.image_id ORDER BY likes.total_likes DESC', '')
	.then(data => {
		let new_data = {
			pageNo: pageNo,
			pageSize: pageSize,
			totalPage: Math.ceil(data.results.length / pageSize),
			totalCounts: data.results.length,
			lists: data.results.slice(_left, _left+pageSize)
		};
		res.json(formater({code:'0', data:new_data}))
	})
});
// 已登录用户，获取其所关注的作者的图片列表
router.all('/getList/following', verify_token, (req, res, next) => {
	let _user = req.body;
	let user_id = req.api_user.data.user_id;
	let pageNo = +_user.pageNo || +req.query.pageNo || 1;
	let pageSize = +_user.pageSize || +req.query.pageSize || 50;
	let _left = (pageNo - 1) * pageSize;
	query('SELECT i.*, u.user_name, u.image_md5 AS avatar, '+
		'u.email, c.is_private, likes.total_likes FROM images i JOIN (SELECT r.following_id FROM relationships r '+
		'WHERE r.user_id = ?) follow ON i.user_id = follow.following_id JOIN users u ON i.user_id = u.user_id '+
		'JOIN image_collection ic ON i.image_id = ic.image_id JOIN collections c ON '+
		'ic.collection_id = c.collection_id LEFT OUTER JOIN (SELECT l.image_id, COUNT(l.user_id) AS '+
		'total_likes FROM image_likes l GROUP BY image_id) likes ON i.image_id = likes.image_id '+
		'WHERE c.is_private = 1 GROUP BY ic.image_id ORDER BY likes.total_likes DESC', [user_id])
	.then(data => {
		let new_data = {
			pageNo: pageNo,
			pageSize: pageSize,
			totalPage: Math.ceil(data.results.length / pageSize),
			totalCounts: data.results.length,
			lists: data.results.slice(_left, _left+pageSize)
		};
		res.json(formater({code:'0', data:new_data}))
	})
});
// 获取某个用户的所有图片列表
router.all('/getList/user', (req, res, next) => {
	let _user = req.body;
	let token = req.body.token || req.query.token || req.headers['x-access-token'] || '';
	let request_user_id = req.body.request_user_id || req.query.request_user_id;
	let pageNo = +_user.pageNo || +req.query.pageNo || 1;
	let pageSize = +_user.pageSize || +req.query.pageSize || 50;
	let _left = (pageNo - 1) * pageSize;
	let q2 = query('SELECT i.*, u.user_name, u.image_md5 AS user_avatar, c.is_private, likes.total_likes '+
		'FROM image_collection ic JOIN collections c ON ic.collection_id = c.collection_id '+
		'JOIN images i ON ic.image_id = i.image_id JOIN users u ON i.user_id = u.user_id LEFT OUTER JOIN '+
		'(SELECT l.image_id, COUNT(l.user_id) AS total_likes FROM image_likes l GROUP BY image_id) likes '+
		'ON i.image_id = likes.image_id WHERE c.is_private = 1 AND i.user_id = ? GROUP BY ic.image_id '+
		'ORDER BY likes.total_likes DESC', [request_user_id])
	if (!request_user_id) {
		return res.json(formater({code: '1', desc: 'id是必须的！'}))
	}
	jwt.verify(token, 'secret', function(err, decoded) {
    if (!err) {
      // 如果没问题就把解码后的信息保存到请求中，供后面的路由使用
      req.api_user = decoded;
      if (req.api_user.data.user_id == request_user_id) {
      	q2 = query('SELECT i.*, u.user_name, u.image_md5 AS user_avatar, c.is_private, likes.total_likes '+
				'FROM image_collection ic JOIN collections c ON ic.collection_id = c.collection_id '+
				'JOIN images i ON ic.image_id = i.image_id JOIN users u ON i.user_id = u.user_id LEFT OUTER JOIN '+
				'(SELECT l.image_id, COUNT(l.user_id) AS total_likes FROM image_likes l GROUP BY image_id) likes '+
				'ON i.image_id = likes.image_id WHERE i.user_id = ? GROUP BY ic.image_id '+
				'ORDER BY likes.total_likes DESC', [request_user_id])
	     }
    }
  })
	Promise.all([q2]).then(values => {
		let new_data = {
			pageNo: pageNo,
			pageSize: pageSize,
			totalPage: Math.ceil(values[0].results.length / pageSize),
			totalCounts: values[0].results.length,
			lists: values[0].results.slice(_left, _left+pageSize)
		};
		res.json(formater({code:'0', data:new_data}))
	});
});
// 获取某个用户喜欢过的图片列表
router.all('/getList/liked', (req, res, next) => {
	let _user = req.body;
	let token = req.body.token || req.query.token || req.headers['x-access-token'] || '';
	let request_user_id = req.body.request_user_id || req.query.request_user_id;
	let pageNo = +_user.pageNo || +req.query.pageNo || 1;
	let pageSize = +_user.pageSize || +req.query.pageSize || 50;
	let _left = (pageNo - 1) * pageSize;
	let q2 = query('SELECT i.image_id, my_likes.total_likes, i.display_location, i.location, i.created_time, '+
	'i.image_md5, i.story_title, i.story_detail, i.user_id, u.user_name, u.image_md5 AS user_avatar, '+
	'u.email, c.collection_id, c.collection_name, c.is_private, c.user_id AS collection_owner_id '+
	'FROM images i JOIN users u ON i.user_id = u.user_id JOIN (SELECT l.image_id, likes.total_likes '+
	'FROM image_likes l, (SELECT l.image_id, COUNT(l.user_id) AS total_likes FROM image_likes l '+
	'GROUP BY l.image_id) likes WHERE l.user_id = ? AND l.image_id = likes.image_id) my_likes ON '+
	'i.image_id = my_likes.image_id JOIN image_collection ic ON i.image_id = ic.image_id JOIN '+
	'collections c ON ic.collection_id = c.collection_id AND c.is_private = 1 GROUP BY i.image_id', [request_user_id])
	if (!request_user_id) {
		return res.json(formater({code: '1', desc: 'id是必须的！'}))
	}
	jwt.verify(token, 'secret', function(err, decoded) {
    if (!err) {
      // 如果没问题就把解码后的信息保存到请求中，供后面的路由使用
      req.api_user = decoded;
      console.log('_user_id: ', req.api_user.data.user_id);
      if (req.api_user.data.user_id == request_user_id) {
      	q2 = query('SELECT i.image_id, my_likes.total_likes, i.display_location, i.location, i.created_time, '+
				'i.image_md5, i.story_title, i.story_detail, i.user_id, u.user_name, u.image_md5 AS user_avatar, '+
				'u.email, c.collection_id, c.collection_name, c.is_private, c.user_id AS collection_owner_id '+
				'FROM images i JOIN users u ON i.user_id = u.user_id JOIN (SELECT l.image_id, likes.total_likes '+
				'FROM image_likes l, (SELECT l.image_id, COUNT(l.user_id) AS total_likes FROM image_likes l '+
				'GROUP BY l.image_id) likes WHERE l.user_id = ? AND l.image_id = likes.image_id) my_likes ON '+
				'i.image_id = my_likes.image_id JOIN image_collection ic ON i.image_id = ic.image_id JOIN '+
				'collections c ON ic.collection_id = c.collection_id GROUP BY i.image_id', [request_user_id])
	     }
    }
  })
	Promise.all([q2]).then(values => {
		let new_data = {
				pageNo: pageNo,
				pageSize: pageSize,
				totalPage: Math.ceil(values[0].results.length / pageSize),
				totalCounts: values[0].results.length,
				lists: values[0].results.slice(_left, _left+pageSize)
			};
			res.json(formater({code:'0', data:new_data}))
	});
});

// 获取所有图片集
router.all('/getCollection/all', (req, res, next) => {
	let _user = req.body;
	let pageNo = +_user.pageNo || +req.query.pageNo || 1;
	let pageSize = +_user.pageSize || +req.query.pageSize || 50;
	let _left = (pageNo - 1) * pageSize;
	let q2 = query('SELECT u.user_id, u.user_name, u.image_md5 AS avatar, ic.collection_id, '+
		'c.collection_name, ic.image_id, i.image_md5 FROM users u, '+
		'image_collection ic, collections c, images i WHERE ic.collection_id = c.collection_id AND '+
		'ic.image_id = i.image_id AND u.user_id = c.user_id AND c.is_private = 1 ORDER BY ic.collection_id DESC', '');
	Promise.all([q2]).then(values => {
		let collections = values[0].results
		let newCollections = []
		let hashTable = {};
		let newArr = [];
		if (collections.length > 0) {
	    for (let c1 of collections) {
	    	let newCollection = {}
	    	newCollection.collection_id = c1.collection_id
	    	newCollection.collection_name = c1.collection_name
	    	newCollection.user_id = c1.user_id
	    	newCollection.user_name = c1.user_name
	    	newCollection.avatar = c1.avatar
	    	newCollection.images_list = []
	    	for (let c2 of collections) {
	    		if (newCollection.collection_id === c2.collection_id) {
	    			newCollection.images_list.push(c2.image_md5)
	    		}
	    	}
	    	newCollections.push(newCollection)
	    }
		  for(let nc of newCollections) {
		    if(!hashTable[nc.collection_id]) {
		      hashTable[nc.collection_id] = true;
		      newArr.push(nc);
		    }
		  }
		}
		let new_data = {
			pageNo: pageNo,
			pageSize: pageSize,
			totalPage: Math.ceil(newArr.length / pageSize),
			totalCounts: newArr.length,
			lists: newArr.slice(_left, _left+pageSize)
		};
		res.json(formater({code:'0', data:new_data}));
	});
});
// 获取某个用户的图片集
router.all('/getCollection/user', (req, res, next) => {
	let _user = req.body;
	let token = req.body.token || req.query.token || req.headers['x-access-token'] || '';
	let request_user_id = _user.request_user_id || req.query.request_user_id;
	let pageNo = +_user.pageNo || +req.query.pageNo || 1;
	let pageSize = +_user.pageSize || +req.query.pageSize || 50;
	let _left = (pageNo - 1) * pageSize;
	let q2 = query('SELECT u.user_id, u.user_name, u.image_md5 AS avatar, ic.collection_id, '+
		'c.collection_name, c.collection_desc, c.is_private, ic.image_id, i.image_md5 FROM users u, '+
		'image_collection ic, collections c, images i WHERE ic.collection_id = c.collection_id AND '+
		'ic.image_id = i.image_id AND u.user_id = c.user_id AND u.user_id = ? AND c.is_private = 1 '+
		'ORDER BY ic.collection_id DESC', [request_user_id]);
	if (!request_user_id) {
		return res.json(formater({code: '1', desc: 'id是必须的！'}))
	}
	jwt.verify(token, 'secret', function(err, decoded) {
    if (!err) {
      // 如果没问题就把解码后的信息保存到请求中，供后面的路由使用
      req.api_user = decoded;
      if (req.api_user.data.user_id == request_user_id) {
      	q2 = query('SELECT u.user_id, u.user_name, u.image_md5 AS avatar, ic.collection_id, '+
      		'c.collection_name, c.is_private, ic.image_id, i.image_md5 FROM users u, '+
				'image_collection ic, collections c, images i WHERE ic.collection_id = c.collection_id AND '+
				'ic.image_id = i.image_id AND u.user_id = c.user_id AND u.user_id = ? '+
				'ORDER BY ic.collection_id DESC', [request_user_id]);
	     }
    }
  })
	Promise.all([q2]).then(values => {
		let collections = values[0].results
		let newCollections = []
		let hashTable = {};
		let newArr = [];
		if (collections.length > 0) {
	    for (let c1 of collections) {
	    	let newCollection = {}
	    	newCollection.collection_id = c1.collection_id
	    	newCollection.collection_name = c1.collection_name
	    	newCollection.user_id = c1.user_id
	    	newCollection.user_name = c1.user_name
	    	newCollection.avatar = c1.avatar
	    	newCollection.is_private = c1.is_private
	    	newCollection.images_list = []
	    	for (let c2 of collections) {
	    		if (newCollection.collection_id === c2.collection_id) {
	    			newCollection.images_list.push(c2.image_md5)
	    		}
	    	}
	    	newCollections.push(newCollection)
	    }
		  for(let nc of newCollections) {
		    if(!hashTable[nc.collection_id]) {
		      hashTable[nc.collection_id] = true;
		      newArr.push(nc);
		    }
		  }
		}
		let new_data = {
			pageNo: pageNo,
			pageSize: pageSize,
			totalPage: Math.ceil(newArr.length / pageSize),
			totalCounts: newArr.length,
			lists: newArr.slice(_left, _left+pageSize)
		};
		res.json(formater({code:'0', data:new_data}));
	});
});
// 获取相册基本信息
router.all('/getCollectionInfo', (req, res, next) => {
	let collection_id = req.body.collection_id || req.query.collection_id
	if (!collection_id) {
		return res.json(formater({code: '1', desc: '相册id是必须的！'}))
	}
	query('SELECT c.*, u.user_id, u.user_name, u.email, u.image_md5 AS avatar FROM collections c ' +
		'JOIN users u ON c.user_id = u.user_id AND c.collection_id = ?', [collection_id])
	.then(data => {
		res.json(formater({code:'0', data:data.results[0]}))
	})
})
// 获取图片基本信息
router.all('/getPhotoInfo', (req, res, next) => {
	
})
// 获取每个图片集里面的图片(如果是私密的要验证用户)
router.all('/getCollection/one', (req, res, next) => {
	let _user = req.body;
	let token = req.body.token || req.query.token || req.headers['x-access-token'] || '';
	let user_id = _user.user_id || req.query.user_id
	let collection_id = _user.collection_id || req.query.collection_id;
	let pageNo = +_user.pageNo || +req.query.pageNo || 1;
	let pageSize = +_user.pageSize || +req.query.pageSize || 50;
	let _left = (pageNo - 1) * pageSize;
	let verify_id = ''
	if (!collection_id) {
		return res.json(formater({code: '1', desc: '相册id是必须的！'}))
	}
	let q2 = query('SELECT i.image_id, i.display_location, i.location, i.created_time, '+
	'i.image_md5, i.story_title, i.story_detail, u.user_id, u.user_name, '+
	'u.image_md5 AS avatar, u.email AS email, '+
	'c.user_id AS collection_owner_id, c.collection_id AS '+
	'collectionId, c.collection_name, c.is_private, c.collection_desc, likes.total_likes FROM '+
	'images i JOIN users u ON i.user_id = u.user_id JOIN image_collection ic ON '+
	'i.image_id = ic.image_id JOIN collections c ON c.collection_id = ic.collection_id '+
	'LEFT OUTER JOIN (SELECT l.image_id, COUNT(l.user_id) AS total_likes FROM '+
  'image_likes l GROUP BY image_id) likes ON i.image_id = likes.image_id WHERE ic.collection_id = ?', 
	[collection_id]);
	jwt.verify(token, 'secret', function(err, decoded) {
    if (!err) {
      req.api_user = decoded;
      verify_id = req.api_user.data.user_id
    }
  })
	query('SELECT is_private, user_id FROM collections WHERE collection_id = ?', [collection_id])
	.then(data => {
		if (data.results[0].is_private == '0' && data.results[0].user_id != verify_id) {
			return res.json(formater({code: '1', desc: '该私密相册不属于该用户，不能被访问！'}))
		}
		Promise.all([q2]).then(values => {
			let new_data = {
				pageNo: pageNo,
				pageSize: pageSize,
				totalPage: Math.ceil(values[0].results.length / pageSize),
				totalCount: values[0].results.length,
				lists: values[0].results.slice(_left, _left+pageSize)
			};
			res.json(formater({code:'0', data:new_data}));
		});
	})
});
//将照片加入自己的相册
router.all('/addToCollection', verify_token, (req, res, next) => {
	let user_id = req.api_user.data.user_id;
	let post = {
		image_id: req.body.image_id || req.query.image_id,
		collection_id: req.body.collection_id || req.query.collection_id
	}
	let collection_name = new Date().getFullYear() + '/' + new Date().getMonth() + '/' + 
		new Date().getDate() + ' ' + new Date().getHours() + ':' + new Date().getMinutes() + 
		':' + new Date().getSeconds()
	if (!post.image_id){
		return res.json(formater({code: '1', desc:'需要相册id'}))
	}
	if(!post.collection_id) {
		query('INSERT INTO collections SET user_id = ?, collection_name = ?', [user_id, collection_name])
	  .then(data => {
			post.collection_id = data.results.insertId;
			query('INSERT INTO image_collection SET ?', [post])
			.then(data2 => {
				res.json(formater({code: '0', desc:'成功将指定相片加入指定相册！'}))
			})
		});
	} else {
		query('SELECT collection_id FROM collections WHERE user_id = ? AND collection_id = ?', [user_id, post.collection_id])
		.then(data => {
			if (data.results.length === 0) {
				return res.json(formater({code: '1', desc: '该相册不属于该用户！'}))
			}
			query('DELETE FROM image_collection WHERE image_id = ? AND collection_id = ?', [post.image_id, post.collection_id])
			.then(data => {
				query('INSERT INTO image_collection SET ?', [post])
				.then(data2 => {
					res.json(formater({code: '0', desc:'成功将指定相片加入指定相册！'}))
				})
			})
		})
	}
})
// 修改相册名称或简介或是否公开
router.all('/updateCollection', verify_token, (req, res, next) => {
	let user_id = req.api_user.data.user_id
	let collection_id = req.body.collection_id || req.query.collection_id
	let collection_name = req.body.collection_name || req.query.collection_name
	let is_private = (req.body.is_private).toString() || (req.query.is_private).toString()
	let collection_desc = req.body.collection_desc || req.query.collection_desc
	if (!collection_id) {
		return res.json(formater({code: '1', desc:'相册id不能为空！'}))
	}
	query('SELECT collection_id FROM collections WHERE user_id = ? AND collection_id = ?', [user_id, collection_id])
	.then(data => {
		if (data.results.length === 0) {
			return res.json(formater({code: '1', desc: '该相册不属于该用户！'}))
		}
		query('UPDATE collections SET collection_name = ?, is_private = ?, collection_desc = ? '+
			'WHERE collection_id = ?', [collection_name, is_private, collection_desc, collection_id])
		.then(data => {
			if (data.results.affectedRows === 1) {
				res.json(formater({code: '0', desc:'相册信息修改成功！'}))
			} else {
				res.json(formater({code: '0', desc:'该相册不存在！'}))
			}
		})
	})
})
// 向服务端请求签名然后直接上传到阿里云
router.all('/getAliyunKey', verify_token, (req, res, next) => {
	let upload_dir = 'users/';
	let end = new Date().getTime() + 300000;
  let expiration = new Date(end).toISOString();
  let policyString = {
    expiration: expiration,
    conditions: [
      ['content-length-range', 0, 1048576000],
      ['starts-with', '$key', upload_dir]
    ]
  };
  policyString = JSON.stringify(policyString);
  const policy = new Buffer(policyString).toString('base64');
  const signature = crypto.createHmac('sha1', my_secret.accessKeySecret).update(policy).digest('base64');
  let keys = {
    accessKeyId: my_secret.accessKeyId,
    host_user: my_secret.host_user,
    policy: policy,
    signature: signature,
    saveName: end,
    startsWith: upload_dir
  };
  res.json(formater({code:'0', data:keys}));
})
// 用户上传图片
router.post('/uploadUserPhoto', verify_token, (req, res, next) => {
	let _user = req.body;
	let user_id = req.api_user.data.user_id;
	let collection_name = new Date().getFullYear() + '/' + new Date().getMonth() + '/' + 
	new Date().getDate() + ' ' + new Date().getHours() + ':' + new Date().getMinutes() + 
	':' + new Date().getSeconds()
	let post = {
		user_id: user_id,
		image_md5: _user.image_md5,
		image_tags: _user.image_tags,
		make: _user.make,
		model: _user.model,
		dateTimeOriginal: _user.dateTimeOriginal,
		focalLength: _user.focalLength,
		aperture: _user.aperture,
		iso: _user.iso,
		shutterSpeed: _user.shutterSpeed,
		story_title: _user.story_title,
		story_detail: _user.story_detail,
		location: _user.location,
		display_location: _user.display,
		collection_id: _user.collection_id
	};
	if(!post.collection_id) {
		query('INSERT INTO collections SET user_id = ?, collection_name = ?', 
			[post.user_id, collection_name])
	  .then(data => {
			post.collection_id = data.results.insertId;
			query('INSERT INTO images SET ?', [post])
			.then(data => {
				let image_id = data.results.insertId
				query('INSERT INTO image_collection SET ?', [{image_id: image_id, collection_id: post.collection_id}])
				.then(data => {
					res.json(formater({code:'0', desc:'图片上传成功！', data:{collection_id: post.collection_id}}));
				})
			})
		});
	} else {
		query('SELECT collection_id FROM collections WHERE collection_id = ?', [post.collection_id])
		.then(data => {
			if(data.results.length === 0) {
				return res.json(formater({code:'1', desc:'插入失败，该id对应的图片集不存在！'}));
			} else {
				query('INSERT INTO images SET ?', [post])
				.then(data => {
					let image_id = data.results.insertId
					query('INSERT INTO image_collection SET ?', [{image_id: image_id, collection_id: post.collection_id}])
					.then(data => {
						res.json(formater({code:'0', desc:'图片上传成功！', data:{collection_id: post.collection_id}}));
					})
				})
			}
		});
	}
});
// 用户修改图片
router.post('/updatePhoto', verify_token, (req, res, next) => {
	let _user = req.body;
	let user_id = req.api_user.data.user_id;
	let post = {
		image_id: _user.image_id,
		image_md5: _user.image_md5,
		image_tags: _user.image_tags,
		make: _user.make,
		model: _user.model,
		dateTimeOriginal: _user.dateTimeOriginal,
		focalLength: _user.focalLength,
		aperture: _user.aperture,
		iso: _user.iso,
		shutterSpeed: _user.shutterSpeed,
		story_title: _user.story_title,
		story_detail: _user.story_detail,
		location: _user.location,
		display_location: _user.display
	};
	query('SELECT image_id FROM images WHERE image_id = ? AND user_id = ?', [post.image_id, user_id])
	.then(data => {
		if (data.results.length === 0) {
			return res.json(formater({code:'1', desc:'该照片不属于该用户，无法更新！'}));
		}
		query('UPDATE images SET image_md5 = ?, image_tags = ?, make = ?, model = ?, dateTimeOriginal = ?, ' + 
			'focalLength = ?, aperture = ?, iso = ?, shutterSpeed = ?, story_title = ?, story_detail = ?, ' + 
			'location = ?, display_location = ? WHERE image_id = ?', [post.image_md5, post.image_tags, post.make, 
			post.model, post.dateTimeOriginal, post.focalLength, post.aperture, post.iso, post.shutterSpeed, 
			post.story_title, post.story_detail, post.location, post.display_location, post.image_id])
		.then(data => {
			res.json(formater({code:'0', desc:'照片信息更新成功！'}));
		})
	})
})
// 上传图片到服务器
router.post('/uploadPhotoToAliyun', (req, res, next) => {
	if(req.headers['content-length'] === '0') {
		return res.json(formater({code:'1', desc:'没有选择图片！'}));
	}
	let ext = req.headers["content-type"].split("/")[1];
	if(ext !== 'jpeg' && ext !== 'png' && ext !== 'gif') {
		return res.json(formater({code:'1', desc:'图片格式不符合，只支持jpg/png/gif格式！'}));
	}
	var chunks = [];
	var size = 0;
	req.on('data' , function(chunk){
	    chunks.push(chunk);
	    size += chunk.length;
	});
	req.on("end",function(){
    var buffer = Buffer.concat(chunks, size);
    co(function* () {
	  	var result3 = yield client.put(new Date().getTime() + '.' + ext, buffer);
	  	var url = result3.url;
		  res.json(formater({code:'0', data:{url:url}}));
		}).catch(function (err) {
		  console.log(err);
		});
	});
});
// 用户下载图片
router.all('/download/photo', (req, res, next) => {
	let filename = req.body.filename || req.query.filename
	if (!filename) {
		return res.json(formater({code:'1',desc:'请提供要下载的文件名称！'}))
	}
	res.set({
		// 'Content-Type': 'application/force-download',
   'Content-Type': 'application/octet-stream',
   'Content-Disposition': 'attachment; filename='+filename
  });
	co(function* () {
  	var result = yield client.getStream(aliyun_folder+filename);
	  result.stream.pipe(res)
	}).catch(function (err) {
	  console.log(err);
	});
})
// 用户是否给该图片点过赞
router.all('/alreadyLike', verify_token, (req, res, next) => {
	let user_id = req.api_user.data.user_id;
	// let user_id = req.body.user_id || req.query.user_id || ''
	let image_id = req.body.image_id;
	if (!image_id) {
		return res.json(formater({code: '1', desc: '请提供图片id'}))
	}
	query('SELECT image_id FROM image_likes WHERE image_id = ? AND user_id = ?', 
		[image_id, user_id])
	.then(data => {
		let alreadyLike = false
		if(data.results.length !== 0) {
			alreadyLike = true
		}
		query('SELECT COUNT(*) AS total_likes FROM image_likes WHERE image_id = ?', [image_id])
		.then(data => {
			res.json(formater({code: '0', data:{alreadyLike: alreadyLike, total_likes: data.results[0].total_likes}}))
		})
	})
})
// 用户给图片点赞
router.post('/photoLike', verify_token, (req, res, next) => {
	let user_id = req.api_user.data.user_id;
	let image_id = req.body.image_id;
	let like = req.body.like;
	if(like !== '0' && like !== '1') {
		return res.json(formater({code:'1', desc:'参数错误！'}));
	}
	query('SELECT image_id, liked FROM images WHERE image_id = ?', [image_id])
	.then(data => {
		if(data.results.length === 0) {
			return res.json(formater({code:'1', desc:'图片不存在！'}));
		}
		query('SELECT image_id FROM image_likes WHERE image_id = ? AND user_id = ?', [image_id, user_id])
		.then(data => {
			let hasRecords = data.results.length === 0 ? false : true;
			if(like === '0') {
				// 用户取消点赞，判断image_likes是否已经有点赞记录，有的话才可以取消
				if (hasRecords) {
					query('DELETE FROM image_likes WHERE image_id = ? AND user_id = ?', [image_id, user_id])
					.then(data => {
						res.json(formater({code:'0', desc:'点赞取消成功！'}));
					})
				} else {
					res.json(formater({code:'1', desc:'用户未给该照片点过赞，无法取消赞！'}));
				}
			} else {
				// 用户给图片点赞，判断image_likes是否不存在该照片的点赞记录，不存在才可以点赞
				if (hasRecords) {
					res.json(formater({code:'1', desc:'用户已经给该照片点过赞，无法再次点赞！'}));
				} else {
					query('INSERT INTO image_likes SET ?', [{image_id: image_id, user_id: user_id}])
					.then(data => {
						res.json(formater({code:'0', desc:'点赞成功！'}));
					})
				}
			}
		})
	})
});


/********* 下一期开发(start) **********/
// 上传商品图片到服务器
router.post('/uploadProductImageToAliyun', verify_token, (req, res, next) => {
	if(req.headers['content-length'] === '0') {
		return res.json(formater({code:'1', desc:'没有选择图片！'}));
	}
	let ext = req.headers["content-type"].split("/")[1];
	if(ext !== 'jpeg' && ext !== 'png' && ext !== 'gif') {
		return res.json(formater({code:'1', desc:'图片格式不符合，只支持jpg/png/gif格式！'}));
	}
	var chunks = [];
	var size = 0;
	req.on('data' , function(chunk){
	    chunks.push(chunk);
	    size += chunk.length;
	});
	req.on("end",function(){
	    var buffer = Buffer.concat(chunks, size);
	    co(function* () {
			  client.useBucket('linyaqing-store');
		  	// 上传图片
		  	var result3 = yield client.put(new Date().getTime() + '.' + ext, buffer);
		  	var url = result3.url;
			  res.json(formater({code:'0', desc:'此url作为添加商品的图片字段', data:{url:url}}));
			}).catch(function (err) {
			  console.log(err);
			});
	});
});
// 修改产品库存
router.post('/changeStocks', verify_token, (req, res, next) => {
	let _user = req.body;
	let user_id = req.api_user.data.user_id;
	let inventory_id = _user.inventory_id;
	let post = {
		product_id:_user.product_id,
		stocks:_user.stocks,
		unit:_user.unit,
		province:_user.province,
		city:_user.city,
		town:_user.town,
		address:_user.address
	};
	// 判断是修改库存还是添加库存
	if(inventory_id) {
		query('UPDATE inventories SET stocks = ? WHERE id = ?', [post.stocks, inventory_id])
		.then(data => {
			res.json(formater({code:'0', desc:'库存更新成功！'}));
		})
	} else {
		query('INSERT INTO inventories SET ?', [post])
		.then(data => {
			res.json(formater({code:'0', desc:'库存添加成功！'}));
		})
	}
});
// 获取store中的最新产品列表
router.all('/getProducts/new', (req, res, next) => {
	let _user = req.body;
	let pageNo = +_user.pageNo || +req.query.pageNo || 1;
	let pageSize = +_user.pageSize || +req.query.pageSize || 50;
	let _left = (pageNo - 1) * pageSize;
	let q1 = query('SELECT COUNT(*) AS totalCounts FROM products', '');
	let q2 = query('SELECT * FROM products ORDER BY created_time DESC LIMIT ?,?', [_left, pageSize]);
	Promise.all([q1, q2]).then(values => {
		let new_data = {
			pageNo: pageNo,
			pageSize: pageSize,
			totalPage: Math.ceil(values[0].results[0].totalCounts / pageSize),
			lists: values[1].results
		};
		res.json(formater({code:'0', data:new_data}));				
	})
});
// 获取store中的最热产品列表
router.all('/getProducts/hot', (req, res, next) => {
	let _user = req.body;
	let pageNo = +_user.pageNo || +req.query.pageNo || 1;
	let pageSize = +_user.pageSize || +req.query.pageSize || 50;
	let _left = (pageNo - 1) * pageSize;
	let q1 = query('SELECT COUNT(*) AS totalCounts FROM products', '');
	let q2 = query('SELECT p.*, sales.total_sales FROM products p, (SELECT product_id, SUM(quantity) AS total_sales ' + 
		'FROM order_details GROUP BY product_id ORDER BY total_sales DESC) sales ' + 
		'WHERE p.product_id = sales.product_id LIMIT ?,?', [_left, pageSize]);
	Promise.all([q1, q2]).then(values => {
		let new_data = {
			pageNo: pageNo,
			pageSize: pageSize,
			totalPage: Math.ceil(values[0].results[0].totalCounts / pageSize),
			lists: values[1].results
		};
		res.json(formater({code:'0', data:new_data}));	
	})
});
// 获取store中所有产品列表
router.all('/getProducts/all', (req, res, next) => {
	let _user = req.body;
	let pageNo = +_user.pageNo || +req.query.pageNo || 1;
	let pageSize = +_user.pageSize || +req.query.pageSize || 50;
	let _left = (pageNo - 1) * pageSize;
	let q1 = query('SELECT COUNT(*) AS totalCounts FROM products', '');
	let q2 = query('SELECT * FROM products LIMIT ?,?', [_left, pageSize]);
	Promise.all([q1, q2]).then(values => {
		let new_data = {
			pageNo: pageNo,
			pageSize: pageSize,
			totalPage: Math.ceil(values[0].results[0].totalCounts / pageSize),
			lists: values[1].results
		};
		res.json(formater({code:'0', data:new_data}));
	})
});
// 获取store中自营的产品列表
router.all('/getProducts/self', (req, res, next) => {
	let _user = req.body;
	let pageNo = +_user.pageNo || +req.query.pageNo || 1;
	let pageSize = +_user.pageSize || +req.query.pageSize || 50;
	let _left = (pageNo - 1) * pageSize;
	let q1 = query('SELECT COUNT(*) AS totalCounts FROM products WHERE is_self = 0', '');
	let q2 = query('SELECT * FROM products WHERE is_self = 0 LIMIT ?,?', [_left, pageSize])
	Promise.all([q1, q2]).then(values => {
		let new_data = {
			pageNo: pageNo,
			pageSize: pageSize,
			totalPage: Math.ceil(values[0].results[0].totalCounts / pageSize),
			lists: values[1].results
		};
		res.json(formater({code:'0', data:new_data}));
	})
});
// 登录用户将商品加入购物车(限制为100条商品记录)
router.post('/addToCart', verify_token, (req, res, next) => {
	let _user = req.body;
	let user_id = req.api_user.data.user_id;
	let product_id = _user.product_id;
	let product_quantity = parseInt(_user.quantity);
	if(!product_id || !product_quantity) {
		return res.json(formater({code:'1', desc:'请提供产品id和产品数量!'}));
	} else {
		query('SELECT SUM(stocks) AS total_stocks FROM inventories WHERE product_id = ?', [product_id])
		.then(data => {
			if(data.results[0].total_stocks >= product_quantity) {
				// 产品是否已经在购物车中
				query('SELECT product_id, product_quantity FROM carts WHERE user_id = ? AND product_id = ?', [user_id, product_id])
				.then(data => {
					if(data.results.length === 0) {
							// 购物车中不存在该产品则新增
							query('INSERT INTO carts SET user_id = ?, product_id = ?, product_quantity = ?', [user_id, product_id, product_quantity])
							.then(data => {
								res.json(formater({code:'0', desc:'成功将商品加入购物车!'}));
							})
					} else {
						// 购物车中存在该商品
						query('UPDATE carts SET product_quantity = ? WHERE product_id = ? AND user_id = ?', 
							[data.results[0].product_quantity + product_quantity, product_id, user_id])
						.then(data => {
							res.json(formater({code:'0', desc:'购物车中已有该商品，成功更新库存!'}));
						})
					}
				})
			} else {
				res.json(formater({code:'1', desc:'产品库存不足!'}));
			}
		})
	}
});
// 登录用户获取购物车中的所有商品列表
router.all('/getProductsInCart', verify_token, (req, res, next) => {
	//获取每件商品的数量，跟库存对比，如果大于库存，则返回实际库存
	let _user = req.body;
	let user_id = req.api_user.data.user_id;
	let pageNo = +_user.pageNo || +req.query.pageNo || 1;
	let pageSize = +_user.pageSize || +req.query.pageSize || 50;
	let _left = (pageNo - 1) * pageSize;
	let q1 = query('SELECT COUNT(*) AS totalCounts FROM(SELECT c.user_id, c.product_id, c.product_quantity, s.stock FROM carts c, ' + 
		'(SELECT product_id, SUM(stocks) AS stock FROM inventories GROUP BY product_id) s ' + 
		' WHERE c.product_id = s.product_id AND c.user_id = ?) a', [user_id]);
	let q2 = query('SELECT c.user_id, c.product_id, c.product_quantity, s.stock FROM carts c, ' + 
		'(SELECT product_id, SUM(stocks) AS stock FROM inventories GROUP BY product_id) s ' + 
		' WHERE c.product_id = s.product_id AND c.user_id = ? LIMIT ?,?', [user_id, _left, pageSize]);
	Promise.all([q1, q2]).then(values => {
		let new_data = {
			pageNo: pageNo,
			pageSize: pageSize,
			totalPage: Math.ceil(values[0].results[0].totalCounts / pageSize),
			lists: values[1].results
		};
		res.json(formater({code:'0', data:new_data}));
	})
});
//用户移除或修改购物车产品的数量
router.post('/removeFromCart', verify_token, (req, res, next) => {
	let _user = req.body;
	let user_id = req.api_user.data.user_id;
	let product_id = _user.product_id;
	if(!product_id) {
		return res.json(formater({code:'1', desc:'请提供产品id!'}));
	} else {
		query('SELECT product_id, product_quantity FROM carts WHERE user_id = ? AND product_id = ?', [user_id, product_id])
		.then(data => {
			if(data.results.length === 0) {
				return res.json(formater({code:'1', desc:'该用户的购物车中不存在该商品！'}));
			} else {
				query('DELETE FROM carts WHERE user_id = ? AND product_id = ?', [user_id, product_id])
				.then(data => {
					res.json(formater({code:'0', desc:'成功从购物车删除该商品!'}));
				})
			}
		})
	}
});
// 获取单件商品的基本信息
router.all('/getProductDetails', (req, res, next) => {
	let _user = req.body;
	let product_id = _user.product_id || req.query.product_id;
	if(!product_id) {
		return res.json(formater({code:'1', desc:'请提供产品id!'}));
	} else {
		let q1 = query('SELECT p.*, o.totalSales FROM products p INNER JOIN ' + 
			'(SELECT product_id, SUM(quantity) AS totalSales FROM order_details GROUP BY product_id) o ' + 
			'ON p.product_id = o.product_id WHERE p.product_id = ?', [product_id]);
		let q2 = query('SELECT * FROM inventories WHERE product_id = ?', [product_id]);
		Promise.all([q1, q2]).then(values => {
			let response = {
				product_info: values[0].results,
				product_inventories: values[1].results
			};
			res.json(formater({code:'0', data:response}));
		})
	}
});
// 获取单件产品的所有图片
router.all('/getAllImages', (req, res, next) => {
	let _user = req.body;
	let product_id = _user.product_id || req.query.product_id;
	if(!product_id) {
		return res.json(formater({code:'1', desc:'请提供产品id!'}));
	} else {
		query('SELECT s.image_id, s.image_name, s.image_url, s.image_desc FROM store_images s, ' + 
			'(SELECT a.image_id FROM product_image a WHERE a.product_id = ?) p WHERE s.image_id = p.image_id', [product_id])
		.then(data => {
			res.json(formater({code:'0', data:data.results}));
		})
	}
});
// 用户添加商品(根据是否是admin判断产品是否属于自营)
router.post('/uploadProducts', verify_token,(req, res, next) => {
	let _user = req.body;
	let user_id = req.api_user.data.user_id;
	let product_id = _user.product_id;
	let post = {
		product_md5: _user.product_md5,
		product_name: _user.product_name,
		product_unit:_user.product_unit,
		product_price:_user.product_price,
		product_desc:_user.product_desc
	};
	// 判断是修改已有产品的信息还是添加新产品
	if(product_id) {
		query('UPDATE products SET product_md5 = ?, product_name = ?, product_unit = ?, product_price = ?, ' + 
			'product_desc = ? WHERE product_id = ?', [post.product_md5, post.product_name, post.product_unit, post.price, post.desc, product_id])
		.then(data => {
			res.json(formater({code:'0', desc:'产品信息更改成功！'}));
		})
	} else {
		// 判断该用户是否是admin
		query('SELECT is_admin FROM users WHERE user_id = ?', [user_id])
		.then(data => {
			if(data.results[0].is_admin === '0') {
				// 添加自营产品
				post.is_self = '0';
			} else {
				post.is_self = '1';
			}
			return data;
		})
		.then(data => {
			query('INSERT INTO products SET product_md5 = ?, product_name = ?, product_unit = ?, ' + 
				'product_price = ?, product_desc = ?, is_self = ?, user_id = ?', [post.product_md5, post.product_name, 
				post.product_unit, post.product_price, post.product_desc, post.is_self, user_id])
			.then(data => {
				res.json(formater({code:'0', desc:'产品添加成功！', data:{'product_id': data.results.insertId}}));
			})
		})
	}
});
// 用户给商品添加图片
router.post('/addProductImages', verify_token, (req, res, next) => {
	let _user = req.body;
	let user_id = req.api_user.data.user_id;
	let product_id = _user.product_id;
	let post = {
		image_name: _user.image_name,
		image_url: _user.image_url,
		image_desc: _user.image_desc
	};
	if(!product_id) {
		return res.json(formater({code:'1', desc:'请提供产品id！'}));
	} else {
		if(!post.image_url) {
			return res.json(formater({code:'1', desc:'请提供图片链接！'}));
		} else {
			// 判断该产品是否是该用户创建的
			query('SELECT user_id FROM products WHERE product_id = ?', [product_id])
			.then(data => {
				if(data.results.length === 0) {
					res.json(formater({code:'1', desc:'该产品不存在！'}));
				} else {
					if(data.results[0].user_id !== user_id) {
						res.json(formater({code:'1', desc:'该产品不是该用户创建的！'}));
					} else {
						query('INSERT INTO store_images SET ?', [post])
						.then(data => {
							return data.results.insertId;
						})
						.then(insertId => {
							query('INSERT INTO product_image SET product_id = ?, image_id = ?', [product_id, insertId])
							.then(data => {
								res.json(formater({code:'0', desc:'图片插入成功！'}));
							})
						})
					}
				}
			})
		}
	}
});
// 修改用户收货地址
router.post('/updateUserAccount/delivery', verify_token, (req, res, next) => {
	let _user = req.body;
	let user_id = req.api_user.data.user_id;
	let delivery_id = _user.delivery_id;
	let post = {
		delivery_address:_user.delivery_address,
		delivery_province:_user.delivery_province,
		delivery_city:_user.delivery_city,
		delivery_town:_user.delivery_town,
		consignee:_user.consignee,
		consignee_phone:_user.consignee_phone
	};
	if(delivery_id) {
		query('SELECT delivery_id FROM deliveries WHERE delivery_id = ?', [delivery_id])
		.then(data => {
			if(data.results.length === 0) {
				return res.json(formater({code:'1',desc:'该id对应的收货地址不存在，请确定是要修改已有收货地址还是新增收货地址，新增的话不需要提供id字段！'}));
			} else {
				query('UPDATE deliveries SET delivery_address = ?, delivery_province = ?, delivery_city = ?, ' + 
					'delivery_town = ?, consignee = ?, consignee_phone = ? WHERE delivery_id = ?', [post.delivery_address, post.delivery_province, 
					post.delivery_city, post.delivery_town, post.consignee, post.consignee_phone, delivery_id])
				.then(data => {
					res.json(formater({code:'0', desc:'收货地址修改成功！'}));
				})
			}
		})
	} else {
		query('INSERT INTO deliveries SET ?', [post])
		.then(data => {
			return data.results.insertId;
		})
		.then(insertId => {
			query('INSERT INTO delivery_address SET ?',[{user_id: user_id, delivery_id: insertId}])
			.then(data => {
				res.json(formater({code:'0', desc:'收货地址新增成功！'}));
			})
		})
	}
});
// 获取用户收货地址
router.all('/getDeliveryAddress', verify_token, (req, res, next) => {
	let _user = req.body;
	let user_id = req.api_user.data.user_id;
	let pageNo = _user.pageNo || +req.query.pageNo || 1;
	let pageSize = _user.pageSize || +req.query.pageSize || 50;
	let _left = (pageNo - 1) * pageSize;
	let q1 = query('SELECT COUNT(*) AS totalCounts FROM (SELECT d.* FROM deliveries d, (SELECT delivery_id FROM delivery_address WHERE user_id = ?) a ' + 
		'WHERE d.delivery_id = a.delivery_id) a', [user_id]);
	let q2 = query('SELECT d.* FROM deliveries d, (SELECT delivery_id FROM delivery_address WHERE user_id = ?) a ' + 
		'WHERE d.delivery_id = a.delivery_id LIMIT ?,?', [user_id, _left, pageSize]);
	Promise.all([q1, q2]).then(values => {
		let new_data = {
			pageNo: pageNo,
			pageSize: pageSize,
			totalPage: Math.ceil(values[0].results[0].totalCounts / pageSize),
			lists: values[1].results
		};
		res.json(formater({code:'0', data:new_data}));
	})
});
// 用户提交订单
router.post('/placeOrder', verify_token, (req, res, next) => {
	let _user = req.body;
	let user_id = req.api_user.data.user_id;
	let delivery_id = _user.delivery_id;
	let orders = _user.orders;
	// 插入orders表，拿到order_id，将order_id和其对应的product_id和product_quantity插入order_details
	query('INSERT INTO orders SET user_id = ?, delivery_id = ?', [user_id, delivery_id])
	.then(data => {
		return data.results.insertId;
	})
	.then(order_id => {
		let order_details = [];
		let order_ids = new Set();
		for(let order of orders) {
			order_ids.add(order.product_id); 
			order_details.push([order_id, order.product_id, order.product_quantity]);
		}
		query('INSERT INTO order_details(order_id, product_id, quantity) VALUES ?', [order_details])
		.then(data => {
			res.json(formater({code:'0', desc:'新增订单成功！'}));
		})
	})
});
/********* 下一期开发(end) **********/

module.exports = router;


