# utility functions
# test with ./u.fn.test.sh

function u.pn2mod {
    : 'public, usage: u.pn2mod ${pathname} # extract the module name in a pathname, e.g. some/path/mod.mod.sh => mod.mod.sh'
    local _self=${FUNCNAME[0]}
    local _mod_name=${_self%%.*};
    local _mod=${_self%.*};

    u.re+extract $(f.must.have "$1" "string") ^".*/"'([^.]+).?'
}

# Find the possible pathnames given a module name based on naming conventions and locations. Generally should find a single pathname.
function u.mod2pn {
    : 'public, usage: u.mod2pn ${mod} # Find pathname candidates to load along PATH given ${mod}'
    local _self=${FUNCNAME[0]}
    local _mod_name=${_self%%.*};
    local _mod=${_self%.*};

    local _that_mod=$(f.must.have "$1" module) || return 1    

    find $(be.root)/bash_login.d -type f -perm /222 -name ${_that_mod}.mod.sh -print0 | xargs --null -n1 realpath
}

function u.mod+exists {
    : 'public, usage: u.mod+exists ${mod} # returns 1 iff ${mod} is loaded.'
    local _mod=$(f.must.have "$1" module) || return 1
    ${_mod}.mod.exists &> /dev/null
}

function u.have.command {
    : 'public, usage: u.have.command ${cmd}... # returns 1 iff all ${cmd}s are on PATH'
    : 'example: u.have.command gh emacs /bin/ls && echo "have em all"'
    local _self=${FUNCNAME[0]}
    local _mod_name=${_self%%.*}
    local _mod=${_self%.*}

    local _command=$(f.must.have "$1" "expecting a command on PATH") || return 1
    local _c; for _c in $*; do type ${_c} &> /dev/null || return 1 ; done
}

function u.usage {
    : 'public, usage: u.usage ${function} # extract a usage string from a bash function'
    local _self=${FUNCNAME[0]}
    local _mod_name=${_self%%.*}
    local _mod=${_self%.*}

    local _f=$(f.must.have "$1" "function name") || return
    [[ "function" = $(type -t ${_f}) ]] || { >&2 echo "{_f} not a function"; return 1; }
    # Note:
    # * need gnu grep to handle \s in regular expression below
    # * relies on author cooperation to use, e.g a "noop" command that looks like ': ... usage: ...'
    # The usage string can be anywhere in the function, but the first line makes sense.
    # Note that bash ':' still evaluates it's arguments, hence a literal string after ':'.
    type ${_f} | grep --extended-regexp '^\s+:\s.*\busage\s*:\s*'
}


# usage: 
# note: you can match with extract if no group 1 in pattern.
function u.re1 {
    : 'public, usage: u.re+extract ${string} ${pattern} [${group:-1}] # => ${matched:string} (status 0) or "" (status 1)'
    local _self=${FUNCNAME[0]}
    local _mod_name=${_self%%.*}
    local _mod=${_self%.*}

    local _string=$(f.must.have "$1" "string")
    local _pattern=$(f.must.have "$2" "re-pattern")
    local -i _group=${3:-1}

    [[ "${_string}" =~ ${_pattern} ]] && echo -n ${BASH_REMATCH[${_group}]}
}

# Does the function's name follow the mod naming convention ${name}.(mod.)?something.
# Not exactly sure what good this is.
function u.modly+named {
    : 'public, usage: u.modly+named ${function} # => return 1 iff ${function} follows the mod naming convention.'
    local _self=${FUNCNAME[0]}
    local _mod_name=${_self%%.*};
    local _mod=${_self%.*};

    local _fn=$(f.must.have "$1" "function name")

    # TODO mike@carif.io: last . not working?
    u.re1 ${_fn} '^[^.]+.[^.]+.'  # x.y.z => y
}

function u.get+mod {
    : 'public, usage: u.get+mod ${function} # => ${mod} of ${function} e.g. u.get+mod u.get+mod => "u"'
    local _self=${FUNCNAME[0]}
    local _mod_name=${_self%%.*};
    local _mod=${_self%.*};

    local _fn=$(f.must.have "$1" "function name")

    # TODO mike@carif.io: last . not working?
    u.re+extract ${_fn} '^([^.]+).'  # x.y.z => y

}

# Export an environment variable iff it's value passes a test.
# unset FOO; u.env.export -z FOO -d ${HOME} ; echo $FOO |> /home/mcarifio  # assign env var FOO to directory home iff FOO is unassigned
# u.env.export -z FOO -d /root; echo $FOO |> /home/mcarifio # FOO already assigned, therefore untouched. A kind of "noclobber".
# u.env.export true FOO -d /root |> /root # true is always true
function u.env.export {
    : 'public, usage: u.env.export ${test} ${name} ${test} ${value} # assigns exports ${name}=${value} if both pass tests'
    : 'example: u.env.export -z TRY -n "${HOME}" # exports TRY if it is not assigned with $HOME if it has a value.'
    local _self=${FUNCNAME[0]}
    local _mod_name=${_self%%.*}
    local _mod=${_self%.*}

    local _name_test=$(f.must.have "$1" "name predicate") || return 1
    local _name=$(f.must.have "$2" "name") || return 1
    local _value_test=$(f.must.have "$3" "value predicate") || return 1
    local _value=$(f.must.have "$4" "value") || return 1

    case ${_name_test} in
        -*) test ${_name_test} ${_name} || return 0 ;;
        *) ${_name_test} ${_name} &> /dev/null || return 0 ;;
    esac

    case ${_value_test} in
        -*) test ${_value_test} ${_value} || return 0 ;;
        *) ${_value_test} ${_value} &> /dev/null || return 0 ;;
    esac

    export "${_name}"="${_value}"
}


# when called in a script, knows if the script file has been sourced. not currently working.
function u.script.sourced {
    : 'public, usage: u.usage ${function} # extract a usage string from a bash function'
    local _self=${FUNCNAME[0]}
    local _mod_name=${_self%%.*};
    local _mod=${_self%.*};

    local _left="${BASH_SOURCE[0]}"
    local _right="${0}"
    [[ ${_left} != ${_right} ]] && echo ${_left}
}

function u.script.run {
    : 'public, usage: u.script.run # => ${pathname}, the file actually run'
    local _self=${FUNCNAME[0]}
    local _mod_name=${_self%%.*};
    local _mod=${_self%.*};

    local _left="${BASH_SOURCE[0]}"
    local _right="${0}"
    [[ ${_left} = ${_right} ]] && echo ${_left}
}


# https://www.gnu.org/software/bash/manual/html_node/The-Shopt-Builtin.html
function u.init.shopt {
    : 'public, usage: u.init.shopt # set bash options'
    local _self=${FUNCNAME[0]}
    local _mod_name=${_self%%.*};
    local _mod=${_self%.*};

    shopt -s extdebug # declare -F ${name} => ${name} ${lineno} ${pathname}
    # shopt -s nullglob # http://bash.cumulonim.biz/NullGlob.html nullglob
    shopt -s globstar # **
    # shopt -s failglob
    shopt -s autocd cdable_vars
    shopt -s checkhash
    shopt -s no_empty_cmd_completion
    shopt -s extglob
}

function u.status {
    local _status=$?
    : 'public, usage: u.status # => echo status to stdout'
    if [[ $? = 0 ]] ; then
        printf 'done'
    else
        printf 'failed (%s)' ${_status}
    fi
}


function u.value {
    : 'public, usage: u.value [${value}] # |> ${value} to stdout iff it is defined.'
    local _self=${FUNCNAME[0]}
    local _mod_name=${_self%%.*};
    local _mod=${_self%.*};

    [[ -n "$1" ]] && echo $1
}

function u.first {
    : 'public, usage: u.first $* # |> the first non-empty value'
    local _self=${FUNCNAME[0]}
    local _mod_name=${_self%%.*};
    local _mod=${_self%.*};

    u.value $1
}

function u.values {
    : 'public, usage: u.values ${delim} $* # |> "$1:$2:..."'
    local _self=${FUNCNAME[0]}
    local _mod_name=${_self%%.*};
    local _mod=${_self%.*};

    local _delim=${1:-':'} ; shift
    local _result=$(printf "%s${_delim}" $*)
    [[ -n "${_result}" ]] && echo ${_result::-1}
}


# fix all the u.source* functions. they don't work.
function u.source {
    : 'public, usage: [verbose=1] u.source ${pathname} # source ${pathname}'
    
    : 'until fixed'
    return $(f.is.broken)

    local _self=${FUNCNAME[0]}
    local _mod_name=${_self%%.*};
    local _mod=${_self%.*};

    local -r _s=$(f.must.have "$1" "bash script") || return 1
    shift
    
    { set -x; source ${_s}; set +x; } && [[ -n "${verbose}" ]] && f.info ${_s}
}


# source a script starting at pathname and then looking up in successive directories.
function u.source.up {
    : 'public, usage: [verbose=1] u.source.up ${pathname} # source ${pathname} up directory tree'

    : 'until fixed'
    return $(f.is.broken)

    local _self=${FUNCNAME[0]}
    local _mod_name=${_self%%.*};
    local _mod=${_self%.*};

    local _s=$(f.must.have "$1" "bash script") || return 1 ; shift

    local _d=$(dirname ${_s})
    local _f=$(basename ${_s})
    while [[ ${_d} != '/' ]] ; do
        _s=$(realpath -s ${_d}/${_f})
        [[ -f ${_s} ]] && return $(u.source ${_d}/${_f})
        _d=$(realpath -s ${_d}/..)
    done
    return 1
}



function u.source.r {
    : 'public, usage: u.usage ${function} # extract a usage string from a bash function'
    return $(f.is.broken)
    local _self=${FUNCNAME[0]}
    local _mod_name=${_self%%.*}
    local _mod=${_self%.*}

    local _s=$(f.must.have "$1" "bash script") || return 1 ; shift

    local -a _stack=($*)
    local _module=$(${_mod_name}.pn2mod ${_s})
    ${_mod_name}.source ${_s}
    function _not_loaded { [[ ! $(u.mod+exists $1) ]] ; }
    local -a _stack=($(f.apply _not_loaded ${_module} ${_stack[*]}))
    while $(( ${#_stack[*]} )) ; do
        _module=${_stack[0]}
        unset _stack[0]; _stack=(${_stack[*]}) # gross
        # (very expensive) recursion
        ${_self} $(${_mod_name}.mod2pn ${_module}) ${_stack[*]}
    done
}


# source all readable files
function u.source.all {
    : 'public, usage: u.usage ${function} # extract a usage string from a bash function'

    : 'until fixed'
    return $(f.is.broken)

    local _self=${FUNCNAME[0]}
    local _mod_name=${_self%%.*}
    local _mod=${_self%.*}

    f.apply u.source $(f.apply file.is.readable $*)
}


function u.source.tree {
    : 'public, usage: u.usage ${function} # extract a usage string from a bash function'

    : 'until fixed'
    return $(f.is.broken) # until fixed
    
    local _self=${FUNCNAME[0]}
    local _mod_name=${_self%%.*}
    local _mod=${_self%.*}

    local _root=${1:-${PWD}}
    local _ext=${2:-.mod.sh}


    # f.apply u.source $(find ${_root} -type f -perm /222 -name \*${_ext})
    find ${_root} -type f -perm /222 -name \*.${_ext} -print0 | xargs --null -n1 u.source
}



# I'm not sure I need this.
function u.source_1 {
    local _self=${FUNCNAME[0]}
    local _mod_name=${_self%%.*}
    local _mod=${_self%.*}

    local _selfno=${FUNCNAME[0]}@${LINENO[0]}
    local _s=$(realpath -s $(u.must.have-ck "${1}" file.is.readable)) ; shift
    [[ -r ${_s} ]] || return ${2:-1} ; shift
    local _there=$(dirname ${_s})
    local _name=$(basename ${_s})
    # >&2 echo ${_s}
    local _log=$(u.must.have "${BASHENV_LOGROOT}" "expecting BASHENV_LOGROOT")/${_name}.txt
    if source ${_s} "$*" &> ${_log} ; then
        local _log_status=${_log}.0.log
        u.mv ${_log} ${_log_status}
        file.xz ${_log_status}
    else
        local _status=$?
        local _log_status=${log}.${_status}.log
        file.mv ${_log} ${_log_status}
        local _backpointer=$(realpath --relative-to ${_there} ${_s})
        ln -sr ${_s} ${_backpointer}
        _w "${_s} status ${_status} log ${_log}.${_status}.log backpointer ${_backpointer}"
    fi
}


# Make this file a "module".
# Extract mod from pathname.
function pn2mod { local _result=${1##*/}; echo ${_result%%.*}; }
# Augment functions above with "module" conventions.
mod.mkmod $(pn2mod ${1:-${BASH_SOURCE[0]}}) ${2:-$(realpath ${BASH_SOURCE[0]})}
