let connection = require('../database/connection');
// 连接数据库
connection.connect();
let query = (sql, data, handler) => {
	connection.query(sql, data, (error, results, fields) => {
		if (error) {
			res.json(formater({success:'false', code:'-1', desc:'sql operation error.'}));
			throw error;
		}
		console.log(results);
		handler(results);
	})
};

module.exports = query;