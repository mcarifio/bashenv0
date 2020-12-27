#!/usr/bin/env bash
# -*- mode: shell-script; -*- # eval: (setq-local indent-tabs-mode nil tab-width 4 indent-line-function 'insert-tab) -*-
#!/usr/bin/env -S sudo -i /usr/bin/env bash # run as root under sudo with login

# @author: Mike Carifio <mike@carif.io>
# Note that emacs can be configured for [editorconfig](https://editorconfig.org/)
#   with [editorconfig-emacs](https://github.com/editorconfig/editorconfig-emacs)


# usage: __simple_template__.sh ${script_pathname:-simple.sh} ${editor:-emacsclient}
# note: to create simple.sh without editing: __simple_template__.sh ${script_name} true


set -euo pipefail
# If passing an array in a function, modify IFS or comment out.
# IFS=$'\n\t'
IFS=$'\n\t'


_me=$(realpath -s ${BASH_SOURCE:-$0})
_here=$(dirname ${_me})
_name=$(basename ${_me} .sh)
_shell=$(realpath /proc/$$/exe) # current shell


source utils.lib.sh &> /dev/null || true
source ${_me}.conf &> /dev/null || true


##### remove start

# note _edit ignores $1 so arguments the same as _start_mk
function _edit {
    local _self=${FUNCNAME[0]}
    local _command=${2:-emacsclient}
    (( $(emacsclient --no-wait --eval '(length (frame-list))') <= 1 )) && _command+=' --create-frame'
    _command+=" --no-wait +${BASH_LINENO[0]} ${_me}"
    if [[ -z "$2" ]] ; then
        echo ${_command}
    else
        env -S ${_command}
    fi 
        
}

function _mk {
    local _exe=$(realpath $1)
    local _e=${2:-emacsclient}
    sed s/^_start_mk/_edit/g ${_me} >| ${_exe} # noclobber isn't working
    chmod a+x ${_exe}
    exec ${_exe} ${_exe} ${_e}
}

function _start_usage {
    local _self=${FUNCNAME[0]}
    # _run $*
    _edit ${LINENO}
}

function _start_mk {
    local _s=${1:-simple.sh} ; shift
    local _e=${1:-emacsclient} ; shift
    if [[ ${_name} = __simple_template__ ]] ; then
        _mk ${_s} ${_e}
    else
        _start_usage $@
    fi
}

function _instance {
    local _i=$(basename ${_me})
    _i=${_i/_template__/}
    _i=${_i/__/}
    echo $_i
}

##### remove end



function _run {
    local _self=${FUNCNAME[0]}
    >&2 printf "%s:%s/%s" ${_me} ${LINENO} ${_self}
    for a in $*; do >&2 printf " %s" $a ; done
    >&2 echo
}

function _start {
    id; echo ${_shell}
    _run $*
}

# _start $@
_start_mk ${1:-$(_instance)} ${2:-'emacsclient'}





