var mysql=require("mysql");
var db = require("./db_info")
var pool = mysql.createPool({
  host     : db.host,
  user     : db.user,
  password : db.password,
  port: db.port,
  database : db.database
});

module.exports=function(sql, data){
  return new Promise(function (resolve, reject) {
    pool.getConnection(function(err,conn){
      if(err){
        reject(err);
      }else{
      	if(data) {
      		conn.query(sql, data, function(err,results,fields){
	          //释放连接
	          conn.release();
            if(err) {
              console.log(err);
              return;
            }
	          //传递Promise回调对象
	          resolve({"err":err, "results":results, "fields":fields});
	        });
      	} else {
      		conn.query(sql, function(err,results,fields){
	          //释放连接
	          conn.release();
            if(err) {
              console.log(err);
              return;
            }
	          //传递Promise回调对象
	          resolve({"err":err, "results":results, "fields":fields});
	        });
      	}
      }
    });
  });
};