线上访问(已部署)
[SharingLife](https://www.linyaqing.com)

如何运行
```js
// 阿里云oss的accessKeyId和accessKeySecret，这是我的图片存储方案。
// 不选择这种方案的话，可以更改routes/users.js中的两个api接口：uploadPhotoToAliyun, uploadProductImageToAliyun

// cmd_1
$ cd server
$ npm install
$ set DEBUG=server & npm start

// cmd_2
$ cd client
$ npm install
$ npm run dev
```

思考：
1. 登录密码的加密方式采用MD5加密
2. 确定接口数据格式，即书写API文档
3. 写接口并测试，给出测试文档
4. 页面UI构建，使用iview框架
5. 前端接入API数据，有未提供的数据暂时使用mockjs模拟数据填充
6. 前端页面和资源使用webpack打包，最后剩下index.html和static文件夹(里面包含css/js/img文件夹)，并通过ftp上传到虚拟主机空间，保证可以通过linyaqing.com访问到index.html及其静态资源
7. nodejs后台文件打包，并购买云服务器，配置node生产环境，将打包好的后台文件放到服务器并跑起来后，有权限的用户可以通过linyaqing.com这个域名下的路径访问到API接口内容。
8. 保证服务的正常运行，包括前端交互、业务数据操作、服务器稳定性和访问速度、数据库安全等方面
9. 未登录用户：new/trending模块、collection模块、store模块
10. 登录用户：new/trending/following模块、collection模块、mine模块、store模块、添加商品模块、购买商品模块开发者模块、标注模块、用户资料编辑模块
11. 图片存储方案：购买阿里云ECS云服务器，安装和启动zimg服务器，将图片存放在该服务器(40G/330元/年)；熟悉阿里云的OSS对象存储API接口，将图片存储在OSS中(目前有40G，有效期是2年)，之后还要去购买可以运行NodeJS的服务器。 =>图片存储在OSS，但是ECS云服务器还是要买
12. 更新下想法：未登录用户可以访问商品，但购买的时候需要登录；登录用户可以添加商品、修改库存、购买商品、将商品放入购物车、添加或修改收货人信息。用户点击提交订单后，会给出订单的详细内容，库存会改变，但不会出现支付页面，也不会出现发货情况，因为支付和运输这两个接口没有接入第三方服务(可以接入支付宝接受用户支付，可以接入第三方物流进行运输)
