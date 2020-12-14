function apt.fn.__template__ {
    local _self=${FUNCNAME[0]}
    declare -F ${_self}
}
export -f apt.fn.__template__

function apt.fn.defines {
    local _self=${FUNCNAME[0]}
    export -f  2>&1 | grep "declare -fx apt"
}
export -f apt.fn.defines

function apt.fn.pathname {
    local _self=${FUNCNAME[0]}
    u.value $(me.pathname)    
}
export -f apt.fn.pathname

function apt.fn.command {
    local _self=${FUNCNAME[0]}
    local _command=${FUNCNAME[1]}
    command -p ${_command} $*
}
export -f apt.fn.command





function apt.install {
    local _self=${FUNCNAME[0]}
    sudo apt update
    sudo apt upgrade -y
    sudo apt install -y $*
    apt-mark auto $*
}
export -f apt.install


function apt.install.all {
    local _self=${FUNCNAME[0]}
    local _forward=${_self%.all}
    f.apply {_forward} openssl openssh-server ssh-import-id whois xdg-utils cloud-init ttyrec python3 emacs
}
export -f apt.install.all

