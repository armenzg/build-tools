#!/bin/bash
# This script creates a virtualenv with all the dependencies to run
# firefox-ui-update tests.
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
PYWIN32=http://pypi.pub.build.mozilla.org/pub/pywin32-216.win32-py2.7.exe

usage()
{
  echo "Usage: setup-marionette.sh [OPTION] [VENV_DIR]"
  echo "    --keep-venv          if you do not want the venv to be removed"
  echo "    --developer-mode     if you're not running this on a releng loaner"
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
    --keep-venv)
      keep_venv=1
      shift
      ;;
    --developer-mode)
      developer_mode=1
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

# Determine the path to the venv
if [ -n "$arg" ]
then
  venv_dir=$arg
  echo "Using $venv_dir as our virtualenv."
else
  echo "You need to specify a path to a venv to create or use."
  exit 1
fi

# Clear venv if not requested to be kept
if [ -z $keep_venv ]
then
  echo "Removing $venv_dir..."
  rm -rf $venv_dir
fi

# Create the venv if it does not exist
if [ ! -d "$venv_dir" ]; then
  venv_options="--no-site-packages "$venv_dir""
  if [ -z $developer_mode ] && [[ "`uname`" == "MINGW32_NT-6.1" ]]
  then
      python c:/mozilla-build/buildbotve/virtualenv.py $venv_options || exit
  else
      virtualenv $venv_options || exit
  fi
fi

# Options needed when not running on a loaner
if [ $developer_mode ]
then
  pip_options="--no-index --find-links http://pypi.pub.build.mozilla.org/pub"
fi

# Activate virtualenv
if [[ "`uname`" == "MING32_NT-6.1" ]]
then
  source $venv_dir/Scripts/activate
else
  source $venv_dir/bin/activate
fi

# firefox-ui-tests has few requirements, however, its requirements do not have
# hard pinned versions. If a new version of those dependencies would be uploaded
# to the internal pypi, we would start using it unless we hard pinned them here
pip install $pip_options -r $DIR/firefox_ui_updates_requirements.txt  || exit
# We install firefox-ui-tests separetedly to cleary distinct the main tool from its dependencies
pip install $pip_options firefox-ui-tests==0.2  || exit

# Most local Windows machines don't have win32api installed
if [ $developer_mode ] && [[ "`uname`" == "MING32_NT-6.1" ]]
then
    # win32api is needed by retry.py
    easy_install $PYWIN32
fi

pip freeze
