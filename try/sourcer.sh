#!/usr/bin/env bash
_me=$(realpath ${BASH_SOURCE})
_here=$(dirname ${_me})
_name=$(basename ${_me} .sh)

# ugly abstraction; --from=3 means da-source.sh reports `from` on file descriptor 3.

_exec() {
    declare -i _start=${2:-3}
    declare -i _end=(( _start + ${#${1[*]}} ))
    for fd in {${_start}..${_end}} ; do
        exec 3<> <(:) ;
    done
}

_to_args {
    local _args=${1}
    local _result=''
    for _k in $${_args[*]} ; do $_result +=" ${_k}=$${_args[${_k}]}" ; done
    echo ${_result}
}


_gather() {
    local _args=${1}
    declare -A _result=( $${_args} )
    for _k in $${_args[*]} ; do read -u $${_args[${_k}]} _result[${_k}]} ; done
    
}

declare -A _coupling=( --from, --there, --why )
_exec _coupling
source ${_here}/da-source.sh $(_to_args _coupling)
declare -A _results
_gather _coupling _results
echo ${_results[*]}




