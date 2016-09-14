#!/usr/bin/env ksh

cd "$(dirname $(readlink -f $(which $0)))"
mkdir -p ./logs/
rm -f logs/*
CONFIG_FILE=./config ../vclod_do_dir vclod_dir && \
  diff <(ls -1 expected_logs/ | sed 's/.expected//') <(ls -1 logs/ | sed -r 's/\.[^.]+\.log$//') && \
  for f in expected_logs/*.expected ; do diff $f <(sed -r 's/^[^[]+[[]/[/' logs/$(basename ${f%expected})*) ; done && \
  rm logs/*
ret=$?
[ -t 1 ] && echo && echo && echo "syslog output to visually confirm it is getting populated (should be a copy of the above output):" && echo && sudo tail /var/log/messages -n"$(cat expected_logs/* | wc -l)"
exit $ret
