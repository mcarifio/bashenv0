#!/usr/bin/env bash
# -*- mode: shell-script; -*- # eval: (setq-local indent-tabs-mode nil tab-width 4 indent-line-function 'insert-tab) -*-
#!/usr/bin/env -S sudo -i /usr/bin/env bash # run as root under sudo

# __fw__ framework
source __fw__.sh || { >&2 echo "$0 cannot find __fw__.sh"; exit 1; }
# trap '_catch --lineno default-catcher $?' ERR

# Specific option parsing
function _fw_start {
    local _self=${FUNCNAME[0]}

    declare -Ag _flags+=([--force]='' [--systemd]='')
    local -a _rest=()
    
    while (( $# )); do
        local _it=${1}
        case "${_it}" in
            --force) _flags[--force]='--force' ;;
            --systemd) _flags[--systemd]='--systemd';;
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

function _start-USER.sh {
    declare -Ag _flags
    local _root=${XDG_DATA_DIR:-~/.local/share}

    ln -sr ${_flags[--force]} -t ${HOME} ${_here}/.bash_* || true
    ln -sr ${_flags[--force]} -t ${HOME} ${_here}/.gdbinit || true

    # graft subfolders here into ${HOME} using relative symlinks.
    ${_here}/.config/ln.sh ${_flags[--force]}
    ${_here}/.local/share/ln.sh ${_flags[--force]} ${_flags[--systemd]}
}


# skip specific option parsing
# _start_at --start=_start-${_basename} $@

# add specific option parsing
_start_at --start=_fw_start --forward=_start-${_basename} $@
