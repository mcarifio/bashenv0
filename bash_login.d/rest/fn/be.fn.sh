# be.fn.sh
# functions to hack/modify bashenv.

function be.fn.__template__ {
    local _self=${FUNCNAME[0]}
    local _fn=${_self%%.*}

    u.value $(${_fn}.fn.pathname)
}

function be.fn.defines {
    local _self=${FUNCNAME[0]}
    local _fn=${_self%%.*}

    export -f  2>&1 | grep "declare -fx ${_fn}."
}
export -f be.fn.defines

function be.fn.pathname {
    local _self=${FUNCNAME[0]}
    local _fn=${_self%%.*}

    u.value $(me.pathname)    
}
export -f be.fn.pathname

# Reload this file. Todo: using inotify to reload automatically.
function be.fn.reload {
    local _self=${FUNCNAME[0]}
    local _fn=${_self%%.*}

    verbose=1 u.source $(${_fn}.fn.pathname)
}
export -f be.fn.reload



# Reload all the functions in "bootstrap" order.
function be.reload {
    verbose=1 u.source $(me.here ../../bootstrap)/load.sh
    verbose=1 u.source.tree $(me.here ../../rest)
}
export -f be.reload

