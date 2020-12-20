# source
# assumes go-t install and in PATH

function twt.fn.__template__ {
    local _self=${FUNCNAME[0]}
    u.value $(twt.fn.pathname)
}
# don't export __template__

function twt.fn.defines {
    local _self=${FUNCNAME[0]}
    export -f  2>&1 | grep "declare -fx twt"
}
export -f twt.fn.defines

function twt.fn.pathname {
    local _self=${FUNCNAME[0]}
    u.value $(me.pathname)    
}
export -f twt.fn.pathname



function twt.status {
    # install go-t if you don't have it
    u.have.command go-t || go.install go-t || return 1
    go-t status update -y -f -
}
export -f twt.status
