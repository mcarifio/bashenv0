function clip.fn.__template__ {
    local _self=${FUNCNAME[0]}
    declare -F ${_self}
}

function clip.fn.defines {
    local _self=${FUNCNAME[0]}
    export -f  2>&1 | grep "declare -fx clip"
}
export -f clip.fn.defines

function clip.fn.pathname {
    local _self=${FUNCNAME[0]}
    u.value $(me.pathname)    
}
export -f clip.fn.pathname


function clip {
    xclip -primary c "${1}" # add more flags like -verbose
}
export -f clip

       
