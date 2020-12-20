function id.fn.__template__ {
    local _self=${FUNCNAME[0]}
    u.value $(id.fn.pathname)
    
}
# don't export __template__

function id.fn.defines {
    local _self=${FUNCNAME[0]}
    export -f  2>&1 | grep "declare -fx id"
}
export -f id.fn.defines

function id.fn.pathname {
    local _self=${FUNCNAME[0]}
    u.value $(me.pathname)    
}
export -f id.fn.pathname

function id.fn.command {
    local _self=${FUNCNAME[0]}
    local _command=${FUNCNAME[1]}
    command -p ${_command} $*
}
export -f id.fn.command


function id {
    id.fn.command $*
}

