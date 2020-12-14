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
    local _ssh_d=${HOME}/.ssh
    local _localdomain_d=${_ssh_d}/keys.d/localdomain
    local _id_rsa=${_localdomain_d}/${USER}@{HOSTNAME}_id_rsa
    command -p mkdir -p --mode=0600 ${_ssh_d}
    command -p mkdir -p ${_localdomain_d}
    ssh.keygen ${_id_rsa}
    file.cp ${_id_rsa} ${_ssh_d}/id_rsa
}
export -f ssh.mkssh



function ssh.keygen {
    local _self=${FUNCNAME[0]}
    local _f=${1:-${HOME}/.ssh/keys.d/localdomain/${USER}@{HOSTNAME}_id_rsa}
    file.mkdir $(file.dirname ${_f})
    command -p ssh-keygen -f ${_f} -P'' -C "${USER}@${HOSTNAME}:${_f}"
}
export -f ssh.keygen
