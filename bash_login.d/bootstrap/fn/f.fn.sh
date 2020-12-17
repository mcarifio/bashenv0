# f.fn.sh brings simple functional programming to bash

function f.__template__ {
    local _self=${FUNCNAME[0]}
    local _fn=${_self%%.*}

    u.value $(${_fn}.fn.pathname)
}

function f.fn.defines {
    local _self=${FUNCNAME[0]}
    local _fn=${_self%%.*}

    export -f  2>&1 | grep "declare -fx ${_fn}."
}
export -f f.fn.defines

function f.fn.pathname {
    local _self=${FUNCNAME[0]}
    local _fn=${_self%%.*}

    u.value $(me.pathname)    
}
export -f f.fn.pathname

# Reload this file. Todo: using inotify to reload automatically.
function f.fn.reload {
    local _self=${FUNCNAME[0]}
    local _fn=${_self%%.*}

    verbose=1 u.source $(${_fn}.fn.pathname)
}
export -f f.fn.reload


# usage: local _v=$(f.must.have+ck "$1" "file.exists" "file")
function f.must.have+ck {
    local _self="${FUNCNAME[0]}"
    local _fn=${_self%%.*}

    local _caller="${FUNCNAME[1]:-main}:${BASH_LINENO[0]:-0}"
    if [[ -n "${1}" && $(${2:-false} $1) ]] ; then
        echo "${1}"
    else
        f.err "${_caller} expected a '${3:-${2:-value}}'"
    fi
}
export -f f.must.have+ck

function f.must.have {
    local _self="${FUNCNAME[0]}"
    local _fn=${_self%%.*}

    local _caller="${FUNCNAME[1]:-main}:${BASH_LINENO[0]:-0}"
    if [[ -n "${1}" ]] ; then
        echo "${1}"
    else
        f.err "${_caller} expected a '${2:-value}'"
    fi
}
export -f f.must.have


function f.msg {
    local -i _status=${2:-$?}
    local _self="${FUNCNAME[0]}"
    local _fn=${_self%%.*}

    # look up the call stack
    local _caller="${FUNCNAME[2]:-main}:${LINENO[1]:-0}"
    local _level=${FUNCNAME[1]#f.}
    local _text=${1:-${_level}}

    printf "%s:%s:%s| %s\n" $(date -Iminutes) ${_caller} ${_level} "${_text}"
    return ${_status}
}
export -f f.msg

function f.err {
    local _self=${FUNCNAME[0]}
    local _fn=${_self%%.*}

    local _status=${2:-1}
    >&2 f.msg "$1" ${_status}
}
export -f f.err

function f.warn {
    local _self="${FUNCNAME[0]}"
    local _fn=${_self%%.*}

    >&2 f.msg "$1" 
}
export -f f.warn

function f.info {
    local _self="${FUNCNAME[0]}"
    local _fn=${_self%%.*}

    >&2 f.msg "$1" 
}
export -f f.info




function f.is.defined {
    local _self=${FUNCNAME[0]}
    local _fn=${_self%%.*}

    [[ function ==  $(type -t $(u.must.have "$1" "function name")) ]]
}
export -f f.is.defined

# https://stackoverflow.com/questions/1203583/how-do-i-rename-a-bash-function
function f.copy {
    local _self=${FUNCNAME[0]}
    local _fn=${_self%%.*}

    test -n "$(declare -f \"$1\")" || return
    eval "${_/$1/$2}"
}
export -f f.copy

function f.rename {
    local _self=${FUNCNAME[0]}
    local _fn=${_self%%.*}

    f.copy "$@" || return
    unset -f "$1"
}
export -f f.rename






function f.apply {
    local _self=${FUNCNAME[0]}
    local _fn=${_self%%.*}

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
    local _fn=${_self%%.*}

    local _p1=$(f.must.have "$1" "predicate"); shift
    f.apply ${_p1} $*
}
export -f f.filter
