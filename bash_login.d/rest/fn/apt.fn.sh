function apt.__template__ {
    local _self=${FUNCNAME[0]}
    echo ${_self} tbs
}
export -f apt.__template__

function apt.install {
    local _self=${FUNCNAME[0]}
    sudo apt update
    sudo apt upgrade -y
    sudo apt install -y $*
    apt-mark auto $*
}
export -f apt.install

