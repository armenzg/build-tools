#!/bin/bash
venv_dir="$1"
fx_ui_tests_package=git+https://github.com/mozilla/firefox-ui-tests.git

if [ ! -d "$venv_dir" ]; then
    virtualenv --no-site-packages "$venv_dir" || exit
    $venv_dir/bin/pip install $fx_ui_tests_package || exit
fi
$venv_dir/bin/pip freeze
