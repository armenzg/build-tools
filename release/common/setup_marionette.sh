#!/bin/bash
venv_dir="$1"

if [ ! -f $HOME/.pip/pip.conf ]
then
    pip_options="--no-index --find-links http://pypi.pub.build.mozilla.org/pub --trusted-host pypi.pub.build.mozilla.org"
fi

if [ ! -d "$venv_dir" ]; then
    virtualenv --no-site-packages "$venv_dir" || exit

    if [ "`uname -o`" == "Msys" ]
    then
        pip_path=$venv_dir/Scripts/pip
        # win32api is needed by retry.py
        $venv_dir/Scripts/easy_install http://pypi.pub.build.mozilla.org/pub/pywin32-216.win32-py2.7.exe
    else
        pip_path=$venv_dir/bin/pip
    fi

    $pip_path install firefox-ui-tests==0.3.dev0 $pip_options || exit
fi
$pip_path freeze
