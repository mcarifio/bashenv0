# apt.mod.sh
# apt install software as a user 

function apt.not-installed {
    : 'apt.not-installed pkg*'
    local _self=${FUNCNAME[0]};
    local _mod_name=${_self%%.*};
    local _mod=${_self%.*};

    for _p in $*; do dpkg -s ${_p} &> /dev/null || printf '%s ' ${_p} ; done
    
}

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
            --name=*) _flags[--name]="${it#--name=}" ;;
            --repo=*) _flags[--repo]="${_it#--repo=}" ;;
            --ppa=*) _flags[--ppa]="${_it#--ppa=}" ;;
            --suffix=*) _flags[--suffix]="${_it#--suffix=}" ;;
            --sign=*) _flags[--sign]="${_it#--sign=}" ;;

            # https://blog.sleeplessbeastie.eu/2018/08/08/how-to-download-public-key-used-to-verify-gnupg-signature-for-the-repository/
            --key=*) _flags[--key]=${_it#--key=} ;;
            *) _rest+=(${_it}) ;;
        esac
        shift
    done

    # filter out installed packages
    _rest=( $(apt.not-installed ${_rest[*]}) )
    # return if all packages already installed
    (( ${#_rest[*]} )) || return 0

    _name=${_flags[--name]:-${_rest[0]}}
    [[ -n "${_flags[--sign]}" ]] && apt.sign "${_flags[--sign]}" "${_name}"
    [[ -n "${_flags[--key]}" ]] && apt.key "${_flags[--key]}" "${_name}"
    [[ -n "${_flags[--repo]}" ]] && apt.repo "${_name}" "${_flags[--repo]}" "${_flags[--suffix]}"
    [[ -n "${_flags[--ppa]}" ]] && apt.ppa "ppa:${_flags[--ppa]}"
    
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
    apt.install --name=osquery --key=1484120AC4E9F8A1A577AEEE97A80C63C9D8B80B --repo='https://pkg.osquery.io/deb' --suffix='deb main' osquery
    apt.install --name=razergenie --sign='https://download.opensuse.org/repositories/hardware:razer/xUbuntu_20.10/Release.key' \
                --repo='http://download.opensuse.org/repositories/hardware:/razer/xUbuntu_20.10/' --suffix='/' razergenie

    # https://github.com/cli/cli/blob/trunk/docs/install_linux.md
    apt.install --name=gh --key=C99B11DEB97541F0 --repo='https://cli.github.com/packages' gh

    apt.install --name=arangodb --repo='https://download.arangodb.com/arangodb37/DEBIAN/' --suffix='/' \
                --key='EA93F5E56E751E9B' arangodb3

    # https://debian.neo4j.com
    apt.install --name=neo4j --sign='https://debian.neo4j.com/neotechnology.gpg.key' \
                --repo='https://debian.neo4j.com' --suffix='stable latest' neo4j

    apt.install --name=terraform --sign='https://apt.releases.hashicorp.com/gpg' \
                --repo='https://apt.releases.hashicorp.com' --suffix="$(lsb_release -cs) main"

    # apt.install --ppa=cncf-buildpacks/pack-cli pack-cli

    # boot a windows 10 qemu image
    # https://www.microsoft.com/en-us/software-download/windows10ISO/ # download iso
    # https://www.techrepublic.com/article/how-to-install-windows-10-in-a-vm-on-a-linux-machine/
    # https://help.ubuntu.com/community/KVM/Installation
    # sudo acpidump -n MSDM  # get the microsoft key from windows bios, depends on the bios
    # lenovo w540: NYVPX-J43BV-Y3DRV-XB8F8-4VTR3
    
    apt.install acpica-tools qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils
    sudo adduser `id -un` libvirt
    sudo adduser `id -un` kvm

    # https://github.com/haskell/haskell-language-server#prerequisites
    apt.install libicu-dev libncurses-dev libgmp-dev zlib1g-dev
    
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
    local _mod_name=${_self%%.*}
    local _mod=${_self%.*}

    printf '%s\n' osquery $(cat $(dirname $(${_mod}.mod.pathname))/${_self}*.list 2>/dev/null | uniq | sort)
}

function apt.sign {
    # ( cd /etc/apt/trusted.gpg.d; sudo curl -fsSl -o "$2" "$1" )
    wget -O - "$1" | sudo apt-key add -

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
