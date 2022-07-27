cat << 'STMT'
#batch 2
#start INSERT INTO my_table1 (id, field1, field2)
#start VALUES
(1,'funny','man')
(2,'silly','baby')
(3,'pretty','woman')
#RESET
#start INSERT INTO my_table2 (id, field1, field2) VALUES
#end ON DUPLICATE KEY UPDATE field1=VALUES(field1), field2=VALUES(field2);
(1,'funny','man')
(2,'silly','baby')
(3,'pretty','woman')
#RESET
DELETE FROM my_local_table WHERE id < 123456;
SELECT 'numb_rows_added_and_deleted', ROW_COUNT();
#RESET
#start INSERT INTO my_table3 (id, field1, field2) VALUES
#del_start DELETE FROM my_table4 WHERE id IN (
1 (1,'funny','man')
2 (2,'silly','baby')
3 (3,'pretty','woman')
STMT
