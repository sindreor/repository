CREATE TABLE `calendar` (
  `cid` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  PRIMARY KEY (`cid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
CREATE TABLE `user` (
  `uid` int(11) NOT NULL AUTO_INCREMENT,
  `firstname` varchar(45) NOT NULL,
  `lastname` varchar(45) NOT NULL,
  `email` varchar(45) NOT NULL,
  `password` varchar(45) NOT NULL,
  `admin` tinyint(1) NOT NULL,
  `registered` timestamp(6) NULL DEFAULT NULL,
  `cid` int(11) NOT NULL,
  PRIMARY KEY (`uid`),
  KEY `cid_idx` (`cid`),
  CONSTRAINT `cid` FOREIGN KEY (`cid`) REFERENCES `calendar` (`cid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
CREATE TABLE `usergroup` (
  `gid` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `parent` int(11) NOT NULL,
  `boss` int(11) NOT NULL,
  `calendar` int(11) NOT NULL,
  `cid` int(11) NOT NULL,
  PRIMARY KEY (`gid`),
  KEY `boss_idx` (`boss`),
  KEY `cid_idx` (`cid`),
  KEY `calendar_idx` (`calendar`),
  KEY `parent_idx` (`parent`),
  CONSTRAINT `boss` FOREIGN KEY (`boss`) REFERENCES `user` (`uid`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `calendar` FOREIGN KEY (`calendar`) REFERENCES `calendar` (`cid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
CREATE TABLE `activity` (
  `aid` int(11) NOT NULL AUTO_INCREMENT,
  `calendar` int(11) NOT NULL,
  `description` text,
  `title` varchar(45) NOT NULL,
  `start` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `end` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`aid`),
  KEY `calendar_idx` (`calendar`),
  CONSTRAINT `calendar_reference` FOREIGN KEY (`calendar`) REFERENCES `calendar` (`cid`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
CREATE TABLE `room` (
  `rid` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `location` varchar(45) NOT NULL,
  PRIMARY KEY (`rid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
CREATE TABLE `meeting` (
  `mid` int(11) NOT NULL AUTO_INCREMENT,
  `rid` int(11) NOT NULL,
  `priority` int(11) NOT NULL,
  `cancelled` tinyint(1) NOT NULL,
  `aid` int(11) NOT NULL,
  PRIMARY KEY (`mid`),
  KEY `activity_relation_idx` (`aid`),
  KEY `room_relation_idx` (`rid`),
  CONSTRAINT `activity_relation` FOREIGN KEY (`aid`) REFERENCES `activity` (`aid`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `room_relation` FOREIGN KEY (`rid`) REFERENCES `room` (`rid`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
CREATE TABLE `participants` (
  `mid` int(11) NOT NULL,
  `uid` int(11) NOT NULL,
  `perticipates` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`mid`,`uid`),
  KEY `user_relation_idx` (`uid`),
  CONSTRAINT `meeting_relation` FOREIGN KEY (`mid`) REFERENCES `meeting` (`mid`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `user_relation` FOREIGN KEY (`uid`) REFERENCES `user` (`uid`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
CREATE TABLE `alert` (
  `alid` int(11) NOT NULL,
  `uid` int(11) NOT NULL,
  `aid` int(11) NOT NULL,
  `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `seen` tinyint(1) NOT NULL,
  PRIMARY KEY (`alid`),
  KEY `activity_relation_idx` (`aid`),
  KEY `user_relation_idx` (`uid`),
  CONSTRAINT `aboutactivity` FOREIGN KEY (`aid`) REFERENCES `activity` (`aid`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `touser` FOREIGN KEY (`uid`) REFERENCES `user` (`uid`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
