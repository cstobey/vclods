#!/usr/bin/env ksh

mkdir -p ./logs/
CONFIG_FILE=./config VCLOD_BASE_DIR="`pwd`/.." ../vclod_do_dir vclod_dir
exit $?
