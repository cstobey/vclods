cat << 'STMT' | vclod_operation b.dst.sql
SELECT CONCAT('SELECT', QUOTE('test inside operation'), ';');
STMT
