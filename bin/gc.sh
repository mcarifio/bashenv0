#!/usr/bin/env bash
# gc.sh will git clone a url into the "right" pathname locally based a few conventions. An example
# is clearer than stating rules:
# gc.sh git@github.com:erichgoldman/add-url-to-window-title.git
#  will clone into ~/src/github.com/erichgoldman/add-url-to-window-title/add-url-to-window-title
# In general:
#  ~/src is the global prefix, override with --root=/tmp/here
#  github.com is the host; repos are subdivided by hostnames
#  erichgoldman/add-url-to-window-title.git is the suffix and becomes erichgoldman/add-url-to-window-title/add-url-to-window-title
#   the repo is repeated twice to give a location for "local scripts"

# Usage: cd $(gc.sh git@github.com:erichgoldman/add-url-to-window-title.git)

# Note: this script is pretty brittle.

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
    cat <<EOF
usage: ${_name} [-h|--help] [-v|--version] [-u|--usage] [--root=/some/pathname] [url*]    # at ${_me}"
Clones urls representing git repositories based on the url details, e.g. `ghc.sh git@github.com:erichgoldman/add-url-to-window-title.git`
clones into ~/src/github.com/erichgoldman/add-user-to-window-title.
EOF
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


# gc (git clone) based on url. Note, only git and http urls are currently supported.
gc() {
    local url=${1?'expecting a url'}
    # git@github.com:erichgoldman/add-url-to-window-title.git
    if [[ "${url}" =~ ^https?:// ]] ; then
        gchttp ${url}
    else
        gcgit ${url}
    fi    
}

# git clone over http/https
gchttp() {
    local url=${1?'expecting a url'}
    # git@github.com:erichgoldman/add-url-to-window-title.git
    if [[ "${url}" =~ ^https?://(.+)(:\d+)?/(.*) ]] ; then
        host=${BASH_REMATCH[1]#*@} # remove optional username/password
        host=${host#:*} # .. and port
        suffix=${BASH_REMATCH[3]}
        repo=$(basename ${suffix} .git)
        target=${root:-${HOME}/src}/${host}/${suffix}/${repo}
        git clone ${url} ${target} 1>/dev/null && echo ${target}
    else
        _error "git http url '${url}' misformed, can't clone"
    fi
    
}

gcgit() {
    local url=${1?'expecting a url'}
    # git@github.com:erichgoldman/add-url-to-window-title.git
    declare -a _split
    IFS=':' read -ra _split <<< "${url}"
    # if [[ "${url}" =~ ^([^:]+):(.*) ]] ; then
    #     host=${BASH_REMATCH[1]%git@}
    #     user_repo=${BASH_REMATCH[2]}
    #     repo=$(basename ${user_repo} .git)
    #     user=$(dirname ${user_repo})
    #     git clone ${url} ${root:-${USER}/src}/${host}/${user}/${repo}
    if (( ${#_split[*]} > 0 )) ; then
        host=${_split[0]#git@}
        suffix=${_split[1]}
        repo=$(basename ${user_repo} .git)
        target=${root:-${HOME}/src}/${host}/${suffix}/${repo}
        git clone ${url} 1>/dev/null ${target} && echo ${target}        
    else
        _error "git git url '${url}' misformed, can't clone"
    fi
}


_start() {
    local -a positionals
    while (( "$#" )); do
        case "${1}" in
            -h|--help) _help; break;;
            -v|--version) _say_version; break;;
            -u|--usage) _usage; break;;
            --root=*) root=${1#--root=*} ; shift;;
            --) shift; break;;
            -*|--*) _error "$1 unknown flag"; break;;
            *) positionals+=(${1}); shift;;
        esac
    done

    # echo "${positionals[*]} # count: ${#positionals[*]}"
    do1=${_name%*.sh}
    if (( ${#positionals[*]} == 0 )) ; then
        positionals+=(xclip -or)
    fi
    for p in "${positionals[*]}" ; do
        ${do1} ${p}
    done

}

root=${HOME}/src
_start $*

