1. 登录密码的加密方式采用RSA非对称加密
2. 确定接口数据格式，即书写API文档
3. 写接口并测试，给出测试文档
4. 页面UI构建，使用iview框架
5. 前端接入API数据，有未提供的数据暂时使用mockjs模拟数据填充
6. 前端页面和资源使用webpack打包，最后剩下index.html和static文件夹(里面包含css/js/img文件夹)，并通过ftp上传到虚拟主机空间，保证可以通过linyaqing.com访问到index.html及其静态资源
7. nodejs后台文件打包，并购买云服务器，配置node生产环境，将打包好的后台文件放到服务器并跑起来后，有权限的用户可以通过linyaqing.com这个域名下的路径访问到API接口内容。
8. 保证服务的正常运行，包括前端交互、业务数据操作、服务器稳定性和访问速度、数据库安全等方面
9. 未登录用户：new/trending模块、 featured/curated模块、store模块
10. 登录用户：new/trending/following模块、featured/curated/mine模块、store模块、开发者模块、标注模块、用户资料编辑模块