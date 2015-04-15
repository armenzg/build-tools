#!/bin/bash
venv_dir="$1"

if [ ! -d "$venv_dir" ]; then
    virtualenv --no-site-packages "$venv_dir" || exit
    $venv_dir/bin/pip install firefox-ui-tests==0.3.dev0 --no-cache-dir --no-index \
        --find-links=http://pypi.pvt.build.mozilla.org/pub \
        --trusted-host pypi.pvt.build.mozilla.org \ 
        --find-links=http://pypi.pub.build.mozilla.org/pub \
        --trusted-host pypi.pub.build.mozilla.org || exit
fi
$venv_dir/bin/pip freeze
