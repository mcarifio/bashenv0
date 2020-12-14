# ssh.fn.sh

function ssh.fn.__template__ {
    local _self=${FUNCNAME[0]}
    u.value $(ssh.fn.pathname)
}
# don't export __template__

function ssh.fn.defines {
    local _self=${FUNCNAME[0]}
    export -f  2>&1 | grep "declare -fx ssh"
}
export -f ssh.fn.defines

function ssh.fn.pathname {
    local _self=${FUNCNAME[0]}
    u.value $(me.pathname)    
}
export -f ssh.fn.pathname


function ssh.mkssh {
    local _self=${FUNCNAME[0]}
    command -p mkdir --mode=0600 ${HOME}/.ssh
}
function ssh.mkssh



function ssh.keygen {
    local _self=${FUNCNAME[0]}
    local _f=${1:-${HOME}/.ssh/keys.d/localdomain/${USER}@{HOSTNAME}_id_rsa}
    file.mkdir $(file.dirname ${_f})
    command -p ssh-keygen -f ${_f} -P'' -C "${USER}@${HOSTNAME}:${_f}"
}
function ssh.keygen
