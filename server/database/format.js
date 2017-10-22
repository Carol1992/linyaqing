var formatResponse = function({success='true', code, desc='', data={}}) {
	// code: 0代表成功，1代表错误，-1代表服务端错误
	return {
		success: success,
		code: code, 
		desc: desc,
		data: data
	}
};

module.exports = formatResponse;