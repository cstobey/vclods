DROP TABLE IF EXISTS script_logs;
CREATE TABLE script_logs (
  scrpit_logs_id int(11) NOT NULL AUTO_INCREMENT,
  datetime datetime NOT NULL,
  pid int(11) NOT NULL,
  tag varchar(50) NOT NULL,
  log_file varchar(255) NOT NULL,
  message varchar(255) DEFAULT NULL,
  variable varchar(255) DEFAULT NULL,
  value int(11) DEFAULT NULL,
  PRIMARY KEY (scrpit_logs_id),
  KEY date_pid (datetime,pid),
  KEY variable (variable),
  KEY tag_date (tag,datetime)
) ENGINE=InnoDB;
