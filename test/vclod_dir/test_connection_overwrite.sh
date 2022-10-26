export _HOST=nonexistent _DB=funny _USER=dont_trust_this_guy _PASSWORD=totally_insecure SRC=_
for i in HOST DB USER PASSWORD ; do echo "$i: $(vclod_conn_arg "$SRC" "mysql" "$i")" ; done
echo "SELECT doesnt matter" | vclod_operation this_should_fail.sql
