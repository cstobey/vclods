#!/bin/ksh

err() { printf '---FAILED %s\n' "$*" >&2; }
# setup
DEBUG_SHOULD_TIME_IT=0 # in case this is being run from the terminal
LOCAL_DIR="$(dirname "$(readlink -f "$(which "$0")")")/test"
export DEBUG_SHOULD_TIME_IT LOCAL_DIR
cd "${LOCAL_DIR}" || { err "Could not cd into the test dir... something is REALLY wrong" ; exit 1; }
mkdir -p ./logs/ ./files/ ./tmp_files/
rm -f logs/* files/* tmp_files/*
numb_lines="$(cat expected_logs/* | wc -l)"

# setup the test logging database.
CONFIG_FILE="${LOCAL_DIR}/config" ../vclod_do_dir "${LOCAL_DIR}/setup_test_pp_db.sh"

# setup web server
( cd test_webserver ; python3 -m http.server 9001 --cgi 2>/dev/null; ) &
WEBSERVER_PID="$!"
export TEST_WEBHOST="http://localhost:9001"
trap "kill $WEBSERVER_PID" EXIT # need to cleanup

# allows you to run one test and see the output.. helpful for dev...
# NOTE: you need to specify the test in relation to the test/ directory.
if [ -n "$1" ] ; then
  CONFIG_FILE="${LOCAL_DIR}/config" ../vclod_do_dir "${LOCAL_DIR}/$1"
  exit $?
fi

rm -f ./vclod_dir/local_config_override/test_symlink.sh
ln -s "$(pwd)"/vclod_dir/{test,local_config_override/test_symlink}.sh
CONFIG_FILE="${LOCAL_DIR}/config" ../vclod_do_dir ./vclod_dir/
ret=$? # run the primary test
rm -f ./vclod_dir/local_config_override/test_symlink.sh

echo 'echo $VCLOD_JOBS' | O_VCLOD_JOBS=200 CONFIG_FILE="${LOCAL_DIR}/config" ../vclod_do_dir test_cli_override_env.sh
ret="$((ret + $?))" # test env override and stdin streams.

# tests off the previous run

# syslog
comm -23 <(cut -d' ' -f3- logs/*.log | sort) <(sudo grep -o "$(whoami): .*$" /var/log/messages | tail -n"$((numb_lines*2))" | cut -d' ' -f2- | sort) | grep . && err "syslog data and pid mismatch"
# log file check
find expected_logs/*.expected logs/*.log | sed -r 's/(^expected_|.expected$)//g;s/[.][0-9]+[.]log$//' | sort | uniq -c | grep -Ev '^ +2 ' && err "to render the right log files"
# log file content check : 2 methods, I think I like the second way
#find expected_logs/*.expected | sed -r 's#^(expected)_(.+).expected$#diff -w <(sort \1_\2.\1) <(sed -r '"'"'s/^[^[]+[[]/[/;s/[.][0-9]+[.]log/..log/'"'"' \2.[0-9]*.log | sort) || echo >\&2 "FAILED content \2 mismatch"#' | . /dev/stdin
for f in expected_logs/*.expected ; do diff -w <(sort "$f") <(sed -r 's/^[^[]+[[]/[/;s/[.][0-9]+[.]log/..log/' "logs/$(basename "${f%expected}")"[0-9]*.log | sort) || err "$f content mismatch" ; done
# test the outfiles... cant test the append, since they put date parts on the ends of the filenames... need to think more about that.
for f in files/* ; do cp "$f" "tmp_files/$(basename "${f/-"$(date +%F)"/}")" ; done
for f in $(ls -1 logs/*.g-* | grep -E '[.]g-[^.]*$') ; do cp "$f" "tmp_files/$(basename "${f}" | sed -r 's/\.[0-9]+\.log//')" ; done
diff -wr expected_files tmp_files || err "to render the right output files with the right content"

# ensure that the post process log2sql process works in all ways.
cat << 'EOF' | CONFIG_FILE="${LOCAL_DIR}/config" O_SRC=LOG_SQL_ ../vclod_do_dir test_pp_logger.out.sh
diff -w <(cat << 'STMT' | vclod_operation get_sql.sql | sort
SELECT
  CONCAT('logs/', SUBSTRING_INDEX(log_file, '/', -1), '.', pid, '.log:',
    ROW_NUMBER() OVER (PARTITION BY log_file, pid ORDER BY script_log_id), ':',
    CONCAT_WS(' ', happened_at, pid, tag, message, value))
FROM script_log ORDER BY 1;
STMT
) <(grep ^ -n logs/*.log | sort)
EOF
grep -Ev '^(>.*[[]LOG[]] subprocess done|[^<>].*)$' files/test_pp_logger-* | grep -q . && err "to export log2sql -- see $(find files/ -name 'test_pp_logger-*')"

# untested extentions
comm -13 <(find vclod_dir/ | grep -Eo '[.][a-z]+' | sort -u) <(find ../extensions/* | sed -r 's#^.*/([^/]+)$#.\1#') | paste -sd',' | sed '/^$/ d;s/^/---UNTESTED EXTENSIONS/;s/[.]/ /g' >&2

# extra tests

# test single file
CONFIG_FILE="${LOCAL_DIR}/config" ../vclod_do_dir test_single_file.diff.sh || err "single file should render without the directory $?"
# stdin
cat << 'EOF' | CONFIG_FILE="${LOCAL_DIR}/config" ../vclod_do_dir test_stdin.diff-test_single_file.sh || err "virtual single file should render without the directory $?"
echo A single file needs to work by itself
EOF
# sh_only
CONFIG_FILE="${LOCAL_DIR}/sh_only/config" ../vclod_do_dir ./sh_only/ || err "mysql should not be required when not used $?"

diff <(find $VCLOD_ERR_DIR $LOCAL_DIR -type p) <(printf "") || err "to clean up fifo files: find $VCLOD_ERR_DIR $LOCAL_DIR -type p -delete>&2"

ls ${TMPDIR:-/tmp}/tmp.* 2>/dev/null | grep "$(whoami)" | grep -q . && err 'to cleanup some temp files'
exit $ret
