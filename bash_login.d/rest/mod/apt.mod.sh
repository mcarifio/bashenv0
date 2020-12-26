# apt.mod.sh
# apt install software as a user 


function apt.install {
    local _self=${FUNCNAME[0]};
    local _mod_name=${_self%%.*};
    local _mod=${_self%.*};
    
    sudo apt update || return 1
    sudo apt upgrade -y || return 1
    sudo apt install -y $* || return 1
    sudo apt-mark auto $* || return 1
}


function apt.install.all {
    local _self=${FUNCNAME[0]}
    local _fn=${_self%%.*}

    local _forward=${_self%.all}

    printf '%s\n' $(f.apply ${_forward} openssl openssh-server ssh-import-id whois xdg-utils cloud-init ttyrec python3 emacs inotify-tools incron wmctrl) | sort | uniq
}


# Make this file a "module".
# Extract mod from pathname.
function pn2mod { local _result=${1##*/}; echo ${_result%%.*}; }
# Augment functions above with "module" conventions.
mod.mkmod $(pn2mod ${1:-${BASH_SOURCE[0]}}) ${2:-$(realpath ${BASH_SOURCE[0]})}
