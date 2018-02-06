-- --------------------------------------------------------
-- 호스트:                          ekkor.ze.am
-- 서버 버전:                        10.2.12-MariaDB-10.2.12+maria~xenial-log - mariadb.org binary distribution
-- 서버 OS:                        debian-linux-gnu
-- HeidiSQL 버전:                  9.3.0.4984
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

-- 테이블 ekkor.activity 구조 내보내기
CREATE TABLE IF NOT EXISTS `activity` (
  `activity_id` int(11) NOT NULL AUTO_INCREMENT,
  `activity_desc` varchar(200) DEFAULT NULL,
  `activity_keyword` varchar(10) NOT NULL,
  `activity_type` varchar(20) NOT NULL,
  `insert_date` datetime DEFAULT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0,
  `qa_id` int(11) DEFAULT NULL,
  `reply_id` int(11) DEFAULT NULL,
  `space_id` int(11) DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  `user_nick` varchar(40) DEFAULT NULL,
  `wiki_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`activity_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 내보낼 데이터가 선택되어 있지 않습니다.


-- 테이블 ekkor.COMPANY 구조 내보내기
CREATE TABLE IF NOT EXISTS `COMPANY` (
  `SEQ` int(11) NOT NULL AUTO_INCREMENT,
  `NAME` varchar(50) NOT NULL DEFAULT 'noname',
  `ADDRESS` varchar(200) NOT NULL DEFAULT 'noaddress',
  `PHONE` varchar(15) NOT NULL DEFAULT '000-0000-0000',
  `EMAIL` varchar(255) NOT NULL,
  `REGTIME` datetime DEFAULT NULL,
  PRIMARY KEY (`SEQ`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 내보낼 데이터가 선택되어 있지 않습니다.


-- 테이블 ekkor.DEPARTMENT 구조 내보내기
CREATE TABLE IF NOT EXISTS `DEPARTMENT` (
  `SEQ` int(11) NOT NULL AUTO_INCREMENT,
  `COMPANY` int(11) NOT NULL,
  `NAME` varchar(50) NOT NULL DEFAULT 'name',
  `PHONE` varchar(15) NOT NULL,
  `EMAIL` varchar(255) NOT NULL,
  `REGTIME` datetime DEFAULT NULL,
  PRIMARY KEY (`SEQ`),
  KEY `fk_DEPARTMENT_COMPANY_idx` (`COMPANY`),
  CONSTRAINT `fk_DEPARTMENT_COMPANY` FOREIGN KEY (`COMPANY`) REFERENCES `myintranet`.`COMPANY` (`SEQ`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 내보낼 데이터가 선택되어 있지 않습니다.


-- 테이블 ekkor.EMPLOYEE 구조 내보내기
CREATE TABLE IF NOT EXISTS `EMPLOYEE` (
  `EMAIL` varchar(255) NOT NULL,
  `NAME` varchar(45) NOT NULL,
  `LEVEL` int(11) NOT NULL,
  `PHONE` varchar(255) NOT NULL,
  `PASSWD` varchar(255) NOT NULL,
  `REGTIME` datetime NOT NULL,
  PRIMARY KEY (`EMAIL`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 내보낼 데이터가 선택되어 있지 않습니다.


-- 테이블 ekkor.feed_action 구조 내보내기
CREATE TABLE IF NOT EXISTS `feed_action` (
  `feed_action_id` int(11) NOT NULL AUTO_INCREMENT,
  `action_type` varchar(30) NOT NULL,
  `feed_actor_id` int(11) NOT NULL,
  `insert_date` datetime NOT NULL,
  `insert_user_id` int(11) NOT NULL,
  `is_canceled` tinyint(1) DEFAULT 0,
  `post_type` varchar(30) NOT NULL,
  `update_date` datetime DEFAULT NULL,
  `update_user_id` int(11) DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  `user_nick` varchar(40) NOT NULL,
  PRIMARY KEY (`feed_action_id`),
  KEY `IDXl9dgugueyhuyr7n1nhtrhk1gm` (`is_canceled`),
  KEY `IDX8m27sl0wellw873h3nsoxvne5` (`feed_actor_id`,`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 내보낼 데이터가 선택되어 있지 않습니다.


-- 테이블 ekkor.feed_file 구조 내보내기
CREATE TABLE IF NOT EXISTS `feed_file` (
  `feed_file_id` int(11) NOT NULL AUTO_INCREMENT,
  `download_count` int(11) DEFAULT NULL,
  `file_path` varchar(80) NOT NULL,
  `file_size` int(11) NOT NULL,
  `file_type` varchar(10) DEFAULT NULL,
  `insert_date` datetime NOT NULL,
  `insert_user_id` int(11) NOT NULL,
  `is_deleted` tinyint(1) DEFAULT 0,
  `real_name` varchar(255) NOT NULL,
  `saved_name` varchar(255) NOT NULL,
  `user_id` int(11) NOT NULL,
  `user_nick` varchar(40) NOT NULL,
  `feed_thread_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`feed_file_id`),
  KEY `IDX6372l2hwn58woorhltuest21p` (`is_deleted`),
  KEY `FKsj48eauq1rqqvwp2dmg1c378x` (`feed_thread_id`),
  CONSTRAINT `FKsj48eauq1rqqvwp2dmg1c378x` FOREIGN KEY (`feed_thread_id`) REFERENCES `feed_thread` (`feed_thread_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 내보낼 데이터가 선택되어 있지 않습니다.


-- 테이블 ekkor.feed_reply 구조 내보내기
CREATE TABLE IF NOT EXISTS `feed_reply` (
  `feed_reply_id` int(11) NOT NULL AUTO_INCREMENT,
  `claim_count` int(11) DEFAULT NULL,
  `feed_reply_content` text NOT NULL,
  `insert_date` datetime NOT NULL,
  `insert_user_id` int(11) NOT NULL,
  `is_deleted` tinyint(1) DEFAULT 0,
  `like_count` int(11) DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  `update_user_id` int(11) DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  `user_nick` varchar(40) NOT NULL,
  `feed_thread_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`feed_reply_id`),
  KEY `IDXdrvodu1scgc2w2klge0vcixbb` (`is_deleted`),
  KEY `IDX8c6ld2tq11k81ey08o4eodhtn` (`user_id`),
  KEY `IDXctvna1x5dyr1pws8acugwp86r` (`user_nick`),
  KEY `FK8w93ek7ah66mkjqmxcx27oaat` (`feed_thread_id`),
  CONSTRAINT `FK8w93ek7ah66mkjqmxcx27oaat` FOREIGN KEY (`feed_thread_id`) REFERENCES `feed_thread` (`feed_thread_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 내보낼 데이터가 선택되어 있지 않습니다.


-- 테이블 ekkor.feed_thread 구조 내보내기
CREATE TABLE IF NOT EXISTS `feed_thread` (
  `feed_thread_id` int(11) NOT NULL AUTO_INCREMENT,
  `claim_count` int(11) DEFAULT NULL,
  `feed_content` text NOT NULL,
  `feed_url` varchar(255) DEFAULT NULL,
  `file_count` int(11) DEFAULT NULL,
  `insert_date` datetime NOT NULL,
  `insert_user_id` int(11) NOT NULL,
  `is_deleted` tinyint(1) DEFAULT 0,
  `is_private` tinyint(1) DEFAULT 0,
  `is_shared` tinyint(1) DEFAULT 0,
  `is_shared_fb` tinyint(1) DEFAULT 0,
  `is_shared_gp` tinyint(1) DEFAULT 0,
  `is_shared_tw` tinyint(1) DEFAULT 0,
  `like_count` int(11) DEFAULT NULL,
  `reply_count` int(11) DEFAULT NULL,
  `shared_contents_type` varchar(20) DEFAULT NULL,
  `shared_response_id` varchar(80) DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  `update_user_id` int(11) DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  `user_nick` varchar(40) NOT NULL,
  PRIMARY KEY (`feed_thread_id`),
  KEY `IDXn0cylndcchgiv2ycphfe6188v` (`is_deleted`),
  KEY `IDXs61g2og7xirkb26fbmxop7vb3` (`user_id`),
  KEY `IDXhteq08jljexe278muql6k1w2b` (`user_nick`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 내보낼 데이터가 선택되어 있지 않습니다.


-- 테이블 ekkor.FILES 구조 내보내기
CREATE TABLE IF NOT EXISTS `FILES` (
  `SEQ` int(11) NOT NULL AUTO_INCREMENT,
  `EMAIL` varchar(255) NOT NULL,
  `SUBNAME` varchar(255) NOT NULL,
  `REALNAME` varchar(255) NOT NULL,
  `REGTIME` varchar(45) NOT NULL,
  PRIMARY KEY (`SEQ`),
  KEY `fk_FILES_EMPLOYEE1_idx` (`EMAIL`),
  CONSTRAINT `fk_FILES_EMPLOYEE1` FOREIGN KEY (`EMAIL`) REFERENCES `EMPLOYEE` (`EMAIL`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 내보낼 데이터가 선택되어 있지 않습니다.


-- 뷰 ekkor.FILES_VIEW 구조 내보내기
-- VIEW 종속성 오류를 극복하기 위해 임시 테이블을 생성합니다.
CREATE TABLE `FILES_VIEW` (
	`SEQ` INT(11) NOT NULL,
	`EMAIL` VARCHAR(255) NOT NULL COLLATE 'utf8mb4_general_ci',
	`NAME` VARCHAR(45) NOT NULL COLLATE 'utf8mb4_general_ci',
	`SUBNAME` VARCHAR(255) NOT NULL COLLATE 'utf8mb4_general_ci',
	`REALNAME` VARCHAR(255) NOT NULL COLLATE 'utf8mb4_general_ci',
	`REGTIME` VARCHAR(45) NOT NULL COLLATE 'utf8mb4_general_ci'
) ENGINE=MyISAM;


-- 테이블 ekkor.keyword 구조 내보내기
CREATE TABLE IF NOT EXISTS `keyword` (
  `keyword_id` int(11) NOT NULL AUTO_INCREMENT,
  `insert_date` datetime NOT NULL,
  `is_deleted` tinyint(1) DEFAULT 0,
  `keyword_group_count` int(11) NOT NULL,
  `keyword_name` varchar(40) NOT NULL,
  `keyword_type` varchar(10) NOT NULL,
  `qa_id` int(11) DEFAULT NULL,
  `space_id` int(11) DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  `wiki_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`keyword_id`),
  KEY `IDX_KEYWORD_SPACE_ID` (`space_id`),
  KEY `IDX_KEYWORD_QA_ID` (`qa_id`),
  KEY `IDX_KEYWORD_WIKI_ID` (`wiki_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 CHECKSUM=1;

-- 내보낼 데이터가 선택되어 있지 않습니다.


-- 테이블 ekkor.keyword_list 구조 내보내기
CREATE TABLE IF NOT EXISTS `keyword_list` (
  `keyword_list_id` int(11) NOT NULL AUTO_INCREMENT,
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0,
  `keyword_count` int(11) NOT NULL DEFAULT 0,
  `keyword_name` varchar(40) NOT NULL,
  `keyword_type` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`keyword_list_id`),
  KEY `IDX_KEYWORDLIST_KEYWORD_TYPE` (`keyword_type`),
  KEY `IDX_KEYWORDLIST_KEYWORD_NAME` (`keyword_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 내보낼 데이터가 선택되어 있지 않습니다.


-- 테이블 ekkor.PAY 구조 내보내기
CREATE TABLE IF NOT EXISTS `PAY` (
  `SEQ` int(11) NOT NULL AUTO_INCREMENT,
  `WRITER` varchar(255) NOT NULL,
  `TITLE` varchar(255) NOT NULL,
  `STARTTIME` datetime NOT NULL,
  `contents` longtext NOT NULL,
  `pay_day` char(10) NOT NULL,
  `pay_ot` char(10) NOT NULL,
  `pay_ottime` char(10) NOT NULL,
  `pay_latetime` char(10) NOT NULL,
  `pay_nighttime` char(10) NOT NULL,
  `ENDTIME` datetime NOT NULL,
  `REGTIME` datetime NOT NULL,
  `UPTIME` datetime NOT NULL,
  `ETC_YN` char(1) NOT NULL DEFAULT 'Y',
  PRIMARY KEY (`SEQ`),
  KEY `fk_PAY_user_idx` (`WRITER`),
  CONSTRAINT `fk_PAY_user_idx` FOREIGN KEY (`WRITER`) REFERENCES `user` (`user_email`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 내보낼 데이터가 선택되어 있지 않습니다.


-- 테이블 ekkor.PAY_DATA 구조 내보내기
CREATE TABLE IF NOT EXISTS `PAY_DATA` (
  `no` int(11) NOT NULL AUTO_INCREMENT,
  `USER_EMAIL` varchar(20) NOT NULL,
  `PAY_DATE` varchar(50) DEFAULT NULL,
  `TIME_SALARY` char(50) DEFAULT NULL,
  `JOB_TIME` char(50) DEFAULT NULL,
  `FULL_WORKING_PENSION` char(50) DEFAULT NULL,
  `FAMILY_PENSION` char(50) DEFAULT NULL,
  `POSITION_PENSION` char(50) DEFAULT NULL,
  `LONGEVITY_PENSION` char(50) DEFAULT NULL,
  `YEARLY` char(50) DEFAULT NULL,
  `ETC` char(50) DEFAULT NULL,
  `TEXES` char(50) DEFAULT NULL,
  `REGTIME` datetime DEFAULT NULL,
  `UPTIME` datetime DEFAULT NULL,
  PRIMARY KEY (`no`),
  UNIQUE KEY `PAYDATA_PK` (`no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 내보낼 데이터가 선택되어 있지 않습니다.


-- 뷰 ekkor.PAY_VIEW 구조 내보내기
-- VIEW 종속성 오류를 극복하기 위해 임시 테이블을 생성합니다.
CREATE TABLE `PAY_VIEW` (
	`SEQ` INT(11) NOT NULL,
	`EMAIL` VARCHAR(255) NOT NULL COLLATE 'utf8mb4_general_ci',
	`TITLE` VARCHAR(255) NOT NULL COLLATE 'utf8mb4_general_ci',
	`contents` LONGTEXT NOT NULL COLLATE 'utf8mb4_general_ci',
	`WRITER` VARCHAR(40) NOT NULL COLLATE 'utf8mb4_general_ci',
	`PAY_DAY` CHAR(10) NOT NULL COLLATE 'utf8mb4_general_ci',
	`PAY_OT` CHAR(10) NOT NULL COLLATE 'utf8mb4_general_ci',
	`PAY_OTTIME` CHAR(10) NOT NULL COLLATE 'utf8mb4_general_ci',
	`PAY_LATETIME` CHAR(10) NOT NULL COLLATE 'utf8mb4_general_ci',
	`PAY_NIGHTTIME` CHAR(10) NOT NULL COLLATE 'utf8mb4_general_ci',
	`STARTTIME` DATETIME NOT NULL,
	`ENDTIME` DATETIME NOT NULL,
	`REGTIME` DATETIME NOT NULL,
	`UPTIME` DATETIME NOT NULL,
	`ETCYN` CHAR(1) NOT NULL COLLATE 'utf8mb4_general_ci'
) ENGINE=MyISAM;


-- 테이블 ekkor.persistent_logins 구조 내보내기
CREATE TABLE IF NOT EXISTS `persistent_logins` (
  `series` varchar(64) NOT NULL,
  `last_used` datetime NOT NULL,
  `token` varchar(64) NOT NULL,
  `username` varchar(64) NOT NULL,
  PRIMARY KEY (`series`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 내보낼 데이터가 선택되어 있지 않습니다.


-- 테이블 ekkor.qa_content 구조 내보내기
CREATE TABLE IF NOT EXISTS `qa_content` (
  `qa_id` int(11) NOT NULL AUTO_INCREMENT,
  `contents` text NOT NULL,
  `contents_markup` text NOT NULL,
  `insert_date` datetime NOT NULL,
  `insert_user_id` int(11) NOT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0,
  `is_replyed` tinyint(1) NOT NULL DEFAULT 0,
  `is_shared` tinyint(1) NOT NULL DEFAULT 0,
  `nonrecommend_count` int(11) NOT NULL DEFAULT 0,
  `recommend_count` int(11) NOT NULL DEFAULT 0,
  `shared_contents_type` varchar(20) DEFAULT NULL,
  `shared_response_id` int(11) DEFAULT NULL,
  `title` varchar(100) NOT NULL,
  `update_date` datetime DEFAULT NULL,
  `update_user_id` int(11) DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  `user_nick` varchar(40) NOT NULL,
  `view_count` int(11) NOT NULL DEFAULT 0,
  `wiki_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`qa_id`),
  KEY `IDX9jekncaq2528h8refelapsdo6` (`is_deleted`),
  KEY `IDX176if9660t95nsdqoe2i9uxgm` (`recommend_count`,`nonrecommend_count`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 내보낼 데이터가 선택되어 있지 않습니다.


-- 테이블 ekkor.qa_file 구조 내보내기
CREATE TABLE IF NOT EXISTS `qa_file` (
  `file_id` int(11) NOT NULL AUTO_INCREMENT,
  `file_path` varchar(80) NOT NULL,
  `file_size` int(11) NOT NULL,
  `file_type` varchar(10) DEFAULT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0,
  `qa_id` int(11) NOT NULL,
  `real_name` varchar(40) NOT NULL,
  `saved_name` varchar(80) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`file_id`),
  KEY `FKneibvnr3boj74hsydj1l6rbbj` (`qa_id`),
  CONSTRAINT `FKneibvnr3boj74hsydj1l6rbbj` FOREIGN KEY (`qa_id`) REFERENCES `qa_content` (`qa_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 내보낼 데이터가 선택되어 있지 않습니다.


-- 테이블 ekkor.qa_recommend 구조 내보내기
CREATE TABLE IF NOT EXISTS `qa_recommend` (
  `qa_recommend_id` int(11) NOT NULL AUTO_INCREMENT,
  `insert_date` datetime NOT NULL,
  `is_canceled` tinyint(1) NOT NULL DEFAULT 0,
  `is_commend` tinyint(1) NOT NULL DEFAULT 0,
  `qa_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `user_nick` varchar(40) NOT NULL,
  PRIMARY KEY (`qa_recommend_id`),
  KEY `FKthpy3h9e7vxloatky070ji9cr` (`qa_id`),
  CONSTRAINT `FKthpy3h9e7vxloatky070ji9cr` FOREIGN KEY (`qa_id`) REFERENCES `qa_content` (`qa_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 내보낼 데이터가 선택되어 있지 않습니다.


-- 테이블 ekkor.qa_reply 구조 내보내기
CREATE TABLE IF NOT EXISTS `qa_reply` (
  `reply_id` int(11) NOT NULL AUTO_INCREMENT,
  `contents` text NOT NULL,
  `contents_markup` text NOT NULL,
  `depth_idx` int(11) NOT NULL DEFAULT 0,
  `insert_date` datetime NOT NULL,
  `insert_user_id` int(11) NOT NULL,
  `is_choice` tinyint(1) NOT NULL DEFAULT 0,
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0,
  `order_idx` int(11) NOT NULL DEFAULT 0,
  `parents_id` int(11) NOT NULL,
  `qa_id` int(11) NOT NULL,
  `title` varchar(100) NOT NULL,
  `update_date` datetime DEFAULT NULL,
  `update_user_id` int(11) DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  `user_nick` varchar(40) NOT NULL,
  `vote_down_count` int(11) NOT NULL DEFAULT 0,
  `vote_up_count` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`reply_id`),
  KEY `FKn410kb60nn687bdxxn0m2y8u1` (`qa_id`),
  CONSTRAINT `FKn410kb60nn687bdxxn0m2y8u1` FOREIGN KEY (`qa_id`) REFERENCES `qa_content` (`qa_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 내보낼 데이터가 선택되어 있지 않습니다.


-- 테이블 ekkor.SCHEDULE 구조 내보내기
CREATE TABLE IF NOT EXISTS `SCHEDULE` (
  `SEQ` int(11) NOT NULL AUTO_INCREMENT,
  `WRITER` varchar(255) NOT NULL,
  `TITLE` varchar(255) NOT NULL,
  `CONTENTS` mediumtext NOT NULL,
  `STARTTIME` datetime NOT NULL,
  `ENDTIME` datetime NOT NULL,
  `REGTIME` datetime NOT NULL,
  `UPTIME` datetime NOT NULL,
  `ETC_YN` char(1) NOT NULL DEFAULT 'Y',
  PRIMARY KEY (`SEQ`),
  KEY `fk_SCHEDULE_EMPLOYEE1_idx` (`WRITER`),
  CONSTRAINT `fk_SCHEDULE_EMPLOYEE1` FOREIGN KEY (`WRITER`) REFERENCES `EMPLOYEE` (`EMAIL`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 내보낼 데이터가 선택되어 있지 않습니다.


-- 테이블 ekkor.SCHEDULE_FILES 구조 내보내기
CREATE TABLE IF NOT EXISTS `SCHEDULE_FILES` (
  `SEQ` int(11) NOT NULL AUTO_INCREMENT,
  `SCHEDULE_SEQ` int(11) NOT NULL,
  `SUBNAME` varchar(255) NOT NULL,
  `REALNAME` varchar(255) NOT NULL,
  `REGTIME` datetime NOT NULL,
  PRIMARY KEY (`SEQ`),
  KEY `fk_SCHEDULE_FILES_SCHEDULE1_idx` (`SCHEDULE_SEQ`),
  CONSTRAINT `fk_SCHEDULE_FILES_SCHEDULE1` FOREIGN KEY (`SCHEDULE_SEQ`) REFERENCES `SCHEDULE` (`SEQ`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 내보낼 데이터가 선택되어 있지 않습니다.


-- 뷰 ekkor.SCHEDULE_VIEW 구조 내보내기
-- VIEW 종속성 오류를 극복하기 위해 임시 테이블을 생성합니다.
CREATE TABLE `SCHEDULE_VIEW` (
	`SEQ` INT(11) NOT NULL,
	`EMAIL` VARCHAR(255) NOT NULL COLLATE 'utf8mb4_general_ci',
	`WRITER` VARCHAR(45) NOT NULL COLLATE 'utf8mb4_general_ci',
	`TITLE` VARCHAR(255) NOT NULL COLLATE 'utf8mb4_general_ci',
	`CONTENTS` MEDIUMTEXT NOT NULL COLLATE 'utf8mb4_general_ci',
	`ETCYN` CHAR(1) NOT NULL COLLATE 'utf8mb4_general_ci',
	`STARTTIME` DATETIME NOT NULL,
	`ENDTIME` DATETIME NOT NULL,
	`REGTIME` DATETIME NOT NULL,
	`UPTIME` DATETIME NOT NULL
) ENGINE=MyISAM;


-- 테이블 ekkor.send_mail_info 구조 내보내기
CREATE TABLE IF NOT EXISTS `send_mail_info` (
  `send_mail_info_id` int(11) NOT NULL AUTO_INCREMENT,
  `confirm_date` date DEFAULT NULL,
  `contents` text NOT NULL,
  `insert_date` date DEFAULT NULL,
  `link_url` varchar(100) DEFAULT NULL,
  `mail_type` varchar(10) DEFAULT NULL,
  `receiver_email` varchar(255) NOT NULL,
  `receiver_id` int(11) NOT NULL,
  `send_type` varchar(10) DEFAULT NULL,
  `sender_email` varchar(255) NOT NULL,
  `sender_id` int(11) NOT NULL,
  `title` varchar(100) NOT NULL,
  PRIMARY KEY (`send_mail_info_id`),
  KEY `send_mail_info_index1` (`sender_id`),
  KEY `send_mail_info_index2` (`receiver_id`),
  KEY `send_mail_info_index3` (`mail_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 내보낼 데이터가 선택되어 있지 않습니다.


-- 테이블 ekkor.space 구조 내보내기
CREATE TABLE IF NOT EXISTS `space` (
  `space_id` int(11) NOT NULL AUTO_INCREMENT,
  `description` text NOT NULL,
  `description_markup` text NOT NULL,
  `insert_date` datetime DEFAULT NULL,
  `insert_user_id` int(11) NOT NULL,
  `insert_user_nick` varchar(40) DEFAULT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0,
  `is_private` tinyint(1) NOT NULL DEFAULT 0,
  `layout_type` varchar(20) NOT NULL,
  `title` varchar(80) NOT NULL,
  `title_image` varchar(40) DEFAULT NULL,
  `title_image_path` varchar(50) DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  `update_user_id` int(11) DEFAULT NULL,
  `update_user_nick` varchar(40) DEFAULT NULL,
  PRIMARY KEY (`space_id`),
  KEY `IDX_SPACE_ID` (`space_id`,`is_deleted`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 내보낼 데이터가 선택되어 있지 않습니다.


-- 테이블 ekkor.space_access_user 구조 내보내기
CREATE TABLE IF NOT EXISTS `space_access_user` (
  `space_access_user_id` int(11) NOT NULL AUTO_INCREMENT,
  `insert_date` date NOT NULL,
  `is_deleted` tinyint(1) DEFAULT 0,
  `update_date` date DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  `space_id` int(11) NOT NULL,
  PRIMARY KEY (`space_access_user_id`),
  KEY `FK5i6tmxyn6wc2vwrahjt33vrif` (`space_id`),
  CONSTRAINT `FK5i6tmxyn6wc2vwrahjt33vrif` FOREIGN KEY (`space_id`) REFERENCES `space` (`space_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 내보낼 데이터가 선택되어 있지 않습니다.


-- 테이블 ekkor.user 구조 내보내기
CREATE TABLE IF NOT EXISTS `user` (
  `user_id` int(11) NOT NULL AUTO_INCREMENT,
  `certification_key` varchar(255) NOT NULL,
  `level` int(11) NOT NULL,
  `channel_type` varchar(20) DEFAULT NULL,
  `insert_date` datetime NOT NULL,
  `is_certification` tinyint(1) NOT NULL DEFAULT 0,
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0,
  `last_visite_date` datetime NOT NULL,
  `role` varchar(255) NOT NULL,
  `update_date` datetime DEFAULT NULL,
  `user_email` varchar(80) NOT NULL,
  `user_image_name` varchar(40) DEFAULT NULL,
  `user_image_path` varchar(80) DEFAULT NULL,
  `user_nick` varchar(40) NOT NULL,
  `user_pass` varchar(255) NOT NULL,
  `passwd` varchar(255) NOT NULL,
  `user_site` varchar(100) DEFAULT NULL,
  `user_thumbnail_image_name` varchar(40) DEFAULT NULL,
  `user_thumbnail_image_path` varchar(80) DEFAULT NULL,
  `user_total_point` int(11) NOT NULL DEFAULT 0,
  `visit_count` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `UK_j09k2v8lxofv2vecxu2hde9so` (`user_email`),
  UNIQUE KEY `UK_23fkpdormb3jwywokgb1gvls5` (`user_nick`),
  KEY `IDX_USER_ID` (`user_id`),
  KEY `IDX_USER_EMAIL` (`user_email`),
  KEY `IDX_USER_NICK` (`user_nick`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 내보낼 데이터가 선택되어 있지 않습니다.


-- 테이블 ekkor.USERARTICLE 구조 내보내기
CREATE TABLE IF NOT EXISTS `USERARTICLE` (
  `SEQ` int(11) NOT NULL AUTO_INCREMENT,
  `WRITER` varchar(255) NOT NULL,
  `RECEIVER` varchar(255) NOT NULL,
  `VIEW_YN` char(1) NOT NULL DEFAULT 'N',
  `TITLE` varchar(255) NOT NULL,
  `CONTENTS` text NOT NULL,
  `REGTIME` datetime NOT NULL,
  `UPTIME` datetime NOT NULL,
  PRIMARY KEY (`SEQ`),
  KEY `fk_USERARTICLE_EMPLOYEE1_idx` (`WRITER`),
  CONSTRAINT `fk_USERARTICLE_EMPLOYEE1` FOREIGN KEY (`WRITER`) REFERENCES `EMPLOYEE` (`EMAIL`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 내보낼 데이터가 선택되어 있지 않습니다.


-- 뷰 ekkor.USERARTICLE_VIEW 구조 내보내기
-- VIEW 종속성 오류를 극복하기 위해 임시 테이블을 생성합니다.
CREATE TABLE `USERARTICLE_VIEW` (
	`SEQ` INT(11) NOT NULL,
	`VIEW_YN` CHAR(1) NOT NULL COLLATE 'utf8mb4_general_ci',
	`WRITER` VARCHAR(255) NOT NULL COLLATE 'utf8mb4_general_ci',
	`RECEIVER` VARCHAR(255) NOT NULL COLLATE 'utf8mb4_general_ci',
	`RECEIVERNAME` VARCHAR(45) NULL COLLATE 'utf8mb4_general_ci',
	`NAME` VARCHAR(45) NOT NULL COLLATE 'utf8mb4_general_ci',
	`TITLE` VARCHAR(255) NOT NULL COLLATE 'utf8mb4_general_ci',
	`CONTENTS` TEXT NOT NULL COLLATE 'utf8mb4_general_ci',
	`REGTIME` DATETIME NOT NULL,
	`UPTIME` DATETIME NOT NULL
) ENGINE=MyISAM;


-- 테이블 ekkor.user_favorite 구조 내보내기
CREATE TABLE IF NOT EXISTS `user_favorite` (
  `favorite_id` int(11) NOT NULL AUTO_INCREMENT,
  `favorite_type` varchar(255) NOT NULL,
  `insert_date` date NOT NULL,
  `is_deleted` tinyint(1) DEFAULT 0,
  `qa_id` int(11) DEFAULT NULL,
  `space_id` int(11) DEFAULT NULL,
  `update_date` date DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  `wiki_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`favorite_id`),
  KEY `IDX_USER_FAVORITE_SPACE_ID` (`space_id`),
  KEY `IDX_USER_FAVORITE_QA_ID` (`qa_id`),
  KEY `IDX_USER_FAVORITE_WIKI_ID` (`wiki_id`),
  KEY `IDX_USER_FAVORITE_USER_ID` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 내보낼 데이터가 선택되어 있지 않습니다.


-- 테이블 ekkor.USER_FILES 구조 내보내기
CREATE TABLE IF NOT EXISTS `USER_FILES` (
  `SEQ` int(11) NOT NULL AUTO_INCREMENT,
  `USERARTICLE_SEQ` int(11) NOT NULL,
  `SUBNAME` varchar(255) NOT NULL,
  `REALNAME` varchar(255) NOT NULL,
  `REGTIME` datetime NOT NULL,
  PRIMARY KEY (`SEQ`),
  KEY `fk_table1_USERARTICLE1_idx` (`USERARTICLE_SEQ`),
  CONSTRAINT `fk_table1_USERARTICLE1` FOREIGN KEY (`USERARTICLE_SEQ`) REFERENCES `USERARTICLE` (`SEQ`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 내보낼 데이터가 선택되어 있지 않습니다.


-- 테이블 ekkor.user_keyword 구조 내보내기
CREATE TABLE IF NOT EXISTS `user_keyword` (
  `user_keyword_id` int(11) NOT NULL AUTO_INCREMENT,
  `insert_date` date NOT NULL,
  `is_deleted` tinyint(1) DEFAULT 0,
  `keyword_name` varchar(20) DEFAULT NULL,
  `update_date` date DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`user_keyword_id`),
  KEY `FK7vf8j5x5grt4n6lxw8bligm4c` (`user_id`),
  CONSTRAINT `FK7vf8j5x5grt4n6lxw8bligm4c` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 내보낼 데이터가 선택되어 있지 않습니다.


-- 테이블 ekkor.user_point 구조 내보내기
CREATE TABLE IF NOT EXISTS `user_point` (
  `user_point_id` int(11) NOT NULL AUTO_INCREMENT,
  `insert_date` date DEFAULT NULL,
  `point_type` varchar(20) DEFAULT NULL,
  `user_point` int(11) NOT NULL DEFAULT 0,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`user_point_id`),
  KEY `FK5evnproqicxekw9a5r0muk6rl` (`user_id`),
  CONSTRAINT `FK5evnproqicxekw9a5r0muk6rl` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 내보낼 데이터가 선택되어 있지 않습니다.


-- 테이블 ekkor.vote 구조 내보내기
CREATE TABLE IF NOT EXISTS `vote` (
  `vote_id` int(11) NOT NULL AUTO_INCREMENT,
  `insert_date` date NOT NULL,
  `is_cancel` tinyint(1) NOT NULL DEFAULT 0,
  `is_vote` tinyint(1) NOT NULL DEFAULT 0,
  `reply_id` int(11) NOT NULL,
  `update_date` date DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  `user_nick` varchar(255) NOT NULL,
  PRIMARY KEY (`vote_id`),
  KEY `FKrfokcnlyt4a0brqllqtwf9qs` (`reply_id`),
  CONSTRAINT `FKrfokcnlyt4a0brqllqtwf9qs` FOREIGN KEY (`reply_id`) REFERENCES `qa_reply` (`reply_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 내보낼 데이터가 선택되어 있지 않습니다.


-- 테이블 ekkor.wiki 구조 내보내기
CREATE TABLE IF NOT EXISTS `wiki` (
  `wiki_id` int(11) NOT NULL AUTO_INCREMENT,
  `contents` longtext NOT NULL,
  `contents_markup` longtext NOT NULL,
  `current_ip` varchar(16) DEFAULT NULL,
  `depth_idx` int(11) NOT NULL DEFAULT 0,
  `edit_reason` varchar(10) DEFAULT NULL,
  `group_idx` int(11) DEFAULT NULL,
  `insert_date` datetime DEFAULT NULL,
  `insert_user_id` int(11) NOT NULL,
  `insert_user_nick` varchar(40) DEFAULT NULL,
  `is_deleted` tinyint(1) DEFAULT 0,
  `is_fixed` tinyint(1) DEFAULT 0,
  `is_lock` tinyint(1) DEFAULT 0,
  `like_count` int(11) DEFAULT NULL,
  `order_idx` int(11) NOT NULL DEFAULT 0,
  `parents_id` int(11) DEFAULT NULL,
  `passwd` varchar(40) DEFAULT NULL,
  `reply_count` int(11) DEFAULT NULL,
  `report_count` int(11) DEFAULT NULL,
  `revision` varchar(10) DEFAULT NULL,
  `space_id` int(11) NOT NULL,
  `title` varchar(100) NOT NULL,
  `update_date` datetime DEFAULT NULL,
  `update_user_id` int(11) DEFAULT NULL,
  `update_user_nick` varchar(40) DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  `user_nick` varchar(40) NOT NULL,
  `view_count` int(11) DEFAULT NULL,
  `wiki_url` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`wiki_id`),
  KEY `IDX_WIKI_SPACE_ID` (`space_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 내보낼 데이터가 선택되어 있지 않습니다.


-- 테이블 ekkor.wiki_file 구조 내보내기
CREATE TABLE IF NOT EXISTS `wiki_file` (
  `file_id` int(11) NOT NULL AUTO_INCREMENT,
  `file_path` varchar(80) NOT NULL,
  `file_size` int(11) NOT NULL,
  `file_type` varchar(10) DEFAULT NULL,
  `insert_date` datetime NOT NULL,
  `is_deleted` tinyint(1) DEFAULT 0,
  `real_name` varchar(255) NOT NULL,
  `saved_name` varchar(255) NOT NULL,
  `update_date` datetime DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  `wiki_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`file_id`),
  KEY `FKn11tkvap2ccqd7my4cvo79r1u` (`wiki_id`),
  CONSTRAINT `FKn11tkvap2ccqd7my4cvo79r1u` FOREIGN KEY (`wiki_id`) REFERENCES `wiki` (`wiki_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 내보낼 데이터가 선택되어 있지 않습니다.


-- 테이블 ekkor.wiki_like 구조 내보내기
CREATE TABLE IF NOT EXISTS `wiki_like` (
  `like_id` int(11) NOT NULL AUTO_INCREMENT,
  `reply_id` int(11) DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  `wiki_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`like_id`),
  UNIQUE KEY `UKntvicbtret3xll971pmaurc5h` (`user_id`,`wiki_id`),
  UNIQUE KEY `UKn6sh3djgu81biy08aj5reftpa` (`user_id`,`reply_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 내보낼 데이터가 선택되어 있지 않습니다.


-- 테이블 ekkor.wiki_reply 구조 내보내기
CREATE TABLE IF NOT EXISTS `wiki_reply` (
  `reply_id` int(11) NOT NULL AUTO_INCREMENT,
  `contents` text NOT NULL,
  `insert_date` datetime DEFAULT NULL,
  `is_deleted` tinyint(1) DEFAULT 0,
  `like_count` int(11) DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  `user_nick` varchar(40) NOT NULL,
  `wiki_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`reply_id`),
  KEY `FK3mb8sclti0b5l4t5wlmf0aaaa` (`wiki_id`),
  CONSTRAINT `FK3mb8sclti0b5l4t5wlmf0aaaa` FOREIGN KEY (`wiki_id`) REFERENCES `wiki` (`wiki_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 내보낼 데이터가 선택되어 있지 않습니다.


-- 테이블 ekkor.wiki_snap_shot 구조 내보내기
CREATE TABLE IF NOT EXISTS `wiki_snap_shot` (
  `wiki_back_id` int(11) NOT NULL AUTO_INCREMENT,
  `contents` text NOT NULL,
  `contents_markup` text NOT NULL,
  `current_ip` varchar(16) DEFAULT NULL,
  `depth_idx` int(11) DEFAULT 0,
  `edit_reason` varchar(10) DEFAULT NULL,
  `insert_date` datetime DEFAULT NULL,
  `is_deleted` tinyint(1) DEFAULT 0,
  `is_fixed` tinyint(1) DEFAULT 0,
  `is_lock` tinyint(1) DEFAULT 0,
  `like_count` int(11) DEFAULT NULL,
  `order_idx` int(11) DEFAULT 0,
  `parents_id` int(11) DEFAULT NULL,
  `passwd` varchar(10) DEFAULT NULL,
  `report_count` int(11) DEFAULT NULL,
  `revision` varchar(10) DEFAULT NULL,
  `revision_action_type` varchar(20) DEFAULT NULL,
  `space_id` int(11) NOT NULL,
  `title` varchar(100) NOT NULL,
  `update_date` datetime DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  `user_nick` varchar(40) NOT NULL,
  `view_count` int(11) DEFAULT NULL,
  `wiki_url` varchar(100) DEFAULT NULL,
  `wiki_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`wiki_back_id`),
  KEY `FK2sk4w9dqc4v5wow8dt8b5gu4v` (`wiki_id`),
  CONSTRAINT `FK2sk4w9dqc4v5wow8dt8b5gu4v` FOREIGN KEY (`wiki_id`) REFERENCES `wiki` (`wiki_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 내보낼 데이터가 선택되어 있지 않습니다.


-- 뷰 ekkor.FILES_VIEW 구조 내보내기
-- 임시 테이블을 제거하고 최종 VIEW 구조를 생성
DROP TABLE IF EXISTS `FILES_VIEW`;
CREATE ALGORITHM=UNDEFINED DEFINER=`admin`@`%` SQL SECURITY DEFINER VIEW `FILES_VIEW` AS select `f`.`SEQ` AS `SEQ`,`f`.`EMAIL` AS `EMAIL`,`e`.`NAME` AS `NAME`,`f`.`SUBNAME` AS `SUBNAME`,`f`.`REALNAME` AS `REALNAME`,`f`.`REGTIME` AS `REGTIME` from (`FILES` `f` join `EMPLOYEE` `e`) where `f`.`EMAIL` = `e`.`EMAIL`;


-- 뷰 ekkor.PAY_VIEW 구조 내보내기
-- 임시 테이블을 제거하고 최종 VIEW 구조를 생성
DROP TABLE IF EXISTS `PAY_VIEW`;
CREATE ALGORITHM=UNDEFINED DEFINER=`admin`@`%` SQL SECURITY DEFINER VIEW `PAY_VIEW` AS select `s`.`SEQ` AS `SEQ`,`s`.`WRITER` AS `EMAIL`,`s`.`TITLE` AS `TITLE`,`s`.`contents` AS `contents`,`e`.`user_nick` AS `WRITER`,`s`.`pay_day` AS `PAY_DAY`,`s`.`pay_ot` AS `PAY_OT`,`s`.`pay_ottime` AS `PAY_OTTIME`,`s`.`pay_latetime` AS `PAY_LATETIME`,`s`.`pay_nighttime` AS `PAY_NIGHTTIME`,`s`.`STARTTIME` AS `STARTTIME`,`s`.`ENDTIME` AS `ENDTIME`,`s`.`REGTIME` AS `REGTIME`,`s`.`UPTIME` AS `UPTIME`,`s`.`ETC_YN` AS `ETCYN` from (`PAY` `s` join `user` `e`) where `s`.`WRITER` = `e`.`user_email`;


-- 뷰 ekkor.SCHEDULE_VIEW 구조 내보내기
-- 임시 테이블을 제거하고 최종 VIEW 구조를 생성
DROP TABLE IF EXISTS `SCHEDULE_VIEW`;
CREATE ALGORITHM=UNDEFINED DEFINER=`admin`@`%` SQL SECURITY DEFINER VIEW `SCHEDULE_VIEW` AS select `s`.`SEQ` AS `SEQ`,`s`.`WRITER` AS `EMAIL`,`e`.`NAME` AS `WRITER`,`s`.`TITLE` AS `TITLE`,`s`.`CONTENTS` AS `CONTENTS`,`s`.`ETC_YN` AS `ETCYN`,`s`.`STARTTIME` AS `STARTTIME`,`s`.`ENDTIME` AS `ENDTIME`,`s`.`REGTIME` AS `REGTIME`,`s`.`UPTIME` AS `UPTIME` from (`SCHEDULE` `s` join `EMPLOYEE` `e`) where `s`.`WRITER` = `e`.`EMAIL`;


-- 뷰 ekkor.USERARTICLE_VIEW 구조 내보내기
-- 임시 테이블을 제거하고 최종 VIEW 구조를 생성
DROP TABLE IF EXISTS `USERARTICLE_VIEW`;
CREATE ALGORITHM=UNDEFINED DEFINER=`admin`@`%` SQL SECURITY DEFINER VIEW `USERARTICLE_VIEW` AS select `a`.`SEQ` AS `SEQ`,`a`.`VIEW_YN` AS `VIEW_YN`,`a`.`WRITER` AS `WRITER`,`a`.`RECEIVER` AS `RECEIVER`,(select `s`.`NAME` from `EMPLOYEE` `s` where `a`.`RECEIVER` = `s`.`EMAIL`) AS `RECEIVERNAME`,`e`.`NAME` AS `NAME`,`a`.`TITLE` AS `TITLE`,`a`.`CONTENTS` AS `CONTENTS`,`a`.`REGTIME` AS `REGTIME`,`a`.`UPTIME` AS `UPTIME` from (`USERARTICLE` `a` join `EMPLOYEE` `e`) where `a`.`WRITER` = `e`.`EMAIL`;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
