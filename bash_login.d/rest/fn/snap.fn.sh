# snap.fn.sh

function snap.fn.__template__ {
    local _self=${FUNCNAME[0]}
    u.value $(snap.fn.pathname)
}
# don't export __template__

function snap.fn.defines {
    local _self=${FUNCNAME[0]}
    export -f  2>&1 | grep "declare -fx snap"
}
export -f snap.fn.defines

function snap.fn.pathname {
    local _self=${FUNCNAME[0]}
    u.value $(me.pathname)    
}
export -f snap.fn.pathname




function snap.i1 {
    local _self=${FUNCNAME[0]}
    # classic is ignore if unneeded
    sudo snap install --classic $*
}
export -f snap.i1

function snap.install {
    local _self=${FUNCNAME[0]}
    f.apply snap.i1 $*
}
export -f snap.install


function snap.install.all {
    local _self=${FUNCNAME[0]}
    snap.install install multipass
}
export -f snap.install.all
