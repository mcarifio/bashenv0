# apt.fn.sh

function apt.fn.__template__ {
    local _self=${FUNCNAME[0]}
    local _fn=${_self%%.*}

    declare -F ${_self}
}

function apt.fn.defines {
    local _self=${FUNCNAME[0]}
    local _fn=${_self%%.*}

    export -f  2>&1 | grep "declare -fx apt."
}
export -f apt.fn.defines

function apt.fn.pathname {
    local _self=${FUNCNAME[0]}
    local _fn=${_self%%.*}

    u.value $(me.pathname)    
}
export -f apt.fn.pathname

function apt.fn.command {
    local _self=${FUNCNAME[0]}
    local _fn=${_self%%.*}

    local _command=${FUNCNAME[1]}

    command -p ${_command} $*
}
export -f apt.fn.command

function apt.fn.reload {
    local _self=${FUNCNAME[0]}
    local _fn=${_self%%.*}

    verbose=1 u.source $(${_fn}.fn.pathname)
}
export -f apt.fn.reload





function apt.install {
    local _self=${FUNCNAME[0]}
    local _fn=${_self%%.*}

    local _log=/tmp/${_self}.log
    
    sudo apt update &>> ${_log} || return 1
    sudo apt upgrade -y &>> ${_log} || return 1
    sudo apt install -y $* &>> ${_log} || return 1
    sudo apt-mark auto $* &>> ${_log} || return 1
    echo ${_log}
}
export -f apt.install


function apt.install.all {
    local _self=${FUNCNAME[0]}
    local _fn=${_self%%.*}

    local _forward=${_self%.all}

    printf '%s\n' $(f.apply ${_forward} openssl openssh-server ssh-import-id whois xdg-utils cloud-init ttyrec python3 emacs inotify-tools incron) | sort | uniq
}
export -f apt.install.all

