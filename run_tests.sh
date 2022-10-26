#!/bin/ksh

# setup
DEBUG_SHOULD_TIME_IT=0 # in case this is being run from the terminal
LOCAL_DIR="$(dirname "$(readlink -f "$(which "$0")")")/test"
export DEBUG_SHOULD_TIME_IT LOCAL_DIR
cd "${LOCAL_DIR}" || { echo >&2 "Could not cd into the test dir... something is REALLY wrong" ; exit 1; }
mkdir -p ./logs/ ./files/ ./tmp_files/
rm -f logs/* files/* tmp_files/*
numb_lines="$(cat expected_logs/* | wc -l)"

# setup the test logging database.
CONFIG_FILE="${LOCAL_DIR}/config" ../vclod_do_dir "${LOCAL_DIR}/setup_test_pp_db.sh"

# setup web server
(cd test_webserver ; python3 -m http.server 9000 2>/dev/null) &
trap "kill $!" EXIT # need to cleanup

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

# tests off the previous run
[ -z "$DEBUG_WHERE" ] || echo "[WHERE] log file check"
diff -w <(ls -1 expected_logs/ | sed 's/.expected//' | sort) <(ls -1 logs/ | grep '.log$' | sed -r 's/\.[0-9]+\.log$//' | sort) || { ret="$((ret + $?))"; echo "FAILED to render the right log files" >&2 ; }
[ -z "$DEBUG_WHERE" ] || echo "[WHERE] log file content check"
for f in expected_logs/*.expected ; do diff -w <(sort "$f") <(sed -r 's/^[^[]+[[]/[/;s/[.][0-9]+[.]log/..log/' "logs/$(basename "${f%expected}")"[0-9]*.log | sort) || { ret="$((ret + $?))" ; echo "FAILED $f content mismatch" >&2 ; } ; done
# test the outfiles... cant test the append, since they put date parts on the ends of the filenames... need to think more about that.
for f in files/* ; do cp "$f" "tmp_files/$(basename "${f/-"$(date +%F)"/}")" ; done
for f in $(ls -1 logs/*.g-* | grep -E '[.]g-[^.]*$') ; do cp "$f" "tmp_files/$(basename "${f}" | sed -r 's/\.[0-9]+\.log//')" ; done
[ -z "$DEBUG_WHERE" ] || echo "[WHERE] diff files"
diff -wr expected_files tmp_files || { ret="$((ret + $?))" ; echo "FAILED to render the right output files with the right content" >&2 ; }

# ensure that the post process log2sql process works in all ways.
cat << 'EOF' | CONFIG_FILE="${LOCAL_DIR}/config" ../vclod_do_dir test_pp_logger.sh || { ret="$((ret + $?))" ; echo "FAILED to export log2sql" >&2 ; }
export SRC=LOG_SQL_
diff -w <(cat << 'STMT' | vclod_operation get_sql.sql | sed 's/\t/ /g' | sort
SELECT
  SUBSTRING_INDEX(log_file, '/', -1) AS base_file, 
  ROW_NUMBER() OVER (PARTITION BY log_file, pid ORDER BY script_log_id) AS line_number, 
  happened_at, pid, tag, message, IFNULL(value, '') AS value 
FROM script_log;
STMT
) <(find logs/* ! -empty -xtype f -regextype posix-egrep -regex '.*[.]log$' | xargs grep ^ -n | sed -r 's#^logs/(.*)[.][0-9]+[.]log:([0-9]+):#\1 \2 #' | sort)
EOF

[ -z "$DEBUG_WHERE" ] || echo "[WHERE] untested extentions"
comm -13 <(ls -R1 vclod_dir/ | grep -E -o '[.][a-z]+' | sed 's/^.//' | sort | uniq) <(ls -1 ../extensions/) | sed 's/^/UNTESTED EXTENSION /' >&2

# TODO: comm doesnt error, so need to get creative with error text.. might use awk
[ -z "$DEBUG_WHERE" ] || echo "[WHERE] syslog data and pid check -- skip time because syslog tends to be off by a second or so"
comm -23 <(cat logs/*.log | sed -r 's/^[^[]* ([0-9]+ [[])/\1/' | sort) <(sudo tail /var/log/messages -n"$((numb_lines*2))" | sed -r 's/^([^ \t]+[ \t]+){5}//' | sort) || { ret="$((ret + $?))" ; echo "FAILED syslog data and pid mismatch" >&2 ; }

[ -z "$DEBUG_WHERE" ] || echo "[WHERE] test_single_file"
CONFIG_FILE="${LOCAL_DIR}/config" ../vclod_do_dir test_single_file.diff.sh || { ret="$((ret + $?))" ; echo "FAILED single file should render without the directory $ret" ; }
[ -z "$DEBUG_WHERE" ] || echo "[WHERE] stdin"
cat << 'EOF' | CONFIG_FILE="${LOCAL_DIR}/config" ../vclod_do_dir test_stdin.diff-test_single_file.sh || { ret="$((ret + $?))" ; echo "FAILED virtual single file should render without the directory $ret" ; }
echo A single file needs to work by itself
EOF
[ -z "$DEBUG_WHERE" ] || echo "[WHERE] sh_only"
CONFIG_FILE="${LOCAL_DIR}/sh_only/config" ../vclod_do_dir ./sh_only/ || { ret="$((ret + $?))" ; echo "FAILED mysql should not be required when not used $ret" ; }

diff <(find $VCLOD_ERR_DIR $LOCAL_DIR -type p) <(printf "") || { ret="$((ret + $?))" ; echo "FAILED to clean up fifo files: find $VCLOD_ERR_DIR $LOCAL_DIR -type p -delete>&2" >&2; } # TODO: should I just delete them?

exit $ret
