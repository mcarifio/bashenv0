# sudo.fn.sh
function sudo.nopasswd {
    local _nopasswd=/etc/sudoers.d/nopasswd
    printf "# fc\n%%%s ALL = (ALL) NOPASSWD: ALL\n" sudo wheel > ${_nopasswd}
    printf "# debian et al\n%%%s ALL = (ALL) NOPASSWD: ALL\n" sudo sudo >> ${_nopasswd}
    chmod 0600 ${_nopasswd}
}
export -f $_

function sudo.useradd {
    local _self=${FUNCNAME[0]}
    local _conf=${_self}.conf
    if ! source ${_conf} &> /dev/null ; then
        [[ -z "${_groups}" ]] && declare -a _groups=(wheel sudo admin plugdev ssh lxd)
    fi

    for u in "$*"; do
        command useradd ${u}
        command usermod --append ${u} --groups ${g} || true
    done    
}
export -f $_

