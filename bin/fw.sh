#!/usr/bin/env bash

# load __fw__ bash framework
source __fw__.sh || { >&2 echo "$(realpath -s ${BASH_SOURCE}) cannot find __fw__.sh"; exit 1; }

function _start {
    declare -Ag _flags
    local _k; for _k in  ${!_flags[*]}; do printf '%s:%s ' ${_k} ${_flags[${_k}]}; done; echo $*
}

_start_at --start=_start $@
