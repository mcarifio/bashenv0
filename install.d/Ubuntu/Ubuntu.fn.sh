[[ -n "${VERBOSE}" ]] && echo ${BASH_SOURCE}

function apt+install {
    local _log=${$1:?'expecting a log pathname'} ; shift

    # assume's root or sudo
    apt update
    apt upgrade -y
    apt install -y "$*" &> ${_log}
    apt-mark auto "$*"
}


