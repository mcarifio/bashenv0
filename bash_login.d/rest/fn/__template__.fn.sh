function f.__template__ {
    local _self=${FUNCNAME[0]}
    echo ${_self} tbs
}
export -f f.__template__
