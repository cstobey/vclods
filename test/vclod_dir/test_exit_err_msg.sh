echo '{"a": "selected key", "b": [2,3], "c": "please ignore",}' | VCLOD_EXIT_ERR="I want to see this" vclod_operation sub_g_check.g-jq-jq_prog
echo 'echo false | vclod_operation inner.sh' | VCLOD_EXIT_ERR="outer should not override inner" vclod_operation outer.sh
