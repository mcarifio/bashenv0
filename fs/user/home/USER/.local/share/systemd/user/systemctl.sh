#!/usr/bin/env bash
# -*- mode: shell-script; -*- # eval: (setq-local indent-tabs-mode nil tab-width 4 indent-line-function 'insert-tab) -*-
#!/usr/bin/env -S sudo -i /usr/bin/env bash # run as root under sudo

# __fw__ framework
source __fw__.sh || { >&2 echo "$0 cannot find __fw__.sh"; exit 1; }
trap '_catch --lineno default-catcher $?' ERR

# Specific option parsing
function _fw_start {
    local _self=${FUNCNAME[0]}

    declare -Ag _flags+=([--template-flag]=default)
    local -a _rest=()
    
    while (( $# )); do
        local _it=${1}
        case "${_it}" in
            --template-flag=*) _flags[--template-flag]=${_it#--template-flag=};;
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

function _do_command {
    local _command=$(f.must.have "$1" "command") || exit 1
    systemctl --user ${_command} $(basename -as ${_here}/!(*.sh|*.gz|*.xz))
    
}

function _dispatch_status {
    _do_command status
}

function _dispatch_enable {
    _do_command enable
}

function _dispatch_disable {
    _do_command disable
}

function _dispatch_start {
    _do_command start
}

function _dispatch_stop {
    _do_command stop
}



function _dispatch {
    local _command=$(f.must.have "$1" "command") || exit 1
    if [[ status = ${_command} ]] ; then
        _dispatch_status
    else
        systemctl --user daemon-reload
        _dispatch_${_command}
    fi
}

# skip specific option parsing
# _start_at --start=_start $@

# add specific option parsing
_start_at --start=_fw_start --forward=_dispatch $@
