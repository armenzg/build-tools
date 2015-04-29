#!/bin/bash
# This script is not meant to be run on a production machine but on a developer's machine
# It is mainly a wrapper which changes pip options and install pywin32 on the venv for Windows
usage()
{
  echo "Usage: marionette_testing.sh [OPTION] [CONFIG_FILE]"
  echo "    --dont-clear-cache     do not clear the cache"
  echo "    --keep-venv            if you do not want the venv to be removed"
}

if [ -z "$*" ]
then
  usage
  exit 0
fi

pass_arg_count=0
while [ "$#" -gt "$pass_arg_count" ]
do
  case "$1" in
    --dont-clear-cache)
      dont_clear=1
      shift
      ;;
    --keep-venv)
      keep_venv=1
      shift
      ;;
    *)
      # Move the unrecognized arg to the end of the list
      arg="$1"
      shift
      set -- "$@" "$arg"
      pass_arg_count=`expr $pass_arg_count + 1`
  esac
done

if [ -n "$arg" ]
then
  config_file=$arg
  echo "Using config file $config_file"
else
  echo "You need to specify a config file"
  exit 1
fi

options=""
if [ $keep_venv ]; then options="$options --keep-venv"; fi
if [ $dont_clear ]; then options="$options --dont-clear-cache"; fi

../common/setup_firefox_ui_updates.sh --developer-mode venv
./verify.sh $options --marionette $config_file
