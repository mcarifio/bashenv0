#!/usr/bin/env bash

set -e
_me=$(realpath ${BASH_SOURCE})
_here=$(dirname ${_me})
_name=$(basename ${_me})

_version() {
    local v=${me}.version.txt
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
    echo "usage: ${_name} [-h|--help] [-v|--version] [-u|--usage]  # at ${_me}"
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

trap _on_exit EXIT

_start() {
    local -a positionals
    while (( "$#" )); do
        case "${1}" in
            -h|--help) _help; break;;
            -v|--version) _say_version; break;;
            -u|--usage) _usage; break;;
            --) shift; break;;
            -*|--*) _error "$1 unknown flag"; break;;
            *) positionals+=(${1}); shift;;
        esac
    done

    # echo "${positionals[*]} # count: ${#positionals[*]}"

    if [[ ${_name} =~ ^mk([^\.]+) ]] ; then
        # local _suffix=${BASH_REMATCH[1]}
        local _suffix=sh
        local __template__=${_here}/__template__.${_suffix}
        [[ ! -r ${__template__} ]] && \
            _error "template '${__template__}' for '${_me}' missing."
    fi
    
            
    for i in "${positionals[*]}" ; do
        name="${i}" _date="$(date)" envsubst '$name $_date' < ${__template__} > ${i}
        chmod a+x ${i}        
    done
}

_start $*


