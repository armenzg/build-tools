#!/bin/bash
venv_dir="$1"

if [ ! -d "$venv_dir" ]; then
    virtualenv --no-site-packages "$venv_dir" || exit
    $venv_dir/bin/pip install firefox-ui-tests==0.3.dev0  || exit
fi
$venv_dir/bin/pip freeze
