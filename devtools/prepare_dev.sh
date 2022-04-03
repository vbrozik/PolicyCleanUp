#!/bin/sh

# Prepare the development environment

# This script is intended to be run on the development machine.
# It will install the required packages and set up the development environment.
# It uses the currently active virtual environment or existing .venv or
# creates a new one.

python=python3
venvdir=.venv
requirements_list="requirements_dev.txt devtools/requirements_dev.txt"
preinstall_packages="pip setuptools wheel"

if test -z "$VIRTUAL_ENV" ; then
    if test -d "$venvdir" ; then
        # shellcheck source=/dev/null
        . "$venvdir/bin/activate" || exit 1
    else
        echo "Creating new virtual environment $venvdir"
        "$python" -m venv "$venvdir" || exit 1
        # shellcheck source=/dev/null
        . "$venvdir/bin/activate" || exit 1
        for package in $preinstall_packages ; do
            "$python" -m pip install --upgrade "$package" || exit 1
        done
    fi
fi

for requirements in $requirements_list ; do
    if test -e "$requirements" ; then
        echo "Installing requirements from $requirements"
        "$python" -m pip install -r "$requirements" || exit 1
    fi
done
