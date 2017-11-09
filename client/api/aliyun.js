module.exports = {
  myPromise (url, data) {
    return new Promise((resolve, reject) => {
      const xhr = new XMLHttpRequest()
      xhr.open('post', url, true)
      xhr.onload = () => resolve(xhr)
      xhr.onerror = () => reject(xhr.statusText)
      xhr.send(data)
    })
  },
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