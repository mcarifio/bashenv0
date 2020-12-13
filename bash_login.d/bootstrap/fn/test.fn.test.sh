function test.skip {
    if [[ -n "${skip}" ]] ; then
        [[ -n "${verbose}" ]] && f.warn "skipping ${FUNCNAME[1]} at ${BASH_SOURCE[2]}:${BASH_LINENO[1]}"
        return 0
    fi
    return 1
}
export -f test.skip

function test.expect.equal {
    local _self=${FUNCNAME[0]}
    test.skip && return 0
    local _left=$(f.must.have "$1" "lhs")
    local _right=$(f.must.have "$2" "rhs")
    if [[ ${_left} = ${_right} ]] ; then
        [[ -n "${verbose}" ]] && >&2 f.info "${_left} = ${_right}"
    else
        f.err "${_left} != ${_right}"
    fi
}
export -f test.expect.equal

function test.expect.notequal {
    local _self=${FUNCNAME[0]}
    test.skip && return 0
    local _left=$(f.must.have "$1" "lhs")
    local _right=$(f.must.have "$2" "rhs")
    if [[ ${_left} != ${_right} ]] ; then
        [[ -n "${verbose}" ]] && >&2 f.info "${_left} != ${_right}"
    else
        f.err "${_left} = ${_right}"
    fi
}
export -f test.expect.notequal
