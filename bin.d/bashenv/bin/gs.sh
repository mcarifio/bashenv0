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
    local _api_key='AIzaSyDn-W0nGM6oW-P7VMqoe5ROxZf7hXPTT0o'
    local _q="https://cse.google.com/cse?cx=d48f69f435d9a32fe&key=AIzaSyDn-W0nGM6oW-P7VMqoe5ROxZf7hXPTT0o&q=kolin&fileType=pdf&num=20"
    while (( $# )); do
        local _it=${1}
        case "${_it}" in
            # --template-flag=*) _template_flag=${_it#--template-flag=};;
            --key) _api_key=${_it#--key}
            --) shift; _positionals+=($*); break;;
            -*|--*) _error "$1 unknown flag"; break;;
            *) _positionals+=(${_it});;
        esac
        shift
    done


    ### *** replace below *** ###
    # echo "${_positionals[*]} # count: ${#_positionals[*]}"
    for p in "${_positionals[*]}" ; do
        echo ${p}
    done


    # fetch exact title of bool (volume) using isbn
    # google book api https://developers.google.com/books/docs/v1/using 
    # curl 'https://www.googleapis.com/books/v1/volumes?key=AIzaSyCiGEIsFvkMoImxcAYbWZrveivNW5kkMoA&isbn=9digits'
    # pull out the title using jq
    # local _title=title+with+plus+signs

    # fetch candidate pdfs urls given exact title of book
    # custom-search api https://developers.google.com/custom-search/v1/reference/rest/v1/cse/list

    # cx and key are specific to this search "project"
    #   https://console.developers.google.com/apis/credentials/key/f2d37ad0-c8c5-495c-8f8c-2b2497b031a9?project=pdf-book-1599066904462
    # local _cx=d48f69f435d9a32fe _key=AIzaSyDn-W0nGM6oW-P7VMqoe5ROxZf7hXPTT0o _fileType=pdf

    # local _endpoint="https://www.googleapis.com/customsearch/v1"
    # local _query_string="cx=${_cx}&key=${_key}$fileType=${_fileType}&q=${_title}"
    # local _request="${_endpoint}?${_query_string}"
    # for u in $( curl ${_request} | jq '.items[].link' ) ; do
    #    # get the resource meta data, including mime type and content length
    #    curl --head ${u}
    #    if mime-type is application/pdf and content-length > some size, fetch the content
    #    curl ${u}
    # done
    
}

# <script> --start=echo * # @advise:bash:inspect: a useful smoketest
_start_echo() {
    echo "$*"
}

_dispatch $@

