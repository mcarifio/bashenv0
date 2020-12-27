#!/usr/bin/env bash
# -*- mode: shell-script; eval: (setq-local indent-tabs-mode nil tab-width 4 indent-line-function 'insert-tab) -*-
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

source utils.lib.sh &> /dev/null || true
source ${_me}.conf &> /dev/null || true

# run as root?
# if [[ $(id -un) != root ]] ; then
#     exec sudo ${_me} --for=${USERNAME} $@
# fi


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


function _message {
    local _lineno=${1:?'expecting required lineno'}
    local _status=${3:-0}
    if [[ -z "${_status}" || "${_status}" == "0" ]] ; then
        local _message=${2:-warning}
        local _status_pair=""
    else
        local _message=${2:-error}
        local _status_pair=", status: ${_status}" 
    fi
    local _funcname=${FUNCNAME[1]}
    echo "{ where: { pathname: \"${_me}\", funcname: \"${_funcname}\", lineno: \"${_lineno}\" }, message: \"${_message}\"${_status_pair} }"
}

function _errorln {
    _catch --exit --print $(_message ${1:-${LINENO}} ${2:-error} ${3:-1})
}

function _error {
    _catch --exit --print $(_message tbs ${1:-error} ${2:-1})
}


function _stacktrace {
    _error "not yet implemented"
}

function _caller {
    echo ${FUNCNAME[1]}
}


# usage: trap '_catch' EXIT
# usage: trap '_catch --exit=1' EXIT
# usage: trap '_catch --return=10' EXIT
# usage: trap '_catch --print[=/dev/stderr] --return'

function _catch {
    # hack: _catch invoked implicitly via explicit exit command (e.g. `exit 1`)
    # rather than via an explicit _catch call.
    [[ ${FUNCNAME[0]} == ${FUNCNAME[1]} ]] && return

    local -a _args=( $* )
    local -a _positionals

    declare -i _exit=1
    declare -i _print=1
    declare -i _lineno=0
    declare -i _status=$?
    declare -i _handler=0
    
    local _to=/dev/stderr
    
    while (( $# )); do
        local _it=${1}
        case "${_it}" in
            # --template-flag=*) _template_flag=${_it#--template-flag=};;
            --return) _exit=0 ;;
            --return=*) _exit=0; _status=${_it#--return=} ;;
            --exit) _exit=1 ;;
            --handler) _handler=1 ;;
            --exit=*) _print=1; _status=${_it#--exit=} ;;
            --lineno=*) _lineno=${_it#--lineno=} ;;
            --print) _print=1 ;;
            --print=*) _print=1; _to=${_it#--print=} ;;
            --) shift; _positionals+=($*); break ;;
            # -*|--*) _message ${LINENO} "$1 unknown flag" ; exit 1 ;;
            -*|--*) _catch --exit=1 ${LINENO} "$1 unknown flag" ;;
            *) _positionals+=(${_it}) ;;
        esac
        shift
    done

    local _message="${_positionals[0]:-}"
    if (( ${_print} )) && [[ -n "${_message}" ]] ; then
        _message ${_lineno} ${_message} ${_status} > ${_to}
        # _message ${_the_lineno} ${_message} ${_status} | jq . > ${_to}
    fi
    if (( _exit && _handler  )) ; then
        exit ${_status}
    fi
}

_on_exit() {
    local _status=$?
    # cleanup here
    exit ${_status}
}

# trap -l to enumerate signals
# trap _on_exit EXIT
trap '_catch --handler --lineno=${LINENO}' EXIT

# allows for: cp $(__template__.sh) /some/path/x.sh
if [[ '__template__' = "${_name}" ]] ; then
    _message ${LINENO} "running template ${_me} directly" >&2
    # _message ${LINENO} "running template ${_me} directly" | jq --compact-output . >&2 
fi



# Explicit dispatch to an entry point, _start by default.
_dispatch() {
    
    local _entry=_start
    declare -a _args # don't pass --start to "real" function
    local _user=${USERNAME}
    declare -i _verbose=0

    while (( $# )); do
        local _it="${1}"
        case "${_it}" in
            -h|--help) _help ;;
            -V|--version) _say_version ;;
            -u|--usage) _usage ;;
            -v|--verbose) _verbose=1 ;;
            # new entry point, --start=${USERNAME} dispatches to _start_mcarifio with all arguments
            --start=*) _entry=_start_${_it#--start=} ;;
            # breaks?
            --as=*) _user=${_it#--as=} ;;
            *) _args+=(${_it}) ;;
        esac
        shift
    done

    if [[ "${USERNAME}" != "${_user}" ]] && (( 0 != $(id -uz) )) ; then
        _errorln ${LINENO} "${USERNAME} can't run ${_me}/${_entry} as user '${_user}'. Only root can do that."
    fi
    
    
    ${_entry} ${_args[*]}
}


_start() {
    local -a _args=( $* )
    local -a _positionals

    # initial (default) values for vars, especially command line switches/flags.
    # local _template_flag=''
    
    while (( $# )); do
        local _it=${1}
        case "${_it}" in
            # --template-flag=*) _template_flag=${_it#--template-flag=};;
            --template-flag=*) _template_flag=${_it#--template-flag=};;
            --) shift; _positionals+=($*); break;;
            -*|--*) _catch --exit=1 --print ${LINENO} "$1 unknown flag" ;;
            *) _positionals+=(${_it});;
        esac
        shift
    done


    ### *** start here *** ###
    # echo "${_positionals[*]} # count: ${#_positionals[*]}"
    # for p in "${_positionals[*]}" ; do
    #     echo ${p}
    # done
    gsettings set org.gnome.desktop.background picture-uri ''
    gsettings set org.gnome.desktop.background primary-color 'rgb(0, 25, 50)'  # dark blue

}

# <script> --start=echo * # @advise:bash:inspect: a useful smoketest
_start_echo() {
    echo "$*"
}

_dispatch $@

