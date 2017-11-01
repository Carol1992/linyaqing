/*
Navicat MySQL Data Transfer

Source Server         : 2017
Source Server Version : 50719
Source Host           : localhost:3306
Source Database       : linyaqing

Target Server Type    : MYSQL
Target Server Version : 50719
File Encoding         : 65001

Date: 2017-10-31 21:55:55
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for `applications`
-- ----------------------------
DROP TABLE IF EXISTS `applications`;
CREATE TABLE `applications` (
  `app_id` int(9) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(9) DEFAULT NULL,
  `app_name` varchar(45) DEFAULT NULL,
  `app_desc` varchar(255) DEFAULT NULL,
  `created_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `callback_url` varchar(255) DEFAULT NULL,
  `status` char(1) DEFAULT '0' COMMENT '0: connected\n1: not connected',
  `hourly_rate_limit` smallint(4) DEFAULT NULL COMMENT '每小时最大访问数',
  `users_user_id` int(9) DEFAULT NULL,
  PRIMARY KEY (`app_id`),
  KEY `fk_applications_users1_idx` (`users_user_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `applications_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8 COMMENT='用户关联到网站的应用';

-- ----------------------------
-- Records of applications
-- ----------------------------
INSERT INTO `applications` VALUES ('3', '3', 'app1', 'my first app', null, 'http://baidu.com', '0', null, null);
INSERT INTO `applications` VALUES ('4', '3', 'app1', 'my first app', null, 'http://baidu.com', '0', null, null);
INSERT INTO `applications` VALUES ('5', '3', 'app1', 'my first app', null, 'http://baidu.com', '0', null, null);
INSERT INTO `applications` VALUES ('6', '3', 'app1', 'my first app', null, 'http://baidu.com', '0', null, null);
INSERT INTO `applications` VALUES ('7', '3', 'app1', 'my first app', null, 'http://baidu.com', '0', null, null);
INSERT INTO `applications` VALUES ('8', '3', 'app1', 'my first app', null, 'http://baidu.com', '0', null, null);
INSERT INTO `applications` VALUES ('9', '3', 'app1', 'my first app', null, 'http://baidu.com', '0', null, null);
INSERT INTO `applications` VALUES ('10', '3', 'app1', 'my first app', null, 'http://baidu.com', '0', null, null);
INSERT INTO `applications` VALUES ('11', '3', 'app1', 'my first app', null, 'http://baidu.com', '0', null, null);
INSERT INTO `applications` VALUES ('12', '3', 'app1', 'my first app', null, 'http://baidu.com', '0', null, null);
INSERT INTO `applications` VALUES ('13', '2', 'app1', 'my first app', null, 'http://baidu.com', '0', null, null);
INSERT INTO `applications` VALUES ('14', '2', 'app1', 'my first app', null, 'http://baidu.com', '0', null, null);
INSERT INTO `applications` VALUES ('15', '2', 'app1', 'my first app', null, 'http://baidu.com', '0', null, null);
INSERT INTO `applications` VALUES ('16', '2', 'app1', 'my first app', null, 'http://baidu.com', '0', null, null);

-- ----------------------------
-- Table structure for `app_permission`
-- ----------------------------
DROP TABLE IF EXISTS `app_permission`;
CREATE TABLE `app_permission` (
  `app_id` int(9) NOT NULL,
  `permission_id` int(9) NOT NULL,
  `applications_app_id` int(9) unsigned DEFAULT NULL,
  `permissions_id` tinyint(1) unsigned DEFAULT NULL,
  `created_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`app_id`,`permission_id`),
  KEY `fk_app_permision_applications1_idx` (`applications_app_id`),
  KEY `fk_app_permision_permissions1_idx` (`permissions_id`),
  CONSTRAINT `fk_app_permision_applications1` FOREIGN KEY (`applications_app_id`) REFERENCES `applications` (`app_id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `fk_app_permision_permissions1` FOREIGN KEY (`permissions_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of app_permission
-- ----------------------------
INSERT INTO `app_permission` VALUES ('12', '1', null, null, '2017-10-31 13:22:31');
INSERT INTO `app_permission` VALUES ('12', '2', null, null, '2017-10-31 13:22:31');
INSERT INTO `app_permission` VALUES ('13', '1', null, null, '2017-10-31 13:22:31');
INSERT INTO `app_permission` VALUES ('13', '2', null, null, '2017-10-31 13:22:31');
INSERT INTO `app_permission` VALUES ('14', '1', null, null, '2017-10-31 13:22:31');
INSERT INTO `app_permission` VALUES ('14', '2', null, null, '2017-10-31 13:22:31');
INSERT INTO `app_permission` VALUES ('15', '1', null, null, '2017-10-31 13:22:31');
INSERT INTO `app_permission` VALUES ('15', '2', null, null, '2017-10-31 13:22:31');
INSERT INTO `app_permission` VALUES ('16', '1', null, null, '2017-10-31 13:22:31');
INSERT INTO `app_permission` VALUES ('16', '2', null, null, '2017-10-31 13:22:31');

-- ----------------------------
-- Table structure for `carts`
-- ----------------------------
DROP TABLE IF EXISTS `carts`;
CREATE TABLE `carts` (
  `user_id` int(9) NOT NULL COMMENT '用户id',
  `product_id` int(9) NOT NULL COMMENT '加入购物车的商品id',
  `product_quantity` smallint(4) DEFAULT NULL,
  `users_user_id` int(9) DEFAULT NULL,
  `products_product_id` int(9) unsigned DEFAULT NULL,
  `created_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`,`product_id`),
  KEY `fk_carts_users1_idx` (`users_user_id`),
  KEY `fk_carts_products1_idx` (`products_product_id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `carts_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `carts_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='购物车，记录登录用户将哪些商品放入购物车。如果是非登录用户将商品放入购物车，则用localStorage在本地记住就好';

-- ----------------------------
-- Records of carts
-- ----------------------------
INSERT INTO `carts` VALUES ('1', '2', '12', null, null, '2017-10-31 18:10:49');

-- ----------------------------
-- Table structure for `categories`
-- ----------------------------
DROP TABLE IF EXISTS `categories`;
CREATE TABLE `categories` (
  `category_id` int(9) unsigned NOT NULL AUTO_INCREMENT,
  `category_name` varchar(45) DEFAULT NULL COMMENT '类别的名称',
  `category_image_md5` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`category_id`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8 COMMENT='按类别分类的图片集';

-- ----------------------------
-- Records of categories
-- ----------------------------
INSERT INTO `categories` VALUES ('15', '动物', '2222');
INSERT INTO `categories` VALUES ('16', '建筑', null);
INSERT INTO `categories` VALUES ('17', '四季风光', null);
INSERT INTO `categories` VALUES ('18', '海洋、江河、湖', null);
INSERT INTO `categories` VALUES ('19', '人物', null);
INSERT INTO `categories` VALUES ('20', '幽默', null);
INSERT INTO `categories` VALUES ('21', '艺术', null);
INSERT INTO `categories` VALUES ('22', '动漫', null);
INSERT INTO `categories` VALUES ('23', '工作', null);

-- ----------------------------
-- Table structure for `collections`
-- ----------------------------
DROP TABLE IF EXISTS `collections`;
CREATE TABLE `collections` (
  `collection_id` int(9) NOT NULL AUTO_INCREMENT,
  `collection_name` varchar(45) DEFAULT NULL,
  `collection_image_md5` varchar(255) DEFAULT NULL,
  `created_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`collection_id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8 COMMENT='图片集合';

-- ----------------------------
-- Records of collections
-- ----------------------------
INSERT INTO `collections` VALUES ('12', '萌宠', '11111111111', '2017-10-10 17:14:03');
INSERT INTO `collections` VALUES ('13', '家人', '111111111111', '2017-10-30 17:14:01');
INSERT INTO `collections` VALUES ('14', null, 'sssssssssssssssssss', null);
INSERT INTO `collections` VALUES ('15', null, 'sssssssssssssssssss', null);
INSERT INTO `collections` VALUES ('16', null, 'sssssssssssssssssss', null);
INSERT INTO `collections` VALUES ('17', null, 'sssssssssssssssssss', null);
INSERT INTO `collections` VALUES ('18', null, 'sssssssssssssssssss', null);
INSERT INTO `collections` VALUES ('19', null, 'sssssssssssssssssss', null);

-- ----------------------------
-- Table structure for `email_settings`
-- ----------------------------
DROP TABLE IF EXISTS `email_settings`;
CREATE TABLE `email_settings` (
  `settings_id` int(9) unsigned NOT NULL,
  `settings_name` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`settings_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='邮件设置';

-- ----------------------------
-- Records of email_settings
-- ----------------------------
INSERT INTO `email_settings` VALUES ('1', '更改用户信息邮件通知');
INSERT INTO `email_settings` VALUES ('2', '关注的作者有作品更新时邮件通知');
INSERT INTO `email_settings` VALUES ('3', '商店有新品上架时邮件通知');
INSERT INTO `email_settings` VALUES ('4', '每日最热图片推送');
INSERT INTO `email_settings` VALUES ('5', '每日最新图片推送');
INSERT INTO `email_settings` VALUES ('6', '每日精选图片集推送');

-- ----------------------------
-- Table structure for `images`
-- ----------------------------
DROP TABLE IF EXISTS `images`;
CREATE TABLE `images` (
  `image_id` int(9) unsigned NOT NULL AUTO_INCREMENT,
  `image_md5` varchar(255) DEFAULT NULL COMMENT '图片MD5',
  `user_id` int(9) DEFAULT NULL COMMENT '图片上传者的id',
  `created_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '图片创建的时间',
  `image_tags` varchar(90) DEFAULT NULL COMMENT '图片的标签',
  `enough_tags` char(1) DEFAULT '1' COMMENT '是否有足够的标签（5个）\n0：是\n1：否',
  `make` varchar(45) DEFAULT NULL COMMENT '相机品牌',
  `model` varchar(45) DEFAULT NULL COMMENT '相机型号',
  `focalLength` varchar(45) DEFAULT NULL COMMENT '焦距',
  `aperture` varchar(45) DEFAULT NULL COMMENT '光圈',
  `iso` varchar(45) DEFAULT NULL COMMENT '感光度',
  `shutterSpeed` varchar(45) DEFAULT NULL COMMENT '快门速度',
  `story_title` varchar(45) DEFAULT NULL COMMENT '照片名称',
  `story_detail` tinytext COMMENT '照片故事',
  `location` varchar(45) DEFAULT NULL COMMENT '拍摄地址',
  `display_location` char(1) DEFAULT '0' COMMENT '0:展示\n1:不展示',
  `liked` smallint(5) DEFAULT NULL,
  `collection_id` int(9) DEFAULT NULL,
  `users_user_id` int(9) DEFAULT NULL,
  PRIMARY KEY (`image_id`),
  KEY `fk_images_users1_idx` (`users_user_id`),
  KEY `collection_id` (`collection_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `images_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `images_ibfk_2` FOREIGN KEY (`collection_id`) REFERENCES `collections` (`collection_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8 COMMENT='单张图片';

-- ----------------------------
-- Records of images
-- ----------------------------
INSERT INTO `images` VALUES ('7', 'eee', '1', '2017-10-16 16:27:37', 'cc,ddd', '1', null, null, null, null, null, null, null, null, null, '0', '12322', null, null);
INSERT INTO `images` VALUES ('8', 'dddd', '4', '2017-10-29 16:27:42', 'carol,cc,carol,cksdkjdkjdkljc', '1', null, null, null, null, null, null, null, null, null, '0', '222', null, null);
INSERT INTO `images` VALUES ('9', 'sssssssssssssssssss', '2', null, 'bird, nice', '1', null, null, null, null, null, null, null, null, null, null, null, '19', null);
INSERT INTO `images` VALUES ('10', 'sssssssssssssssssssssssssss', '2', null, 'bird, nice', '1', null, null, null, null, null, null, null, null, null, null, null, '14', null);
INSERT INTO `images` VALUES ('11', 'sssssssssssssssssss', '2', null, 'bird, nice', '1', null, null, null, null, null, null, null, null, null, null, null, '19', null);
INSERT INTO `images` VALUES ('12', 'sssssssssssssssssss', '2', null, 'bird, nice', '1', null, null, null, null, null, null, null, null, null, null, null, '19', null);
INSERT INTO `images` VALUES ('13', 'sssssssssssssssssss', '2', null, 'bird, nice', '1', null, null, null, null, null, null, null, null, null, null, null, '19', null);
INSERT INTO `images` VALUES ('14', 'sssssssssssssssssss', '2', null, 'bird, nice', '1', null, null, null, null, null, null, null, null, null, null, null, '19', null);
INSERT INTO `images` VALUES ('15', 'sssssssssssssssssss', '2', null, 'bird, nice', '1', null, null, null, null, null, null, null, null, null, null, null, '19', null);
INSERT INTO `images` VALUES ('16', 'sssssssssssssssssss', '2', null, 'bird, nice', '1', null, null, null, null, null, null, null, null, null, null, null, '19', null);
INSERT INTO `images` VALUES ('17', 'sssssssssssssssssss', '2', null, 'bird, nice', '1', null, null, null, null, null, null, null, null, null, null, null, '19', null);
INSERT INTO `images` VALUES ('18', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509421924159.jpeg', '3', null, 'bird, nice', '1', null, null, null, null, null, null, null, null, null, null, null, '19', null);

-- ----------------------------
-- Table structure for `inventories`
-- ----------------------------
DROP TABLE IF EXISTS `inventories`;
CREATE TABLE `inventories` (
  `id` int(9) NOT NULL AUTO_INCREMENT,
  `product_id` int(9) DEFAULT NULL,
  `inventory` smallint(5) DEFAULT NULL,
  `unit` varchar(45) DEFAULT NULL COMMENT '单位：件、个、幅等',
  `location` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `inventories_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of inventories
-- ----------------------------
INSERT INTO `inventories` VALUES ('1', '1', '8999', '件', '深圳');
INSERT INTO `inventories` VALUES ('2', '2', '999', '件', '上海');
INSERT INTO `inventories` VALUES ('3', '1', '22', '件', '广州');
INSERT INTO `inventories` VALUES ('4', '1', '13', null, '北京');

-- ----------------------------
-- Table structure for `orders`
-- ----------------------------
DROP TABLE IF EXISTS `orders`;
CREATE TABLE `orders` (
  `order_id` int(9) NOT NULL AUTO_INCREMENT,
  `user_id` int(9) DEFAULT NULL,
  `created_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`order_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of orders
-- ----------------------------
INSERT INTO `orders` VALUES ('1', '3', '2017-10-31 21:46:07');

-- ----------------------------
-- Table structure for `order_details`
-- ----------------------------
DROP TABLE IF EXISTS `order_details`;
CREATE TABLE `order_details` (
  `order_id` int(9) NOT NULL,
  `product_id` int(9) NOT NULL,
  `quantity` smallint(4) DEFAULT NULL,
  `products_product_id` int(9) unsigned DEFAULT NULL,
  `orders_order_id` int(9) DEFAULT NULL,
  PRIMARY KEY (`order_id`,`product_id`),
  KEY `fk_order_details_products1_idx` (`products_product_id`),
  KEY `fk_order_details_orders1_idx` (`orders_order_id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `order_details_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `order_details_ibfk_2` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of order_details
-- ----------------------------
INSERT INTO `order_details` VALUES ('1', '1', '12', null, null);
INSERT INTO `order_details` VALUES ('1', '2', '13', null, null);
INSERT INTO `order_details` VALUES ('1', '3', '23', null, null);

-- ----------------------------
-- Table structure for `permissions`
-- ----------------------------
DROP TABLE IF EXISTS `permissions`;
CREATE TABLE `permissions` (
  `id` tinyint(1) unsigned NOT NULL AUTO_INCREMENT,
  `permission_name` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8 COMMENT='应用能够获取到的用户权限';

-- ----------------------------
-- Records of permissions
-- ----------------------------
INSERT INTO `permissions` VALUES ('1', '允许分享');
INSERT INTO `permissions` VALUES ('2', '允许SEO');

-- ----------------------------
-- Table structure for `products`
-- ----------------------------
DROP TABLE IF EXISTS `products`;
CREATE TABLE `products` (
  `product_id` int(9) NOT NULL AUTO_INCREMENT,
  `product_md5` varchar(255) DEFAULT NULL COMMENT '商品封面',
  `product_name` varchar(45) DEFAULT NULL COMMENT '商品名',
  `user_id` int(9) DEFAULT NULL COMMENT '作者',
  `product_price` decimal(10,0) DEFAULT NULL COMMENT '产品价格',
  `profits_share` char(1) DEFAULT '0' COMMENT '作者得到利润的30% \n0： true\n1: false',
  `created_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '商品创建时间',
  `product_desc` tinytext COMMENT '产品描述',
  `product_size` varchar(2) DEFAULT NULL COMMENT '产品规格：xs, s, m, l, xl',
  `body_length` tinyint(3) DEFAULT NULL COMMENT '衣长',
  `chest` tinyint(3) DEFAULT NULL COMMENT '胸围',
  `sleeve` tinyint(3) DEFAULT NULL COMMENT '袖长',
  PRIMARY KEY (`product_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `products_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COMMENT='商品列表';

-- ----------------------------
-- Records of products
-- ----------------------------
INSERT INTO `products` VALUES ('1', '11111111111111111111111111', '产品', '1', '12', '0', '2017-10-31 18:06:51', '端到端', '12', '23', '22', null);
INSERT INTO `products` VALUES ('2', '3333333333333333', '谔谔谔谔', '3', '23', '0', '2017-10-31 18:06:49', '订单', '23', '22', '22', null);
INSERT INTO `products` VALUES ('3', '222222222222', '分发', '3', null, '0', '2017-10-31 18:07:04', null, null, null, null, null);

-- ----------------------------
-- Table structure for `product_image`
-- ----------------------------
DROP TABLE IF EXISTS `product_image`;
CREATE TABLE `product_image` (
  `product_id` int(9) NOT NULL,
  `image_id` int(9) NOT NULL,
  PRIMARY KEY (`product_id`,`image_id`),
  KEY `image_id` (`image_id`),
  CONSTRAINT `product_image_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `product_image_ibfk_2` FOREIGN KEY (`image_id`) REFERENCES `store_images` (`image_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of product_image
-- ----------------------------
INSERT INTO `product_image` VALUES ('1', '1');
INSERT INTO `product_image` VALUES ('1', '2');

-- ----------------------------
-- Table structure for `relationships`
-- ----------------------------
DROP TABLE IF EXISTS `relationships`;
CREATE TABLE `relationships` (
  `user_id` int(9) NOT NULL,
  `follower_id` int(9) NOT NULL,
  `users_user_id` int(9) DEFAULT NULL,
  `created_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`,`follower_id`),
  KEY `fk_relationships_users1_idx` (`users_user_id`),
  CONSTRAINT `relationships_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of relationships
-- ----------------------------
INSERT INTO `relationships` VALUES ('2', '1', null, '2017-10-31 13:20:39');
INSERT INTO `relationships` VALUES ('2', '3', null, '2017-10-31 13:20:39');
INSERT INTO `relationships` VALUES ('2', '4', null, '2017-10-31 13:20:39');
INSERT INTO `relationships` VALUES ('3', '1', null, '2017-10-31 13:20:39');
INSERT INTO `relationships` VALUES ('3', '4', null, '2017-10-31 13:20:39');

-- ----------------------------
-- Table structure for `store_images`
-- ----------------------------
DROP TABLE IF EXISTS `store_images`;
CREATE TABLE `store_images` (
  `image_id` int(9) NOT NULL AUTO_INCREMENT,
  `image_name` varchar(45) DEFAULT NULL,
  `image_url` varchar(255) DEFAULT NULL,
  `image_desc` tinytext,
  `created_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`image_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of store_images
-- ----------------------------
INSERT INTO `store_images` VALUES ('1', '11111', '111', '111', '2017-10-31 18:07:34');
INSERT INTO `store_images` VALUES ('2', '1122', '333', '222', '2017-10-31 18:07:43');
INSERT INTO `store_images` VALUES ('3', '12', '33', '饿饿的', '2017-10-31 18:07:54');

-- ----------------------------
-- Table structure for `users`
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `user_id` int(9) NOT NULL AUTO_INCREMENT,
  `is_developer` char(1) DEFAULT '1' COMMENT '是否注册为开发者：\n0：是\n1：否',
  `is_admin` char(1) DEFAULT '1' COMMENT '是否是管理员\n0： 是\n1： 不是',
  `user_name` varchar(90) DEFAULT NULL COMMENT '用户名',
  `first_name` varchar(45) DEFAULT NULL COMMENT '名',
  `last_name` varchar(45) DEFAULT NULL COMMENT '姓',
  `phone` varchar(14) DEFAULT NULL COMMENT '手机号码',
  `email` varchar(45) DEFAULT NULL COMMENT '邮件',
  `password` varchar(45) DEFAULT NULL,
  `province` char(6) DEFAULT NULL COMMENT '省代码',
  `city` char(6) DEFAULT NULL COMMENT '市代码',
  `town` char(6) DEFAULT NULL COMMENT '县区代码',
  `image_md5` varchar(255) DEFAULT NULL COMMENT '用户头像，MD5格式',
  `personal_site` varchar(255) DEFAULT NULL COMMENT '个人网站',
  `instagram` varchar(45) DEFAULT NULL COMMENT 'instagram用户名',
  `twitter` varchar(45) DEFAULT NULL COMMENT 'twitter 用户名',
  `location` varchar(255) DEFAULT NULL COMMENT '地址',
  `bio` tinytext CHARACTER SET dec8 COLLATE dec8_bin COMMENT '个人简介',
  `created_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `dev_url` varchar(255) DEFAULT NULL,
  `dev_desc` tinytext,
  `company` varchar(45) DEFAULT NULL,
  `delivery_address` varchar(90) DEFAULT NULL,
  `delivery_city` char(6) DEFAULT NULL,
  `delivery_province` char(6) DEFAULT NULL,
  `delivery_town` char(6) DEFAULT NULL,
  `postal_code` varchar(6) DEFAULT NULL,
  `card_num` char(16) DEFAULT NULL,
  `name_on_card` varchar(45) DEFAULT NULL,
  `mm/yy` char(5) DEFAULT NULL,
  `cvv` char(3) DEFAULT NULL,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 COMMENT='存储注册用户的相关信息';

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO `users` VALUES ('1', '1', '1', '大苏打', '', '', null, 'mklklklkeli@gmail.com', 'hh', '广东', '深圳', '福田', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null);
INSERT INTO `users` VALUES ('2', '0', '1', '大苏打', '', '', null, 'm@gmail.com', 'kijkjkjkju', null, null, null, null, null, null, null, null, null, null, 'https://baidu.com', 'I AM AN EXCELLENT DEVELOPER', null, null, null, null, null, null, null, null, null, null);
INSERT INTO `users` VALUES ('3', '0', '1', '大苏lll打', '', '', null, 'm0@gmail.com', 'hh', null, null, null, null, null, null, null, null, null, null, 'https://baidu.com', 'I AM AN EXCELLENT DEVELOPER', null, null, null, null, null, null, null, null, null, null);
INSERT INTO `users` VALUES ('4', '1', '1', '大苏lll打', '', '', null, 'mklklk0@gmail.com', 'hh', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null);
INSERT INTO `users` VALUES ('6', '1', '1', '大苏打', '', '', null, 'm1@gmail.com', '5e36941b3d856737e81516acd45edc50', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null);
INSERT INTO `users` VALUES ('7', '1', '1', '大苏打', '', '', null, 'q@gmail.com', '5e36941b3d856737e81516acd45edc50', null, null, null, null, null, null, null, null, null, '2017-10-31 13:13:49', null, null, null, null, null, null, null, null, null, null, null, null);

-- ----------------------------
-- Table structure for `user_category`
-- ----------------------------
DROP TABLE IF EXISTS `user_category`;
CREATE TABLE `user_category` (
  `user_id` int(9) NOT NULL,
  `category_id` int(9) NOT NULL,
  `categories_category_id` int(9) unsigned DEFAULT NULL,
  `users_user_id` int(9) DEFAULT NULL,
  `created_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`category_id`,`user_id`),
  KEY `fk_user_category_categories1_idx` (`categories_category_id`),
  KEY `fk_user_category_users1_idx` (`users_user_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `fk_user_category_categories1` FOREIGN KEY (`categories_category_id`) REFERENCES `categories` (`category_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `user_category_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of user_category
-- ----------------------------
INSERT INTO `user_category` VALUES ('3', '15', null, null, '2017-10-31 13:19:58');
INSERT INTO `user_category` VALUES ('3', '16', null, null, '2017-10-31 13:19:58');
INSERT INTO `user_category` VALUES ('3', '17', null, null, '2017-10-31 13:19:58');
INSERT INTO `user_category` VALUES ('3', '18', null, null, '2017-10-31 13:19:58');
INSERT INTO `user_category` VALUES ('3', '23', null, null, '2017-10-31 13:19:58');

-- ----------------------------
-- Table structure for `user_email`
-- ----------------------------
DROP TABLE IF EXISTS `user_email`;
CREATE TABLE `user_email` (
  `user_id` int(9) NOT NULL,
  `settings_id` int(9) NOT NULL,
  `email_settings_settings_id` int(9) unsigned DEFAULT NULL,
  `users_user_id` int(9) DEFAULT NULL,
  `created_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`settings_id`,`user_id`),
  KEY `fk_user_email_email_settings1_idx` (`email_settings_settings_id`),
  KEY `fk_user_email_users1_idx` (`users_user_id`),
  KEY `user_email_ibfk_1` (`user_id`),
  CONSTRAINT `fk_user_email_email_settings1` FOREIGN KEY (`email_settings_settings_id`) REFERENCES `email_settings` (`settings_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `user_email_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of user_email
-- ----------------------------
INSERT INTO `user_email` VALUES ('3', '1', null, null, '2017-10-31 13:19:23');
INSERT INTO `user_email` VALUES ('3', '2', null, null, '2017-10-31 13:19:23');
INSERT INTO `user_email` VALUES ('3', '3', null, null, '2017-10-31 13:19:23');
INSERT INTO `user_email` VALUES ('3', '4', null, null, '2017-10-31 13:19:23');
INSERT INTO `user_email` VALUES ('3', '5', null, null, '2017-10-31 13:19:23');
INSERT INTO `user_email` VALUES ('3', '6', null, null, '2017-10-31 13:19:23');
