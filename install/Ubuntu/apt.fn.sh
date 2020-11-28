function apt/install {
    local log=${$1:?'expecting a log pathname'} ; shift
    [[ -f ${log} ]] && exit 0

    apt update
    apt upgrade -y
    apt install -y "$*" &> ${log}
    apt-mark auto "$*"
}
