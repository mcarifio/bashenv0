# f.mod.sh "brings" simple functional programming to bash

function f.must.have {
    : 'public, usage: f.must.have ${value} ${label} # |> ${value} if not empty && returns 0, otherwise writes an error && returns 1'
    local _self=${FUNCNAME[0]}
    local _mod_name=${_self%%.*}
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
    : 'public, usage: f.must.have+ck ${value} ${test} ${label} # |>&2 formats ${msg}, labels it an error, prints to stderr'
    : 'example: local _v=$(f.must.have+ck "${_HOME}/.bashrc" "-f" "file") # |> /home/mcarifio/.bashrc'
    local _self=${FUNCNAME[0]}
    local _mod_name=${_self%%.*}
    local _mod=${_self%.*};

    local _caller="${FUNCNAME[1]:-main}:${BASH_LINENO[0]:-0}"
    local _value=$(f.must.have "$1" "value")
    local _test=$(f.must.have "$2" "test")
    local _label=${3:-${_test}}

    case ${_test} in
         -*) test ${_test} ${_value} ;;
         *) $({_test} ${_value}) &> /dev/null ;;
    esac
    if [[ $? = 0 ]]; then
        echo "${_value}"
        return 0
    fi

    f.err "${_caller} expected a '${_label}'"
    return 1
}

function f.msg {
    local -i _status=${2:-$?}
    : 'internal, usage: f.err ${msg} [$?] # |>&2 formats ${msg}, labels it based on caller, prints to stderr'

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
    : 'public, usage: f.err ${msg} # |>&2 formats ${msg}, labels it an error, prints to stderr'
    local _self=${FUNCNAME[0]};
    local _mod_name=${_self%%.*};
    local _mod=${_self%.*};

    local _status=${2:-1}
    >&2 f.msg "$1" ${_status}
}


function f.warn {
    : 'public, usage: f.warn ${msg} # |>&2 formats ${msg}, labels it a warning, prints to stderr'
    local _self=${FUNCNAME[0]};
    local _mod_name=${_self%%.*};
    local _mod=${_self%.*};

    >&2 f.msg "$1" 
}


function f.info {
    : 'public, usage: f.info ${msg} # |>&2 formats ${msg}, labels it informational, prints to stderr'
    local _self=${FUNCNAME[0]};
    local _mod_name=${_self%%.*};
    local _mod=${_self%.*};


    >&2 f.msg "$1" 
}


function f.is.defined {
    : 'public, usage: f.is.defined ${function} # => 0 iff ${function} is a function'
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
    : 'public, usage: f.copy ${f0} ${f1} # copies function f0 to f1, removing f1'
    local _self=${FUNCNAME[0]};
    local _mod_name=${_self%%.*};
    local _mod=${_self%.*};

    local _f=$(declare -f "$1") || return $(f.err "no function $1")
    eval "${_f/$1/$2}" || f.err "$1 not copied to $2"
}


function f.rename {
    : 'public, usage: f.rename ${f0} ${f1} # renames f0 to f1'
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
    echo "function ${_f} { eval '$1'; } ; echo ${_f} ;"
}

function f.apply {
    : 'public, usage: f.apply ${f} $* # applies function ${f} to each element of $*, echoing the result iff it succeeds.'
    local _self=${FUNCNAME[0]};
    local _mod_name=${_self%%.*};
    local _mod=${_self%.*};

    local _f=$(f.must.have "$1" "function") || return $(f.err "expected a function")
    f.is.defined ${_f} || return $(f.err "${_f} not defined.")
    shift
    # If you passed a function definition, evaluate it and the use the bound function as the first argument. Brittle.
    [[ "${_f}" =~ ^"function " ]] && _f=$(eval "${_f}")

    local -a _all=($*)
    local _a
    for _a in ${_all[@]::${#_all}}; do printf '%s ' $(${_f} ${_a}) ; done
    printf '%s' $(${_f} ${_all[-1]})
    return $?
}

function f.apply0 {
    : 'public, usage: f.apply ${f} $* # applies function ${f} to each element of $*, echoing the result iff it succeeds.'
    local _self=${FUNCNAME[0]};
    local _mod_name=${_self%%.*};
    local _mod=${_self%.*};

    local _f=$(f.must.have "$1" "function") || return $(f.err "expected a function")
    f.is.defined ${_f} || return $(f.err "${_f} not defined.")
    shift
    # If you passed a function definition, evaluate it and the use the bound function as the first argument. Brittle.
    [[ "${_f}" =~ ^"function " ]] && _f=$(eval "${_f}")
    # don't quote $*
    local __; for __ in $* ; do
        local _result=$(${_f} ${__}) && [[ -n "${_result}" ]] && printf '%s ' ${_result}
    done
}

function f.apply.json {
    : 'public, usage: f.apply.json ${f} $* | jq .'
    local _self=${FUNCNAME[0]};
    local _mod_name=${_self%%.*};
    local _mod=${_self%.*};

    local _f=$(f.must.have "$1" "function") || return $(f.err "expected a function")
    f.is.defined ${_f} || return $(f.err "${_f} not defined.")
    shift

    local -a _all=($*)
    local _a
    printf '['
    # printf '%s,' ${_a[@]::${#_a}}
    for _a in ${_all[@]::${#_all}}; do printf '{"result": "%s", "status": %s},' $(${_f} ${_a}) $? ; done
    printf '{"result": "%s", "status": %s}]' $(${_f} ${_all[-1]}) $?
}



# Make this file a "module".
# Extract mod from pathname.
function pn2mod { local _result=${1##*/}; echo ${_result%%.*}; }
# Augment functions above with "module" conventions.
mod.mkmod $(pn2mod ${1:-${BASH_SOURCE[0]}}) ${2:-$(realpath -s ${BASH_SOURCE[0]})}


