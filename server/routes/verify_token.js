let jwt = require('jsonwebtoken');//用来创建和确认用户信息摘要
// 检查用户会话
module.exports = function(req, res, next) {
  console.log('check token.');
  //检查post的信息或者url查询参数或者头信息
  var token = req.body.token || req.query.token || req.headers['x-access-token'];
  // 解析 token
  if (token) {
    // 确认token
    jwt.verify(token, 'secret', function(err, decoded) {
      if (err) {
        console.log('token信息错误');
        return res.status(403).send({code:'1', desc:'token信息错误！'});
      } else {
        // 如果没问题就把解码后的信息保存到请求中，供后面的路由使用
        req.api_user = decoded;
        console.log('_user_id: ', req.api_user.data.user_id);
        next();
      }
    });
  } else {
    // 如果没有token，则返回错误
    console.log('没有提供token信息');
    return res.status(403).send({code:'1', desc:'没有提供token！'});
  }
};