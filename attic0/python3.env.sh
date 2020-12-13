have-command python || return 0

# Expecting python3 startup script in ../rc/python3rc.py.
_startup=$(readlink -f $(dirname $BASH_SOURCE)/../rc)/python3rc.py

# Is the startup script readable? if so, use it.
[ -r "${_startup}" ] && export PYTHONSTARTUP="${_startup}"

# `python -m pip install --user ${package}` can sometimes install command line binaries 
# TODO mike@carif.io: do several python installs share the same site user-base?
# https://packaging.python.org/tutorials/installing-packages/#id21
path_if_exists $(python -m site --user-base)/bin

# less typing
function pip+install {
    if [[ -z "${update_pip}" ]] ; then
        python -m pip install --upgrade pip
        update_pip=$(date -Iseconds)
    fi
    python -m pip install --upgrade "$*"
}

