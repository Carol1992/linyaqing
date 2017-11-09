module.exports = {
  uploadPhotoToAliyun (formData, callback) {
    axios.post('/api/uploadPhotoToAliyun', {
      token:localStorage.token,
      processData: false,
      contentType: false,
      data: formData
    })
    .then(function (response) {
      callback(response)
    })
    .catch(function (error) {
      console.log(error)
    });
  },
  uploadProductImageToAliyun (formData, callback) {
    axios.post('/api/uploadProductImageToAliyun', {
      token:localStorage.token,
      processData: false,
      contentType: false,
      data: formData
    })
    .then(function (response) {
      callback(response)
    })
    .catch(function (error) {
      console.log(error)
    });
  },
  getAliyunKey (callback) {
    axios.post('/api/getAliyunKey', {
      token:localStorage.token
    })
    .then(function (response) {
      callback(response)
    })
    .catch(function (error) {
      console.log(error)
    });
  }
}