# f.fn.sh brings simple functional programming to bash

function f.must.have {
    local _self=${FUNCNAME[0]};
    local _mod_name=${_self%%.*};
    local _mod=${_self%.*};

    local _caller="${FUNCNAME[1]:-main}:${BASH_LINENO[0]:-0}"
    if [[ -n "${1}" ]] ; then
        echo "${1}"
    else
        f.err "${_caller} expected a '${2:-value}'"
    fi
}


# usage: local _v=$(f.must.have+ck "$1" "file.exists" "file")
function f.must.have+ck {
    local _self=${FUNCNAME[0]};
    local _mod_name=${_self%%.*};
    local _mod=${_self%.*};

    local _caller="${FUNCNAME[1]:-main}:${BASH_LINENO[0]:-0}"
    if [[ -n "${1}" && $(${2:-false} $1) ]] ; then
        echo "${1}"
    else
        f.err "${_caller} expected a '${3:-${2:-value}}'"
    fi
}

function f.msg {
    local -i _status=${2:-$?}

    local _self=${FUNCNAME[0]};
    local _mod_name=${_self%%.*};
    local _mod=${_self%.*};

    # look up the call stack
    local _caller="${FUNCNAME[2]:-main}:${LINENO[1]:-0}"
    local _level=${FUNCNAME[1]#${_mod_name}.}
    local _text=${1:-${_level}}

    printf "%s:%s:%s| %s\n" $(date -Iminutes) ${_caller} ${_level} "${_text}"
    return ${_status}
}



function f.err {
    local _self=${FUNCNAME[0]};
    local _mod_name=${_self%%.*};
    local _mod=${_self%.*};

    local _status=${2:-1}
    >&2 f.msg "$1" ${_status}
}


function f.warn {
    local _self=${FUNCNAME[0]};
    local _mod_name=${_self%%.*};
    local _mod=${_self%.*};

    >&2 f.msg "$1" 
}


function f.info {
    local _self=${FUNCNAME[0]};
    local _mod_name=${_self%%.*};
    local _mod=${_self%.*};

    >&2 f.msg "$1" 
}


function f.is.defined {
    local _self=${FUNCNAME[0]};
    local _mod_name=${_self%%.*};
    local _mod=${_self%.*};

    [[ function ==  $(type -t $(f.must.have "$1" "function name")) ]]
}


function f.is {
    : 'private, usage: f.is ${state:-broken} # announces the current state of the implementation'
    local _self=${FUNCNAME[0]}
    local _mod_name=${_self%%.*}
    local _mod=${_self%.*}

    local _state=${1:-${FUNCNAME[1]##*.}}
    f.err "${FUNCNAME[2]:-main} is ${_state}"
    return 1
}

function f.is.broken {
    : 'private, usage: f.is.broken # indicates current function is broken'
    local _self=${FUNCNAME[0]}
    local _mod_name=${_self%%.*}
    local _mod=${_self%.*}

    # f.is broken
    ${_self%.*} ${_self##*.}
}

function f.is.tbs {
    : 'private, usage: f.is.tbs # indicates current function needs an implementation'
    local _self=${FUNCNAME[0]}
    local _mod_name=${_self%%.*}
    local _mod=${_self%.*}

    # f.is tbs
    ${_self%.*} ${_self##*.}
}




# https://stackoverflow.com/questions/1203583/how-do-i-rename-a-bash-function
function f.copy {
    local _self=${FUNCNAME[0]};
    local _mod_name=${_self%%.*};
    local _mod=${_self%.*};

    local _f=$(declare -f "$1") || f.err "no function $1"
    eval "${_f/$1/$2}" || f.err "$1 not copied to $2"
}


function f.rename {
    local _self=${FUNCNAME[0]};
    local _mod_name=${_self%%.*};
    local _mod=${_self%.*};

    f.copy "$@" || return 1
    unset -f "$1" || f.err "could not remove $1"
}


function f.id { echo $1; }
function f.true { echo $1; }
function f.none { : ; }
function f.false { : ; }


# Italian anonymous function. Creates a string with is a function definition suitable for eval.
# $1 is the entire expression body. When evaluated, it creates a new function wrapping the expression.
# Parameters from the call are bound in the usual way, $1 $2 etc.
function f.lambda {
    local _f=${2:-__}
    echo "function ${_f} { eval '$1'; } ; echo ${_f};"
}

function f.apply {
    local _self=${FUNCNAME[0]};
    local _mod_name=${_self%%.*};
    local _mod=${_self%.*};

    local _f=$(f.must.have "$1" "function") ; shift
    # If you passed a function definition, evaluate it and the use the bound function as the first argument. Brittle.
    [[ "${_f}" =~ ^"function " ]] && _f=$(eval "${_f}")
    # don't quote $*    
    local __; for __ in $* ; do
        local _result=$(${_f} ${__}) && [[ -n "${_result}" ]] && printf '%s ' ${_result}
    done
}



# Glad this works. Very brittle.
# Usage: f.apply.json ${function} ${list} | jq .
function f.jsonify {
    local _status=$?
    printf '{"result": "%s", "status": %s}' $1 ${_status}  
}


function f.wrap {
    printf "function $1 { f.jsonify \$($2 \$1); }"
}


function f.apply.json {
    local _self=${FUNCNAME[0]};
    local _mod_name=${_self%%.*};
    local _mod=${_self%.*};

    local _f=$(f.must.have "$1" "function") ; shift
    local _wrapped=f.wrap.${_f}
    eval "$(f.wrap ${_wrapped} ${_f})" || f.err "${_wrapped} cannot wrap ${_f} $?"

    # don't quote $*
    local _result=$(f.apply ${_wrapped} $*)
    echo "[${_result//\} \{/\}, \{}]"
}


# Make this file a "module".
# Extract mod from pathname.
function pn2mod { local _result=${1##*/}; echo ${_result%%.*}; }
# Augment functions above with "module" conventions.
mod.mkmod $(pn2mod ${1:-${BASH_SOURCE[0]}}) ${2:-$(realpath -s ${BASH_SOURCE[0]})}


