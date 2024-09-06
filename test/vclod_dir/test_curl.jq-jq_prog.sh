sleep 1
vcurl_run "$TEST_WEBHOST/page_1.json"

from_total()
{
  [ "$VCURL_LOOP_COUNTER" -lt "$(JQ_EXT_PROG='.total' vclod_operation get_total.jq <"$VCURL_LAST_OUTPUT")" ] && echo "$TEST_WEBHOST/cgi-bin/query?cnt=$((VCURL_LOOP_COUNTER+1))&funny=man"
}
vcurl_while from_total

next_page()
{
  JQ_EXT_OPT='-r' JQ_EXT_PROG='.next' vclod_operation get_next_url.jq <"$VCURL_LAST_OUTPUT" 2>/dev/null | sed 's/^null$//'
}
vcurl_while next_page "$TEST_WEBHOST/next_page_1.json" '-H"X-Custom-Header: test_space_in_arg"'

cat << EOF | vcurl_multi_run
$TEST_WEBHOST/page_1.json
$TEST_WEBHOST/page_2.json
EOF

echo 'test=post&silly=woman' | vcurl_run "$TEST_WEBHOST/cgi-bin/query" -d @-
vcurl_run "$TEST_WEBHOST/cgi-bin/query" -d 'test=argument' -d'silly=woman'
#echo >&2 "files in script: $VCURL_LAST_FULL_OUT, $VCURL_LAST_ERROR, $VCURL_LAST_HEADER, $VCURL_LAST_OUTPUT"
#echo >&2 "[INFO] $(grep -n ^$ "$VCURL_LAST_FULL_OUT")"
#echo >&2 [INFO] all
#sed 's/^/[INFO] /' $VCURL_LAST_FULL_OUT >&2
#echo >&2 [INFO] headers
#cat $VCURL_LAST_HEADER >&2
#echo >&2 [INFO] errors
#cat $VCURL_LAST_ERROR >&2
#echo >&2 [INFO] output
#cat $VCURL_LAST_OUTPUT >&2
