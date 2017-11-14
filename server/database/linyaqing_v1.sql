/*
Navicat MySQL Data Transfer

Source Server         : 2017
Source Server Version : 50719
Source Host           : localhost:3306
Source Database       : linyaqing

Target Server Type    : MYSQL
Target Server Version : 50719
File Encoding         : 65001

Date: 2017-11-14 15:36:30
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
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8 COMMENT='用户关联到网站的应用';

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
INSERT INTO `applications` VALUES ('17', '15', 'my_first_app', '我的第一个应用，展示hello world', '2017-11-03 23:17:14', 'http://linyaqing.com', '0', null, null);

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
INSERT INTO `carts` VALUES ('1', '1', '32', null, null, '2017-11-02 13:19:53');
INSERT INTO `carts` VALUES ('1', '2', '32', null, null, '2017-11-02 13:19:53');
INSERT INTO `carts` VALUES ('2', '1', '32', null, null, '2017-11-02 13:19:53');
INSERT INTO `carts` VALUES ('3', '3', '72', null, null, '2017-11-02 17:24:21');
INSERT INTO `carts` VALUES ('15', '2', '20', null, null, '2017-11-04 07:01:05');

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
  `collection_name` varchar(45) DEFAULT '',
  `collection_image_md5` varchar(255) DEFAULT '',
  `created_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_private` char(1) DEFAULT '0' COMMENT '是否私有：0：是，1：否',
  `collection_desc` varchar(255) DEFAULT NULL,
  `user_id` int(9) DEFAULT NULL,
  PRIMARY KEY (`collection_id`)
) ENGINE=InnoDB AUTO_INCREMENT=71 DEFAULT CHARSET=utf8 COMMENT='图片集合';

-- ----------------------------
-- Records of collections
-- ----------------------------
INSERT INTO `collections` VALUES ('12', '萌宠', '11111111111', '2017-11-14 09:21:56', '0', null, null);
INSERT INTO `collections` VALUES ('13', '家人', '111111111111', '2017-11-14 09:21:59', '0', null, null);
INSERT INTO `collections` VALUES ('14', '家人撒', 'sssssssssssssssssss', '2017-11-14 14:28:41', '0', null, null);
INSERT INTO `collections` VALUES ('15', '阿萨斯', 'sssssssssssssssssss', '2017-11-14 14:28:43', '0', null, null);
INSERT INTO `collections` VALUES ('16', '飒飒的', 'sssssssssssssssssss', '2017-11-14 14:28:45', '0', null, null);
INSERT INTO `collections` VALUES ('17', '死掉的萨芬锁定', 'sssssssssssssssssss', '2017-11-14 14:28:48', '0', null, null);
INSERT INTO `collections` VALUES ('18', '啊谁说的', 'sssssssssssssssssss', '2017-11-14 14:28:49', '0', null, null);
INSERT INTO `collections` VALUES ('19', '我是skjH', 'sssssssssssssssssss', '2017-11-14 15:30:43', '0', '家啊空间和慷慨就发个快递就和德国空军和', '3');
INSERT INTO `collections` VALUES ('20', '啊打算', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509425905335.jpeg', '2017-11-14 14:28:52', '1', null, null);
INSERT INTO `collections` VALUES ('21', '达到', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509425905335.jpeg', '2017-11-14 14:28:54', '1', null, null);
INSERT INTO `collections` VALUES ('22', '阿萨大大', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509425905335.jpeg', '2017-11-14 14:28:56', '1', null, null);
INSERT INTO `collections` VALUES ('23', '啊实打实大大', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509425905335.jpeg', '2017-11-14 14:28:58', '1', null, null);
INSERT INTO `collections` VALUES ('24', '额外请问', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509425905335.jpeg', '2017-11-14 14:29:01', '1', null, null);
INSERT INTO `collections` VALUES ('25', '相册1', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/users/1510280136379', '2017-11-11 12:22:39', '1', null, null);
INSERT INTO `collections` VALUES ('26', '不会', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/users/1510290779977', '2017-11-11 12:22:43', '1', null, null);
INSERT INTO `collections` VALUES ('27', '速度', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/users/1510367446831', '2017-11-11 12:22:44', '1', null, null);
INSERT INTO `collections` VALUES ('28', '实时路况很差吃了', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/users/1510367689888', '2017-11-14 14:29:50', '0', null, null);
INSERT INTO `collections` VALUES ('29', '领取空间后来', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/users/1510369355464', '2017-11-11 12:22:50', '1', null, null);
INSERT INTO `collections` VALUES ('30', 'i哦iu却i', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/users/1510369776666', '2017-11-11 12:22:55', '1', null, null);
INSERT INTO `collections` VALUES ('31', '看我等级', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/users/1510369805175', '2017-11-11 12:22:57', '1', null, null);
INSERT INTO `collections` VALUES ('32', '的很快就会', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/users/1510369840905', '2017-11-11 12:22:59', '1', null, null);
INSERT INTO `collections` VALUES ('33', 'lkdkj', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/users/1510369860244', '2017-11-11 12:23:01', '1', null, null);
INSERT INTO `collections` VALUES ('34', '龙宽九段', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/users/1510369874229', '2017-11-11 12:23:03', '1', null, null);
INSERT INTO `collections` VALUES ('35', 'hkhdkdjh', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/users/1510372277858', '2017-11-11 12:23:07', '1', null, null);
INSERT INTO `collections` VALUES ('36', '了快点结婚', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/users/1510372357828', '2017-11-11 12:23:09', '1', null, null);
INSERT INTO `collections` VALUES ('37', '了电脑开机', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/users/1510372672960', '2017-11-11 12:23:12', '1', null, null);
INSERT INTO `collections` VALUES ('38', '的道理可我就', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/users/1510372745563', '2017-11-11 12:23:14', '1', null, null);
INSERT INTO `collections` VALUES ('39', 'lh', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/users/1510372931568', '2017-11-11 12:23:19', '1', null, null);
INSERT INTO `collections` VALUES ('40', '角度看', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/users/1510408947713', '2017-11-12 22:52:12', '1', null, null);
INSERT INTO `collections` VALUES ('41', '客户端', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/users/1510409114954', '2017-11-12 22:52:09', '1', null, null);
INSERT INTO `collections` VALUES ('42', '快乐就好', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/users/1510409413882', '2017-11-12 22:52:08', '1', null, null);
INSERT INTO `collections` VALUES ('43', '卡就好好', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/users/1510409522162', '2017-11-12 22:52:07', '1', null, null);
INSERT INTO `collections` VALUES ('44', '百度空间', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/users/1510409522162', '2017-11-12 22:52:06', '1', null, null);
INSERT INTO `collections` VALUES ('45', '好看多了', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/users/1510410044304', '2017-11-12 22:52:04', '1', null, null);
INSERT INTO `collections` VALUES ('46', '离开家', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/users/1510410056398', '2017-11-12 22:52:03', '1', null, null);
INSERT INTO `collections` VALUES ('47', '快结婚的话', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/users/1510410063543', '2017-11-12 22:52:01', '1', null, null);
INSERT INTO `collections` VALUES ('48', '大家看', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/users/1510410073081', '2017-11-12 22:51:58', '1', null, null);
INSERT INTO `collections` VALUES ('49', '机顶盒即可', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/users/1510410084646', '2017-11-12 22:51:57', '1', null, null);
INSERT INTO `collections` VALUES ('50', '金卡金卡', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/users/1510410093203', '2017-11-12 22:51:56', '1', null, null);
INSERT INTO `collections` VALUES ('51', '是卡会离开', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/users/1510451487446', '2017-11-12 22:51:55', '1', null, null);
INSERT INTO `collections` VALUES ('52', '啊看电视了看见', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/users/1510451582239', '2017-11-12 22:51:53', '1', null, null);
INSERT INTO `collections` VALUES ('53', '看见很多离开', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/users/1510451609812', '2017-11-12 22:51:52', '1', null, null);
INSERT INTO `collections` VALUES ('54', '卡会离开', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/users/1510451650279', '2017-11-12 22:51:51', '1', null, null);
INSERT INTO `collections` VALUES ('55', 'u也哦i有', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/users/1510456189444', '2017-11-12 22:51:50', '1', null, null);
INSERT INTO `collections` VALUES ('56', '就DHL卡号', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/users/1510456860200', '2017-11-12 22:51:48', '1', null, null);
INSERT INTO `collections` VALUES ('57', '就好的客户', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/users/1510458740107', '2017-11-12 22:51:47', '1', null, null);
INSERT INTO `collections` VALUES ('58', '到海枯石烂看', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/users/1510477906153', '2017-11-12 22:51:45', '1', null, null);
INSERT INTO `collections` VALUES ('59', '是大客户的空间', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/users/1510478176464', '2017-11-12 22:51:44', '1', null, null);
INSERT INTO `collections` VALUES ('60', '就是老客户', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/users/1510478302486', '2017-11-12 22:51:42', '1', null, null);
INSERT INTO `collections` VALUES ('61', '撒旦立刻就会上来的客户', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/users/1510482524800', '2017-11-12 22:51:41', '1', null, null);
INSERT INTO `collections` VALUES ('62', '很多机会了看见', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/users/1510531513647', '2017-11-14 14:29:07', '1', null, null);
INSERT INTO `collections` VALUES ('63', '打开就回来看', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/users/1510542844285', '2017-11-14 14:29:08', '1', null, null);
INSERT INTO `collections` VALUES ('64', 'u欸u哦i', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/users/1510580860312', '2017-11-14 14:29:10', '1', null, null);
INSERT INTO `collections` VALUES ('65', '看见了空间', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/users/1510626813686', '2017-11-14 14:29:12', '1', null, null);
INSERT INTO `collections` VALUES ('66', '离开', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509406044609.gif', '2017-11-14 15:22:45', '1', null, '31');
INSERT INTO `collections` VALUES ('67', '离开家', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/users/1510636768504', '2017-11-14 15:22:40', '1', null, '31');
INSERT INTO `collections` VALUES ('68', '2017/10/14-31', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/users/1510640679775', '2017-11-14 15:22:38', '1', null, '31');
INSERT INTO `collections` VALUES ('69', '2017/10/14 14:25:59 创建的新相册', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/users/1510641044080', '2017-11-14 15:22:35', '1', null, '31');
INSERT INTO `collections` VALUES ('70', '2017/10/14 15:21:29 创建的新相册', '', '2017-11-14 15:21:29', '0', null, '31');

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
INSERT INTO `delivery_address` VALUES ('3', '1');
INSERT INTO `delivery_address` VALUES ('3', '2');
INSERT INTO `delivery_address` VALUES ('2', '3');
INSERT INTO `delivery_address` VALUES ('3', '4');
INSERT INTO `delivery_address` VALUES ('15', '5');
INSERT INTO `delivery_address` VALUES ('15', '6');

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
  `enough_tags` char(1) DEFAULT '1' COMMENT '是否有足够的标签（5个）\n0：是\n1：否',
  `make` varchar(45) DEFAULT '' COMMENT '相机品牌',
  `model` varchar(45) DEFAULT '' COMMENT '相机型号',
  `focalLength` varchar(45) DEFAULT '' COMMENT '焦距',
  `aperture` varchar(45) DEFAULT '' COMMENT '光圈',
  `dateTimeOriginal` varchar(45) DEFAULT 'CURRENT_TIMESTAMP',
  `iso` varchar(45) DEFAULT '' COMMENT '感光度',
  `shutterSpeed` varchar(45) DEFAULT '' COMMENT '快门速度',
  `story_title` varchar(45) DEFAULT '' COMMENT '照片名称',
  `story_detail` varchar(255) DEFAULT '' COMMENT '照片故事',
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
) ENGINE=InnoDB AUTO_INCREMENT=162 DEFAULT CHARSET=utf8 COMMENT='单张图片';

-- ----------------------------
-- Records of images
-- ----------------------------
INSERT INTO `images` VALUES ('7', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509421924159.jpeg', '1', '2017-11-06 08:51:15', 'cc,ddd,carol,lynn,jsjsjs', '1', '1111', '111', null, '11', '2017-11-10 12:04:48', null, '111', '太阳当空照', '太阳当空照', '广东深圳龙华1866绿景小区', '0', '1', '19', null);
INSERT INTO `images` VALUES ('8', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509421924159.jpeg', '4', '2017-11-10 15:16:25', 'carol,cc,carol,cksdkjdkjdkljc', '1', '111', null, null, null, '2017-11-10 15:16:25', '111', null, '太阳当空照', '太阳当空照', '广东深圳龙华1866绿景小区', '0', '5', '14', null);
INSERT INTO `images` VALUES ('9', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509421924159.jpeg', '2', '2017-11-06 08:51:47', 'bird, nice', '1', '111', null, null, '11', '2017-11-10 12:04:48', null, null, '太阳当空照', '太阳当空照太阳当空照太阳当空照太阳当空照', '广东深圳龙华1866绿景小区', '1', '3', '19', null);
INSERT INTO `images` VALUES ('10', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509425905335.jpeg', '2', '2017-11-05 14:14:33', 'bird, nice', '1', null, null, null, null, '2017-11-10 12:04:48', null, null, '太阳当空照', '太阳当空照', '广东深圳龙华1866绿景小区', '1', '123', '14', null);
INSERT INTO `images` VALUES ('11', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509425905335.jpeg', '2', '2017-11-05 14:14:54', 'bird, nice', '1', null, null, '111', '111', '2017-11-10 12:04:48', null, null, '太阳当空照', '太阳当空照', '广东深圳龙华1866绿景小区', '1', '333', '19', null);
INSERT INTO `images` VALUES ('12', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509425905335.jpeg', '2', '2017-11-14 08:00:44', 'bird, nice', '1', null, null, null, null, '2017-11-10 12:04:48', '11', '11', '太阳当空照', '太阳当空照', '广东深圳龙华1866绿景小区', '1', '222', '14', null);
INSERT INTO `images` VALUES ('13', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509425905335.jpeg', '2', '2017-11-05 14:15:00', 'bird, nice', '1', null, '11', null, null, '2017-11-10 12:04:48', null, null, '太阳当空照', '太阳当空照', '广东深圳龙华1866绿景小区', '1', '12', '19', null);
INSERT INTO `images` VALUES ('14', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509425905335.jpeg', '2', '2017-11-05 14:14:41', 'bird, nice', '1', null, null, null, null, '2017-11-10 12:04:48', null, null, '太阳当空照', '太阳当空照', '广东深圳龙华1866绿景小区', '1', '3', '19', null);
INSERT INTO `images` VALUES ('15', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509421924159.jpeg', '2', '2017-11-14 08:00:58', 'bird, nice', '1', '111', null, null, null, '2017-11-10 12:04:48', null, null, null, null, '广东深圳龙华1866绿景小区', '1', '5', '21', null);
INSERT INTO `images` VALUES ('16', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509421924159.jpeg', '2', '2017-11-14 08:00:53', 'bird, nice', '1', null, null, '111', null, '2017-11-10 12:04:48', null, '111', null, null, '广东深圳龙华1866绿景小区', '1', '78', '21', null);
INSERT INTO `images` VALUES ('17', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509421924159.jpeg', '2', '2017-11-14 08:00:50', 'bird, nice', '1', null, '11', null, '11', '2017-11-10 12:04:48', null, null, null, null, '广东深圳龙华1866绿景小区', '1', '66', '20', null);
INSERT INTO `images` VALUES ('18', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509421924159.jpeg', '3', '2017-11-14 08:00:47', 'bird, nice', '1', null, null, null, null, '2017-11-10 12:04:48', '11', null, null, null, '广东深圳龙华1866绿景小区', '1', '55', '20', null);
INSERT INTO `images` VALUES ('19', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509425905335.jpeg', '15', '2017-11-05 14:13:39', 'pig, animals', '1', '2222', '2222', '2222', '2222', '2017-11-10 12:04:48', '2222', '2222', null, null, '广东深圳龙华1866绿景小区', '1', '44', '20', null);
INSERT INTO `images` VALUES ('20', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509425905335.jpeg', '15', '2017-11-05 14:13:40', 'pig, animals', '1', '2222', '2222', '2222', '2222', '2017-11-10 12:04:48', '2222', '2222', null, null, '广东深圳龙华1866绿景小区', '0', '33', '21', null);
INSERT INTO `images` VALUES ('21', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509425905335.jpeg', '15', '2017-11-05 14:13:41', 'pig, animals', '1', '2222', '2222', '2222', '2222', '2017-11-10 12:04:48', '2222', '2222', null, null, '广东深圳龙华1866绿景小区', '0', '22', '22', null);
INSERT INTO `images` VALUES ('22', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509425905335.jpeg', '15', '2017-11-05 14:13:41', 'pig, animals', '1', '2222', '2222', '2222', '2222', '2017-11-10 12:04:48', '2222', '2222', null, null, '广东深圳龙华1866绿景小区', '0', '11', '23', null);
INSERT INTO `images` VALUES ('23', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509425905335.jpeg', '15', '2017-11-05 14:13:45', 'pig, animals', '1', '2222', '2222', '2222', '2222', '2017-11-10 12:04:48', '2222', '2222', null, null, '广东深圳龙华1866绿景小区', '0', '11', '24', null);
INSERT INTO `images` VALUES ('24', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509421924159.jpeg', '3', '2017-11-14 08:01:00', 'bird, nice', '1', null, null, null, null, '2017-11-10 12:04:48', null, null, null, null, null, null, null, '24', null);
INSERT INTO `images` VALUES ('25', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509421924159.jpeg', '3', '2017-11-14 08:01:04', 'bird, nice', '1', null, null, null, null, '2017-11-10 12:04:48', null, null, null, null, null, null, null, '24', null);
INSERT INTO `images` VALUES ('26', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509421924159.jpeg', '3', '2017-11-14 08:01:06', 'bird, nice', '1', null, null, null, null, '2017-11-10 12:04:48', null, null, null, null, null, null, null, '22', null);
INSERT INTO `images` VALUES ('27', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509421924159.jpeg', '3', '2017-11-14 08:01:13', 'bird, nice', '1', null, null, null, null, '2017-11-10 12:04:48', null, null, null, null, null, null, null, '22', null);
INSERT INTO `images` VALUES ('28', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509421924159.jpeg', '3', '2017-11-14 08:01:16', 'bird, nice', '1', null, null, null, null, '2017-11-10 12:04:48', null, null, null, null, null, null, null, '23', null);
INSERT INTO `images` VALUES ('29', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509421924159.jpeg', '3', '2017-11-13 20:45:04', 'bird, nice', '1', null, null, null, null, '2017-11-10 12:04:48', null, null, null, null, null, null, null, '20', null);
INSERT INTO `images` VALUES ('30', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509421924159.jpeg', '3', '2017-11-05 15:25:42', 'bird, nice', '1', null, null, null, null, '2017-11-10 12:04:48', null, null, null, null, null, null, null, '19', null);
INSERT INTO `images` VALUES ('31', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509421924159.jpeg', '3', '2017-11-05 15:25:42', 'bird, nice', '1', null, null, null, null, '2017-11-10 12:04:48', null, null, null, null, null, null, null, '19', null);
INSERT INTO `images` VALUES ('32', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509421924159.jpeg', '3', '2017-11-05 15:25:42', 'bird, nice', '1', null, null, null, null, '2017-11-10 12:04:48', null, null, null, null, null, null, null, '19', null);
INSERT INTO `images` VALUES ('33', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509421924159.jpeg', '3', '2017-11-05 15:25:42', 'bird, nice', '1', null, null, null, null, '2017-11-10 12:04:48', null, null, null, null, null, null, null, '19', null);
INSERT INTO `images` VALUES ('34', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509406172995.jpeg', '3', '2017-11-05 15:27:54', 'bird, nice', '1', null, null, null, null, '2017-11-10 12:04:48', null, null, null, null, null, '1', null, '19', null);
INSERT INTO `images` VALUES ('35', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509406172995.jpeg', '3', '2017-11-05 15:27:57', 'bird, nice', '1', null, null, null, null, '2017-11-10 12:04:48', null, null, null, null, null, '1', null, '19', null);
INSERT INTO `images` VALUES ('36', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509406172995.jpeg', '3', '2017-11-05 15:27:57', 'bird, nice', '1', null, null, null, null, '2017-11-10 12:04:48', null, null, null, null, null, '1', null, '19', null);
INSERT INTO `images` VALUES ('37', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509406172995.jpeg', '3', '2017-11-05 15:27:57', 'bird, nice', '1', null, null, null, null, '2017-11-10 12:04:48', null, null, null, null, null, '1', null, '19', null);
INSERT INTO `images` VALUES ('38', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509406044609.gif', '3', '2017-11-05 15:42:03', 'bird, nice', '1', null, null, null, null, '2017-11-10 12:04:48', null, null, null, null, null, '1', null, '19', null);
INSERT INTO `images` VALUES ('39', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509406044609.gif', '3', '2017-11-05 15:42:03', 'bird, nice', '1', null, null, null, null, '2017-11-10 12:04:48', null, null, null, null, null, '1', null, '19', null);
INSERT INTO `images` VALUES ('40', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509406044609.gif', '3', '2017-11-05 15:42:03', 'bird, nice', '1', null, null, null, null, '2017-11-10 12:04:48', null, null, null, null, null, '1', null, '19', null);
INSERT INTO `images` VALUES ('41', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509406044609.gif', '3', '2017-11-05 15:42:04', 'bird, nice', '1', null, null, null, null, '2017-11-10 12:04:48', null, null, null, null, null, '1', null, '19', null);
INSERT INTO `images` VALUES ('42', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509406044609.gif', '3', '2017-11-13 20:45:36', 'bird, nice', '1', null, null, null, null, '2017-11-10 12:04:48', null, null, null, null, null, '1', null, '21', null);
INSERT INTO `images` VALUES ('43', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509406044609.gif', '3', '2017-11-05 15:42:04', 'bird, nice', '1', null, null, null, null, '2017-11-10 12:04:48', null, null, null, null, null, '1', null, '19', null);
INSERT INTO `images` VALUES ('44', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509406044609.gif', '3', '2017-11-13 20:45:21', 'bird, nice', '1', null, null, null, null, '2017-11-10 12:04:48', null, null, null, null, null, '1', null, '20', null);
INSERT INTO `images` VALUES ('45', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509406044609.gif', '3', '2017-11-05 15:42:05', 'bird, nice', '1', null, null, null, null, '2017-11-10 12:04:48', null, null, null, null, null, '1', null, '19', null);
INSERT INTO `images` VALUES ('46', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509406044609.gif', '3', '2017-11-05 15:42:05', 'bird, nice', '1', null, null, null, null, '2017-11-10 12:04:48', null, null, null, null, null, '1', null, '19', null);
INSERT INTO `images` VALUES ('47', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509406044609.gif', '3', '2017-11-05 15:42:05', 'bird, nice', '1', null, null, null, null, '2017-11-10 12:04:48', null, null, null, null, null, '1', null, '19', null);
INSERT INTO `images` VALUES ('48', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509406044609.gif', '3', '2017-11-05 15:42:17', 'bird, nice', '1', null, null, null, null, '2017-11-10 12:04:48', null, null, null, null, null, '1', null, '19', null);
INSERT INTO `images` VALUES ('49', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509406044609.gif', '3', '2017-11-05 15:42:18', 'bird, nice', '1', null, null, null, null, '2017-11-10 12:04:48', null, null, null, null, null, '1', null, '19', null);
INSERT INTO `images` VALUES ('50', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509406044609.gif', '3', '2017-11-05 15:42:18', 'bird, nice', '1', null, null, null, null, '2017-11-10 12:04:48', null, null, null, null, null, '1', null, '19', null);
INSERT INTO `images` VALUES ('51', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509406044609.gif', '3', '2017-11-05 15:42:18', 'bird, nice', '1', null, null, null, null, '2017-11-10 12:04:48', null, null, null, null, null, '1', null, '19', null);
INSERT INTO `images` VALUES ('52', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509406044609.gif', '3', '2017-11-05 15:42:18', 'bird, nice', '1', null, null, null, null, '2017-11-10 12:04:48', null, null, null, null, null, '1', null, '19', null);
INSERT INTO `images` VALUES ('53', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509406044609.gif', '3', '2017-11-05 15:42:19', 'bird, nice', '1', null, null, null, null, '2017-11-10 12:04:48', null, null, null, null, null, '1', null, '19', null);
INSERT INTO `images` VALUES ('54', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509406044609.gif', '3', '2017-11-05 15:42:19', 'bird, nice', '1', null, null, null, null, '2017-11-10 12:04:48', null, null, null, null, null, '1', null, '19', null);
INSERT INTO `images` VALUES ('55', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509406044609.gif', '3', '2017-11-05 15:42:19', 'bird, nice', '1', null, null, null, null, '2017-11-10 12:04:48', null, null, null, null, null, '1', null, '19', null);
INSERT INTO `images` VALUES ('56', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509406044609.gif', '3', '2017-11-05 15:42:19', 'bird, nice', '1', null, null, null, null, '2017-11-10 12:04:48', null, null, null, null, null, '1', null, '19', null);
INSERT INTO `images` VALUES ('57', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509406044609.gif', '3', '2017-11-05 15:42:19', 'bird, nice', '1', null, null, null, null, '2017-11-10 12:04:48', null, null, null, null, null, '1', null, '19', null);
INSERT INTO `images` VALUES ('58', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509406044609.gif', '3', '2017-11-05 15:42:19', 'bird, nice', '1', null, null, null, null, '2017-11-10 12:04:48', null, null, null, null, null, '1', null, '19', null);
INSERT INTO `images` VALUES ('59', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509406044609.gif', '3', '2017-11-05 15:42:20', 'bird, nice', '1', null, null, null, null, '2017-11-10 12:04:48', null, null, null, null, null, '1', null, '19', null);
INSERT INTO `images` VALUES ('60', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509406044609.gif', '3', '2017-11-05 15:42:20', 'bird, nice', '1', null, null, null, null, '2017-11-10 12:04:48', null, null, null, null, null, '1', null, '19', null);
INSERT INTO `images` VALUES ('61', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509406044609.gif', '3', '2017-11-05 15:42:20', 'bird, nice', '1', null, null, null, null, '2017-11-10 12:04:48', null, null, null, null, null, '1', null, '19', null);
INSERT INTO `images` VALUES ('62', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509406044609.gif', '3', '2017-11-05 15:42:20', 'bird, nice', '1', null, null, null, null, '2017-11-10 12:04:48', null, null, null, null, null, '1', null, '19', null);
INSERT INTO `images` VALUES ('63', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509406044609.gif', '3', '2017-11-05 15:42:21', 'bird, nice', '1', null, null, null, null, '2017-11-10 12:04:48', null, null, null, null, null, '1', null, '19', null);
INSERT INTO `images` VALUES ('64', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509406044609.gif', '3', '2017-11-05 15:42:21', 'bird, nice', '1', null, null, null, null, '2017-11-10 12:04:48', null, null, null, null, null, '1', null, '19', null);
INSERT INTO `images` VALUES ('65', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509406044609.gif', '3', '2017-11-05 15:42:21', 'bird, nice', '1', null, null, null, null, '2017-11-10 12:04:48', null, null, null, null, null, '1', null, '19', null);
INSERT INTO `images` VALUES ('66', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509406044609.gif', '3', '2017-11-05 15:42:21', 'bird, nice', '1', null, null, null, null, '2017-11-10 12:04:48', null, null, null, null, null, '1', null, '19', null);
INSERT INTO `images` VALUES ('67', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509406044609.gif', '3', '2017-11-05 15:42:21', 'bird, nice', '1', null, null, null, null, '2017-11-10 12:04:48', null, null, null, null, null, '1', null, '19', null);
INSERT INTO `images` VALUES ('68', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509406044609.gif', '3', '2017-11-05 15:42:22', 'bird, nice', '1', null, null, null, null, '2017-11-10 12:04:48', null, null, null, null, null, '1', null, '19', null);
INSERT INTO `images` VALUES ('69', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509406044609.gif', '3', '2017-11-05 16:55:08', 'bird, nice', '1', null, null, null, null, '2017-11-10 12:04:48', null, null, null, null, null, '1', null, '19', null);
INSERT INTO `images` VALUES ('70', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509406044609.gif', '3', '2017-11-05 16:55:09', 'bird, nice', '1', null, null, null, null, '2017-11-10 12:04:48', null, null, null, null, null, '1', null, '19', null);
INSERT INTO `images` VALUES ('71', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509406044609.gif', '3', '2017-11-05 16:55:09', 'bird, nice', '1', null, null, null, null, '2017-11-10 12:04:48', null, null, null, null, null, '1', null, '19', null);
INSERT INTO `images` VALUES ('72', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509406044609.gif', '3', '2017-11-05 16:55:09', 'bird, nice', '1', null, null, null, null, '2017-11-10 12:04:48', null, null, null, null, null, '1', null, '19', null);
INSERT INTO `images` VALUES ('73', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509406044609.gif', '3', '2017-11-05 16:55:09', 'bird, nice', '1', null, null, null, null, '2017-11-10 12:04:48', null, null, null, null, null, '1', null, '19', null);
INSERT INTO `images` VALUES ('74', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509406044609.gif', '3', '2017-11-05 16:55:10', 'bird, nice', '1', null, null, null, null, '2017-11-10 12:04:48', null, null, null, null, null, '1', null, '19', null);
INSERT INTO `images` VALUES ('75', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509406044609.gif', '3', '2017-11-05 16:55:10', 'bird, nice', '1', null, null, null, null, '2017-11-10 12:04:48', null, null, null, null, null, '1', null, '19', null);
INSERT INTO `images` VALUES ('76', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509406044609.gif', '3', '2017-11-05 16:55:10', 'bird, nice', '1', null, null, null, null, '2017-11-10 12:04:48', null, null, null, null, null, '1', null, '19', null);
INSERT INTO `images` VALUES ('77', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509406044609.gif', '3', '2017-11-05 16:55:10', 'bird, nice', '1', null, null, null, null, '2017-11-10 12:04:48', null, null, null, null, null, '1', null, '19', null);
INSERT INTO `images` VALUES ('78', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509406044609.gif', '3', '2017-11-05 16:55:10', 'bird, nice', '1', null, null, null, null, '2017-11-10 12:04:48', null, null, null, null, null, '1', null, '19', null);
INSERT INTO `images` VALUES ('79', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509406044609.gif', '3', '2017-11-05 16:55:11', 'bird, nice', '1', null, null, null, null, '2017-11-10 12:04:48', null, null, null, null, null, '1', null, '19', null);
INSERT INTO `images` VALUES ('80', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509406044609.gif', '3', '2017-11-05 16:55:11', 'bird, nice', '1', null, null, null, null, '2017-11-10 12:04:48', null, null, null, null, null, '1', null, '19', null);
INSERT INTO `images` VALUES ('81', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509406044609.gif', '3', '2017-11-05 16:55:11', 'bird, nice', '1', null, null, null, null, '2017-11-10 12:04:48', null, null, null, null, null, '1', null, '19', null);
INSERT INTO `images` VALUES ('82', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509406044609.gif', '3', '2017-11-05 16:55:11', 'bird, nice', '1', null, null, null, null, '2017-11-10 12:04:48', null, null, null, null, null, '1', null, '19', null);
INSERT INTO `images` VALUES ('83', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509406044609.gif', '3', '2017-11-05 16:55:11', 'bird, nice', '1', null, null, null, null, '2017-11-10 12:04:48', null, null, null, null, null, '1', null, '19', null);
INSERT INTO `images` VALUES ('84', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509406044609.gif', '3', '2017-11-05 16:55:11', 'bird, nice', '1', null, null, null, null, '2017-11-10 12:04:48', null, null, null, null, null, '1', null, '19', null);
INSERT INTO `images` VALUES ('85', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509406044609.gif', '3', '2017-11-05 16:55:11', 'bird, nice', '1', null, null, null, null, '2017-11-10 12:04:48', null, null, null, null, null, '1', null, '19', null);
INSERT INTO `images` VALUES ('86', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509406044609.gif', '3', '2017-11-05 16:55:12', 'bird, nice', '1', null, null, null, null, '2017-11-10 12:04:48', null, null, null, null, null, '1', null, '19', null);
INSERT INTO `images` VALUES ('87', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509406044609.gif', '3', '2017-11-05 16:55:12', 'bird, nice', '1', null, null, null, null, '2017-11-10 12:04:48', null, null, null, null, null, '1', null, '19', null);
INSERT INTO `images` VALUES ('88', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509406044609.gif', '3', '2017-11-05 16:55:12', 'bird, nice', '1', null, null, null, null, '2017-11-10 12:04:48', null, null, null, null, null, '1', null, '19', null);
INSERT INTO `images` VALUES ('89', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509406044609.gif', '3', '2017-11-05 16:55:12', 'bird, nice', '1', null, null, null, null, '2017-11-10 12:04:48', null, null, null, null, null, '1', null, '19', null);
INSERT INTO `images` VALUES ('90', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509406044609.gif', '3', '2017-11-05 16:55:12', 'bird, nice', '1', null, null, null, null, '2017-11-10 12:04:48', null, null, null, null, null, '1', null, '19', null);
INSERT INTO `images` VALUES ('91', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509406044609.gif', '3', '2017-11-05 16:55:12', 'bird, nice', '1', null, null, null, null, '2017-11-10 12:04:48', null, null, null, null, null, '1', null, '19', null);
INSERT INTO `images` VALUES ('92', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509406044609.gif', '3', '2017-11-05 16:55:13', 'bird, nice', '1', null, null, null, null, '2017-11-10 12:04:48', null, null, null, null, null, '1', null, '19', null);
INSERT INTO `images` VALUES ('93', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509406044609.gif', '3', '2017-11-05 16:55:13', 'bird, nice', '1', null, null, null, null, '2017-11-10 12:04:48', null, null, null, null, null, '1', null, '19', null);
INSERT INTO `images` VALUES ('94', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509406044609.gif', '3', '2017-11-14 08:02:26', 'bird, nice', '1', null, null, null, null, '2017-11-10 12:04:48', null, null, null, null, null, '1', null, '21', null);
INSERT INTO `images` VALUES ('95', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509406044609.gif', '3', '2017-11-05 16:55:13', 'bird, nice', '1', null, null, null, null, '2017-11-10 12:04:48', null, null, null, null, null, '1', null, '19', null);
INSERT INTO `images` VALUES ('96', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509406044609.gif', '3', '2017-11-05 16:55:13', 'bird, nice', '1', null, null, null, null, '2017-11-10 12:04:48', null, null, null, null, null, '1', null, '19', null);
INSERT INTO `images` VALUES ('97', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509406044609.gif', '3', '2017-11-14 09:17:04', 'bird, nice', '1', null, null, null, null, '2017-11-10 12:04:48', null, null, null, null, null, '1', '9', '19', null);
INSERT INTO `images` VALUES ('98', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509406044609.gif', '3', '2017-11-14 09:17:33', 'bird, nice', '1', null, null, null, null, '2017-11-10 12:04:48', null, null, null, null, null, '1', '9', '19', null);
INSERT INTO `images` VALUES ('99', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509406044609.gif', '3', '2017-11-05 16:55:14', 'bird, nice', '1', null, null, null, null, '2017-11-10 12:04:48', null, null, null, null, null, '1', null, '19', null);
INSERT INTO `images` VALUES ('100', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509406044609.gif', '3', '2017-11-05 16:55:14', 'bird, nice', '1', null, null, null, null, '2017-11-10 12:04:48', null, null, null, null, null, '1', null, '19', null);
INSERT INTO `images` VALUES ('101', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509406044609.gif', '3', '2017-11-05 16:55:14', 'bird, nice', '1', null, null, null, null, '2017-11-10 12:04:48', null, null, null, null, null, '1', null, '19', null);
INSERT INTO `images` VALUES ('102', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509406044609.gif', '3', '2017-11-05 16:55:14', 'bird, nice', '1', null, null, null, null, '2017-11-10 12:04:48', null, null, null, null, null, '1', null, '19', null);
INSERT INTO `images` VALUES ('123', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/users/1510410044304', '30', '2017-11-13 21:45:24', null, '1', 'Apple', 'iPhone 6s Plus', '2.65', '2.2750071245369052', '2017-07-17 21:09:34', '400', '4.058893515764426', null, null, null, '0', '0', '47', null);
INSERT INTO `images` VALUES ('125', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/users/1510410063543', '30', '2017-11-11 22:16:07', null, '1', 'Apple', 'iPhone 6s Plus', '2.65', '2.2750071245369052', '2017-06-24 08:29:36', '80', '4.058893515764426', null, null, null, '0', '0', '47', null);
INSERT INTO `images` VALUES ('127', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/users/1510410084646', '30', '2017-11-11 22:16:28', null, '1', 'Apple', 'iPhone 6s Plus', '2.65', '2.2750072066878064', '2017-08-02 21:12:00', '320', '4.058893515764426', null, null, null, '0', '0', '49', null);
INSERT INTO `images` VALUES ('128', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/users/1510410093203', '30', '2017-11-13 21:44:35', null, '1', 'Apple', 'iPhone 6s Plus', '2.65', '2.2750072066878064', '2017-08-01 21:26:37', '640', '4.058893515764426', null, null, null, '0', '0', '49', null);
INSERT INTO `images` VALUES ('129', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/users/1510451487446', '30', '2017-11-13 21:44:53', null, '1', 'XIAOMI', 'MI4', '3.9', '1.69', '2016-10-05 14:45:47', '100', '12.161', null, null, null, '0', '0', '49', null);
INSERT INTO `images` VALUES ('130', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/users/1510451582239', '30', '2017-11-13 21:43:21', null, '1', 'XIAOMI', 'MI4', '3.9', '1.69', '2016-10-01 08:35:23', '100', '11.016', null, null, null, '0', '0', '50', null);
INSERT INTO `images` VALUES ('132', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/users/1510451650279', '30', '2017-11-13 21:43:25', null, '1', 'SAMSUNG', 'WB30F/WB31F/WB32F\0\0\0\0\0\0\0\0\0\0\0\0', '5.1', '3.44', '2016-10-06 19:34:45', '640', '4.37', null, null, null, '0', '0', '50', null);
INSERT INTO `images` VALUES ('133', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/users/1510456189444', '30', '2017-11-12 11:05:29', null, '1', 'XIAOMI', 'MI4', '3.9', '1.69', '2016-10-05 14:38:50', '100', '12.523', null, null, null, '0', '0', '55', null);
INSERT INTO `images` VALUES ('134', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/users/1510456860200', '30', '2017-11-13 21:44:11', null, '1', 'SAMSUNG', 'WB30F/WB31F/WB32F\0\0\0\0\0\0\0\0\0\0\0\0', '7.6', '3.92', '2015-04-24 14:28:21', '640', '3.68', null, null, null, '0', '0', '55', null);
INSERT INTO `images` VALUES ('135', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/users/1510458740107', '30', '2017-11-13 21:44:13', null, '1', 'SAMSUNG', 'WB30F/WB31F/WB32F\0\0\0\0\0\0\0\0\0\0\0\0', '13.2', '4.58', '2015-04-24 16:49:21', '120', '5.62', null, null, null, '0', '0', '55', null);
INSERT INTO `images` VALUES ('136', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/users/1510477906153', '30', '2017-11-12 17:07:52', '林晴的毕业照', '1', 'SAMSUNG', 'WB30F/WB31F/WB32F\0\0\0\0\0\0\0\0\0\0\0\0', '13.2', '4.58', '2015-04-24 16:33:49', '640', '4.5', null, null, null, '0', '0', '58', null);
INSERT INTO `images` VALUES ('137', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/users/1510478176464', '30', '2017-11-13 21:44:15', '毕业照，江绵绵，广外', '1', 'SAMSUNG三星', 'WB30F/WB31F/WB32F', '13.2', '4.58', '2015-04-24 16:34:19', '640', '4.37', '毕业照', '林晴的毕业照林晴的毕业照林晴的毕业照林晴的毕业照林晴的毕业照林晴的毕业照林晴的毕业照林晴的毕业照林晴的毕业照林晴的毕业照林晴的毕业照林晴的毕业照林晴的毕业照林晴的毕业照林晴的毕业照林晴的毕业照林晴的毕业照林晴的毕业照林晴的毕业照林晴的毕业照林晴的毕业照林晴的毕业照', '广东外语外贸大学', null, '0', '58', null);
INSERT INTO `images` VALUES ('139', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/users/1510482524800', '30', '2017-11-13 21:44:20', '物流四班毕业照', '1', 'SAMSUNG', 'WB30F/WB31F/WB32F\0\0\0\0\0\0\0\0\0\0\0\0', '4.3', '3.26', '2015:04:24 10:54:44', '80', '7.56', null, null, null, '0', '0', '58', null);
INSERT INTO `images` VALUES ('140', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/users/1510531513647', '30', '2017-11-13 10:41:27', null, '1', 'XIAOMI', 'MI4', '3.9', '1.69', '2016:10:01 08:35:23', '100', '11.016', null, null, null, '0', '0', '62', null);
INSERT INTO `images` VALUES ('141', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/users/1510541314584', '30', '2017-11-13 10:43:52', null, '1', 'XIAOMI', 'MI4', '3.9', '1.69', '2016:10:05 15:47:31', '100', '12.766', null, null, null, '0', '0', '47', null);
INSERT INTO `images` VALUES ('142', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/users/1510541818075', '30', '2017-11-13 21:44:26', null, '1', 'SAMSUNG', 'WB30F/WB31F/WB32F\0\0\0\0\0\0\0\0\0\0\0\0', '4.3', '3.26', '2015:04:24 09:33:54', '80', '7.93', null, null, null, '0', '0', '62', null);
INSERT INTO `images` VALUES ('143', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/users/1510542844285', '30', '2017-11-13 21:44:32', null, '1', 'XIAOMI', 'MI4', '3.9', '1.69', '2016:10:02 07:19:35', '100', '11.702', null, null, null, '0', '0', '62', null);
INSERT INTO `images` VALUES ('144', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/users/1510543244331', '30', '2017-11-13 21:46:38', null, '1', 'XIAOMI', 'MI4', '3.9', '1.69', '2016:10:02 07:32:18', '100', '8.824', null, null, null, '0', '0', '50', null);
INSERT INTO `images` VALUES ('145', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/users/1510580860312', '30', '2017-11-13 21:46:00', null, '1', 'SAMSUNG', 'WB30F/WB31F/WB32F\0\0\0\0\0\0\0\0\0\0\0\0', '9.6', '4.27', '2015:04:24 11:43:34', '80', '8.18', null, null, null, '0', '0', '47', null);
INSERT INTO `images` VALUES ('146', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/users/1510622631332', '30', '2017-11-14 09:19:18', null, '1', 'XIAOMI', 'MI4', '3.9', '1.69', '2016:10:06 14:59:10', '200', '5.643', null, null, null, '0', '0', '55', null);
INSERT INTO `images` VALUES ('147', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/users/1510626813686', '31', '2017-11-14 10:28:43', null, '1', 'XIAOMI', 'MI4', '3.9', '1.69', '2016:10:02 07:19:29', '100', '11.525', null, null, null, '0', '0', '65', null);
INSERT INTO `images` VALUES ('148', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509406044609.gif', '3', '2017-11-14 11:23:16', 'bird, nice', '1', null, null, null, null, null, null, null, '哈哈哈哈哈哈', null, '广东深圳罗湖区', '1', '0', '19', null);
INSERT INTO `images` VALUES ('149', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509406044609.gif', '3', '2017-11-14 11:23:55', 'bird, nice', '1', null, null, null, null, null, null, null, '哈哈哈哈哈哈', null, '广东深圳罗湖区', '1', '0', '19', null);
INSERT INTO `images` VALUES ('150', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509406044609.gif', '3', '2017-11-14 11:24:01', 'bird, nice', '1', null, null, null, null, null, null, null, '哈哈哈哈哈哈', null, '广东深圳罗湖区', '1', '0', '19', null);
INSERT INTO `images` VALUES ('151', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509406044609.gif', '3', '2017-11-14 11:24:45', 'bird, nice', '1', null, null, null, null, null, null, null, '哈哈哈哈哈哈', null, '广东深圳罗湖区', '1', '0', '19', null);
INSERT INTO `images` VALUES ('152', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509406044609.gif', '3', '2017-11-14 11:25:02', 'bird, nice', '1', null, null, null, null, null, null, null, '哈哈哈哈哈哈', null, '广东深圳罗湖区', '1', '0', '19', null);
INSERT INTO `images` VALUES ('153', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509406044609.gif', '3', '2017-11-14 11:25:23', 'bird, nice', '1', null, null, null, null, null, null, null, '哈哈哈哈哈哈', null, '广东深圳罗湖区', '1', '0', '66', null);
INSERT INTO `images` VALUES ('154', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/users/1510636768504', '31', '2017-11-14 13:14:57', '缅甸', '1', 'XIAOMI', 'MI4', '3.9', '1.69', '2016:10:05 14:38:50', '100', '12.523', null, null, '缅甸胶漂', '0', '0', '67', null);
INSERT INTO `images` VALUES ('155', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/users/1510636816147', '31', '2017-11-14 13:15:48', '缅甸仰光', '1', 'XIAOMI', 'MI4', '3.9', '1.69', '2016:10:06 16:26:45', '200', '5.643', null, null, '仰光', '0', '0', '67', null);
INSERT INTO `images` VALUES ('156', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/users/1510636871918', '31', '2017-11-14 13:16:27', null, '1', 'XIAOMI', 'MI4', '3.9', '1.69', '2016:10:07 10:33:56', '100', '5.058', null, null, null, '0', '0', '67', null);
INSERT INTO `images` VALUES ('157', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/users/1510640679775', '31', '2017-11-14 14:19:55', null, '1', 'XIAOMI', 'MI4', '3.9', '1.69', '2016:10:01 08:35:23', '100', '11.016', null, null, null, '0', '0', '68', null);
INSERT INTO `images` VALUES ('158', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/users/1510640725601', '31', '2017-11-14 14:21:42', null, '1', 'XIAOMI', 'MI4', '3.9', '1.69', '2016:10:06 20:31:21', '700', '4.058', null, null, null, '0', '0', '68', null);
INSERT INTO `images` VALUES ('159', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/users/1510641044080', '31', '2017-11-14 14:25:59', null, '1', 'XIAOMI', 'MI4', '3.9', '1.69', '2016:10:05 15:41:38', '100', '11.938', null, null, null, '0', '0', '69', null);
INSERT INTO `images` VALUES ('160', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/users/1510641091483', '31', '2017-11-14 14:26:40', null, '1', 'Xiaomi', 'MI 4LTE', null, null, null, null, null, null, null, null, '0', '0', '69', null);
INSERT INTO `images` VALUES ('161', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/users/1510644360187', '31', '2017-11-14 15:21:29', null, '1', 'XIAOMI', 'MI4', '3.9', '1.69', '2016:10:05 15:52:01', '100', '11.201', null, null, null, '0', '0', '70', null);

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
INSERT INTO `image_collection` VALUES ('151', '19', '2017-11-14 12:47:45');
INSERT INTO `image_collection` VALUES ('152', '19', '2017-11-14 12:47:45');
INSERT INTO `image_collection` VALUES ('153', '19', '2017-11-14 15:31:23');
INSERT INTO `image_collection` VALUES ('153', '20', '2017-11-14 15:32:08');
INSERT INTO `image_collection` VALUES ('153', '21', '2017-11-14 15:33:36');
INSERT INTO `image_collection` VALUES ('153', '66', '2017-11-14 12:47:45');
INSERT INTO `image_collection` VALUES ('154', '67', '2017-11-14 13:14:57');
INSERT INTO `image_collection` VALUES ('155', '67', '2017-11-14 13:15:48');
INSERT INTO `image_collection` VALUES ('156', '67', '2017-11-14 13:16:27');
INSERT INTO `image_collection` VALUES ('157', '68', '2017-11-14 14:19:55');
INSERT INTO `image_collection` VALUES ('158', '68', '2017-11-14 14:21:42');
INSERT INTO `image_collection` VALUES ('159', '69', '2017-11-14 14:25:59');
INSERT INTO `image_collection` VALUES ('160', '69', '2017-11-14 14:26:40');
INSERT INTO `image_collection` VALUES ('161', '70', '2017-11-14 15:21:29');

-- ----------------------------
-- Table structure for `image_likes`
-- ----------------------------
DROP TABLE IF EXISTS `image_likes`;
CREATE TABLE `image_likes` (
  `image_id` int(9) NOT NULL,
  `user_id` int(9) NOT NULL,
  `created_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`image_id`,`user_id`),
  KEY `image_likes_ibfk_1` (`user_id`),
  CONSTRAINT `image_likes_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user_email` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `image_likes_ibfk_2` FOREIGN KEY (`image_id`) REFERENCES `images` (`image_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of image_likes
-- ----------------------------
INSERT INTO `image_likes` VALUES ('8', '3', '2017-11-10 17:39:22');
INSERT INTO `image_likes` VALUES ('8', '4', '2017-11-10 15:30:02');
INSERT INTO `image_likes` VALUES ('87', '4', '2017-11-10 15:31:08');
INSERT INTO `image_likes` VALUES ('87', '15', '2017-11-10 15:30:30');
INSERT INTO `image_likes` VALUES ('152', '4', '2017-11-14 13:20:11');
INSERT INTO `image_likes` VALUES ('153', '3', '2017-11-14 13:19:30');

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
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of inventories
-- ----------------------------
INSERT INTO `inventories` VALUES ('1', '1', '8999', '件', '深圳', '广东', null, null);
INSERT INTO `inventories` VALUES ('2', '2', '999', '件', '上海', null, null, null);
INSERT INTO `inventories` VALUES ('3', '1', '22', '件', '广州', '上海', null, null);
INSERT INTO `inventories` VALUES ('4', '1', '13', null, '北京', '北京', null, null);
INSERT INTO `inventories` VALUES ('5', '6', '80', '件', null, '广东', '深圳', '龙华');
INSERT INTO `inventories` VALUES ('6', '3', '345', null, null, null, null, null);
INSERT INTO `inventories` VALUES ('7', '1', '1000', '件', 'ss', '河南', '石家庄', '');
INSERT INTO `inventories` VALUES ('8', '1', '1000', '件', 'ss', '河南', '石家庄', '');
INSERT INTO `inventories` VALUES ('9', '1', '1000', '件', 'ss', '河南', '石家庄', '');
INSERT INTO `inventories` VALUES ('10', '1', '1000', '件', 'ss', '河南', '石家庄', '');
INSERT INTO `inventories` VALUES ('11', '1', '1000', '件', 'ss', '河南', '石家庄', '');

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
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of orders
-- ----------------------------
INSERT INTO `orders` VALUES ('1', '3', '2017-10-31 21:46:07', null);
INSERT INTO `orders` VALUES ('2', '2', '2017-11-02 12:54:08', null);
INSERT INTO `orders` VALUES ('3', '1', '2017-11-02 12:54:47', null);
INSERT INTO `orders` VALUES ('4', '3', '2017-11-02 21:20:35', '1');
INSERT INTO `orders` VALUES ('5', '3', '2017-11-02 21:23:45', '1');
INSERT INTO `orders` VALUES ('6', '3', '2017-11-02 21:24:16', '1');
INSERT INTO `orders` VALUES ('7', '3', '2017-11-02 21:25:04', '1');
INSERT INTO `orders` VALUES ('8', '3', '2017-11-02 21:26:14', '1');
INSERT INTO `orders` VALUES ('9', '3', '2017-11-02 21:27:06', '1');
INSERT INTO `orders` VALUES ('10', '3', '2017-11-02 21:32:46', '1');
INSERT INTO `orders` VALUES ('11', '3', '2017-11-02 21:59:31', '1');
INSERT INTO `orders` VALUES ('12', '3', '2017-11-02 21:59:51', '1');
INSERT INTO `orders` VALUES ('13', '3', '2017-11-02 22:01:06', '1');
INSERT INTO `orders` VALUES ('14', '3', '2017-11-02 22:02:25', '1');
INSERT INTO `orders` VALUES ('15', '3', '2017-11-02 22:02:47', '1');
INSERT INTO `orders` VALUES ('16', '3', '2017-11-02 22:05:29', '1');
INSERT INTO `orders` VALUES ('17', '3', '2017-11-02 22:06:07', '1');
INSERT INTO `orders` VALUES ('18', '15', '2017-11-04 10:19:43', '1');
INSERT INTO `orders` VALUES ('19', '15', '2017-11-04 10:24:30', '1');
INSERT INTO `orders` VALUES ('20', '15', '2017-11-04 10:24:53', '1');
INSERT INTO `orders` VALUES ('21', '15', '2017-11-04 10:30:37', '1');
INSERT INTO `orders` VALUES ('22', '15', '2017-11-04 10:30:55', '1');
INSERT INTO `orders` VALUES ('23', '15', '2017-11-04 10:52:05', '1');
INSERT INTO `orders` VALUES ('24', '15', '2017-11-04 10:53:51', '1');
INSERT INTO `orders` VALUES ('25', '15', '2017-11-04 11:06:19', '1');

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
INSERT INTO `order_details` VALUES ('1', '1', '12', null, null);
INSERT INTO `order_details` VALUES ('1', '2', '13', null, null);
INSERT INTO `order_details` VALUES ('1', '3', '23', null, null);
INSERT INTO `order_details` VALUES ('2', '1', '12', null, null);
INSERT INTO `order_details` VALUES ('3', '1', '133', null, null);
INSERT INTO `order_details` VALUES ('15', '1', '20', null, null);
INSERT INTO `order_details` VALUES ('15', '2', '20', null, null);
INSERT INTO `order_details` VALUES ('16', '1', '20', null, null);
INSERT INTO `order_details` VALUES ('16', '2', '20', null, null);
INSERT INTO `order_details` VALUES ('17', '2', '20', null, null);
INSERT INTO `order_details` VALUES ('17', '3', '200', null, null);
INSERT INTO `order_details` VALUES ('21', '1', '200', null, null);
INSERT INTO `order_details` VALUES ('21', '12', '20', null, null);
INSERT INTO `order_details` VALUES ('22', '1', '200', null, null);
INSERT INTO `order_details` VALUES ('22', '12', '20', null, null);
INSERT INTO `order_details` VALUES ('23', '1', '200', null, null);
INSERT INTO `order_details` VALUES ('23', '12', '20', null, null);
INSERT INTO `order_details` VALUES ('24', '1', '200', null, null);
INSERT INTO `order_details` VALUES ('24', '12', '20', null, null);
INSERT INTO `order_details` VALUES ('25', '1', '200', null, null);
INSERT INTO `order_details` VALUES ('25', '12', '20', null, null);

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
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8 COMMENT='商品列表';

-- ----------------------------
-- Records of products
-- ----------------------------
INSERT INTO `products` VALUES ('1', '11111111111111111111111111', '产品', '1', '12', '2017-10-31 18:06:51', '端到端', null, '1');
INSERT INTO `products` VALUES ('2', '3333333333333333', '谔谔谔谔', '3', '23', '2017-10-31 18:06:49', '订单', null, '1');
INSERT INTO `products` VALUES ('3', '222222222222', '分发', '3', '44', '2017-11-01 13:40:11', null, null, '1');
INSERT INTO `products` VALUES ('4', '000000000000', 'carol', '3', '12', '2017-11-01 16:18:06', 'hs', '', '1');
INSERT INTO `products` VALUES ('5', '000000000000', 'carol', '3', '12', '2017-11-01 16:18:46', 'hs', '', '1');
INSERT INTO `products` VALUES ('6', '0000000gggg00000', 'cafffrol', '3', '12', '2017-11-01 16:21:09', 'hs', '件', '1');
INSERT INTO `products` VALUES ('7', 'sssssssssssssss', 'ddddd', '8', '12', '2017-11-01 17:15:24', null, null, '0');
INSERT INTO `products` VALUES ('8', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509425429031.jpeg', 'pic-1', '15', '30', '2017-11-04 10:19:43', null, '件', '1');
INSERT INTO `products` VALUES ('9', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509425429031.jpeg', 'pic-1', '15', '30', '2017-11-04 10:24:30', null, '件', '1');
INSERT INTO `products` VALUES ('10', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509425429031.jpeg', 'pic-1', '15', '30', '2017-11-04 10:24:53', null, '件', '1');
INSERT INTO `products` VALUES ('11', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509425429031.jpeg', 'pic-1', '15', '30', '2017-11-04 10:28:10', null, '件', '1');
INSERT INTO `products` VALUES ('12', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/1509425429031.jpeg', 'pic-1', '15', '30', '2017-11-04 10:30:11', null, '件', '1');

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
INSERT INTO `product_image` VALUES ('6', '4');
INSERT INTO `product_image` VALUES ('4', '5');
INSERT INTO `product_image` VALUES ('5', '6');
INSERT INTO `product_image` VALUES ('8', '7');
INSERT INTO `product_image` VALUES ('8', '8');
INSERT INTO `product_image` VALUES ('8', '9');
INSERT INTO `product_image` VALUES ('8', '10');

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
INSERT INTO `relationships` VALUES ('3', '2', null, '2017-11-11 09:39:14');
INSERT INTO `relationships` VALUES ('3', '4', null, '2017-10-31 13:20:39');
INSERT INTO `relationships` VALUES ('15', '1', null, '2017-11-04 09:51:29');
INSERT INTO `relationships` VALUES ('15', '2', null, '2017-11-04 09:51:29');
INSERT INTO `relationships` VALUES ('15', '3', null, '2017-11-04 09:51:29');
INSERT INTO `relationships` VALUES ('15', '4', null, '2017-11-04 09:51:29');

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
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8 COMMENT='存储注册用户的相关信息';

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO `users` VALUES ('1', '1', '1', '大苏打', null, 'mklklklkeli@gmail.com', 'hh', '广东', '深圳', '福田', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/users/1510477906153', null, null, null, null, '2017-11-14 13:43:29', null, null, null, null, null, null, null, null);
INSERT INTO `users` VALUES ('2', '0', '1', '大苏打', null, 'm@gmail.com', 'kijkjkjkju', null, null, null, 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/users/1510477906153', null, null, null, null, '2017-11-14 13:43:31', 'https://baidu.com', 'I AM AN EXCELLENT DEVELOPER', null, null, null, null, null, null);
INSERT INTO `users` VALUES ('3', '0', '1', '大苏打', null, 'meli@gmail.com', 'hh', '广东', '深圳', '福田', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/users/1510477906153', null, null, null, null, '2017-11-14 13:43:32', 'https://baidu.com', 'I AM AN EXCELLENT DEVELOPER', null, null, null, null, null, null);
INSERT INTO `users` VALUES ('4', '1', '1', '大苏lll打', null, 'mklklk0@gmail.com', 'hh', null, null, null, 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/users/1510477906153', null, null, null, null, '2017-11-14 13:43:34', null, null, null, null, null, null, null, null);
INSERT INTO `users` VALUES ('6', '1', '1', '大苏打', null, 'm1@gmail.com', '5e36941b3d856737e81516acd45edc50', null, null, null, 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/users/1510477906153', null, null, null, null, '2017-11-14 13:43:35', null, null, null, null, null, null, null, null);
INSERT INTO `users` VALUES ('7', '1', '1', '大苏打', null, 'q@gmail.com', '5e36941b3d856737e81516acd45edc50', null, null, null, 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/users/1510477906153', null, null, null, null, '2017-11-14 13:43:36', null, null, null, null, null, null, null, null);
INSERT INTO `users` VALUES ('8', '0', '0', '林晴', '18826417583', 'lq@gmail.com', '123321', null, null, null, 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/users/1510477906153', null, null, null, null, '2017-11-14 13:43:37', null, null, null, null, null, null, null, null);
INSERT INTO `users` VALUES ('9', '1', '1', '大苏打', null, 'mq@gmail.com', '5e36941b3d856737e81516acd45edc50', null, null, null, 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/users/1510477906153', null, null, null, 'fffffffffffffff', '2017-11-14 13:43:38', null, null, null, null, null, null, null, null);
INSERT INTO `users` VALUES ('10', '1', '1', '大苏打', null, 'mdq@gmail.com', '5e36941b3d856737e81516acd45edc50', null, null, null, 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/users/1510477906153', null, null, null, '???????????', '2017-11-14 13:43:39', null, null, null, null, null, null, null, null);
INSERT INTO `users` VALUES ('11', '1', '1', '大苏打', null, 'mdssq@gmail.com', '5e36941b3d856737e81516acd45edc50', null, null, null, 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/users/1510477906153', null, null, null, 'ffffffff', '2017-11-14 13:43:40', null, null, null, null, null, null, null, null);
INSERT INTO `users` VALUES ('12', '1', '1', 'carol', null, 'carol@gmail.com', 'ff92a240d11b05ebd392348c35f781b2', null, null, null, 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/users/1510477906153', null, null, null, null, '2017-11-14 13:43:41', null, null, null, null, null, null, null, null);
INSERT INTO `users` VALUES ('15', '0', '1', 'carol2', null, 'carol2@gmail.com', '670b14728ad9902aecba32e22fa4f6bd', null, null, null, 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/users/1510477906153', null, null, null, null, '2017-11-14 13:43:42', 'http://baidu.com', '读书多了，容颜自然改变，许多时候，自己可能以为许多看过的书籍都成了过眼云烟，不复记忆，其实他们仍是潜在的。在气质里，在谈吐上，在胸襟的无涯，当然也可能显露在生活和文字里。', null, null, null, null, null, null);
INSERT INTO `users` VALUES ('16', '1', '1', '大苏打', null, 'm3@gmail.com', 'hh', null, null, null, 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/users/1510477906153', null, null, null, null, '2017-11-14 13:43:43', null, null, null, null, null, null, null, null);
INSERT INTO `users` VALUES ('17', '1', '1', 'carollynn', null, 'carol1992@gmail.com', '46f94c8de14fb36680850768ff1b7f2a', null, null, null, 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/users/1510477906153', null, null, null, null, '2017-11-14 13:43:44', null, null, null, null, null, null, null, null);
INSERT INTO `users` VALUES ('19', '1', '1', '大苏打', '', 'mpp@gmail.com', 'hh', '', '', '', '', '', '', '', '', '2017-11-14 13:44:18', '', '', '', '', '', '', '', '');
INSERT INTO `users` VALUES ('30', '1', '1', '林晴', '', 'linqing@qq.com', '46f94c8de14fb36680850768ff1b7f2a', '', '', '', 'http://my-image-carol.oss-cn-beijing.aliyuncs.com/users/1510482998348', 'www.linyaqing.com', '', '广东省深圳市', '我是前端开发工程师', '2017-11-12 18:31:38', '', '', '', '', '', '', '', '');
INSERT INTO `users` VALUES ('31', '1', '1', 'test', '', 'test@gmail.com', '05a671c66aefea124cc08b76ea6d30bb', '', '', '', '', '', '', '', '', '2017-11-14 10:13:46', '', '', '', '', '', '', '', '');

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
INSERT INTO `user_category` VALUES ('15', '1', null, null, '2017-11-04 09:51:29');
INSERT INTO `user_category` VALUES ('15', '2', null, null, '2017-11-04 09:51:29');
INSERT INTO `user_category` VALUES ('15', '3', null, null, '2017-11-04 09:51:29');
INSERT INTO `user_category` VALUES ('15', '4', null, null, '2017-11-04 09:51:29');
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
INSERT INTO `user_email` VALUES ('4', '1', null, null, '2017-11-07 15:57:17');
INSERT INTO `user_email` VALUES ('15', '1', null, null, '2017-11-03 23:12:29');
INSERT INTO `user_email` VALUES ('30', '1', null, null, '2017-11-11 22:15:29');
INSERT INTO `user_email` VALUES ('3', '2', null, null, '2017-10-31 13:19:23');
INSERT INTO `user_email` VALUES ('4', '2', null, null, '2017-11-07 15:57:24');
INSERT INTO `user_email` VALUES ('15', '2', null, null, '2017-11-03 23:12:29');
INSERT INTO `user_email` VALUES ('30', '2', null, null, '2017-11-11 22:15:29');
INSERT INTO `user_email` VALUES ('3', '3', null, null, '2017-10-31 13:19:23');
INSERT INTO `user_email` VALUES ('15', '3', null, null, '2017-11-03 23:12:29');
INSERT INTO `user_email` VALUES ('30', '3', null, null, '2017-11-11 22:15:29');
INSERT INTO `user_email` VALUES ('3', '4', null, null, '2017-10-31 13:19:23');
INSERT INTO `user_email` VALUES ('15', '4', null, null, '2017-11-03 23:12:29');
INSERT INTO `user_email` VALUES ('30', '4', null, null, '2017-11-11 22:15:29');
INSERT INTO `user_email` VALUES ('3', '5', null, null, '2017-10-31 13:19:23');
INSERT INTO `user_email` VALUES ('30', '5', null, null, '2017-11-11 22:15:29');
INSERT INTO `user_email` VALUES ('3', '6', null, null, '2017-10-31 13:19:23');
INSERT INTO `user_email` VALUES ('30', '6', null, null, '2017-11-11 22:15:29');
