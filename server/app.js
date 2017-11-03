var express = require('express');
var path = require('path');
var logger = require('morgan');
var cookieParser = require('cookie-parser');
var bodyParser = require('body-parser');
//  用户注册、登录、修改信息的接口路由
var users = require('./routes/users');

var app = express();
app.use(logger('dev'));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));
app.use(cookieParser());
// 接口路由
app.use(users);

// error handler
app.use(function(err, req, res, next) {
  // set locals, only providing error in development
  res.locals.message = err.message;
  res.locals.error = req.app.get('env') === 'development' ? err : {};
  res.status(err.status || 500).end(err);
  //throw err;
});
app.use(function(req, res, next) {
  // 设置所有HTTP请求的超时时间
  req.setTimeout(10000);
  // 设置所有HTTP请求的服务器响应超时时间
  res.setTimeout(10000);
  next();
});
app.all('*', function(req, res){
  res.send('该接口不存在或请求方式不支持！', 404);
});

module.exports = app;
