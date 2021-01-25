#!/bin/ksh

# in case this is being run from the terminal
set -a
DEBUG_SHOULD_TIME_IT=0
set +a

# setup
LOCAL_DIR="$(dirname $(readlink -f $(which $0)))/test"
cd "${LOCAL_DIR}"
mkdir -p ./logs/
rm -f logs/*
numb_lines="$(cat expected_logs/* | wc -l)"

rm -f ./vclod_dir/test_symlink.sh
ln -s $(pwd)/vclod_dir/test{,_symlink}.sh
CONFIG_FILE="${LOCAL_DIR}/config" ../vclod_do_dir ./vclod_dir/
ret=$? # run the primary test
rm -f ./vclod_dir/test_symlink.sh
wait ; sleep 2 # really make sure the logs have been written
# [ -t 1 ] && echo "
#
# syslog output to visually confirm it is getting populated (should be a copy of the above output -- also automatically checked):
# " && sudo tail /var/log/messages -n"$numb_lines" && echo "Start Test verification output"

# tests off the previous run
diff -w <(ls -1 expected_logs/ | sed 's/.expected//' | sort) <(ls -1 logs/ | sed -r 's/\.[^.]+\.log$//' | sort) || { echo "FAILED to render the right log files" >&2 ; ret="$((ret + $?))" ; }
for f in expected_logs/*.expected ; do diff -w $f <(sed -r 's/^[^[]+[[]/[/' logs/$(basename ${f%expected})[0-9]*) || { echo "FAILED $f content mismatch" >&2 ; ret="$((ret + $?))" ; } ; done

# the specific one didnt work because of whitespace... and comm cant ignore whitespace... consider adding tr?
comm -23 <(cat expected_logs/* | sort) <(sudo tail /var/log/messages -n"$(($numb_lines*5))" | sed -r 's/^[^[]+[[]/[/' | sort) || { echo "FAILED syslog data mismatch" >&2 ; ret="$((ret + $?))" ; }
comm -23 <(cat logs/* | sed -r 's/^[0-9]{4}\-[0-9]{2}\-[0-9]{2} //;s/[]].*/]/' | sort) <(sudo tail /var/log/messages -n"$(($numb_lines*5))" | awk '{print $3" "$6" "$7}' | sort) || { echo "FAILED syslog timing and pid mismatch" >&2 ; ret="$((ret + $?))" ; }

# this was too spammy on active servers... used the above
#diff -w <(cat expected_logs/* | sort) <(sudo tail /var/log/messages -n"$numb_lines" | sed -r 's/^[^[]+[[]/[/' | sort) || { echo "FAILED syslog data mismatch" >&2 ; ret="$((ret + $?))" ; }
#diff -w <(cat logs/* | sed -r 's/^[0-9]{4}\-[0-9]{2}\-[0-9]{2} //;s/[]].*/]/' | sort) <(sudo tail /var/log/messages -n"$numb_lines" | awk '{print $3" "$6" "$7}' | sort) || { echo "FAILED syslog timing and pid mismatch" >&2 ; ret="$((ret + $?))" ; }

CONFIG_FILE="${LOCAL_DIR}/config" ../vclod_do_dir ./test_single_file.diff.sh || { echo "FAILED single file should render without the directory"; ret="$((ret + $?))" ; }
CONFIG_FILE="${LOCAL_DIR}/sh_only/config" ../vclod_do_dir ./sh_only/ || { echo "FAILED mysql should not be required when not used"; ret="$((ret + $?))" ; }

exit $ret
