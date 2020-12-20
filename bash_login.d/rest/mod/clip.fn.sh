function clip.fn.__template__ {
    local _self=${FUNCNAME[0]}
    local _fn=${_self%%.*}

    u.value $(ssh.fn.pathname)
}

function clip.fn.defines {
    local _self=${FUNCNAME[0]}
    local _self=${FUNCNAME[0]}
    local _fn=${_self%%.*}

    export -f  2>&1 | grep "declare -fx ${_fn}."
}
export -f clip.fn.defines

function clip.fn.pathname {
    local _self=${FUNCNAME[0]}
    local _fn=${_self%%.*}

    u.value $(me.pathname)    
}
export -f clip.fn.pathname

function clip.fn.reload {
    local _self=${FUNCNAME[0]}
    local _fn=${_self%%.*}

    verbose=1 u.source $(${_fn}.fn.pathname)
}
export -f clip.fn.reload


function clip {
    local _self=${FUNCNAME[0]}
    local _fn=${_self%%.*}

    xclip -primary c "${1}" # add more flags like -verbose
}
export -f clip

       
