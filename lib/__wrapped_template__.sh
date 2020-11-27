#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

# how is _me etc handled?
_me=$(realpath ${BASH_SOURCE})
_here=$(dirname ${_me})
_name=$(basename ${_me})

source utils.lib.sh &> /dev/null || true
wrapper=../lib/wrapper.sh
source ${wrapper} || { echo &> "wrapper not found at ${wrapper}, stopping"; exit 1; }

# Override these functions by redefining them or chaining them. Rarely needed.
# _version() { exit 0; }
# _say_version() { exit 0; }
# _help() { exit 0; }
# _usage() { exit 0; }
# _error() { exit 1; }

# _on_exit() {
#     local _status=$?
#     # cleanup here
#     exit ${_status}
# }





# You define _start[*]()
# Here's are some starting implementations.


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
    for p in "${_positionals[*]}" ; do
        echo ${p}
    done

}

# <script> --start=echo * # @advise:bash:inspect: a useful smoketest
_start_echo() {
    echo "$*"
}

# Always called last.
_dispatch $@
