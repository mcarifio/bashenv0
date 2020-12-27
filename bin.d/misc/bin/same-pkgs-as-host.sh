#!/usr/bin/env bash

# This script will install all the apt and snap packages installed on another ubuntu machine. It assumes the reference machine is running the same release
# (otherwise the apt repositories might not be correct). Note that if you've installed unnecessary kruft on the reference machine, you'll get it on target.
# This might not be what you want, but sorting out exceptions takes significant effort also. This is by far the biggest limitation of this script. It
# can just propagate errors and bad installs, since I don't have a way right now to test that an installation worked or is working on the reference machine.

# me, the full canonical pathname for this script
me=$(realpath ${BASH_SOURCE})
# here, me's directory.
here=${me%/*}

# host, used to gather the apt and snap packages to install. Usually a FQDN, but .local can work, e.g. shuttle.m00nlit.com or shuttle.local.
host=${1:?'expecting a hostname'}

# You must run as root to execute several command below. If you forget to sudo `same-pkgs-as-host.sh`, we reissue the command as root.
if (( $(id -u) != 0 )) ; then
    exec sudo ${me} "$*"  # rerun as root, replacing this command
fi

# To simplify the implementation, you ssh into ${host} as root, unless you
#   create a ~/.ssh/ssh_config Host stanza to remap the username. We test to make sure
#   you can ssh into the host first.
#
# To configure:
#   sudo -i scp ~root/.ssh/id_rsa.pub ${host}:/tmp/${host}_root_id_rsa.pub
#   ssh ${host} cat /tmp/${host}_root_id_rsa.pub | sudo tee -a ~root/.ssh/authorized_keys
#
# To test: ssh root@${host} id
if ! ssh ${host} id ; then
    printf "Can't ssh to ${host} as user $(id)."
    exit 1
fi


# Is an apt package installed?
function apt_installed {
    dpkg --list $1 &> /dev/null
}

# Install an apt pkg if it isn't already installed. It will be upgraded on the next `apt upgrade`
function i {
    if apt_installed $1 ; then
        printf "# $1 installed, skipping.\n"
    else
        apt install -y $1
    fi    
}

# Is a snap installed?
function snap_installed {
    snap list $1 &> /dev/null
}


# Install a snap by constructing the right command based on the track and risk.
function s {
    local name=${1:?'expecting a name'}
    local tracking=${2:?'expecting a track'}
    local notes=${3:?'expecting a note'}
    local flag=''
    local track=''
    
    [[ "${notes}" -eq 'classic' ]] && flag='--classic'
    [[ "${notes}" -eq 'devmode' ]] && flag='--devmode'
    [[ "${tracking}" -eq 'beta' ]] && track='--beta'
    [[ "${tracking}" -eq 'edge' ]] && track='--edge'
    
    
    if snap_installed $1 ; then
        printf "# $1 installed, skipping.\n"
    else
        snap install ${flag} ${track} $1
    fi    
}



# Silently allow list.{g,x}z files in /etc/apt/sources.list.d. Hackcity.
if [[ ! -r /etc/apt/apt.conf.d/999gzxz ]] ; then
    cat<<EOF > /etc/apt/apt.conf.d/999gzxz
Dir::Ignore-Files-Silently:: "\.gz$";
Dir::Ignore-Files-Silently:: "\.xz$";
EOF
fi

# Add all ${host}'s repositories and apt keys.
ssh ${host} 'cat /etc/apt/sources.list.d/*.list' > /etc/apt/sources.list.d/${host}.list
[[ -n "$2" ]] && ssh ${host} apt-key exportall | apt-key add -

# If a past installation broke "in-flight", fix it.
dpkg --configure -a
apt install --fix-broken

# Identify newer packages.
apt update
apt upgrade -y
apt autoremove -y

# https://www.linuxjournal.com/content/bash-trap-command
function on_exit {
    apt upgrade -y 
    apt autoremove -y
    apt clean
    apt autoclean
}
trap on_exit EXIT


# Find all the apt
function remote_apt_pkgs {
    ssh ${1} aptitude search '~i!~M!~E!~prequired!~pimportant' | awk '{print $1,$2}'
}

function remote_snap_pkgs {
    ssh ${1} snap list | tail -n+2 | awk '{print "s", $1 == "-" ? "hyphen": "\"" $1 "\"", $4 == "-" ? "hyphen": "\"" $4 "\"", $6 == "-" ? "hyphen": "\"" $6 "\""}'
}

remote_apt_pkgs ${host} | source /dev/stdin
remote_snap_pkgs ${host} | source /dev/stdin


