#!/usr/bin/env ksh

cd "$(dirname $(readlink -f $(which $0)))/test"
mkdir -p ./logs/
rm -f logs/*
CONFIG_FILE=./config ../vclod_do_dir ./vclod_dir/ && \
  diff -w <(ls -1 expected_logs/ | sed 's/.expected//' | sort) <(ls -1 logs/ | sed -r 's/\.[^.]+\.log$//' | sort) && \
  for f in expected_logs/*.expected ; do diff -w $f <(sed -r 's/^[^[]+[[]/[/' logs/$(basename ${f%expected})[0-9]*) ; done && \
  rm logs/*
ret=$?
[ -t 1 ] && echo "

syslog output to visually confirm it is getting populated (should be a copy of the above output -- also automatically checked):
" && sudo tail /var/log/messages -n"$(cat expected_logs/* | wc -l)"

# syslog should have all the expected data in it.
diff -w <(cat expected_logs/* | sort) <(sudo tail /var/log/messages -n"$(cat expected_logs/* | wc -l)" | sed -r 's/^[^[]+[[]/[/' | sort)
ret="$((ret + $?))"

# The mysql connection settings are not required when they arent needed
CONFIG_FILE=./sh_only/config ../vclod_do_dir ./sh_only/
ret="$((ret + $?))"

# A single file should runable without needing to run the whole directory
CONFIG_FILE=./config ../vclod_do_dir ./test_single_file.diff.sh
ret="$((ret + $?))"

exit $ret
