# apt.mod.sh
# apt install software as a user 


function apt.install {
    : 'public, usage: apt.install [--key=${url}] [--deb="deb [arch=amd64] ${url} ${parts...}"'
    local _self=${FUNCNAME[0]};
    local _mod_name=${_self%%.*};
    local _mod=${_self%.*};

    local _name=${_self}
    local -a _rest=()
    while (( $# )); do
        local _it=${1}
        case "${_it}" in
            # --template-flag=*) _flags[--template_flag]=${_it#--template-flag=};;
            --name=*) _name="${it#--name=}" ;;
            --deb=*) echo "${_it#--deb=}" | sudo tee -a /etc/sources.list.d/${_name}.list ;;
            --sign=*) local _sign="${_it#--sign=}"
                      (cd /etc/apt/trusted.gpg.d; sudo curl ${_sign} -fsSlO) ;;

            # https://blog.sleeplessbeastie.eu/2018/08/08/how-to-download-public-key-used-to-verify-gnupg-signature-for-the-repository/
            --key=*) local _key="${_it#--key=}"
                     sudo gpg2 --no-default-keyring --keyring gnupg-ring:/etc/apt/trusted.gpg.d/${_name}.gpg --keyserver keyserver.ubuntu.com --receive-key ${_key}
                     chmod 644 /etc/apt/trusted.gpg.d/${_name}.gpg ;;
            *) _rest+=(${_it}) ;;
        esac
        shift
    done
    
    sudo apt update || return 1
    sudo apt upgrade -y || return 1
    sudo apt install -y ${_rest[*]} || return 1
    sudo apt-mark auto ${_rest[*]} || return 1
}


function apt.install.all {
    : 'public, usage: apt.install.all'
    local _self=${FUNCNAME[0]}
    local _fn=${_self%%.*}

    local _forward=${_self%.all}

    apt.install openssl openssh-server ssh-import-id whois xdg-utils cloud-init ttyrec python3 emacs inotify-tools incron wmctrl gnupg2
    apt.install --name=osquery --key=1484120AC4E9F8A1A577AEEE97A80C63C9D8B80B --deb="'deb [arch=amd64] https://pkg.osquery.io/deb deb main'" osquery
}


# Make this file a "module".
# Extract mod from pathname.
function pn2mod { local _result=${1##*/}; echo ${_result%%.*}; }
# Augment functions above with "module" conventions.
mod.mkmod $(pn2mod ${1:-${BASH_SOURCE[0]}}) ${2:-$(realpath ${BASH_SOURCE[0]})}
