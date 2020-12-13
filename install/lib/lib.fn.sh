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

function mkgopath {
    local _gopath=$(go env GOPATH)
    [[ -z "${_gopath}" ]] && _w "go env GOPATH fails"
    mkdir -p ${_gopath}/{bin,pkg,src}
}

function go+install {
    go install -i "$*"
}

function pip+install {
    if [[ -z "${update_pip}" ]] ; then
        python -m pip install --upgrade pip
        update_pip=$(date -Iseconds)
    fi
    python -m pip install --upgrade "$*"
}

function pip+install+all {
    pip+install wheel git git-url-parse gitpython dotmap fire rich dotmap maya fabric patchwork invocations poetry 'xonsh[full]' prompt_toolkit
}

function snap+install+all {
    snap install --classic go
    mkgopath
    go+install go-t

    snap install multipass

}

function passwordless-sudo {
    local _nopasswd=/etc/sudoers.d/nopasswd
    printf "%%%s ALL = (ALL) NOPASSWD: ALL\n" sudo wheel > ${_nopasswd}
    chmod 0600 ${_nopasswd}
}

function install+all {

    pip+install+all
    snap+install+all

    # add users
    useradd git bashenv skippy
    passwordless-sudo
}
