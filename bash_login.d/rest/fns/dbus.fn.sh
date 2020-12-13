function DBus.ListNames {
    local _self=${FUNCNAME[0]}
    local _prefix=org.freedesktop
    local _full=${_prefix}.${_self}
    local _dbus=${_self%.*}
    local _service=${1:-${_prefix}.${_dbus}}
    local _path=/${_service//./\/}
    # dbus-send --session --dest=org.freedesktop.DBus --type=method_call --print-reply /org/freedesktop/DBus org.freedesktop.DBus.ListNames
    dbus-send --session --dest=${_service} --type=method_call --print-reply ${_path} ${_full}
}
export -f DBus.ListNames
