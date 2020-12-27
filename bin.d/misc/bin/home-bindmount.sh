#!/usr/bin/env bash
# -*- mode: shell-script; eval: (setq indent-tabs-mode nil tab-width 4 indent-line-function 'insert-tab) -*-
# @author: Mike Carifio <mike@carif.io>
# Note that emacs can be configured for [editorconfig](https://editorconfig.org/)
#   with [editorconfig-emacs](https://github.com/editorconfig/editorconfig-emacs)

set -euo pipefail
# If passing an array in a function, modify IFS or comment out.
# IFS=$'\n\t'
IFS=$'\n\t'


_me=$(realpath -s ${BASH_SOURCE:-$0})
_here=$(dirname ${_me})
_name=$(basename ${_me} .sh)

# allows for: cp $(__template__.sh) /some/path/x.sh
if [[ '__template__' = "${_name}" ]] ; then
  echo ${_me}
  exit 0
fi

source utils.lib.sh &> /dev/null || true
source ${_me}.conf &> /dev/null || true

_version() {
    local v=${_me}.version.txt
    if [[ -r ${v} ]] ; then
        cat -s ${v}
    else
        echo "0.1.1"
    fi
}

_say_version() {
    echo "${_name} $(_version) # at ${_me}"
    exit 0
}

_help() {
    echo "help ${_name} $(_version) # at ${_me}"
    exit 0
}

_usage() {
    echo "usage: ${_name} [-h|--help] [-v|--version] [-u|--usage] [--start=<function_name>] # at ${_me}"
    exit 1
}

_error() {
    local _status=${2:-1}
    local _message=${1-"${_me} error ${_status}"}
    echo ${_message} > /dev/stderr
    exit 1
}

_on_exit() {
    local _status=$?
    # cleanup here
    exit ${_status}
}

# trap -l to enumerate signals
trap _on_exit EXIT

# Explicit dispatch to an entry point, _start by default.
_dispatch() {
    
    local _entry=_start
    declare -a _args # don't pass --start to "real" function
    local _user=${USER}


    while (( $# )); do
        local _it="${1}"
        case "${_it}" in
            -h|--help) _help ;;
            -v|--version) _say_version ;;
            -u|--usage) _usage ;;
            # new entry point, --start=${USERNAME} dispatches to _start_mcarifio with all arguments
            --start=*) _entry=_start_${_it#--start=} ;;
            # breaks?
            --as=*) _user=${_it#--as=} ;;
            *) _args+=(${_it}) ;;
        esac
        shift
    done

    if [[ "${USERNAME}" != "${_user}" ]] && (( 0 != $(id -uz) )) ; then
        _error "${USERNAME} can't run ${_me}/${_entry} as user '${_user}'. Only root can do that."
    fi
    
    
    ${_entry} ${_args[*]}
}


_start() {
    local -a _args=( $* )
    local -a _positionals

    # initial (default) values for vars, especially command line switches/flags.
    # local _template_flag=''
    local _template_flag=''
    
    while (( $# )); do
        local _it=${1}
        case "${_it}" in
            # --template-flag=*) _template_flag=${_it#--template-flag=};;
            --template-flag=*) _template_flag=${_it#--template-flag=};;
            --) shift; _positionals+=($*); break;;
            -*|--*) _error "$1 unknown flag"; break;;
            *) _positionals+=(${_it});;
        esac
        shift
    done


    ### *** start here *** ###
    # echo "${_positionals[*]} # count: ${#_positionals[*]}"
    # for p in "${_positionals[*]}" ; do
    #     echo ${p}
    # done

    # snap chromium doesn't let user see files outside $HOME
    # for all zfs pool mount points mp ...
    for mp in $(zfs list -o mountpoint|tail -n1); do
        # ... if that mount point has a "user area" for $USER ...
        local from=${mp}/${USER}
        if [[ -d ${from} ]] ; then
            local to=${HOME}/pools/${mp}
            mkdir -p ${to}
            sudo mount --bind ${from} ${to}
        fi
    done
    

}

# <script> --start=echo * # @advise:bash:inspect: a useful smoketest
_start_echo() {
    echo "$*"
}

_dispatch $@

