# utility functions
# test with ./u.fn.test.sh

function u.__template__ {
    local _self=${FUNCNAME[0]}
    echo ${_self} tbs
}
export -f u.__template__

# usage: u.is.command gh && f.warn "gh defined"
function u.have.command {
    local _self=${FUNCNAME[0]}
    local _command=$(f.must.have "$1" "expecting a command on PATH") || return 1
    for _c in $*; do type ${_c} &> /dev/null || return 1 ; done
}
export -f u.have.command

# function set.env.FOO { u.env -d $1 ; }
# set.env.FOO 100; echo $FOO |> 100
function u.env {
    local _self=${FUNCNAME[0]}
    local _name=$(f.must.have "${FUNCNAME[1]##*.env.}" "caller") || return 1
    local _test=$(f.must.have "$1" "predicate") || return 1
    local _value=$(f.must.have "$2" "value") || return 1
    test ${_test} "${_value}" && export ${_name}="${_value}"
}
export -f u.env

# when called in a script, knows if the script file has been sourced. not currently working.
function u.script.source {
    local _self=${FUNCNAME[0]}
    local _left="${BASH_SOURCE[0]}"
    local _right="${0}"
    [[ ${_left} != ${_right} ]] && echo ${_left}
}
export -f u.script.source

function u.script.run {
    local _self=${FUNCNAME[0]}
    local _left="${BASH_SOURCE[0]}"
    local _right="${0}"
    [[ ${_left} = ${_right} ]] && echo ${_left}
}
export -f u.script.run


# https://www.gnu.org/software/bash/manual/html_node/The-Shopt-Builtin.html
function u.init.shopt {
    shopt -s extdebug # declare -F ${name} => ${name} ${lineno} ${pathname}
    # shopt -s nullglob # http://bash.cumulonim.biz/NullGlob.html nullglob
    shopt -s globstar # **
    # shopt -s failglob
    shopt -s autocd cdable_vars
    shopt -s checkhash
    shopt -s no_empty_cmd_completion
}
export -f u.init.shopt


# source all readable files
function u.source.all {
    local _self=${FUNCNAME[0]}
    f.apply u.source $(f.filter file.is.readable $*)
}
export -f u.source.all

function u.source {
    local _self=${FUNCNAME[0]}
    local _s=$(f.must.have "$1" "bash script") || return 1
    [[ -n "${verbose}" ]] && >&2 echo $(realpath ${_s})
    source ${_s}
}
export -f u.source.all




##########################


# source all *.sh files in a directory.
# TODO mcarifio: source from stdin
# I don't think I actually need this?
function u.source_d {
    local _self=${FUNCNAME[0]}
    local _d=${1:-${PWD}}
    local _pattern=${2:-'*.sh'}
    [[ -d "${_d}" ]] && u.apply u.source_1 ${_d}/${_pattern}
}
export -f u.source_d

# don't need this
function u.show-logs {
    # shopt -u nullglob
    u.apply cat "$*"
}
export -f u.show-logs




# export BASHENV_LOGROOT=${BASHENV_LOGROOT:-$(u.mkdir /tmp/${USER}/bashenv)}

# I'm not sure I need this.
function u.source_1 {
    local _self=${FUNCNAME[0]}
    local _selfno=${FUNCNAME[0]}@${LINENO[0]}
    local _s=$(realpath -s $(u.must.have "${1}" "expecting a pathname")) ; shift
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
export -f u.source_1

function u.source.all {
    local _self=${FUNCNAME[0]}
    f.apply source $*
}
export -f u.source.all


