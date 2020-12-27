#!/usr/bin/env bash
# @author: Mike Carifio <mike@carif.io>
# -*- mode: shell-script; eval: (message "tab-width: %d, indent with %s" tab-width (if indent-tabs-mode "tabs (not preferred)" "spaces (preferred)")) -*- 

# Note that emacs can be configured for [editorconfig](https://editorconfig.org/)
#   with [editorconfig-emacs](https://github.com/editorconfig/editorconfig-emacs)

set -euo pipefail
IFS=$'\n\t'

_me=$(realpath ${BASH_SOURCE})
_here=$(dirname ${_me})
_name=$(basename ${_me})

source utils.lib.sh &> /dev/null || true

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

powerState() {
    local name=${1:?'expecting azure machine name'}
    local group=${2:?'expecting a resource group'}
    az vm show --name=${name} --resource-group=${group} --show-details -d --query='powerState'
}

running?() {
    local name=${1:?'expecting azure machine name'}
    local group=${2:?'expecting a resource group'}
    powerState ${name} ${group} | grep -q "VM stopped" 
}

awake() {
    local name=${1:?'expecting azure machine name'}
    local group=${2:?'expecting a resource group'}
    declare -i repeat=${3:-3} duration=10 total=0
    ( set -x ; az vm start --name=${_name} --resource-group=${group} )
    for i in {1..${repeat}} ; do
        sleep ${duration}
        total+=${duration}
        running? ${name} ${group} && return 0
    done
    _error "${name} didn't start after ${total} seconds."
}

# Explicit dispatch to an entry point, _start by default.
_dispatch() {
    
    local _entry=_start
    declare -a _args # don't pass --start to "real" function
    local _user=${USERNAME}


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
    local _name=''
    local _resource_group=${AZURE_RESOURCE_GROUP:-$(2>/dev/null az config get defaults.group --query=value)}
    local _subscription=${AZURE_SUBSCRIPTION:-$(2>/dev/null az config get defaults.subscription --query=value)}
    
    while (( $# )); do
        local _it=${1}
        case "${_it}" in
            # --template-flag=*) _template_flag=${_it#--template-flag=};;
            --name=*) _name=${_it#--name=};;
            --resource-group=*) _resource_group=${_it#--resource-group=};;
            --subscription=*) _subscription=${_it#--subscription=};;
            --) shift; _positionals+=($*); break;;
            -*|--*) _error "$1 unknown flag"; break;;
            *) _positionals+=(${_it});;
        esac
        shift
    done

    [[ -z "${_name}" ]] && _error "Expecting --name="
    
    ### *** replace below *** ###
    if ! running? ${_name} ${_resource_group} ; then
        ( set -x; awake ${_name} ${_resource_group} )        
    fi
    
}

# <script> --start=echo * # @advise:bash:inspect: a useful smoketest
_start_echo() {
    echo "$*"
}

_dispatch $@

