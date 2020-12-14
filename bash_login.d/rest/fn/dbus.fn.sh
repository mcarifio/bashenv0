function dbus.fn.__template__ {
    local _self=${FUNCNAME[0]}
    declare -F ${_self}
}

function dbus.fn.defines {
    local _self=${FUNCNAME[0]}
    export -f  2>&1 | grep "declare -fx dbus"
}
export -f dbus.fn.defines

function dbus.fn.pathname {
    local _self=${FUNCNAME[0]}
    u.value $(me.pathname)    
}
export -f dbus.fn.pathname



function dbus.DBus.ListNames {
    local _self=${FUNCNAME[0]}
    local _prefix=org.freedesktop
    local _full=${_prefix}.${_self}
    local _dbus=${_self%.*}
    local _service=${1:-${_prefix}.${_dbus}}
    local _path=/${_service//./\/}
    # dbus-send --session --dest=org.freedesktop.DBus --type=method_call --print-reply /org/freedesktop/DBus org.freedesktop.DBus.ListNames
    dbus-send --session --dest=${_service} --type=method_call --print-reply ${_path} ${_full}
}
export -f dbus.DBus.ListNames
