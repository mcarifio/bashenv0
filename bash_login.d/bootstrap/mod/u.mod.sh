# utility functions
# test with ./u.fn.test.sh

# Given a pathname, return the (ostensible) module based on the naming convention ${mod}.mod.sh
function u.pn2mod {
    local _self=${FUNCNAME[0]}
    local _mod_name=${_self%%.*};
    local _mod=${_self%.*};

    u.re+extract $(f.must.have "$1" "string") ^".*/"'([^.]+).?'
}

# Find the possible pathnames given a module name based on naming conventions and locations.
# Generally should find a single pathname.
function u.mod2pn {
    local _self=${FUNCNAME[0]}
    local _mod_name=${_self%%.*};
    local _mod=${_self%.*};

    local _that_mod=$(f.must.have "$1" module) || return 1    

    find $(be.root)/bash_login.d -type f -perm /222 -name ${_that_mod}.mod.sh -print0 | xargs --null -n1 realpath
}

function u.mod+exists {
    local _mod=$(f.must.have "$1" module) || return 1
    ${_mod}.mod.exists &> /dev/null
}

# usage: u.have.command gh emacs /bin/ls && echo "have 'em"
function u.have.command {
    local _self=${FUNCNAME[0]}
    local _mod_name=${_self%%.*};
    local _mod=${_self%.*};

    local _command=$(f.must.have "$1" "expecting a command on PATH") || return 1
    local _c; for _c in $*; do type ${_c} &> /dev/null || return 1 ; done
}


# usage: u.re+extract ${string} ${pattern} ${group:-1} -> ${string} # status 0
# note: you can match with extract if no group 1 in pattern.
function u.re1 {
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
    local _self=${FUNCNAME[0]}
    local _mod_name=${_self%%.*};
    local _mod=${_self%.*};

    local _fn=$(f.must.have "$1" "function name")

    # TODO mike@carif.io: last . not working?
    u.re1 ${_fn} '^[^.]+.[^.]+.'  # x.y.z => y
}

function u.get+mod {
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
    local _self=${FUNCNAME[0]}
    local _mod_name=${_self%%.*}
    local _mod=${_self%.*}

    local _name_test=$(f.must.have "$1" "name predicate") || return 1
    local _name=$(f.must.have "$2" "name") || return 1
    local _value_test=$(f.must.have "$3" "value predicate") || return 1
    local _value=$(f.must.have "$4" "value") || return 1

    # not working
    [[ "true" != "${_name_test}" ]] && test "${_name_test}" "${!_name}" || return 0
    [[ "true" != "${_value_test}" ]] && test "${_value_test}" "${_value}" || return 0
    export "${_name}"="${_value}"
}


# when called in a script, knows if the script file has been sourced. not currently working.
function u.script.sourced {
    local _self=${FUNCNAME[0]}
    local _mod_name=${_self%%.*};
    local _mod=${_self%.*};

    local _left="${BASH_SOURCE[0]}"
    local _right="${0}"
    [[ ${_left} != ${_right} ]] && echo ${_left}
}

function u.script.run {
    local _self=${FUNCNAME[0]}
    local _mod_name=${_self%%.*};
    local _mod=${_self%.*};

    local _left="${BASH_SOURCE[0]}"
    local _right="${0}"
    [[ ${_left} = ${_right} ]] && echo ${_left}
}


# https://www.gnu.org/software/bash/manual/html_node/The-Shopt-Builtin.html
function u.init.shopt {
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
}


function u.value {
    local _self=${FUNCNAME[0]}
    local _mod_name=${_self%%.*};
    local _mod=${_self%.*};

    [[ -n "$1" ]] && echo $1
}

function u.first {
    local _self=${FUNCNAME[0]}
    local _mod_name=${_self%%.*};
    local _mod=${_self%.*};

    u.value $1
}

function u.a.values {
    local _self=${FUNCNAME[0]}
    local _mod_name=${_self%%.*};
    local _mod=${_self%.*};

    local _delim=${1:-':'} ; shift
    local _result=$(f.must.value "$1" "array length>0") || return 1; shift
    u.value "${_result}$(printf '${_delim}%s' ${_delim} $*)"
}




# fix all the u.source* functions. they don't work.
function u.source {
    local _self=${FUNCNAME[0]}
    local _mod_name=${_self%%.*};
    local _mod=${_self%.*};

    local -r _s=$(f.must.have "$1" "bash script") || return 1 ; shift
    
    { set -x; source ${_s}; set +x; } && [[ -n "${verbose}" ]] && f.info ${_s}
}


# source a script starting at pathname and then looking up in successive directories.
function u.source.up {
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
    local _self=${FUNCNAME[0]}
    local _mod_name=${_self%%.*}
    local _mod=${_self%.*}

    f.apply u.source $(f.apply file.is.readable $*)
}


function u.source.tree {
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
