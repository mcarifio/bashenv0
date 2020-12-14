# sudo.fn.sh
function sudo.nopasswd {
    local _nopasswd=/etc/sudoers.d/nopasswd
    printf "# fc\n%%%s ALL = (ALL) NOPASSWD: ALL\n" sudo wheel > ${_nopasswd}
    printf "# debian et al\n%%%s ALL = (ALL) NOPASSWD: ALL\n" sudo sudo >> ${_nopasswd}
    chmod 0600 ${_nopasswd}
}
export -f sudo.nopasswd

function sudo.useradd {
    local _self=${FUNCNAME[0]}
    local -i _start=${start:-2000} _step=${step:-10}
    local _password=${password:-${HOSTNAME:-${_self}}}
    local _groups=${groups:-'wheel,sudo,admin,plugdev,ssh,lxd'}

    local _encrypted_password=$(command -p openssl passwd -1 -stdin <<< ${_password})

    f.apply sudo.groupadd ${_groups/,/}
    # can't use f.apply b/c of sudo
    for _username in $*; do
        sudo useradd --user-group --create-home --groups=${_groups} --password="${_encrypted_password}" --uuid=${_start} ${_username}
        sudo.ssh.mkssh ${_username}
        (( _start+=_step ))
    done    
}
export -f sudo.useradd

function sudo.passwd {
    local _self=${FUNCNAME[0]}
    local _username=$(f.must.have "$1" "username")
    local _password=${2:-${HOSTNAME:-${_self}}}
    local _encrypted_password=$(command -p openssl passwd -1 -stdin <<< ${_password})
    sudo usermod --password=${_encrypted_password} ${_username}
}
export -f sudo.passwd




function sudo.mkdir {
    local _self=${FUNCNAME[0]}
    local _d=$(f.must.haves "$1" "directory")
    local _username=${2:-${USER}}
    local -i _uid=$(id -u ${_username})
    local -i _gid=$(id -g ${_username})
    local _mode=""
    [[ -n "${mode}" ]] && _mode=" --mode=${mode} "
    sudo install --owner=${_uid} --group=${_gid} ${_mode} --directory ${_d}
}
export -f sudo.mkdir

function sudo.cp {
    local _self=${FUNCNAME[0]}
    local _src=$(f.must.haves "$1" "file")
    local _dst=$(f.must.haves "$1" "file || directory")
    local _username=${3:-${USER}}

    local -i _uid=$(id -u ${_username})
    local -i _gid=$(id -g ${_username})
    local _mode=""
    [[ -n "${mode}" ]] && _mode=" --mode=${mode} "

    sudo install --owner=${_uid} --group=${_gid} ${_mode} -D ${_src} ${_dst}
}
export -f sudo.cp



function sudo.ssh.mkssh {
    local _self=${FUNCNAME[0]}
    local _username=${1:-${USER}}
    local _home=$(getent.home ${_username})
    local _ssh_d=${_home}/.ssh
    mode=0600 sudo.mkdir {_ssh_d} ${_username}
    local _localdomain_d=${_ssh_d}/keys.d/localdomain
    sudo.mkdir ${_localdomain_d} ${_username}
    local _key=${_home}/.ssh/keys.d/localdomain/${_username}@${HOSTNAME}_id_rsa}
    sudo.ssh.keygen ${_username} ${_key}
    mode=0600 sudo.cp ${_key} ${_ssh_d}/id_rsa ${_username} 
}
export -f sudo.ssh.mkssh

function sudo.ssh.keygen {
    local _self=${FUNCNAME[0]}
    local _username=$(f.must.have "$1" "username")
    local _home=$(getent.home ${_username})
    local _f=${1:-${_home}/.ssh/keys.d/localdomain/${USER}@${HOSTNAME}_id_rsa}
    file.mkdir $(file.dirname ${_f})
    command -p ssh-keygen -f ${_f} -P'' -C "${USER}@${HOSTNAME}:${_f}"
}
export -f sudo.ssh.keygen




function sudo.groupadd {
    local _self=${FUNCNAME[0]}
    # can't use f.appy b/c of sudo
    for _g in $*; do sudo groupadd ${_g} ; done
}
export -f sudo.groupadd
