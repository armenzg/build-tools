#!/bin/bash
venv_dir="$1"

if [ "`uname -o`" == "Msys" ]
then
    pip_path=$venv_dir/Scripts/pip
else
    pip_path=$venv_dir/bin/pip
fi

if [ ! -d "$venv_dir" ]; then
    virtualenv --no-site-packages "$venv_dir" || exit
    $pip_path install firefox-ui-tests==0.3.dev0 --no-cache-dir --no-index \
        --find-links http://pypi.pub.build.mozilla.org/pub \
        --trusted-host pypi.pub.build.mozilla.org || exit
fi
$pip_path freeze
