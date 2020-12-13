# f.fn.sh brings simple functional programming to bash

function f.__template__ {
    local _self=${FUNCNAME[0]}
    echo ${_self} tbs
}
export -f f.__template__


# usage: local _v=$(f.must "$1" "pathname")
function f.must.have {
    local _self="${FUNCNAME[0]}"
    local _caller="${FUNCNAME[1]:-main}:${BASH_LINENO[1]:-0}"
    if [[ -z "${1}" ]] ; then
        f.err "${_caller} expected a '${2}'"
    else
        echo "${1}"
    fi
}
export -f f.must.have

function f.msg {
    local -i _status=${2:-$?}
    local _self="${FUNCNAME[0]}"
    # look up the call stack
    local _caller="${FUNCNAME[2]:-main}:${LINENO[2]:-0}"
    local _level=${FUNCNAME[1]#f.}
    local _text=${1:-${_level}}

    printf "%s:%s:%s| %s\n" $(date -Iminutes) ${_caller} ${_level} "${_text}"
    return ${_status}
}
export -f f.msg

function f.err {
    local _self=${FUNCNAME[0]}
    local _status=${2:-1}
    >&2 f.msg "$1" ${_status}
}
export -f f.err

function f.warn {
    local _self="${FUNCNAME[0]}"
    >&2 f.msg "$1" 
}
export -f f.warn

function f.info {
    local _self="${FUNCNAME[0]}"
    >&2 f.msg "$1" 
}
export -f f.info




function f.is.defined {
    local _self=${FUNCNAME[0]}
    [[ function ==  $(type -t $(u.must.have "$1" "function name")) ]]
}
export -f f.is.defined

# https://stackoverflow.com/questions/1203583/how-do-i-rename-a-bash-function
function f.copy {
    local _self=${FUNCNAME[0]}
    test -n "$(declare -f \"$1\")" || return
    eval "${_/$1/$2}"
}
export -f f.copy

function f.rename {
    local _self=${FUNCNAME[0]}
    f.copy "$@" || return
    unset -f "$1"
}
export -f f.rename






function f.apply {
    local _self=${FUNCNAME[0]}
    local _f=$(f.must.have "$1" "function") ; shift
    # don't quote $*
    for i in $* ; do
        local _result=$(${_f} ${i}) && [[ $? && -n "${_result}" ]] && printf '%s ' ${_result}
    done
    # echo
}
export -f f.apply

function f.filter {
    local _self=${FUNCNAME[0]}
    local _p1=$(f.must.have "$1" "predicate"); shift
    f.apply ${_p1} $*
}
export -f f.filter
