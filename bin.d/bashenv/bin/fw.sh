#!/usr/bin/env bash

# Simulate installation. Gross.
shopt -s extglob
[[ -z "${BASHENV}" && -f ~/.bash_login ]] && source ~/.bash_login || true
if [[ -z "${BASHENV}" ]] ; then
    local _xdg_data_home=${XDG_DATA_HOME:-~/.local/share}
    [[ -d ${_xdg_data_home} ]] || { >&2 echo "${xdg_data_home} not found."; return 1; }
    export BASHENV=${_xdg_data_home}
    source ${BASHENV}/load.mod.sh
    path.add $(path.bins)
fi

# load __fw__ bash framework
source __fw__.sh || { >&2 echo "$(realpath -s ${BASH_SOURCE}) cannot find __fw__.sh"; exit 1; }

function _start {
    declare -Ag _flags
    local _k; for _k in  ${!_flags[*]}; do printf '%s:%s ' ${_k} ${_flags[${_k}]}; done; echo $*
}

_start_at --start=_start $@
