# machine.fn.sh

function machine.fn.__template__ {
    local _self=${FUNCNAME[0]}
    u.value $(machine.fn.pathname)
}
# don't export __template__

function machine.fn.defines {
    local _self=${FUNCNAME[0]}
    export -f  2>&1 | grep "declare -fx machine"
}
export -f machine.fn.defines

function machine.fn.pathname {
    local _self=${FUNCNAME[0]}
    u.value $(me.pathname)    
}
export -f machine.fn.pathname



function machine.bootstrap.install+all {
    
    py.pip+install.all
    snap.install.all

    # add users
    uid_start=2000 uid_incr=10 sudo.useradd git skippy bashenv 
    sudo.nopasswd
}
export -f machine.bootstrap.install+all

