cat << 'STMT' | vclod_operation b.dst.sql
SELECT CONCAT('SELECT', QUOTE('this should fail with an error'), ';');
STMT
