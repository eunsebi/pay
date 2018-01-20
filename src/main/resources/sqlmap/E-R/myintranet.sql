-- ----------------------------------------------------------------------------
-- MySQL Workbench Migration
-- Migrated Schemata: myintranet
-- Source Schemata: myintranet
-- Created: Thu Jan 11 10:12:18 2018
-- Workbench Version: 6.3.4
-- ----------------------------------------------------------------------------

SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------------------------------------------------------
-- Schema myintranet
-- ----------------------------------------------------------------------------
DROP SCHEMA IF EXISTS `myintranet` ;
CREATE SCHEMA IF NOT EXISTS `myintranet` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;

-- ----------------------------------------------------------------------------
-- Table myintranet.COMPANY
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `myintranet`.`COMPANY` (
  `SEQ` INT NOT NULL AUTO_INCREMENT COMMENT '',
  `NAME` VARCHAR(50) NOT NULL DEFAULT 'noname' COMMENT '',
  `ADDRESS` VARCHAR(200) NOT NULL DEFAULT 'noaddress' COMMENT '',
  `PHONE` VARCHAR(15) NOT NULL DEFAULT '000-0000-0000' COMMENT '',
  `EMAIL` VARCHAR(255) NOT NULL COMMENT '',
  `REGTIME` DATETIME NULL COMMENT '',
  PRIMARY KEY (`SEQ`)  COMMENT '')
ENGINE = InnoDB;

-- ----------------------------------------------------------------------------
-- Table myintranet.DEPARTMENT
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `myintranet`.`DEPARTMENT` (
  `SEQ` INT NOT NULL AUTO_INCREMENT COMMENT '',
  `COMPANY` INT NOT NULL COMMENT '',
  `NAME` VARCHAR(50) NOT NULL DEFAULT 'name' COMMENT '',
  `PHONE` VARCHAR(15) NOT NULL COMMENT '',
  `EMAIL` VARCHAR(255) NOT NULL COMMENT '',
  `REGTIME` DATETIME NULL COMMENT '',
  INDEX `fk_DEPARTMENT_COMPANY_idx` (`COMPANY` ASC)  COMMENT '',
  PRIMARY KEY (`SEQ`)  COMMENT '',
  CONSTRAINT `fk_DEPARTMENT_COMPANY`
    FOREIGN KEY (`COMPANY`)
    REFERENCES `myintranet`.`COMPANY` (`SEQ`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- ----------------------------------------------------------------------------
-- Table myintranet.EMPLOYEE
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `myintranet`.`EMPLOYEE` (
  `EMAIL` VARCHAR(255) NOT NULL COMMENT '',
  `NAME` VARCHAR(45) NOT NULL COMMENT '',
  `LEVEL` INT NOT NULL COMMENT '',
  `PHONE` VARCHAR(255) NOT NULL COMMENT '',
  `PASSWD` VARCHAR(255) NOT NULL COMMENT '',
  `REGTIME` DATETIME NOT NULL COMMENT '',
  PRIMARY KEY (`EMAIL`)  COMMENT '')
ENGINE = InnoDB;

-- ----------------------------------------------------------------------------
-- Table myintranet.USERARTICLE
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `myintranet`.`USERARTICLE` (
  `SEQ` INT NOT NULL AUTO_INCREMENT COMMENT '',
  `WRITER` VARCHAR(255) NOT NULL COMMENT '',
  `RECEIVER` VARCHAR(255) NOT NULL COMMENT '',
  `VIEW_YN` CHAR NOT NULL DEFAULT 'N' COMMENT '',
  `TITLE` VARCHAR(255) NOT NULL COMMENT '',
  `CONTENTS` TEXT NOT NULL COMMENT '',
  `REGTIME` DATETIME NOT NULL COMMENT '',
  `UPTIME` DATETIME NOT NULL COMMENT '',
  PRIMARY KEY (`SEQ`)  COMMENT '',
  INDEX `fk_USERARTICLE_EMPLOYEE1_idx` (`WRITER` ASC)  COMMENT '',
  CONSTRAINT `fk_USERARTICLE_EMPLOYEE1`
    FOREIGN KEY (`WRITER`)
    REFERENCES `myintranet`.`EMPLOYEE` (`EMAIL`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- ----------------------------------------------------------------------------
-- Table myintranet.SCHEDULE
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `myintranet`.`SCHEDULE` (
  `SEQ` INT NOT NULL AUTO_INCREMENT COMMENT '',
  `WRITER` VARCHAR(255) NOT NULL COMMENT '',
  `TITLE` VARCHAR(255) NOT NULL COMMENT '',
  `CONTENTS` MEDIUMTEXT NOT NULL COMMENT '',
  `STARTTIME` DATETIME NOT NULL COMMENT '',
  `ENDTIME` DATETIME NOT NULL COMMENT '',
  `REGTIME` DATETIME NOT NULL COMMENT '',
  `UPTIME` DATETIME NOT NULL COMMENT '',
  `ETC_YN` CHAR NOT NULL DEFAULT 'Y' COMMENT '',
  INDEX `fk_SCHEDULE_EMPLOYEE1_idx` (`WRITER` ASC)  COMMENT '',
  PRIMARY KEY (`SEQ`)  COMMENT '',
  CONSTRAINT `fk_SCHEDULE_EMPLOYEE1`
    FOREIGN KEY (`WRITER`)
    REFERENCES `myintranet`.`EMPLOYEE` (`EMAIL`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- ----------------------------------------------------------------------------
-- Table myintranet.FILES
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `myintranet`.`FILES` (
  `SEQ` INT NOT NULL AUTO_INCREMENT COMMENT '',
  `EMAIL` VARCHAR(255) NOT NULL COMMENT '',
  `SUBNAME` VARCHAR(255) NOT NULL COMMENT '',
  `REALNAME` VARCHAR(255) NOT NULL COMMENT '',
  `REGTIME` VARCHAR(45) NOT NULL COMMENT '',
  INDEX `fk_FILES_EMPLOYEE1_idx` (`EMAIL` ASC)  COMMENT '',
  PRIMARY KEY (`SEQ`)  COMMENT '',
  CONSTRAINT `fk_FILES_EMPLOYEE1`
    FOREIGN KEY (`EMAIL`)
    REFERENCES `myintranet`.`EMPLOYEE` (`EMAIL`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- ----------------------------------------------------------------------------
-- Table myintranet.USER_FILES
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `myintranet`.`USER_FILES` (
  `SEQ` INT NOT NULL AUTO_INCREMENT COMMENT '',
  `USERARTICLE_SEQ` INT NOT NULL COMMENT '',
  `SUBNAME` VARCHAR(255) NOT NULL COMMENT '',
  `REALNAME` VARCHAR(255) NOT NULL COMMENT '',
  `REGTIME` DATETIME NOT NULL COMMENT '',
  INDEX `fk_table1_USERARTICLE1_idx` (`USERARTICLE_SEQ` ASC)  COMMENT '',
  PRIMARY KEY (`SEQ`)  COMMENT '',
  CONSTRAINT `fk_table1_USERARTICLE1`
    FOREIGN KEY (`USERARTICLE_SEQ`)
    REFERENCES `myintranet`.`USERARTICLE` (`SEQ`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- ----------------------------------------------------------------------------
-- Table myintranet.SCHEDULE_FILES
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `myintranet`.`SCHEDULE_FILES` (
  `SEQ` INT NOT NULL AUTO_INCREMENT COMMENT '',
  `SCHEDULE_SEQ` INT NOT NULL COMMENT '',
  `SUBNAME` VARCHAR(255) NOT NULL COMMENT '',
  `REALNAME` VARCHAR(255) NOT NULL COMMENT '',
  `REGTIME` DATETIME NOT NULL COMMENT '',
  PRIMARY KEY (`SEQ`)  COMMENT '',
  INDEX `fk_SCHEDULE_FILES_SCHEDULE1_idx` (`SCHEDULE_SEQ` ASC)  COMMENT '',
  CONSTRAINT `fk_SCHEDULE_FILES_SCHEDULE1`
    FOREIGN KEY (`SCHEDULE_SEQ`)
    REFERENCES `myintranet`.`SCHEDULE` (`SEQ`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- ----------------------------------------------------------------------------
-- View myintranet.SCHEDULE_VIEW
-- ----------------------------------------------------------------------------
USE `myintranet`;
CREATE  OR REPLACE VIEW `SCHEDULE_VIEW` AS
SELECT
			s.SEQ as SEQ,
			s.WRITER as EMAIL,
			e.NAME as WRITER,
			s.TITLE as TITLE,
			s.CONTENTS as CONTENTS,
			s.ETC_YN as ETCYN,
			s.STARTTIME as STARTTIME,
			s.ENDTIME as ENDTIME,
			s.REGTIME as REGTIME,
			s.UPTIME as UPTIME
		FROM SCHEDULE s, EMPLOYEE e
		WHERE s.WRITER = e.EMAIL
;

-- ----------------------------------------------------------------------------
-- View myintranet.FILES_VIEW
-- ----------------------------------------------------------------------------
USE `myintranet`;
CREATE  OR REPLACE VIEW `FILES_VIEW` AS
SELECT
			f.SEQ as SEQ,
			f.EMAIL as EMAIL,
			e.NAME as NAME,
			f.SUBNAME as SUBNAME,
			f.REALNAME as REALNAME,
			f.REGTIME as REGTIME
		FROM FILES f, EMPLOYEE e
		WHERE f.EMAIL = e.EMAIL
;

-- ----------------------------------------------------------------------------
-- View myintranet.USERARTICLE_VIEW
-- ----------------------------------------------------------------------------
USE `myintranet`;
CREATE  OR REPLACE VIEW `USERARTICLE_VIEW` AS
SELECT
	a.SEQ as SEQ,
	a.VIEW_YN as VIEW_YN,
	a.WRITER as WRITER,
	a.RECEIVER as RECEIVER,
	(SELECT NAME FROM EMPLOYEE s WHERE a.RECEIVER = s.EMAIL) as RECEIVERNAME,
	e.NAME as NAME,
	a.TITLE as TITLE,
	a.CONTENTS as CONTENTS,
	a.REGTIME as REGTIME,
	a.UPTIME as UPTIME
FROM USERARTICLE a, EMPLOYEE e
WHERE a.WRITER = e.EMAIL;
SET FOREIGN_KEY_CHECKS = 1;
