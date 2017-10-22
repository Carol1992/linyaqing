var mysql = require('mysql');
var connection = mysql.createConnection({
  host     : 'localhost',
  user     : 'carol',
  password : 'carol',
  database : 'linyaqing'
});

module.exports = connection;