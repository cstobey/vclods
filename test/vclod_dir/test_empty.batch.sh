cat << 'EOF'
#start INSERT INTO a_table (id, a_column, b_column, c_colunm) VALUES 
#end ON DUPLICATE KEY UPDATE a_column = VALUES(a_column), b_column = VALUES(b_column), c_colunm = VALUES(c_colunm);
#because RESET was showing the end when the list was empty. 
#RESET
this should be the only line
EOF
