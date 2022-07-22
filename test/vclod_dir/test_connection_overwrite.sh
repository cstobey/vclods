export _HOST=nonexistent _DB=funny _USER=dont_trust_this_guy _PASSWORD=totally_insecure
SRC="$(vclod_connection _)"
literate_source "$SRC"
echo "SELECT doesnt matter" | vclod_operation this_should_fail.sql
