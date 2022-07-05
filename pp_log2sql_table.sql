CREATE TABLE log_tag (
  log_tag_id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(50) NOT NULL UNIQUE
) ENGINE=InnoDB;
CREATE TABLE log_file (
  log_file_id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(1024) NOT NULL UNIQUE
) ENGINE=InnoDB;
CREATE TABLE log_message (
  log_message_id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(4096) NOT NULL,
  UNIQUE KEY name (name(1000))
) ENGINE=InnoDB;
CREATE TABLE log_line (
  log_line_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  log_tag_id INT UNSIGNED NOT NULL,
  log_file_id INT UNSIGNED NOT NULL,
  log_message_id INT UNSIGNED NOT NULL,
  pid INT UNSIGNED NOT NULL,
  value INT UNSIGNED NULL DEFAULT NULL,
  happened_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP(),
  KEY (happened_at),
  KEY (value),
  CONSTRAINT sl_st_fk FOREIGN KEY (log_tag_id) REFERENCES log_tag (log_tag_id) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT sl_lf_fk FOREIGN KEY (log_file_id) REFERENCES log_file (log_file_id) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT sl_lm_fk FOREIGN KEY (log_message_id) REFERENCES log_message (log_message_id) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB;
CREATE VIEW script_log AS 
  SELECT lf.name AS log_file, ll.log_line_id AS script_log_id, ll.happened_at, ll.pid, lt.name AS tag, lm.name AS message, value 
  FROM log_line AS ll 
  JOIN log_tag AS lt USING (log_tag_id) 
  JOIN log_message AS lm USING (log_message_id)
  JOIN log_file AS lf USING (log_file_id)
