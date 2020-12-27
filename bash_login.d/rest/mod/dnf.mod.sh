# dnf.mod.sh
# dnf install software as a user 


function dnf.install {
    local _self=${FUNCNAME[0]};
    local _mod_name=${_self%%.*};
    local _mod=${_self%.*};
    
    sudo dnf upgrade --refresh --best --allowerasing -y | return 1
    sudo dnf install -y $* || return 1
}


function dnf.install.all {
    local _self=${FUNCNAME[0]}
    local _mod_name=${_self%%.*};
    local _mod=${_self%.*};
    
    local _forward=${_self%.all}
    ${_forward} git emacs python3 chromium gparted gnome-tweak-tool thunderbird golang nginx hyper zfs postgresql{,-server} @development-tools ffmpeg gstreamer{,-ffmpeg} \
                meld getmail jq golang-github-jmespath maildir-utils rust cargo gstreamer1-libav gstreamer1-plugins-ugly unrar copyq fuse-sshfs cmus flameshot mongodb-org \
                haskell-platform snapd dnf-plugin-system-upgrade code powershell kernel-devel kernel-headers gcc dkms acpid libglvnd-glx libglvnd-opengl libglvnd-devel pkgconfig\
                vdpauinfo libva-vdpau-driver libva-utils sox mosh autossh wireshark wireguard-dkms wireguard-tools nushell cockpit openssl-devel automake libtool \
                gperf libpng-devel dotnet-sdk-5.0 texinfo libjpeg-turbo-devel libtiff-devel giflib-devel libXpm-devel gtk3-devel gnutls-devel ncurses-devel \
                libxml2-devel libXt-devel @development-tools automake clang clang-devel highlight vlc remmina vokoscreenNG gstreamer1-plugin-openh264 opam ocaml nmap\
                editorconfig java-latest-openjdk{,-devel} hwinfo stack gh
}


# Make this file a "module".
# Extract mod from pathname.
function pn2mod { local _result=${1##*/}; echo ${_result%%.*}; }
# Augment functions above with "module" conventions.
mod.mkmod $(pn2mod ${1:-${BASH_SOURCE[0]}}) ${2:-$(realpath ${BASH_SOURCE[0]})}
