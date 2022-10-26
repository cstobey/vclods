export SRC=LOG_SQL_
cat - ../pp_log2sql_table.sql << 'STMT' | vclod_operation setup_test_pp_db.sql
DROP VIEW IF EXISTS script_log;
DROP TABLE IF EXISTS log_line, log_message, log_file, log_tag;
STMT
