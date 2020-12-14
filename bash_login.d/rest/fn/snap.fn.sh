# snap.fn.sh
function snap.i1 {
    local _self=${FUNCNAME[0]}
    # classic is ignore if unneeded
    sudo snap install --classic $*
}
export -f $_

function snap.install {
    local _self=${FUNCNAME[0]}
    f.apply snap.i1 $*
}
export -f $_


function snap.install.all {
    local _self=${FUNCNAME[0]}
    snap.install install multipass
}
export -f $_
