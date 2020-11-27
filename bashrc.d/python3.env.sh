# Expecting python3 startup script in ../rc/python3rc.py.
startup=$(readlink -f $(dirname $BASH_SOURCE)/../rc)/python3rc.py

# Is the startup script readable? if so, use it.
[ -r $startup ] && export PYTHONSTARTUP=$startup

# /usr/bin/python -m pip install ${something} # puts bins in ${HOME}/.local/bin for user installs
path_if_exists ${HOME}/.local/bin

