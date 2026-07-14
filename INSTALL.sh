#! /bin/ksh

DEST_FOLDER="$(dirname "$(readlink -f "$(which "$0")")")"
cd "$DEST_FOLDER" || { echo >&2 "[ERROR] $DEST_FOLDER is not a valid directory"; exit 1; }

cat << EOF >/usr/local/bin/vclod
#! /bin/ksh

export VCLOD_BASE_DIR="$DEST_FOLDER"
. "$DEST_FOLDER/vclod_do_dir"
EOF
cat << EOF >/usr/local/bin/vsql
#! /bin/ksh

export VCLOD_BASE_DIR="$DEST_FOLDER"
. "$DEST_FOLDER/sql_interactive" "SRC"
EOF
cat << EOF >/usr/local/bin/vdst
#! /bin/ksh

export VCLOD_BASE_DIR="$DEST_FOLDER"
. "$DEST_FOLDER/sql_interactive" "DST"
EOF
cat << 'EOF' >/usr/local/bin/vps
#! /bin/ksh

: "${FOREST:=f}" "${SHOW_ALL:=1}" "${VCLOD_USE_CGROUP:=1}" "${VCLOD_LOCK_DIR:=/dev/shm}"
for x in $* ; do case $x in
  -f) FOREST="" ;;
  -s) SHOW_ALL=0 ;;
  *)  echo -e "$(basename "$0") Usage\n  -f Flat output, do not show tree lines\n  -s Script only output" ; exit ;;
esac ; done

ulimit -s unlimited
if [ "$VCLOD_USE_CGROUP" -eq 1 ] && sudo -v && mount -l | grep cgroup -q ; then
  CGROUP_BASE="/sys/fs/cgroup/cpuset"
  CGROUP_FILE="tasks"
  if mount -l | grep cgroup2 -q ; then
    CGROUP_BASE="/sys/fs/cgroup"
    CGROUP_FILE="cgroup.procs"
  fi  
  { [ "$SHOW_ALL" -eq 1 ] && grep ^ $CGROUP_BASE/*/$CGROUP_FILE -H | sed -r 's#^/.*/([^/]+)/[^/:]+:(.+)$#\1 \2#'; grep ^ $VCLOD_LOCK_DIR/*.LCK -H | sed -r 's#^/.*/([^/]+)[.]([0-9]+)[.]LCK:(.+)$#\1_\2 \3#'; } | sort | awk -v q='"' -v f="$FOREST" 'BEGIN {print "export PS_FORMAT=pid,ppid,%cpu,%mem,tname,uname,start_time,time,args;"} function o() {print "ps -p "pids" "f" | cat <(echo -e "q"\033[1;31m"proc"\033[0m"q") -";pids="";proc=$1} NR == 1 {proc=$1} $1 != proc {o()} $1 == proc {pids=((pids=="") ? "" : (pids","))$2} END {o()}' | . /dev/stdin
else
  cd $VCLOD_LOCK_DIR ; fst_l=1; typeset -A locks; typeset -A files; typeset -A pids;
  grep ^ -H *.LCK 2>/dev/null | sed -r 's#^(.*)-([0-9]+)[.][0-9]+[.]LCK:([0-9]+)$#\3 \2 \1#;s#^(.*)[.][0-9]+[.]LCK:([0-9]+)$#\2 x \1#' | while read p i f ; do locks["$p"]="$i"; files["$p"]="$([ "$i" == "x" ] && echo "${f//_/[\/_]}" || echo "$f")" ; done
  PS_FORMAT=pid,ppid,%cpu,%mem,tname,uname,start_time,time,args ps -e $FOREST | while read pid ppid cpu mem tty u st t line ; do
    if [ "$fst_l" -eq 1 ] ; then echo -e "$pid\t$ppid\t$cpu\t$mem\t$tty\t$u\t$st\t$t\t$line"; fst_l=0;
    elif [ -n "${locks["$pid"]}" ] ; then
      pids["$pid"]=1;
      d="$(echo "$line" | sed -r 's#^.*?/vclod ##')";
      f="$([ "${locks["$pid"]}" == "x" ] && find "$d" ! -empty -xtype f | grep -E "${files["$pid"]}" || find "$d" -inum ${locks["$pid"]} -name ${files["$pid"]})";
      c="$(echo "$line" | sed "s@$d@${f:-$d/${files["$pid"]}}@")"
      echo -e "$pid\t$ppid\t$cpu\t$mem\t$tty\t$u\t$st\t$t\t$c LOCKED";
    elif [[ "$line" =~ /vclod ]] || [ -n "${pids["$ppid"]}" ] ; then pids["$pid"]=1; [ "$SHOW_ALL" -eq 1 ] && echo -e "$pid\t$ppid\t$cpu\t$mem\t$tty\t$u\t$st\t$t\t$line";
    fi ; done ;
fi
EOF
cat << 'EOF' >/usr/local/bin/vkill
#! /bin/ksh

if [ "${VCLOD_USE_CGROUP:=1}" -eq 1 ] && sudo -v && mount -l | grep cgroup -q ; then
  CGROUP_BASE="/sys/fs/cgroup/cpuset"
  CGROUP_FILE="tasks"
  if mount -l | grep cgroup2 -q ; then
    CGROUP_BASE="/sys/fs/cgroup"
    CGROUP_FILE="cgroup.procs"
  fi
  pid_to_kill="${1:?lock name to kill required}"
  list_of_pids_to_kill="$(grep ^ "$CGROUP_BASE/$pid_to_kill/$CGROUP_FILE" -h 2>/dev/null | paste -sd" ")"
  [ -n "$list_of_pids_to_kill" ] && kill $list_of_pids_to_kill || echo >&2 "Failed to kill anything"
else
  pid_to_kill="${1:?pid to kill required}"
  [[ "$pid_to_kill" =~ ^[0-9]+$ ]] || { echo >&2 "Pid must be a number"; exit 1; }
  pstree -p "$pid_to_kill" |
    sed -r 's/[^()0-9]*[(]([0-9]+)[)][^()0-9]*/\1\n/g' |
    awk 'BEGIN {printf "kill "} /^[0-9]+$/ {printf $1" "} END {printf ";\n"}' |
    . /dev/stdin
fi
EOF
chmod +x /usr/local/bin/{vclod,vsql,vdst,vps,vkill} vclod_do_dir sql_interactive
