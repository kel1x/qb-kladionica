CREATE TABLE IF NOT EXISTS `qb-kladionica` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tim1` tinytext NOT NULL,
  `tim2` tinytext NOT NULL,
  `kec` tinytext NOT NULL,
  `x` tinytext NOT NULL,
  `dvojka` tinytext NOT NULL,
  `status` longtext DEFAULT 'Nije Pocelo',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `qb-kladjenja` (
  `igrac` varchar(255) NOT NULL DEFAULT '',
  `imeigraca` longtext DEFAULT NULL,
  `x12` longtext DEFAULT NULL,
  `tekma` int(11) unsigned NOT NULL,
  `ulog` int(11) NOT NULL,
  KEY `tekma` (`tekma`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
