[[ -n "${VERBOSE}" ]] && echo ${BASH_SOURCE}

function dnf+install {
    local _log=${$1:?'expecting a log pathname'} ; shift

    # assume's root or sudo
    dnf --refresh upgrade -y --allowereasing --best
    dnf install -y "$*" &> ${_log}
}
