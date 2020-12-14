# -*- eval: (modify-fn-template) -*- to be written

function __t__.fn.__template__ {
    local _self=${FUNCNAME[0]}
    local _fn=${_self%*.}
    u.value $(__t__.fn.pathname)
}
# don't export __template__

function __t__.fn.defines {
    local _self=${FUNCNAME[0]}
    export -f  2>&1 | grep "declare -fx __t__"
}
export -f __t__.fn.defines

function __t__.fn.pathname {
    local _self=${FUNCNAME[0]}
    u.value $(me.pathname)    
}
export -f __t__.fn.pathname


function __t__.fn.command {
    local _self=${FUNCNAME[0]}
    local _command=${FUNCNAME[1]}
    command -p ${_command} $*
}
export -f __t__.fn.command

