#!/usr/bin/env bash
# -*- mode: shell-script; -*- # eval: (setq-local indent-tabs-mode nil tab-width 4 indent-line-function 'insert-tab) -*-
#!/usr/bin/env -S sudo -i /usr/bin/env bash # run as root under sudo

# usage: ./user.sh # copies user/*.system into ~/.local/share/systemd/use/ then enable and start each service

# __fw__ framework
source __fw__.sh || { >&2 echo "$0 cannot find __fw__.sh"; exit 1; }
# trap '_catch --lineno --status=$? error' ERR

# Specific option parsing
function _fw_start {
    local _self=${FUNCNAME[0]}

    declare -Ag _flags+=() # [--template-flag]=default)
    local -a _rest=()
    
    while (( $# )); do
        local _it=${1}
        case "${_it}" in
            # --template-flag=*) _flags[--template-flag]=${_it#--template-flag=};;
            --) shift; _rest+=($*); break;;
            -*|--*) _catch --exit=1 --print --lineno "${_it} unknown flag" ;;
            *) _rest+=(${_it});;
        esac
        shift
    done

    # echo the command line with default flags added.
    if (( ${_flags[--verbose]} )) ; then
        printf "${_self} "
        local _k; for _k in ${!_flags[*]}; do printf '%s=%s ' ${_k} ${_flags[${_k}]}; done;
        printf '%s ' ${_rest[*]}
        echo
    fi

    # All options parsed (or defaulted). Do the work.
    ${_flags[--forward]} ${_rest[*]}
}


# Specific work.
function _start-echo {
    declare -Ag _flags
    local _k; for _k in  ${!_flags[*]}; do printf '%s:%s ' ${_k} ${_flags[${_k}]}; done; echo $*
}

function _unit {
    local _u=$(basename $(f.must.have "$1" "unit")) || return 1
    systemctl --user reenable ${_u}
    systemctl --user reload-or-restart ${_u}
}

function _start-user.sh {
    declare -Ag _flags

    systemctl --user daemon-reload
    # https://www.linuxjournal.com/content/bash-extended-globbing
    # https://unix.stackexchange.com/questions/157541/parenthesis-works-in-bash-shell-itself-but-not-in-bash-script
    local _s
    for _s in $(basename -as ${_here}/${_name}/!(*.mount|*.xz|*.gz|*~)); do _unit ${_s}; done
}


# skip specific option parsing
# _start_at --start=_start $@

# add specific option parsing
_start_at --start=_fw_start --forward=_start-${_basename} $@

