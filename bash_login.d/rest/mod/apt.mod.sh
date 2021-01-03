# apt.mod.sh
# apt install software as a user 


function apt.install {
    : 'public, usage: apt.install [--key=${url}] [--deb="deb [arch=amd64] ${url} ${parts...}"'
    local _self=${FUNCNAME[0]};
    local _mod_name=${_self%%.*};
    local _mod=${_self%.*};

    local -A _flags=([--name]=${_self} [--url]='' [--suffix]='' [--sign]='' [--key]='' [--ppa]='')
    local -a _rest=()
    while (( $# )); do
        local _it=${1}
        case "${_it}" in
            # --template-flag=*) _flags[--template_flag]=${_it#--template-flag=};;
            --name=*) _flags[--name]=${it#--name=} ;;
            --url=*) _flags[--url]=${_it#--url=} ;;
            --ppa=*) _flags[--ppa]=${_it#--ppa=} ;;
            --suffix=*) _flags[--suffix]=${_it#--suffix=} ;;
            --sign=*) _flags[--sign]=${_it#--sign=} ;;

            # https://blog.sleeplessbeastie.eu/2018/08/08/how-to-download-public-key-used-to-verify-gnupg-signature-for-the-repository/
            --key=*) _flags[--key]=${_it#--key=} ;;
            *) _rest+=(${_it}) ;;
        esac
        shift
    done

    _name=${_flags[--name]:-${_rest[0]}}
    [[ -n "${_flags[--sign]}" ]] && (cd /etc/apt/trusted.gpg.d; sudo curl ${_flags[--sign]} -fsSlO)
    [[ -n "${_flags[--key]}" ]] && apt.key ${_flags[--key]} ${_name}
    [[ -n "${_flags[--url]}" ]] && echo "deb [arch=amd64] ${_flags[--url]} ${_flags[--suffix]}" | sudo install /dev/stdin /etc/apt/sources.list.d/${_name}.list
    [[ -n "${_flags[--ppa]}" ]] && sudo add-apt-repository -y ppa:${_flags[--ppa]}
    
    sudo apt update || return 1
    sudo apt upgrade -y || return 1
    sudo apt install -y ${_rest[*]} || return 1
    sudo apt-mark auto ${_rest[*]} || return 1
}


function apt.install.all {
    : 'public, usage: apt.install.all'
    local _self=${FUNCNAME[0]}
    local _mod_name=${_self%%.*};
    local _mod=${_self%.*};

    local _forward=${_self%.all}

    apt.install openssl openssh-server ssh-import-id whois xdg-utils cloud-init ttyrec python3 emacs inotify-tools incron wmctrl gnupg2
    apt.install --key=1484120AC4E9F8A1A577AEEE97A80C63C9D8B80B --url='https://pkg.osquery.io/deb' --suffix='deb main' osquery
    apt.install --ppa=jgmath2000/et et
}

function apt.key {
     sudo gpg2 --export --no-default-keyring --keyring gnupg-ring:/etc/apt/trusted.gpg.d/${2:-$1}.gpg --keyserver keyserver.ubuntu.com --receive-key ${1:-$(return $(f.err "expecting key"))}    
}

# Make this file a "module".
# Extract mod from pathname.
function pn2mod { local _result=${1##*/}; echo ${_result%%.*}; }
# Augment functions above with "module" conventions.
mod.mkmod $(pn2mod ${1:-${BASH_SOURCE[0]}}) ${2:-$(realpath ${BASH_SOURCE[0]})}
