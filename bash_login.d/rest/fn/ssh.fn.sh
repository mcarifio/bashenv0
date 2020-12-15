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

function ssh.fn.reload {
    verbose=1 u.source $(ssh.fn.pathname)
}
export -f ssh.fn.reload



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


# ssh.ssh ccgdev [-o ForwardX11=yes]
function ssh.ssh {
    local _self=${FUNCNAME[0]}
    local _target=$(f.must.have "$1" "host") ; shift 
    IFS='@' read -ra _pair <<< "${_target}"
    if (( ${#_pair[*]} == 1 )) ; then
        local _UserName=${USER}
        local _Host=${_pair[0]}
    else
        local _UserName=${_pair[0]}
        local _Host=${_pair[1]}
    fi
    local _f=${HOME}/.ssh/keys.d/by-quad/${USER}/${HOSTNAME}/${_UserName}/${_Host}/private.key
    [[ -f ${_f} ]] || f.err "key '${_f}' not found"
    
    local _Host2Hostname=$(dirname ${_f})/${_Host}
    [[ -f ${_Host2Hostname} ]] && _Hostname=$(<${_Host2Hostname})
    [[ -z "${_Hostname}" ]] && _Hostname=$(grep ${_Host} ${HOME}/.ssh/hosts | cut -d' ' -f2)
    [[ -z "${_Hostname}" ]] && _Hostname=${_Host}
    command -p ssh -F none -l ${_UserName} -i ${_f} -o IdentitiesOnly=yes -o PubkeyAuthentication=yes -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no $* ${_Hostname}
}
export -f ssh.keygen
