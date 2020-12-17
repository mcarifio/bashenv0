function dbus.fn.__template__ {
    local _self=${FUNCNAME[0]}
    local _fn=${_self%%.*}

    u.value $(ssh.fn.pathname)
}

function dbus.fn.defines {
    local _self=${FUNCNAME[0]}
    local _fn=${_self%%.*}

    export -f  2>&1 | grep "declare -fx dbus"
}
export -f dbus.fn.defines

function dbus.fn.pathname {
    local _self=${FUNCNAME[0]}
    local _fn=${_self%%.*}

    u.value $(me.pathname)    
}
export -f dbus.fn.pathname

function dbus.fn.reload {
    local _self=${FUNCNAME[0]}
    local _fn=${_self%%.*}

    verbose=1 u.source $(${_fn}.fn.pathname)
}
export -f dbus.fn.reload



function dbus.DBus.ListNames {
    local _self=${FUNCNAME[0]}
    local _prefix=org.freedesktop
    local _fn=${_self#*.}
    local _full=${_prefix}.${_fn}
    local _DBus=${_self%.*}; _DBus=${_DBus#*.}
    local _service=${1:-${_prefix}}.${_DBus}
    local _path=/${_service//./\/}
    # dbus-send --session --dest=org.freedesktop.DBus --type=method_call --print-reply /org/freedesktop/DBus org.freedesktop.DBus.ListNames
    dbus-send --session --dest=${_service} --type=method_call --print-reply ${_path} ${_full}
}
export -f dbus.DBus.ListNames
