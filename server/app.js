var express = require('express');
var path = require('path');
var logger2 = require('morgan');
var cookieParser = require('cookie-parser');
var bodyParser = require('body-parser');
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
//  用户注册、登录、修改信息的接口路由
var users = require('./routes/users');
// 日志
const log4js = require('log4js');
log4js.configure({
  appenders: { app: { type: 'file', filename: 'app.log' } },
  categories: { default: { appenders: ['app'], level: 'info' } }
});
 
const logger = log4js.getLogger('app');

var app = express();
app.use(logger2('dev'));
app.use(log4js.connectLogger(log4js.getLogger("http"), { level: 'auto' }));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));
app.use(cookieParser());
// 接口路由
app.use(users);
app.use('/static', express.static('public'))

// error handler
// app.use(function(err, req, res, next) {
//   // set locals, only providing error in development
//   res.locals.message = err.message;
//   res.locals.error = req.app.get('env') === 'development' ? err : {};
//   res.status(err.status || 500).end(err);
//   //throw err;
// });
// app.use(function(req, res, next) {
//   // 设置所有HTTP请求的超时时间
//   req.setTimeout(10000);
//   // 设置所有HTTP请求的服务器响应超时时间
//   res.setTimeout(10000);
//   next();
// });

/// catch 404 and forward to error handler
app.use(function(req, res, next) {
    var err = new Error('Not Found');
    err.status = 404;
    next(err);
});

/// error handlers

// development error handler
// will print stacktrace
if (app.get('env') === 'development') {
    app.use(function(err, req, res, next) {
        logger.error("Something went wrong:", err);
        res.status(err.status || 500);
        res.end(err.message)
    });
}

// production error handler
// no stacktraces leaked to user
app.use(function(err, req, res, next) {
    logger.error("Something went wrong:", err);
    res.status(err.status || 500);
    res.end(err.message)
});

app.all('*', function(req, res){
  res.send('该接口不存在或请求方式不支持！', 404);
});

module.exports = app;
