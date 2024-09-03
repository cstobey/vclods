#! /bin/ksh

DEST_FOLDER="$(dirname "$(readlink -f "$(which "$0")")")"
cd "$DEST_FOLDER" || { echo >&2 "[ERROR] $DEST_FOLDER is not a valid directory"; exit 1; }

cat << EOF >/usr/local/bin/vclod
#! /bin/ksh

export VCLOD_BASE_DIR="$DEST_FOLDER"
. "$DEST_FOLDER/vclod_do_dir"
EOF
cat << 'EOF'>/usr/local/bin/vps
#! /bin/ksh

: "${PS_ARG:=-e f}" "${SHOW_ALL:=1}"
for x in $* ; do case $x in 
  -f) PS_ARG="-e" ;;
  -s) SHOW_ALL=0 ;;
  *)  echo -e "$(basename "$0") Usage\n  -f Flat output, do not show tree lines\n  -s Script only output" ; exit ;;
esac ; done
cd /dev/shm ; fst_l=1; typeset -A locks; typeset -A files; typeset -A pids;
grep ^ -H *.LCK 2>/dev/null | sed -r 's#^(.*)-([0-9]+)[.][0-9]+[.]LCK:([0-9]+)$#\3 \2 \1#;s#^(.*)[.][0-9]+[.]LCK:([0-9]+)$#\2 x \1#' | while read p i f ; do locks["$p"]="$i"; files["$p"]="$([ "$i" == "x" ] && echo "${f//_/[\/_]}" || echo "$f")" ; done
PS_FORMAT=pid,ppid,%cpu,%mem,tname,uname,start_time,time,args ps $PS_ARG | while read pid ppid cpu mem tty u st t line ; do 
  if [ "$fst_l" -eq 1 ] ; then echo -e "$pid\t$ppid\t$cpu\t$mem\t$tty\t$u\t$st\t$t\t$line"; fst_l=0; 
  elif [ -n "${locks["$pid"]}" ] ; then 
    pids["$pid"]=1; 
    d="$(echo "$line" | sed -r 's#^.*?/vclod ##')"; 
    f="$([ "${locks["$pid"]}" == "x" ] && find "$d" ! -empty -xtype f | grep -E "${files["$pid"]}" || find "$d" -inum ${locks["$pid"]} -name ${files["$pid"]})";
    c="$(echo "$line" | sed "s@$d@${f:-$d/${files["$pid"]}}@")"
    echo -e "$pid\t$ppid\t$cpu\t$mem\t$tty\t$u\t$st\t$t\t$c LOCKED";
  elif [[ "$line" =~ /vclod ]] || [ -n "${pids["$ppid"]}" ] ; then pids["$pid"]=1; [ "$SHOW_ALL" -eq 1 ] && echo -e "$pid\t$ppid\t$cpu\t$mem\t$tty\t$u\t$st\t$t\t$line";
  fi ; done ; 
EOF
cat << 'EOF' >/usr/local/bin/vkill
#! /bin/ksh

pid_to_kill="${1:?pid to kill required}"
[[ "$pid_to_kill" =~ ^[0-9]+$ ]] || { echo >&2 "Pid must be a number"; exit 1; }
pstree -p "$pid_to_kill" | 
  sed -r 's/[^()0-9]*[(]([0-9]+)[)][^()0-9]*/\1\n/g' | 
  awk 'BEGIN {printf "kill "} /^[0-9]+$/ {printf $1" "} END {printf ";\n"}' | 
  . /dev/stdin 
EOF
chmod +x /usr/local/bin/{vclod,vps,vkill} vclod_*
