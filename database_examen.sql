-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               5.7.33 - MySQL Community Server (GPL)
-- Server OS:                    Win64
-- HeidiSQL Version:             11.2.0.6213
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Dumping database structure for prueba
CREATE DATABASE IF NOT EXISTS `prueba` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `prueba`;

-- Dumping structure for procedure prueba.deleteuser
DELIMITER //
CREATE PROCEDURE `deleteuser`(
	IN `_username` VARCHAR(50)
)
BEGIN
DELETE FROM users WHERE username=_username;
END//
DELIMITER ;

-- Dumping structure for procedure prueba.edit
DELIMITER //
CREATE PROCEDURE `edit`(
	IN `_name` VARCHAR(50),
	IN `_id` INT
)
BEGIN
UPDATE users SET name = _name WHERE id = _id;
END//
DELIMITER ;

-- Dumping structure for procedure prueba.login
DELIMITER //
CREATE PROCEDURE `login`(
	IN `_username` VARCHAR(50),
	IN `_Key` VARCHAR(50)
)
BEGIN
SELECT id, username, CAST(AES_DECRYPT(password, _Key) AS CHAR), name
FROM users WHERE username = _username;
END//
DELIMITER ;

-- Dumping structure for procedure prueba.registros
DELIMITER //
CREATE PROCEDURE `registros`()
BEGIN
	SELECT username, name FROM users;
END//
DELIMITER ;

-- Dumping structure for procedure prueba.signup
DELIMITER //
CREATE PROCEDURE `signup`(
	IN `_username` VARCHAR(50),
	IN `_password` VARCHAR(50),
	IN `_Key` VARCHAR(50)
)
BEGIN
INSERT INTO	users (USERNAME, PASSWORD) VALUES (_username, AES_ENCRYPT(_password,_Key));
END//
DELIMITER ;

-- Dumping structure for table prueba.users
CREATE TABLE IF NOT EXISTS `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `password` blob NOT NULL,
  `name` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=latin1;

-- Data exporting was unselected.

-- Dumping structure for procedure prueba.validateuser
DELIMITER //
CREATE PROCEDURE `validateuser`(
	IN `_username` VARCHAR(50)
)
BEGIN
SELECT username FROM users WHERE username = _username;
END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
