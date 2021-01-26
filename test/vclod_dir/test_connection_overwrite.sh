SRC=`_HOST=nonexistent _DB=funny _USER=dont_trust_this_guy _PASSWORD=totally_insecure vclod_connection _`
echo $SRC
echo "SELECT doesnt matter" | vclod_operation a.sql
