#!/usr/bin/env ksh

# setup
cd "$(dirname $(readlink -f $(which $0)))/test"
mkdir -p ./logs/
rm -f logs/*
numb_lines="$(cat expected_logs/* | wc -l)"

CONFIG_FILE=./config ../vclod_do_dir ./vclod_dir/
ret=$? # run the primary test
[ -t 1 ] && echo "

syslog output to visually confirm it is getting populated (should be a copy of the above output -- also automatically checked):
" && sudo tail /var/log/messages -n"$numb_lines"

# tests off the previous run
diff -w <(ls -1 expected_logs/ | sed 's/.expected//' | sort) <(ls -1 logs/ | sed -r 's/\.[^.]+\.log$//' | sort)
ret="$((ret + $?))" # test that there are the right number and names for the files
for f in expected_logs/*.expected ; do diff -w $f <(sed -r 's/^[^[]+[[]/[/' logs/$(basename ${f%expected})[0-9]*) ; done
ret="$((ret + $?))" # test that each file has the right content
diff -w <(cat expected_logs/* | sort) <(sudo tail /var/log/messages -n"$numb_lines" | sed -r 's/^[^[]+[[]/[/' | sort)
ret="$((ret + $?))" # test syslog data is accurate
diff -w <(cat logs/* | sed -r 's/^[0-9]{4}\-[0-9]{2}\-//;s/[]].*/]/' | sort) <(sudo tail /var/log/messages -n"$numb_lines" | awk '{print $2" "$3" "$6" "$7}' | sort)
ret="$((ret + $?))" # test syslog timing and pid are accurate

CONFIG_FILE=./config ../vclod_do_dir ./test_single_file.diff.sh
ret="$((ret + $?))" # A single file should runable without needing to run the whole directory

CONFIG_FILE=./sh_only/config ../vclod_do_dir ./sh_only/
ret="$((ret + $?))" # The mysql connection settings are not required when they arent needed

exit $ret
