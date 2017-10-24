let connection = require('../database/connection');
let formater = require('../database/format');
// 连接数据库
connection.connect();
let query = (sql, data, handler, res) => {
	if(data) {
		connection.query(sql, data, (error, results, fields) => {
			if (error) {
				res.json(formater({success:'false', code:'-1', desc:'sql operation error.'}));
				throw error;
			}
			console.log(results);
			handler(results);
		});
	} else {
		connection.query(sql, (error, results, fields) => {
			if (error) {
				res.json(formater({success:'false', code:'-1', desc:'sql operation error.'}));
				throw error;
			}
			console.log(results);
			handler(results);
		});
	}
};

module.exports = query;