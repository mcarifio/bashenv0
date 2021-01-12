#!/usr/bin/env bash
# -*- mode: shell-script; eval: (setq indent-tabs-mode nil tab-width 4 indent-line-function 'insert-tab) -*-
# @author: Mike Carifio <mike@carif.io>
# Note that emacs can be configured for [editorconfig](https://editorconfig.org/)
#   with [editorconfig-emacs](https://github.com/editorconfig/editorconfig-emacs)

# usage:
#    * directly: `bindmount-home [--mnt=${HOME}/mnt] [--kinds=zfs,tmp] [${folder}...]`
#    * systemd: `cp ../home/.config/systemd/user/bindmount-home.service ~/.config/systemd/user # must be a cp, not a symlink
#                systemctl --user daemon-reload
#                systemctl --user enable bindmount-home.service
#                systemctl --user start bindmount-home.service
#                systemctl --user status bindmount-home.service
# then: `tree -aCF ~/mnt`


# __fw__ framework
[[ -z "${BASHENV}" ]] && source ~/.bash_login
source __fw__.sh || { >&2 echo "$0 cannot find __fw__.sh"; exit 1; }
# trap '_catch --lineno default-catcher $?' ERR

# bindmount-home.sh options parsing
function _fw_start {
    local _self=${FUNCNAME[0]}

    declare -Ag _flags+=([--mnt]=${HOME}/mnt [--kinds]='zfs,tmp')
    local -a _rest=()
    
    while (( $# )); do
        local _it=${1}
        case "${_it}" in
            # --template-flag=*) _flags[--template-flag]=${_it#--template-flag=};;
            --mnt=*) _flags[--mnt]=${_it#--mnt=};;
            --kinds=*) _flags[--kinds]=${_it#--kinds=};;
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

    # All options parsed (or defaulted). Finally do the work.
    ${_flags[--forward]} ${_rest[*]}
}


# test invocation: bindmount-home.sh --forward=_start-echo ... rest of args ...
function _start-echo {
    declare -Ag _flags
    local _k; for _k in ${!_flags[*]}; do printf '%s:%s ' ${_k} ${_flags[${_k}]}; done; echo $*
}


function bindmount-home-zfs {
    # snap chromium doesn't let user see files outside $HOME
    # for all zfs pool mount points mp ...
    local _mnt=$(f.must.have "$1" "mount point") || return 1
    file.mkdir ${_mnt}

    local _zfsmp
    for _zfsmp in $(zfs list -o mountpoint|tail -n1); do
        # ... if that mount point has a "user area" for $USER ...
        local _from=${_zfsmp}/${USER}
        if [[ -d ${_from} ]] ; then
            local _to=${_mnt}/zfs/pool/${_zfsmp}
            file.mkdir ${_to}
            sudo mount --bind ${_from} ${_to}
        fi
    done    
}

function bindmount-home-tmp {
    # snap chromium doesn't let user see files outside $HOME
    # for all zfs pool mount points mp ...
    local _mnt=$(f.must.have "$1" "mount point" "-d") || return 1
    file.mkdir ${_mnt}

    local _tmpmp
    for _tmpmp in /tmp; do
        local _n=$(basename ${_tmpmp})
        local _from=${_tmpmp}/${USER}/${_n}
        file.mkdir ${_from}
        local _to=${_mnt}/tmp/${_n}
        file.mkdir ${_to}
        sudo mount --bind ${_from} ${_to}
    done    
}



function bindmount-home-dirs {
    # snap chromium doesn't let user see files outside $HOME
    # for all zfs pool mount points mp ...
    local _mnt=$(f.must.have "$1" "mount point" "-d") || return 1
    local _from=$(f.must.have "$2" "mount point" "-d") || return 1
    file.mkdir ${_mnt}

    local _d
    for _d in $*; do
        local _n=$(basename ${_d})
        local _from=${_d}
        local _to=${_mnt}/${_n}
        file.mkdir ${_to}
        sudo mount --bind ${_from} ${_to}
    done    
}


# After all the argument parsing, start here.
# 
function _start-bindmount-home {
    local _mnt=${_flags[--mnt]:-${HOME}/mnt}
    file.mkdir ${_mnt}
    local IFS=' '
    local _k; for _k in ${_flags[--kinds]//,/ }; do bindmount-home-${_k} ${_mnt}; done
    local _d; for _d in $*; do bindmount-home-dirs ${_mnt} ${_d} ; done
}


# skip specific option parsing
# _start_at --start=_start $@

# @see _start-echo to test invocation
_start_at --start=_fw_start --forward=_start-bindmount-home $@

