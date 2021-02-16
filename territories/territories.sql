
CREATE TABLE IF NOT EXISTS `territories` (
  `zone` varchar(50) NOT NULL,
  `control` varchar(50) NOT NULL,
  `influence` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `territories` (`zone`, `control`, `influence`) VALUES
	('Davis', 'police', 100),
	('East V', 'police', 100),
	('ChamberlainHills', 'police', 100),
	('Rancho', 'police', 100);

