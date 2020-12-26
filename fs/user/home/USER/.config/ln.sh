#!/usr/bin/env bash
# -*- mode: shell-script; -*- # eval: (setq-local indent-tabs-mode nil tab-width 4 indent-line-function 'insert-tab) -*-
#!/usr/bin/env -S sudo -i /usr/bin/env bash # run as root under sudo

# [[ -z "${BASHENV}" ]] && source ~/.bash_login
# __fw__ framework
source __fw__.sh || { >&2 echo "$0 cannot find __fw__.sh"; exit 1; }
# trap '_catch --lineno default-catcher $?' ERR

# Specific option parsing
function _fw_start {
    local _self=${FUNCNAME[0]}

    declare -Ag _flags+=([--force]='') # [--template-flag]=default)
    local -a _rest=()
    
    while (( $# )); do
        local _it=${1}
        case "${_it}" in
            # --template-flag=*) _flags[--template-flag]=${_it#--template-flag=};;
            --) shift; _rest+=($*); break;;
            --force) _flags[--force]='--force' ;;
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
    local _k; for _k in  ${!_flags[*]}; do printf '%s:%s ' ${_k} ${_flags[${_k}]}; done
    echo $*
}

function _start-ln.sh {
    local _self=${FUNCNAME[0]}
    declare -Ag _flags
    local _top=$(realpath ${_here} --relative-to ${_here}/..)
    local _target=~/${_top}
    local -a _folders=$(find ${_here} -mindepth 1 -maxdepth 1 -type d ! -name .attic -exec realpath --relative-to ${_here/..} {} \;)
    ln -vsrdf ${_flags[--force]} -t ${_target} ${_folders[*]} || true
    &> /dev/null find ${_here} -name Makefile -type f -exec make -f {} \; || true
}

_start_at --start=_fw_start --forward=_start-ln.sh

