#!/usr/bin/env bash

#!/usr/bin/env bash
# -*- mode: shell-script; -*- # eval: (setq-local indent-tabs-mode nil tab-width 4 indent-line-function 'insert-tab) -*-
#!/usr/bin/env -S sudo -i /usr/bin/env bash # run as root under sudo

# __fw__ framework
source __fw__.sh || { >&2 echo "$0 cannot find __fw__.sh"; exit 1; }
trap '_catch --lineno default-catcher $?' ERR

# Specific option parsing
function _fw_start {
    local _self=${FUNCNAME[0]}

    declare -Ag _flags+=([--compress]=xz [--stop]=0 [--restart]=1 )
    local -a _rest=()
    
    while (( $# )); do
        local _it=${1}
        case "${_it}" in
            --compress=*) _flags[--compress]=${_it#--compress=};;
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
function _start {
    declare -Ag _flags

    local -i _process=$(pgrep thunderbird 2 > /dev/null)
    if [[ -n "${_process}" && (( ${_stop} )) ]] ; then
        pkill thunderbird
    else
        f.err "Thunderbird is running. Stop it and retry ${_name} or use ${_name} --stop"
    fi    
    find ${_here}/.. -type \*.msf -exec ${_flags[--compress]} {} \;
    _process=$(pgrep thunderbird 2 > /dev/null)
    [[ -z "${_process}" ]] && thunderbird && f.info "started thunderbird"
}

_start_at --start=_fw_start --forward=_start
