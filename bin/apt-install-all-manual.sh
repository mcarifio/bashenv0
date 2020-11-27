#!/usr/bin/env bash
me=$(realpath ${BASH_SOURCE})
here=${me%/*}

if (( $(id -u) != 0 )) ; then
    exec sudo ${me} "$*"  # rerun as root, replacing this command
fi

function apt_installed {
    dpkg --list $1 &> /dev/null
}

function i {
    apt_installed $1 || apt install -y $1
}

function snap_installed {
    snap list $1 &> /dev/null
}

function s {
    local name=${1:?'expecting a name'}
    local tracking=${2:?'expecting a track'}
    local notes=${3:?'expecting a note'}
    local flag=''
    local track=''
    
    [[ ${notes} -eq 'classic' ]] && flag='--classic'
    [[ ${notes} -eq 'devmode' ]] && flag='--devmode'
    [[ ${tracking} -eq 'beta' ]] && track='--beta'
    [[ ${tracking} -eq 'edge' ]] && track='--edge'
    
    
    snap_installed $1 || snap install -y ${flag} ${track} $1
}



# Is apt-key add idempotent? How does it avoid duplicates?
# apt-key add the keys if the (exported) file is passed.
key_file=${1}
[[ -n "${key_file}" ]] && apt-key add ${key_file}

# Prep
apt update
apt upgrade -y
apt autoremove -y

# https://www.linuxjournal.com/content/bash-trap-command
function on_exit {
    apt autoremove -y
    apt clean
    apt autoclean
}
trap on_exit EXIT




# usage: `aptitude search '~i!~M!~E!~prequired!~pimportant' | awk '{print $1,$2} | apt-install-all-manual.sh [apt-trusted-keys]
# or: apt-install-all-manual.sh [apt-trusted-keys] < ${HOSTNAME}-apt.list < ${HOSTNAME}-snap.list
# or: snap list | tail -n+2 | awk '{print "s", $1, $4, $6}' | apt-install-all-manual.sh [apt-trusted-keys]

source /dev/stdin
