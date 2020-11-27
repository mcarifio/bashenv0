#!/usr/bin/env bash
_me=$(realpath ${BASH_SOURCE})
_here=$(dirname ${_me})
_name=$(basename ${_me} .sh)

# declare -A _coupling=( --from, --there, --why )
# _exec _coupling
# source ${_here}/da-source.sh $(_to_args _coupling)
# declare -A _results
# _gather _coupling _results
# echo ${_results[*]}
# source ${_here}/da-source.sh $(_to_args _coupling)

_s() {
    local _fdname=''
    case $1 in
        --fdname=*) _fdname=${1#--fdname=}; shift;;
    esac    
    local _src=${1:?'src file'} ; shift
    local _ffdname=${FUNCNAME[0]}
    # trap "eval 'exec ${_fd}>&-'" RETURN # close descriptor always
    # https://superuser.com/questions/184307/bash-create-anonymous-fifo
    eval "exec {${_ffdname}}<> <(:)"
    if [[ -r ${_src} ]] ; then
        source ${_src} --fdname=${_ffdname} $* &> /dev/null
        local _status=$?
        declare -i timeout=2
        local _result="{timeout: ${timeout}, result: {}}"
        read -t ${timeout} -u ${!_ffdname}
        _result=${REPLY:=${_result}}
        # echo "${_result}"
        [[ -n "${_fdname}" ]] && eval "echo '${_result}' >&${!_fdname}"
        return ${_status}
    else
        echo "${_src} not found" > /dev/stderr
        return 1
    fi
}

eval "exec {${_name}}<> <(:)"
_s --fdname=${_name} ${_here}/da-source.sh $*
if read -t 2 -u ${!_name} _s_result ; then
    ( set -x ; jq -srC . <<< ${_s_result} )
fi



