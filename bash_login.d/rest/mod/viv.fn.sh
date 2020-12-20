# viv.fn.sh vivaldi web browser

function viv.fn.__template__ {
    local _self=${FUNCNAME[0]}
    u.value $(viv.fn.pathname)
}
# don't export __template__

function viv.fn.defines {
    local _self=${FUNCNAME[0]}
    export -f  2>&1 | grep "declare -fx viv"
}
export -f viv.fn.defines

function viv.fn.pathname {
    local _self=${FUNCNAME[0]}
    u.value $(me.pathname)    
}
export -f viv.fn.pathname



function viv.run {
    local profile=$(f.must.have "$1" "profile")
    # install vivaldi if you don't yet have it
    u.have.command vivaldi || apt.install vivaldi || return 1
    command vivaldi --user-data-dir=$HOME/.config/vivaldi/profiles/${profile} &
}
export -f viv.run

