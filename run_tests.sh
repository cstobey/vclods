#!/bin/ksh

# setup
export DEBUG_SHOULD_TIME_IT=0 # in case this is being run from the terminal
export LOCAL_DIR="$(dirname $(readlink -f $(which $0)))/test"
cd "${LOCAL_DIR}"
mkdir -p ./logs/ ./files/ ./tmp_files/
rm -f logs/* files/* tmp_files/*
numb_lines="$(cat expected_logs/* | wc -l)"

# allows you to run one test and see the output.. helpful for dev...
# NOTE: you need to specify the test in relation to the test/ directory.
if [ ! -z "$1" ] ; then
  CONFIG_FILE="${LOCAL_DIR}/config" ../vclod_do_dir "${LOCAL_DIR}/$1"
  exit $?
fi

rm -f ./vclod_dir/test_symlink.sh
ln -s $(pwd)/vclod_dir/test{,_symlink}.sh
CONFIG_FILE="${LOCAL_DIR}/config" ../vclod_do_dir ./vclod_dir/
ret=$? # run the primary test
rm -f ./vclod_dir/test_symlink.sh
wait ; sleep 2 ; sync # really make sure the logs have been written
# [ -t 1 ] && echo "
#
# syslog output to visually confirm it is getting populated (should be a copy of the above output -- also automatically checked):
# " && sudo tail /var/log/messages -n"$numb_lines" && echo "Start Test verification output"

# tests off the previous run
[ -z "$DEBUG_WHERE" ] || echo "[WHERE] log file check"
diff -w <(ls -1 expected_logs/ | sed 's/.expected//' | sort) <(ls -1 logs/ | grep '.log$' | sed -r 's/\.[0-9]+\.log$//' | sort) || { ret="$((ret + $?))"; echo "FAILED to render the right log files" >&2 ; }
[ -z "$DEBUG_WHERE" ] || echo "[WHERE] log file content check"
for f in expected_logs/*.expected ; do diff -w <(cat $f | sort) <(sed -r 's/^[^[]+[[]/[/' logs/$(basename ${f%expected})[0-9]*.log | sort) || { ret="$((ret + $?))" ; echo "FAILED $f content mismatch" >&2 ; } ; done
# test the outfiles... cant test the append, since they put date parts on the ends of the filenames... need to think more about that.
for f in files/* ; do cp $f tmp_files/$(basename ${f/-$(date +%F)/}) ; done
for f in $(ls -1 logs/*.g-* | egrep '[.]g-[^.]*$') ; do cp $f tmp_files/$(basename ${f} | sed -r 's/\.[0-9]+\.log//') ; done
[ -z "$DEBUG_WHERE" ] || echo "[WHERE] diff files"
diff -wr expected_files tmp_files || { ret="$((ret + $?))" ; echo "FAILED to render the right output files with the right content" >&2 ; }

[ -z "$DEBUG_WHERE" ] || echo "[WHERE] untested extentions"
diff <(ls -1 vclod_dir/ | egrep -o '[.][^.-]+' | sed 's/^.//' | sort | uniq) <(ls -1 ../extensions/) || { ret="$((ret + $?))" ; echo "UNTESTED EXTENTIONS" >&2 ; }

# the specific one didnt work because of whitespace... and comm cant ignore whitespace... consider adding tr?
[ -z "$DEBUG_WHERE" ] || echo "[WHERE] syslog data check"
comm -23 <(cat expected_logs/* | sort) <(sudo tail /var/log/messages -n"$(($numb_lines*5))" | sed -r 's/^[^[]+[[]/[/' | sort) || { ret="$((ret + $?))" ; echo "FAILED syslog data mismatch" >&2 ; }
[ -z "$DEBUG_WHERE" ] || echo "[WHERE] syslog timing check"
comm -23 <(cat logs/* | grep '.log$' | sed -r 's/^[0-9]{4}\-[0-9]{2}\-[0-9]{2} //;s/[]].*/]/' | sort) <(sudo tail /var/log/messages -n"$(($numb_lines*5))" | awk '{print $3" "$6" "$7}' | sort) || { ret="$((ret + $?))" ; echo "FAILED syslog timing and pid mismatch" >&2 ; }

# this was too spammy on active servers... used the above
#diff -w <(cat expected_logs/* | sort) <(sudo tail /var/log/messages -n"$numb_lines" | sed -r 's/^[^[]+[[]/[/' | sort) || { echo "FAILED syslog data mismatch" >&2 ; ret="$((ret + $?))" ; }
#diff -w <(cat logs/* | sed -r 's/^[0-9]{4}\-[0-9]{2}\-[0-9]{2} //;s/[]].*/]/' | sort) <(sudo tail /var/log/messages -n"$numb_lines" | awk '{print $3" "$6" "$7}' | sort) || { echo "FAILED syslog timing and pid mismatch" >&2 ; ret="$((ret + $?))" ; }

[ -z "$DEBUG_WHERE" ] || echo "[WHERE] test_single_file"
CONFIG_FILE="${LOCAL_DIR}/config" ../vclod_do_dir ./test_single_file.diff.sh || { ret="$((ret + $?))" ; echo "FAILED single file should render without the directory $ret" ; }
[ -z "$DEBUG_WHERE" ] || echo "[WHERE] sh_only"
CONFIG_FILE="${LOCAL_DIR}/sh_only/config" ../vclod_do_dir ./sh_only/ || { ret="$((ret + $?))" ; echo "FAILED mysql should not be required when not used $ret" ; }

exit $ret
