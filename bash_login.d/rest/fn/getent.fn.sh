function getent.fn.__template__ {
    local _self=${FUNCNAME[0]}
    u.value $(getent.fn.pathname)
}
# don't export __template__

function getent.fn.defines {
    local _self=${FUNCNAME[0]}
    export -f  2>&1 | grep "declare -fx getent"
}
export -f getent.fn.defines

function getent.fn.pathname {
    local _self=${FUNCNAME[0]}
    u.value $(me.pathname)    
}
export -f getent.fn.pathname

function getent.home {
    local _username=${1:-${USER}}
    command -p getent passwd ${_username} | cut -d: -f6
}
export -f getent.home

