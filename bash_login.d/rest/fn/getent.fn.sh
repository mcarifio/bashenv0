# getent.fn.sh

function getent.fn.__template__ {
    local _self=${FUNCNAME[0]}
    local _fn=${_self%%.*}

    u.value $(getent.fn.pathname)
}

function getent.fn.defines {
    local _self=${FUNCNAME[0]}
    local _fn=${_self%%.*}

    export -f  2>&1 | grep "declare -fx ${_fn}."
}
export -f getent.fn.defines

function getent.fn.pathname {
    local _self=${FUNCNAME[0]}
    local _fn=${_self%%.*}

    u.value $(me.pathname)    
}
export -f getent.fn.pathname

function getent.fn.reload {
    local _self=${FUNCNAME[0]}
    local _fn=${_self%%.*}

    verbose=1 u.source $(${_fn}.fn.pathname)
}
export -f getent.fn.reload




function getent.home {
    local _self=${FUNCNAME[0]}
    local _fn=${_self%%.*}

    local _username=${1:-${USER}}

    command -p getent passwd ${_username} | cut -d: -f6
}
export -f getent.home

