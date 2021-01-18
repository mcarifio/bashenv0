# apt.mod.sh
# apt install software as a user 


function apt.install {
    : 'public, usage: apt.install [--key=${url}] [--deb="deb [arch=amd64] ${url} ${parts...}"'
    local _self=${FUNCNAME[0]};
    local _mod_name=${_self%%.*};
    local _mod=${_self%.*};

    local -A _flags=([--name]=${_self} [--repo]='' [--suffix]='' [--sign]='' [--key]='' [--ppa]='')
    local -a _rest=()
    while (( $# )); do
        local _it=${1}
        case "${_it}" in
            # --template-flag=*) _flags[--template_flag]=${_it#--template-flag=};;
            --name=*) _flags[--name]=${it#--name=} ;;
            --repo=*) _flags[--repo]=${_it#--repo=} ;;
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
    [[ -n "${_flags[--sign]}" ]] && apt.sign ${_flags[--sign]} ${_name}
    [[ -n "${_flags[--key]}" ]] && apt.key ${_flags[--key]} ${_name}
    [[ -n "${_flags[--repo]}" ]] && apt.repo ${_name} ${_flags[--repo]} ${_flags[--suffix]}
    [[ -n "${_flags[--ppa]}" ]] && apt.ppa ppa:${_flags[--ppa]}
    
    sudo apt update || return 1
    sudo apt upgrade -y || return 1
    sudo apt install -y ${_rest[*]} || return 1
    # sudo apt-mark auto ${_rest[*]} || return 1
    : 'remember installed pkgs'
    printf '%s ' ${_rest[*]} >> $(dirname $(${_mod}.mod.pathname))/${_self}.${HOSTNAME}.list
}


function apt.install.all {
    : 'public, usage: apt.install.all'
    local _self=${FUNCNAME[0]}
    local _mod_name=${_self%%.*};
    local _mod=${_self%.*};

    local _forward=${_self%.all}


    # install osqueryi etc
    apt.install --key=1484120AC4E9F8A1A577AEEE97A80C63C9D8B80B --repo='https://pkg.osquery.io/deb' --suffix='deb main' osquery
    apt.install --sign='https://download.opensuse.org/repositories/hardware:razer/xUbuntu_20.10/Release.key' --repo='http://download.opensuse.org/repositories/hardware:/razer/xUbuntu_20.10/' --suffix='/' razergenie

    # https://github.com/cli/cli/blob/trunk/docs/install_linux.md
    apt.install --key=C99B11DEB97541F0 --repo='https://cli.github.com/packages' gh 

    # install eternal terminal
    # apt.install --ppa=jgmath2000/et et
    : 'install list of packages from other machines if they are listed locally'
    apt.install $(cat $(dirname $(${_mod}.mod.pathname))/${_self}*.list 2>/dev/null)


    # should be a better place to put these
    sudo systemctl enable --now cockpit.socket
    
}

function apt.installed.all {
    : 'public, usage: apt.installed.all # report a list of pkgs apt.install.all will install'
    local _self=${FUNCNAME[0]}
    local _mod_name=${_self%%.*};
    local _mod=${_self%.*};

    printf '%s\n' osquery $(cat $(dirname $(${_mod}.mod.pathname))/${_self}*.list 2>/dev/null | uniq | sort)
}

function apt.sign {
    ( cd /etc/apt/trusted.gpg.d; sudo curl -fsSl -o $2 $1 )
}


function apt.repo {
    local _name=$1
    local _repo=$2
    local _suffix=$3
    echo "deb $(apt.arch) ${_repo} ${_suffix}" | sudo install /dev/stdin /etc/apt/sources.list.d/${_name}.list
}

function apt.arch {
   local -A _arch=([x86_64]='amd64')
   printf '[arch=%s]' ${_arch[${HOSTTYPE}]}
}

function apt.key {
    # broken
    sudo gpg2 --export --no-default-keyring --keyring gnupg-ring:/etc/apt/trusted.gpg.d/${2:-$1}.gpg --keyserver hkp://keyserver.ubuntu.com --receive-keys ${1:-$(return $(f.err "expecting key"))}    
}

function apt.ppa {
    local _ppa=$1
    sudo add-apt-repository -y ppa:${_ppa}    
}


# Make this file a "module".
# Extract mod from pathname.
function pn2mod { local _result=${1##*/}; echo ${_result%%.*}; }
# Augment functions above with "module" conventions.
mod.mkmod $(pn2mod ${1:-${BASH_SOURCE[0]}}) ${2:-$(realpath ${BASH_SOURCE[0]})}
