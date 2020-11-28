# shared functions across all distros
[[ -n "${VERBOSE}" ]] && echo ${BASH_SOURCE}

function useradd {
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

