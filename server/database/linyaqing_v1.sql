/*
Navicat MySQL Data Transfer

Source Server         : 2017
Source Server Version : 50719
Source Host           : localhost:3306
Source Database       : linyaqing

Target Server Type    : MYSQL
Target Server Version : 50719
File Encoding         : 65001

Date: 2017-11-22 11:31:06
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for `applications`
-- ----------------------------
DROP TABLE IF EXISTS `applications`;
CREATE TABLE `applications` (
  `app_id` int(9) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(9) DEFAULT NULL,
  `app_name` varchar(45) DEFAULT '',
  `app_desc` varchar(255) DEFAULT '',
  `created_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `callback_url` varchar(255) DEFAULT '',
  `status` char(1) DEFAULT '0' COMMENT '0: connected\n1: not connected',
  `hourly_rate_limit` smallint(4) DEFAULT '0' COMMENT '每小时最大访问数',
  `users_user_id` int(9) DEFAULT NULL,
  PRIMARY KEY (`app_id`),
  KEY `fk_applications_users1_idx` (`users_user_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `applications_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户关联到网站的应用';

-- ----------------------------
-- Records of applications
-- ----------------------------

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
  CONSTRAINT `fk_app_permision_applications1` FOREIGN KEY (`applications_app_id`) REFERENCES `applications` (`app_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_app_permision_permissions1` FOREIGN KEY (`permissions_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
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
INSERT INTO `app_permission` VALUES ('17', '1', null, null, '2017-11-03 23:17:14');
INSERT INTO `app_permission` VALUES ('17', '2', null, null, '2017-11-03 23:17:14');

-- ----------------------------
-- Table structure for `carts`
-- ----------------------------
DROP TABLE IF EXISTS `carts`;
CREATE TABLE `carts` (
  `user_id` int(9) NOT NULL COMMENT '用户id',
  `product_id` int(9) NOT NULL COMMENT '加入购物车的商品id',
  `product_quantity` smallint(4) DEFAULT '0',
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

-- ----------------------------
-- Table structure for `categories`
-- ----------------------------
DROP TABLE IF EXISTS `categories`;
CREATE TABLE `categories` (
  `category_id` int(9) unsigned NOT NULL AUTO_INCREMENT,
  `category_name` varchar(45) DEFAULT '' COMMENT '类别的名称',
  `category_image_md5` varchar(255) DEFAULT '',
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
  `collection_image_md5` varchar(255) DEFAULT '',
  `created_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_private` char(1) DEFAULT '0' COMMENT '是否私有：0：是，1：否',
  `collection_desc` varchar(255) DEFAULT NULL,
  `user_id` int(9) DEFAULT NULL,
  PRIMARY KEY (`collection_id`)
) ENGINE=InnoDB AUTO_INCREMENT=110 DEFAULT CHARSET=utf8 COMMENT='图片集合';

-- ----------------------------
-- Records of collections
-- ----------------------------
INSERT INTO `collections` VALUES ('75', '缅甸胶漂电站', '', '2017-11-16 20:24:36', '1', null, '34');
INSERT INTO `collections` VALUES ('76', '和同事在海边玩', '', '2017-11-16 20:25:22', '0', null, '34');
INSERT INTO `collections` VALUES ('77', '公司聚会', '', '2017-11-19 10:03:44', '0', null, '35');
INSERT INTO `collections` VALUES ('78', '公司party', '', '2017-11-19 10:03:52', '0', null, '36');
INSERT INTO `collections` VALUES ('79', '家人自拍', '', '2017-11-19 10:03:59', '1', null, '37');
INSERT INTO `collections` VALUES ('81', '自拍自拍自拍自', '', '2017-11-19 15:11:00', '1', null, '37');
INSERT INTO `collections` VALUES ('82', '缅甸电站', '', '2017-11-19 10:04:06', '1', null, '38');
INSERT INTO `collections` VALUES ('85', '风景与仰光', '', '2017-11-19 10:04:17', '0', null, '39');
INSERT INTO `collections` VALUES ('86', '阳光和向日葵', '', '2017-11-19 10:04:30', '0', null, '39');
INSERT INTO `collections` VALUES ('87', '猫狗', '', '2017-11-19 10:04:41', '0', null, '39');
INSERT INTO `collections` VALUES ('92', '宠物', '', '2017-11-19 10:04:50', '1', null, '39');
INSERT INTO `collections` VALUES ('93', '猫', '', '2017-11-19 10:04:56', '1', null, '39');
INSERT INTO `collections` VALUES ('94', '狗', '', '2017-11-19 10:04:59', '1', null, '40');
INSERT INTO `collections` VALUES ('97', '1992', '', '2017-11-19 10:05:27', '1', null, '42');
INSERT INTO `collections` VALUES ('98', '1992', '', '2017-11-19 10:05:31', '1', null, '42');
INSERT INTO `collections` VALUES ('99', '天空', '', '2017-11-19 10:40:57', '0', null, '42');
INSERT INTO `collections` VALUES ('100', '2017/10/19 11:33:56', '', '2017-11-19 11:33:56', '0', null, '45');
INSERT INTO `collections` VALUES ('101', '2017/10/19 12:23:51', '', '2017-11-19 15:11:07', '1', null, '37');
INSERT INTO `collections` VALUES ('102', '2017/10/19 14:55:15', '', '2017-11-19 14:55:15', '0', null, '47');
INSERT INTO `collections` VALUES ('103', '2017/10/19 15:10:39', '', '2017-11-19 15:10:50', '1', null, '37');
INSERT INTO `collections` VALUES ('104', '2017/10/19 15:18:36', '', '2017-11-19 15:18:42', '1', null, '39');
INSERT INTO `collections` VALUES ('105', '2017/10/19 15:19:28', '', '2017-11-19 15:20:07', '1', null, '39');
INSERT INTO `collections` VALUES ('106', '2017/10/19 15:19:53', '', '2017-11-19 15:19:59', '1', null, '39');
INSERT INTO `collections` VALUES ('107', '2017/10/19 15:32:59', '', '2017-11-19 15:32:59', '0', null, '39');
INSERT INTO `collections` VALUES ('108', '2017/10/21 18:36:49', '', '2017-11-21 18:36:49', '0', null, '49');
INSERT INTO `collections` VALUES ('109', '2017/10/21 18:37:4', '', '2017-11-21 18:37:04', '0', null, '49');

-- ----------------------------
-- Table structure for `comments`
-- ----------------------------
DROP TABLE IF EXISTS `comments`;
CREATE TABLE `comments` (
  `comment_id` int(11) NOT NULL AUTO_INCREMENT,
  `image_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `comment` char(250) DEFAULT NULL,
  PRIMARY KEY (`comment_id`),
  KEY `image_id` (`image_id`),
  CONSTRAINT `comments_ibfk_1` FOREIGN KEY (`image_id`) REFERENCES `images` (`image_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of comments
-- ----------------------------

-- ----------------------------
-- Table structure for `deliveries`
-- ----------------------------
DROP TABLE IF EXISTS `deliveries`;
CREATE TABLE `deliveries` (
  `delivery_id` int(9) NOT NULL AUTO_INCREMENT,
  `delivery_address` varchar(90) DEFAULT '',
  `delivery_city` varchar(45) DEFAULT '',
  `delivery_province` varchar(45) DEFAULT '',
  `delivery_town` varchar(45) DEFAULT '',
  `consignee` varchar(45) DEFAULT '',
  `consignee_phone` char(13) DEFAULT '',
  PRIMARY KEY (`delivery_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of deliveries
-- ----------------------------
INSERT INTO `deliveries` VALUES ('1', 'hshshsh', '深圳', '广东', '龙华', '林晴', '18826417583');
INSERT INTO `deliveries` VALUES ('2', '哈哈道具卡还是看', '广州', '广东', '越秀', '绵绵', '17726262662');
INSERT INTO `deliveries` VALUES ('3', '金卡金卡金卡', '北京', '北京', null, null, '92798798793');
INSERT INTO `deliveries` VALUES ('4', 'jjdjdjjd', null, null, null, 'carol', '17772772');
INSERT INTO `deliveries` VALUES ('5', '1866蓝湾半岛', '北海', '广西', '', '林晴', '18826417583');
INSERT INTO `deliveries` VALUES ('6', '1866蓝湾半岛', '北海', '广西', '', '林晴', '18826417583');

-- ----------------------------
-- Table structure for `delivery_address`
-- ----------------------------
DROP TABLE IF EXISTS `delivery_address`;
CREATE TABLE `delivery_address` (
  `user_id` int(9) NOT NULL,
  `delivery_id` int(9) NOT NULL,
  PRIMARY KEY (`user_id`,`delivery_id`),
  KEY `delivery_id` (`delivery_id`),
  CONSTRAINT `delivery_address_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `delivery_address_ibfk_2` FOREIGN KEY (`delivery_id`) REFERENCES `deliveries` (`delivery_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of delivery_address
-- ----------------------------

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
INSERT INTO `email_settings` VALUES ('5', '好友关系互动邮件通知');
INSERT INTO `email_settings` VALUES ('6', '每日精选推送');

-- ----------------------------
-- Table structure for `images`
-- ----------------------------
DROP TABLE IF EXISTS `images`;
CREATE TABLE `images` (
  `image_id` int(9) NOT NULL AUTO_INCREMENT,
  `image_md5` varchar(255) DEFAULT '' COMMENT '图片MD5',
  `user_id` int(9) DEFAULT NULL COMMENT '图片上传者的id',
  `created_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '图片创建的时间',
  `image_tags` varchar(90) DEFAULT '' COMMENT '图片的标签',
  `story_title` varchar(45) DEFAULT '' COMMENT '照片名称',
  `story_detail` varchar(255) DEFAULT '' COMMENT '照片故事',
  `enough_tags` char(1) DEFAULT '1' COMMENT '是否有足够的标签（5个）\n0：是\n1：否',
  `make` varchar(45) DEFAULT '' COMMENT '相机品牌',
  `model` varchar(45) DEFAULT '' COMMENT '相机型号',
  `focalLength` varchar(45) DEFAULT '' COMMENT '焦距',
  `aperture` varchar(45) DEFAULT '' COMMENT '光圈',
  `dateTimeOriginal` varchar(45) DEFAULT 'CURRENT_TIMESTAMP',
  `iso` varchar(45) DEFAULT '' COMMENT '感光度',
  `shutterSpeed` varchar(45) DEFAULT '' COMMENT '快门速度',
  `location` varchar(45) DEFAULT '' COMMENT '拍摄地址',
  `display_location` char(1) DEFAULT '0' COMMENT '0:展示\n1:不展示',
  `liked` smallint(5) DEFAULT '0',
  `collection_id` int(9) DEFAULT NULL,
  `users_user_id` int(9) DEFAULT NULL,
  PRIMARY KEY (`image_id`),
  KEY `fk_images_users1_idx` (`users_user_id`),
  KEY `collection_id` (`collection_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `images_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=236 DEFAULT CHARSET=utf8 COMMENT='单张图片';

-- ----------------------------
-- Records of images
-- ----------------------------
INSERT INTO `images` VALUES ('187', '1510840015938.JPG', '37', '2017-11-19 10:22:17', '自拍', '我的自拍', '自拍', '1', 'Apple', 'iPhone 6s Plus', '2.65', '2.2750071245369052', '2017:06:24 08:29:36', '80', '4.058893515764426', '深圳', '0', '0', '80', null);
INSERT INTO `images` VALUES ('188', '1510840032069.JPG', '37', '2017-11-19 10:22:19', '狗', '我的狗', '狗', '1', 'Apple', 'iPhone 6s Plus', '2.65', '2.2750071245369052', '2017:06:03 06:42:04', '80', '4.058893515764426', '深圳', '0', '0', '80', null);
INSERT INTO `images` VALUES ('189', '1510840584912.JPG', '37', '2017-11-19 10:22:23', '自拍', '我的猫', '猫猫', '1', 'Apple', 'iPhone 6s Plus', '2.65', '2.2750071245369052', '2017:04:17 21:43:25', '250', '4.321928460342146', '缅甸', '0', '0', '81', null);
INSERT INTO `images` VALUES ('190', '1510840602628.JPG', '37', '2017-11-19 10:22:26', '猫', '太阳', '太阳', '1', 'Apple', 'iPhone8,2', null, null, '2017:07:19 21:03:58', null, null, '缅甸', '0', '0', '81', null);
INSERT INTO `images` VALUES ('191', '1510840618515.JPG', '37', '2017-11-19 10:22:29', '太阳,风景', '猫', '公司鬼鬼鬼鬼鬼鬼', '1', null, null, null, null, null, null, null, '北京', '0', '0', '81', null);
INSERT INTO `images` VALUES ('193', '1510841408476.jpg', '38', '2017-11-19 10:22:33', '猫', '猫', '公司猫猫猫猫猫猫猫', '1', 'XIAOMI', 'MI4', '3.9', '1.69', '2016:10:04 17:55:21', '100', '9.181', '北京', '0', '0', '82', null);
INSERT INTO `images` VALUES ('211', '1510996592696.JPG', '42', '2017-11-19 10:22:45', '猫', '公司', '缅甸古古怪怪', '1', 'Apple', 'iPhone8,2', null, null, '2017:07:19 21:03:58', null, null, '天津', '0', '0', '95', null);
INSERT INTO `images` VALUES ('212', '1510997320069.JPG', '42', '2017-11-19 10:22:50', '狗', '狗狗', '公司计算机系', '1', 'Apple', 'iPhone8,2', null, null, '2017:07:19 21:03:58', null, null, '湖南', '0', '0', '96', null);
INSERT INTO `images` VALUES ('213', '1510999979197.jpg', '42', '2017-11-19 10:23:01', '1992', '1992', '1992', '1', 'XIAOMI1992', 'MI41992', '3.91992', '1.691992', '2016:10:01 08:35:231992', '1001992', '11.0161992', '揭阳', null, '0', '97', null);
INSERT INTO `images` VALUES ('214', '1511000001163.jpg', '42', '2017-11-19 10:22:55', '缅甸', '仰光缅甸', '1992', '1', 'XIAOMI', 'MI4', '3.9', '1.69', '2016:10:02 07:19:32', '100', '11.702', '深圳', '0', '0', '98', null);
INSERT INTO `images` VALUES ('215', '1511011765057.jpg', '42', '2017-11-19 10:21:49', '缅甸', '早晨', '1992', '1', 'XIAOMI', 'MI4', '3.9', '1.69', '2016:10:02 07:17:31', '100', '11.181', '缅甸', '0', '0', '99', null);
INSERT INTO `images` VALUES ('216', '1511012800057.jpg', '42', '2017-11-19 10:23:15', '缅甸,胶漂,公司', '缅甸', '1992', '1', 'XIAOMI', 'MI4', '3.9', '1.69', '2016:10:05 14:38:55', '100', '12.33', '浙江', '0', '0', '99', null);
INSERT INTO `images` VALUES ('217', '1511012841499.jpg', '42', '2017-11-19 10:23:19', '公司', '公司', '1992', '1', 'XIAOMI', 'MI4', '3.9', '1.69', '2016:10:05 14:42:35', '100', '12.64', '湖北', '0', '0', '98', null);
INSERT INTO `images` VALUES ('218', '1511012875367.jpg', '42', '2017-11-19 10:23:22', '自拍,公司', '公司', '1992', '1', 'XIAOMI', 'MI4', '3.9', '1.69', '2016:10:05 14:42:29', '100', '11.903', '海南', '0', '0', '99', null);
INSERT INTO `images` VALUES ('219', '1511058140494.jpg', '42', '2017-11-19 10:23:31', '海', '海', '海边深圳', '1', 'XIAOMI', 'MI4', '3.9', '1.69', '2016:10:05 14:45:45', '100', '12.243', '广东海南', '0', '0', '97', null);
INSERT INTO `images` VALUES ('220', '1511059373979.jpg', '42', '2017-11-19 10:40:43', '天空', '天空', '天空', '1', 'XIAOMI', 'MI4', '3.9', '1.69', '2016:10:06 09:06:10', '100', '10.523', null, '0', '0', '99', null);
INSERT INTO `images` VALUES ('222', '1511068215481.jpg', '37', '2017-11-22 10:20:43', null, '缅甸', null, '1', 'XIAOMI', 'MI4', '2.6133', '1.69', '2016:10:06 17:17:47', '100', '7.241', null, null, '0', '81', null);
INSERT INTO `images` VALUES ('223', '1511073234339.jpg', '37', '2017-11-20 12:39:42', null, '缅甸', null, '1', 'XIAOMI', 'MI4', '3.9', '1.69', '2016:10:02 07:32:20', '100', '8.912', null, '0', '0', '81', null);
INSERT INTO `images` VALUES ('224', '1511074808619.jpg', '47', '2017-11-20 12:39:45', null, '缅甸', null, '1', 'XIAOMIsssss', 'MI4', '3.9', '1.69', '2016:10:01 08:35:23', '100', '11.016', null, null, '0', '102', null);
INSERT INTO `images` VALUES ('225', '1511075705813.JPG', '37', '2017-11-19 15:10:39', '缅甸大金塔', '缅甸大金塔', '缅甸大金塔', '1', 'SAMSUNG', 'WB30F/WB31F/WB32F\0\0\0\0\0\0\0\0\0\0\0\0', '9.6', '4.27', '2016:10:06 19:37:28', '640', '3.25', '缅甸', '0', '0', '103', null);
INSERT INTO `images` VALUES ('226', '1511076208487.jpg', '39', '2017-11-20 12:39:47', null, '缅甸', null, '1', 'XIAOMI', 'MI4', '3.9', '1.69', '2016:10:05 14:38:50', '100', '12.523', null, '0', '0', '104', null);
INSERT INTO `images` VALUES ('227', '1511076254272.JPG', '39', '2017-11-20 12:39:50', '毕业照', '缅甸', null, '1', 'SAMSUNG', 'WB30F/WB31F/WB32F\0\0\0\0\0\0\0\0\0\0\0\0', '13.2', '4.58', '2015:04:24 16:49:21', '120', '5.62', null, '0', '0', '105', null);
INSERT INTO `images` VALUES ('228', '1511076279379.JPG', '39', '2017-11-19 15:19:53', '毕业照合照', null, null, '1', 'SAMSUNG', 'WB30F/WB31F/WB32F\0\0\0\0\0\0\0\0\0\0\0\0', '13.2', '4.58', '2015:04:24 12:24:55', '80', '8.5', null, '0', '0', '106', null);
INSERT INTO `images` VALUES ('229', '1511076343840.JPG', '39', '2017-11-19 15:20:54', null, null, null, '1', 'SAMSUNG', 'WB30F/WB31F/WB32F\0\0\0\0\0\0\0\0\0\0\0\0', '4.3', '3.26', '2015:04:24 10:56:53', '80', '8', null, '0', '0', '106', null);
INSERT INTO `images` VALUES ('230', '1511076368159.JPG', '39', '2017-11-19 15:21:18', null, null, null, '1', 'SAMSUNG', 'WB30F/WB31F/WB32F\0\0\0\0\0\0\0\0\0\0\0\0', '4.3', '3.26', '2015:04:24 09:33:42', '80', '8.18', null, '0', '0', '106', null);
INSERT INTO `images` VALUES ('231', '1511076390015.JPG', '39', '2017-11-19 15:21:39', null, null, null, '1', 'SAMSUNG', 'WB30F/WB31F/WB32F\0\0\0\0\0\0\0\0\0\0\0\0', '17.9', '4.86', '2015:04:24 16:49:51', '200', '5.68', null, '0', '0', '105', null);
INSERT INTO `images` VALUES ('232', '1511076421063.jpg', '39', '2017-11-19 15:22:18', null, null, null, '1', 'XIAOMI', 'MI4', '3.9', '1.69', '2016:10:05 14:45:47', '100', '12.161', null, '0', '0', '104', null);
INSERT INTO `images` VALUES ('233', '1511076461287.jpg', '39', '2017-11-19 15:22:59', null, null, null, '1', 'XIAOMI', 'MI4', '3.9', '1.69', '2016:10:05 14:42:24', '100', '11.977', null, '0', '0', '104', null);
INSERT INTO `images` VALUES ('234', '1511076544049.JPG', '39', '2017-11-19 15:24:14', null, null, null, '1', 'SAMSUNG', 'WB30F/WB31F/WB32F\0\0\0\0\0\0\0\0\0\0\0\0', '17.9', '4.86', '2015:04:24 11:54:28', '80', '7.56', null, '0', '0', '105', null);
INSERT INTO `images` VALUES ('235', '1511260991095.jpg', '49', '2017-11-21 18:38:35', null, null, null, '1', 'XIAOMI', 'MI4', '3.9', '1.69', '2016:10:04 17:57:52', '100', '8.498', null, '0', '0', '108', null);

-- ----------------------------
-- Table structure for `image_collection`
-- ----------------------------
DROP TABLE IF EXISTS `image_collection`;
CREATE TABLE `image_collection` (
  `image_id` int(9) NOT NULL,
  `collection_id` int(9) NOT NULL,
  `created_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`image_id`,`collection_id`),
  KEY `collection_id` (`collection_id`),
  CONSTRAINT `image_collection_ibfk_1` FOREIGN KEY (`image_id`) REFERENCES `images` (`image_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `image_collection_ibfk_2` FOREIGN KEY (`collection_id`) REFERENCES `collections` (`collection_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of image_collection
-- ----------------------------
INSERT INTO `image_collection` VALUES ('189', '81', '2017-11-16 21:51:37');
INSERT INTO `image_collection` VALUES ('189', '97', '2017-11-18 20:48:54');
INSERT INTO `image_collection` VALUES ('190', '81', '2017-11-16 21:51:49');
INSERT INTO `image_collection` VALUES ('190', '101', '2017-11-19 12:23:51');
INSERT INTO `image_collection` VALUES ('191', '81', '2017-11-16 21:52:05');
INSERT INTO `image_collection` VALUES ('193', '82', '2017-11-16 22:05:16');
INSERT INTO `image_collection` VALUES ('213', '97', '2017-11-18 20:48:46');
INSERT INTO `image_collection` VALUES ('214', '98', '2017-11-18 18:08:28');
INSERT INTO `image_collection` VALUES ('215', '99', '2017-11-18 21:24:56');
INSERT INTO `image_collection` VALUES ('216', '99', '2017-11-18 21:41:53');
INSERT INTO `image_collection` VALUES ('217', '98', '2017-11-18 21:42:33');
INSERT INTO `image_collection` VALUES ('218', '99', '2017-11-18 21:43:03');
INSERT INTO `image_collection` VALUES ('219', '97', '2017-11-19 10:17:54');
INSERT INTO `image_collection` VALUES ('220', '99', '2017-11-19 10:40:43');
INSERT INTO `image_collection` VALUES ('222', '81', '2017-11-19 13:07:19');
INSERT INTO `image_collection` VALUES ('223', '81', '2017-11-19 14:32:03');
INSERT INTO `image_collection` VALUES ('224', '102', '2017-11-19 14:55:15');
INSERT INTO `image_collection` VALUES ('225', '103', '2017-11-19 15:10:39');
INSERT INTO `image_collection` VALUES ('225', '108', '2017-11-21 18:36:49');
INSERT INTO `image_collection` VALUES ('225', '109', '2017-11-21 18:37:04');
INSERT INTO `image_collection` VALUES ('226', '104', '2017-11-19 15:18:36');
INSERT INTO `image_collection` VALUES ('227', '105', '2017-11-19 15:19:28');
INSERT INTO `image_collection` VALUES ('228', '106', '2017-11-19 15:19:53');
INSERT INTO `image_collection` VALUES ('229', '106', '2017-11-19 15:20:54');
INSERT INTO `image_collection` VALUES ('230', '106', '2017-11-19 15:21:18');
INSERT INTO `image_collection` VALUES ('231', '105', '2017-11-19 15:21:39');
INSERT INTO `image_collection` VALUES ('232', '104', '2017-11-19 15:22:18');
INSERT INTO `image_collection` VALUES ('233', '104', '2017-11-19 15:22:59');
INSERT INTO `image_collection` VALUES ('234', '105', '2017-11-19 15:24:14');
INSERT INTO `image_collection` VALUES ('235', '108', '2017-11-21 18:38:35');

-- ----------------------------
-- Table structure for `image_likes`
-- ----------------------------
DROP TABLE IF EXISTS `image_likes`;
CREATE TABLE `image_likes` (
  `image_id` int(9) NOT NULL,
  `user_id` int(9) NOT NULL,
  `created_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`image_id`,`user_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `image_likes_ibfk_2` FOREIGN KEY (`image_id`) REFERENCES `images` (`image_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `image_likes_ibfk_3` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of image_likes
-- ----------------------------
INSERT INTO `image_likes` VALUES ('189', '42', '2017-11-18 18:52:24');
INSERT INTO `image_likes` VALUES ('190', '39', '2017-11-18 13:47:24');
INSERT INTO `image_likes` VALUES ('191', '42', '2017-11-18 18:52:32');
INSERT INTO `image_likes` VALUES ('193', '37', '2017-11-19 15:11:33');
INSERT INTO `image_likes` VALUES ('193', '38', '2017-11-19 15:13:49');
INSERT INTO `image_likes` VALUES ('193', '39', '2017-11-18 10:26:08');
INSERT INTO `image_likes` VALUES ('193', '42', '2017-11-18 18:52:31');
INSERT INTO `image_likes` VALUES ('213', '37', '2017-11-19 11:16:29');
INSERT INTO `image_likes` VALUES ('213', '38', '2017-11-19 15:14:16');
INSERT INTO `image_likes` VALUES ('213', '42', '2017-11-18 19:27:50');
INSERT INTO `image_likes` VALUES ('214', '37', '2017-11-19 11:16:18');
INSERT INTO `image_likes` VALUES ('214', '38', '2017-11-19 15:14:01');
INSERT INTO `image_likes` VALUES ('214', '39', '2017-11-19 15:15:41');
INSERT INTO `image_likes` VALUES ('214', '42', '2017-11-18 18:52:34');
INSERT INTO `image_likes` VALUES ('214', '49', '2017-11-21 21:25:15');
INSERT INTO `image_likes` VALUES ('216', '39', '2017-11-20 17:33:43');
INSERT INTO `image_likes` VALUES ('217', '37', '2017-11-19 15:11:40');
INSERT INTO `image_likes` VALUES ('217', '39', '2017-11-19 15:15:38');
INSERT INTO `image_likes` VALUES ('218', '39', '2017-11-20 20:38:50');
INSERT INTO `image_likes` VALUES ('219', '37', '2017-11-19 15:11:43');
INSERT INTO `image_likes` VALUES ('219', '39', '2017-11-19 15:16:13');
INSERT INTO `image_likes` VALUES ('222', '37', '2017-11-19 15:12:40');
INSERT INTO `image_likes` VALUES ('222', '38', '2017-11-19 15:13:52');
INSERT INTO `image_likes` VALUES ('222', '39', '2017-11-19 15:14:58');
INSERT INTO `image_likes` VALUES ('222', '49', '2017-11-21 18:35:55');
INSERT INTO `image_likes` VALUES ('224', '47', '2017-11-19 14:58:59');
INSERT INTO `image_likes` VALUES ('225', '37', '2017-11-19 15:13:23');
INSERT INTO `image_likes` VALUES ('225', '38', '2017-11-19 15:14:00');
INSERT INTO `image_likes` VALUES ('225', '39', '2017-11-19 15:15:12');
INSERT INTO `image_likes` VALUES ('227', '49', '2017-11-21 18:37:58');

-- ----------------------------
-- Table structure for `inventories`
-- ----------------------------
DROP TABLE IF EXISTS `inventories`;
CREATE TABLE `inventories` (
  `id` int(9) NOT NULL AUTO_INCREMENT,
  `product_id` int(9) DEFAULT NULL,
  `stocks` smallint(5) DEFAULT '0',
  `unit` varchar(45) DEFAULT '' COMMENT '单位：件、个、幅等',
  `address` varchar(45) DEFAULT '',
  `province` varchar(45) DEFAULT '',
  `city` varchar(45) DEFAULT '',
  `town` varchar(45) DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `inventories_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of inventories
-- ----------------------------

-- ----------------------------
-- Table structure for `orders`
-- ----------------------------
DROP TABLE IF EXISTS `orders`;
CREATE TABLE `orders` (
  `order_id` int(9) NOT NULL AUTO_INCREMENT,
  `user_id` int(9) DEFAULT NULL,
  `created_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `delivery_id` int(9) DEFAULT NULL,
  PRIMARY KEY (`order_id`),
  KEY `user_id` (`user_id`),
  KEY `delivery_id` (`delivery_id`),
  CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `orders_ibfk_2` FOREIGN KEY (`delivery_id`) REFERENCES `deliveries` (`delivery_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of orders
-- ----------------------------

-- ----------------------------
-- Table structure for `order_details`
-- ----------------------------
DROP TABLE IF EXISTS `order_details`;
CREATE TABLE `order_details` (
  `order_id` int(9) NOT NULL,
  `product_id` int(9) NOT NULL,
  `quantity` smallint(4) DEFAULT '0',
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

-- ----------------------------
-- Table structure for `permissions`
-- ----------------------------
DROP TABLE IF EXISTS `permissions`;
CREATE TABLE `permissions` (
  `id` tinyint(1) unsigned NOT NULL AUTO_INCREMENT,
  `permission_name` varchar(45) DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT='应用能够获取到的用户权限';

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
  `product_md5` varchar(255) DEFAULT '' COMMENT '商品封面',
  `product_name` varchar(45) DEFAULT '' COMMENT '商品名',
  `user_id` int(9) DEFAULT NULL COMMENT '作者',
  `product_price` decimal(10,0) DEFAULT '0' COMMENT '产品价格',
  `created_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '商品创建时间',
  `product_desc` varchar(255) DEFAULT '' COMMENT '产品描述',
  `product_unit` varchar(6) DEFAULT '',
  `is_self` char(1) NOT NULL DEFAULT '1' COMMENT '是否自营：1: 否  0: 是',
  PRIMARY KEY (`product_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `products_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='商品列表';

-- ----------------------------
-- Records of products
-- ----------------------------

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

-- ----------------------------
-- Table structure for `relationships`
-- ----------------------------
DROP TABLE IF EXISTS `relationships`;
CREATE TABLE `relationships` (
  `user_id` int(9) NOT NULL,
  `following_id` int(9) NOT NULL,
  `users_user_id` int(9) DEFAULT NULL,
  `created_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`,`following_id`),
  KEY `fk_relationships_users1_idx` (`users_user_id`),
  CONSTRAINT `relationships_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of relationships
-- ----------------------------
INSERT INTO `relationships` VALUES ('37', '38', null, '2017-11-19 12:11:09');
INSERT INTO `relationships` VALUES ('37', '42', null, '2017-11-19 12:16:24');
INSERT INTO `relationships` VALUES ('38', '37', null, '2017-11-16 21:53:22');
INSERT INTO `relationships` VALUES ('39', '38', null, '2017-11-18 10:21:14');
INSERT INTO `relationships` VALUES ('39', '42', null, '2017-11-19 15:17:46');
INSERT INTO `relationships` VALUES ('42', '39', null, '2017-11-18 21:03:18');
INSERT INTO `relationships` VALUES ('49', '37', null, '2017-11-21 18:36:28');

-- ----------------------------
-- Table structure for `store_images`
-- ----------------------------
DROP TABLE IF EXISTS `store_images`;
CREATE TABLE `store_images` (
  `image_id` int(9) NOT NULL AUTO_INCREMENT,
  `image_name` varchar(45) DEFAULT '',
  `image_url` varchar(255) DEFAULT '',
  `image_desc` varchar(255) DEFAULT '',
  `created_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`image_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of store_images
-- ----------------------------
INSERT INTO `store_images` VALUES ('1', '11111', '111', '111', '2017-10-31 18:07:34');
INSERT INTO `store_images` VALUES ('2', '1122', '333', '222', '2017-10-31 18:07:43');
INSERT INTO `store_images` VALUES ('3', '12', '33', '饿饿的', '2017-10-31 18:07:54');
INSERT INTO `store_images` VALUES ('4', 'hajhjahjs', 'sahkjhakhd', null, '2017-11-01 22:27:17');
INSERT INTO `store_images` VALUES ('5', 'hajhjahjs', 'sahkjhakhd', null, '2017-11-01 22:27:30');
INSERT INTO `store_images` VALUES ('6', 'hajhjahjs', 'sahkjhakhd', null, '2017-11-01 22:27:57');
INSERT INTO `store_images` VALUES ('7', 'pic-2', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509425272934.jpeg', 'just for good sales', '2017-11-04 10:24:30');
INSERT INTO `store_images` VALUES ('8', 'pic-2', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509425272934.jpeg', 'just for good sales', '2017-11-04 10:24:53');
INSERT INTO `store_images` VALUES ('9', 'pic-2', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509425272934.jpeg', 'just for good sales', '2017-11-04 10:28:10');
INSERT INTO `store_images` VALUES ('10', 'pic-2', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509425272934.jpeg', 'just for good sales', '2017-11-04 10:30:11');

-- ----------------------------
-- Table structure for `users`
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `user_id` int(9) NOT NULL AUTO_INCREMENT,
  `is_developer` char(1) DEFAULT '1' COMMENT '是否注册为开发者：\n0：是\n1：否',
  `is_admin` char(1) DEFAULT '1' COMMENT '是否是管理员\n0： 是\n1： 不是',
  `user_name` varchar(90) DEFAULT '' COMMENT '用户名',
  `phone` varchar(14) DEFAULT '' COMMENT '手机号码',
  `email` varchar(45) DEFAULT '' COMMENT '邮件',
  `password` varchar(45) DEFAULT '',
  `province` char(6) DEFAULT '' COMMENT '省代码',
  `city` char(6) DEFAULT '' COMMENT '市代码',
  `town` char(6) DEFAULT '' COMMENT '县区代码',
  `image_md5` varchar(255) DEFAULT '' COMMENT '用户头像，MD5格式',
  `personal_site` varchar(255) DEFAULT '' COMMENT '个人网站',
  `wechat` varchar(45) DEFAULT '' COMMENT 'instagram用户名',
  `address` varchar(255) DEFAULT '' COMMENT '地址',
  `bio` varchar(255) DEFAULT '' COMMENT '个人简介',
  `created_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `dev_url` varchar(255) DEFAULT '',
  `dev_desc` varchar(255) DEFAULT '',
  `delivery_address` varchar(90) DEFAULT '',
  `delivery_city` varchar(45) DEFAULT '',
  `delivery_province` varchar(45) DEFAULT '',
  `delivery_town` varchar(45) DEFAULT '',
  `consignee` varchar(45) DEFAULT '',
  `consignee_phone` char(13) DEFAULT '',
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=50 DEFAULT CHARSET=utf8 COMMENT='存储注册用户的相关信息';

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO `users` VALUES ('37', '1', '1', '阿猫123qwe', '', 'admin@qq.com', '46f94c8de14fb36680850768ff1b7f2a', '', '', '', '1511064368339', '', '', '', '我是前端开发工程师，卡还多久啊很快就好噶好的高科技韩国', '2017-11-20 20:31:12', '', '', '', '', '', '', '', '');
INSERT INTO `users` VALUES ('38', '1', '1', '阿狗自拍', '', 'tester@qq.com', '46f94c8de14fb36680850768ff1b7f2a', '', '', '', '', '', '', '', '我空间说说大家大家还记得好久放假', '2017-11-20 20:31:17', '', '', '', '', '', '', '', '');
INSERT INTO `users` VALUES ('39', '1', '1', '我的公司', '', 'tester2@qq.com', '46f94c8de14fb36680850768ff1b7f2a', '', '', '', '1510880264709', '', '', '', '速度，买点面包吃NBC成本，目标', '2017-11-20 20:31:21', '', '', '', '', '', '', '', '');
INSERT INTO `users` VALUES ('41', '1', '1', '缅甸电站123qwe', '', 'm@gmail.com', 'hh', '', '', '', '', '', '', '', '就看我和客户解决好几个', '2017-11-20 20:31:24', '', '', '', '', '', '', '', '');
INSERT INTO `users` VALUES ('42', '1', '1', '自拍达人', '', 'linqing@qq.com', '62c8ad0a15d9d1ca38d5dee762a16e01', '', '', '', '1510994978358', '', '', '', '进度计划计划计划', '2017-11-20 20:31:27', '', '', '', '', '', '', '', '');
INSERT INTO `users` VALUES ('46', '1', '1', '123qwe', '', 'tt@qq.com', '46f94c8de14fb36680850768ff1b7f2a', '', '', '', '', '', '', '', '都不会，门禁', '2017-11-20 20:31:30', '', '', '', '', '', '', '', '');
INSERT INTO `users` VALUES ('47', '1', '1', '123qwe', '', 'tt2@qq.com', '46f94c8de14fb36680850768ff1b7f2a', '', '', '', '1511075021765', '', '', '', '就问看清洁空气好看人家俩人日艺人如何规划计划和付款', '2017-11-20 20:31:35', '', '', '', '', '', '', '', '');
INSERT INTO `users` VALUES ('49', '1', '1', '林晴', '', 'yottalynn@gmail.com', '46f94c8de14fb36680850768ff1b7f2a', '', '', '', '1511261060353', '', '', '', '', '2017-11-21 18:39:23', '', '', '', '', '', '', '', '');

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
INSERT INTO `user_email` VALUES ('37', '1', null, null, '2017-11-22 10:20:47');
INSERT INTO `user_email` VALUES ('42', '1', null, null, '2017-11-18 16:49:33');
INSERT INTO `user_email` VALUES ('37', '2', null, null, '2017-11-22 10:20:47');
INSERT INTO `user_email` VALUES ('42', '2', null, null, '2017-11-18 16:49:33');
INSERT INTO `user_email` VALUES ('37', '3', null, null, '2017-11-22 10:20:47');
INSERT INTO `user_email` VALUES ('42', '3', null, null, '2017-11-18 16:49:33');
INSERT INTO `user_email` VALUES ('37', '4', null, null, '2017-11-22 10:20:47');
INSERT INTO `user_email` VALUES ('42', '4', null, null, '2017-11-18 16:49:33');
INSERT INTO `user_email` VALUES ('37', '5', null, null, '2017-11-22 10:20:47');
INSERT INTO `user_email` VALUES ('42', '5', null, null, '2017-11-18 16:49:33');
INSERT INTO `user_email` VALUES ('37', '6', null, null, '2017-11-22 10:20:47');
INSERT INTO `user_email` VALUES ('42', '6', null, null, '2017-11-18 16:49:33');
