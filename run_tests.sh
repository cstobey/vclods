#!/usr/bin/env ksh

cd "$(dirname $(readlink -f $(which $0)))/test"
mkdir -p ./logs/
rm -f logs/*
CONFIG_FILE=./config ../vclod_do_dir ./vclod_dir/ && \
  diff <(ls -1 expected_logs/ | sed 's/.expected//') <(ls -1 logs/ | sed -r 's/\.[^.]+\.log$//') && \
  for f in expected_logs/*.expected ; do diff $f <(sed -r 's/^[^[]+[[]/[/' logs/$(basename ${f%expected})*) ; done && \
  rm logs/*
ret=$?
[ -t 1 ] && echo "

syslog output to visually confirm it is getting populated (should be a copy of the above output -- also automatically checked):
" && sudo tail /var/log/messages -n"$(cat expected_logs/* | wc -l)"
diff <(cat expected_logs/* | sort) <(sudo tail /var/log/messages -n"$(cat expected_logs/* | wc -l)" | sed -r 's/^[^[]+[[]/[/' | sort)
CONFIG_FILE=./sh_only/config ../vclod_do_dir ./sh_only/
CONFIG_FILE=./config ../vclod_do_dir ./test_single_file.diff.sh
exit $((ret + $?))
