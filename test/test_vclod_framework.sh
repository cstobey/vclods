#!/usr/bin/env ksh

mkdir -p ./logs/
CONFIG_FILE=./config ../vclod_do_dir vclod_dir
exit $?
