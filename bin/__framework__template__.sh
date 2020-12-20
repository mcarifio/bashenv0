#!/usr/bin/env bash
# -*- mode: shell-script; -*- # eval: (setq-local indent-tabs-mode nil tab-width 4 indent-line-function 'insert-tab) -*-
#!/usr/bin/env -S sudo -i /usr/bin/env bash # run as root under sudo

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
_ap_shell=$(realpath /proc/$$/exe) # absolute pathname of current shell
_shell=$(basename ${_ap_shell}) # current shell: 'bash' (unless you change the shebang line).
_version="0.0.1"

source utils.lib.sh &> /dev/null || true
source ${_me}.conf &> /dev/null || true
source ${_here}/__framework__.sh
trap '_catch ${LINENO} default-catcher $?' ERR


# Parse specific flags and values. Display them if needed.
function _fw_start {
    local _self=${FUNCNAME[0]}

    declare -Ag _flags+=([--eval]=echo)
    local -a _rest=()

    # default flag values
    # _flags[--template_flag]='template'
    # _flags[--specific_flag]='specific'
    _flags[--template_flag]='template'
    _flags[--specific_flag]='specific'
    
    while (( $# )); do
        local _it=${1}
        case "${_it}" in
            # --template-flag=*) _flag[--template_flag]=${_it#--template-flag=};;
            # --specific-flag=*) _flag[--specific_flag]=${_it#--specific-flag=};;
            --template-flag=*) _flags[--template_flag]=${_it#--template-flag=};;
            --specific-flag=*) _flags[--specific_flag]=${_it#--specific-flag=};;
            --eval) _flags[--eval]=eval;;
            --) shift; _rest+=($*); break;;
            -*|--*) _catch --exit=1 --print ${LINENO} "$1 unknown flag" ;;
            *) _rest+=(${_it});;
        esac
        shift
    done


    if (( ${_flags[--verbose]} )) ; then
        printf "${_self} "
        local _k; for _k in ${!_flags[*]}; do printf '%s=%s ' ${_k} ${_flags[${_k}]}; done;
        printf '%s ' ${_rest[*]}
        echo
    fi

    ${_flags[--forward]} ${_rest[*]}
}


# __framework__template.sh --eval a_file.sh will run emacsclient on a_file.sh
# approximately here. Remove this function and change the invocation below.
function _fw_start0 {
    local -r _self=${FUNCNAME[0]}

    declare -Ag _flags

    if [[ -z "$1" ]] ; then
        echo "ec +${LINENO[0]} ${_me}"
    else
        local -r _f=$1
        cp -v ${_me} ${_f}
        chmod a+x ${_f}
        local -r _command="emacsclient --no-wait +$(( ${LINENO[0]} - 6 )) $(realpath -s ${_f})"
        ${_flags[--eval]} ${_command}
    fi        
}

function _start {
    local -r _self=${FUNCNAME[0]}

    declare -Ag _flags

    echo "modify ${_me}/${_self} at ${LINENO[0]}"

}

# change this
_start_at --forward=_fw_start0 $@
# to this:
# _start_at $@ # short for: _start_at --start=_fw_start --forward=_start $@




