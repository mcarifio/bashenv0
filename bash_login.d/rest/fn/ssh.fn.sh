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
    command -p mkdir -p --mode=0600 ${_ssh_d}
    file.cp $(ssh.keygen localhost ${USER}) ${_ssh_d}/id_rsa
}
export -f ssh.mkssh

function ssh.keygen {
    local _self=${FUNCNAME[0]}
    local _Host=${1:-localhost}
    local _UserName=${2:-${USER}}
    local _f=${HOME}/.ssh/keys.d/by-quad/${USER}/${HOSTNAME}/${_UserName}/${_Host}/${USER}@${HOSTNAME}4${_UserName}@${_Host}_id_rsa
    local _d=$(dirname ${_f})
    file.mkdir ${_d}
    command -p ssh-keygen -q -C "${USER}@${HOSTNAME}:${_f}" -f ${_f} -N ''
    ln -srf ${_f} ${_d}/private.key
    echo ${_Host} > ${_d}/${_Host}
    echo ${_f}
}
export -f ssh.keygen


function ssh.pub4 {
    local _f=$(f.must.have "$1" "file")
    local _pub=${_f}.pub
    [[ -f ${_pub} ]] || ssh-keygen -v -y -f ${_f} > ${_f}.pub
}
export -f ssh.pub4

# ssh.ssh ccgdev [-o ForwardX11=yes]
function ssh.ssh {
    local _self=${FUNCNAME[0]}
    local _target=$(f.must.have "$1" "host") ; shift
    local -a _pair
    IFS='@' read -ra _pair <<< "${_target}"
    if (( ${#_pair[*]} == 1 )) ; then
        local _UserName=${USER}
        local _Host=${_pair[0]}
    else
        local _UserName=${_pair[0]}
        local _Host=${_pair[1]}
    fi
    local _f=${HOME}/.ssh/keys.d/by-quad/${USER}/${HOSTNAME}/${_UserName}/${_Host}/private.key
    [[ -f ${_f} ]] || { local _key=$(ssh.keygen ${_Host} ${_UserName}) ; f.err "scp ${_f}.pub to ${_Host}" ; }
    # Generate a pub key from the private key if it isn't already co-located. Stops an ssh-warning.
    ssh.pub4 ${_f}
    
    local _Host2Hostname=$(dirname ${_f})/${_Host}
    [[ -f "${_Host2Hostname}" ]] && _Hostname=$(<${_Host2Hostname})
    [[ -z "${_Hostname}" ]] && _Hostname=$(grep ${_Host} ${HOME}/.ssh/hosts | cut -d' ' -f2)
    [[ -z "${_Hostname}" ]] && _Hostname=${_Host}
    command -p ssh -F none -l ${_UserName} -i ${_f} -o IdentitiesOnly=yes -o PubkeyAuthentication=yes -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no $* ${_Hostname}
}
export -f ssh.ssh
