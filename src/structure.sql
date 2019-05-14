SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;


CREATE TABLE IF NOT EXISTS `deleted_words` (
  `dictionary` int(11) NOT NULL,
  `word_id` int(11) NOT NULL,
  `deleted_on` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `dictionaries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user` int(11) NOT NULL,
  `name` varchar(50) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'New',
  `specification` varchar(50) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'Dictionary',
  `description` text COLLATE utf8_unicode_ci NOT NULL COMMENT 'Markdown',
  `allow_duplicates` tinyint(1) NOT NULL DEFAULT '0',
  `case_sensitive` tinyint(1) NOT NULL DEFAULT '0',
  `sort_by_definition` tinyint(1) NOT NULL DEFAULT '0',
  `is_complete` tinyint(1) NOT NULL DEFAULT '0',
  `is_public` tinyint(1) NOT NULL DEFAULT '0',
  `last_updated` int(11) DEFAULT NULL,
  `created_on` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=500 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
DELIMITER $$
CREATE TRIGGER IF NOT EXISTS `delete_dictionary_parts` AFTER DELETE ON `dictionaries` FOR EACH ROW BEGIN
	DELETE FROM words WHERE words.dictionary=old.id;
	DELETE FROM dictionary_linguistics WHERE dictionary_linguistics.dictionary=old.id;
	DELETE FROM deleted_words WHERE deleted_words.dictionary=old.id;
END
$$
DELIMITER ;

CREATE TABLE IF NOT EXISTS `dictionary_linguistics` (
  `dictionary` int(11) NOT NULL,
  `parts_of_speech` text NOT NULL COMMENT 'JSON array',
  `consonants` text NOT NULL COMMENT 'JSON array',
  `vowels` text NOT NULL COMMENT 'JSON array',
  `blends` text NOT NULL COMMENT 'JSON array',
  `onset` text NOT NULL COMMENT 'JSON array',
  `nucleus` text NOT NULL COMMENT 'JSON array',
  `coda` text NOT NULL COMMENT 'JSON array',
  `exceptions` text NOT NULL COMMENT 'Markdown',
  `orthography_notes` text NOT NULL COMMENT 'Markdown',
  `grammar_notes` text NOT NULL COMMENT 'Markdown',
  UNIQUE KEY `dictionary` (`dictionary`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `memberships` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user` int(11) NOT NULL,
  `start_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `expire_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `old_password` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `password` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `public_name` varchar(50) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'Someone',
  `current_dictionary` int(11) DEFAULT NULL,
  `allow_email` tinyint(1) NOT NULL DEFAULT '1',
  `last_login` int(11) DEFAULT NULL,
  `password_reset_code` varchar(20) COLLATE utf8_unicode_ci DEFAULT NULL,
  `password_reset_date` int(11) DEFAULT NULL,
  `created_on` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=MyISAM AUTO_INCREMENT=184 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
DELIMITER $$
CREATE TRIGGER IF NOT EXISTS `Delete_User_Dictionaries` AFTER DELETE ON `users` FOR EACH ROW DELETE FROM dictionaries WHERE dictionaries.user = old.id
$$
DELIMITER ;

CREATE TABLE IF NOT EXISTS `words` (
  `dictionary` int(11) NOT NULL,
  `word_id` int(11) NOT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `pronunciation` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `part_of_speech` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `definition` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `details` text COLLATE utf8_unicode_ci NOT NULL COMMENT 'Markdown',
  `last_updated` int(11) DEFAULT NULL,
  `created_on` int(11) NOT NULL,
  UNIQUE KEY `unique_index` (`dictionary`,`word_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;