var mysql=require("mysql");
var pool = mysql.createPool({
  host     : 'localhost',
  user     : 'carol',
  password : 'carol',
  database : 'linyaqing'
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
	          //传递Promise回调对象
	          resolve({"err":err, "results":results, "fields":fields});
	        });
      	} else {
      		conn.query(sql, function(err,results,fields){
	          //释放连接
	          conn.release();
	          //传递Promise回调对象
	          resolve({"err":err, "results":results, "fields":fields});
	        });
      	}
        
      }
    });
  });
};