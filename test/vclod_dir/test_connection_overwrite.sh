export SQL_EXT_ENVSUBST=0
echo 'SELECT "some$var$type$strings"' | vclod_operation should_pass_through.sql
export _HOST=nonexistent _DB=funny _USER=dont_trust_this_guy _PASSWORD=totally_insecure SRC=_
for i in HOST DB USER PASSWORD ; do echo "$i: $(vclod_conn_arg "$SRC" "mysql" "$i")" ; done
echo "SELECT doesnt matter" | vclod_operation this_should_fail.sql
export SQL_EXT_IGNORE_NO_CONNECT=1
echo "SELECT doesnt matter" | vclod_operation this_should_fail_silently.sql
