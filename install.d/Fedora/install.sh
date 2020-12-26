#!/usr/bin/env -S sudo bash
# `-S sudo bash` means `${}` is a sudoer.

set -euo pipefail
IFS=$'\n\t'
shopt -u nullglob


declare _me=$(realpath -s ${BASH_SOURCE}) _you=$(id -u) _id=$(lsb_release -si) # Ubuntu, Fedora, others

function _e {
    local _status=${2:-1}
    >&2 echo "$1"
    exit ${_status}
}

[[ ${_id} != Fedora ]] && _e "Expecting Ubuntu, found ${_id}."    
[[ ${_you} != 0 ]] && _e "Could not elevate to root to run ${_me}"

declare _here=${_me%/*}
declare _prefix="$(printf "%s:" ${_here}/{..,../../lib})"
PATH="${_prefix}${PATH}"

function ssource {
    shopt -u nullglob
    for s in "$*"; do source ${s} &> /dev/null || true ; done
}
    
ssource lib.fn.sh ${_id}.fn.sh

# https://rpmfusion.org/Configuration
dnf+install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
    https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
dnf+install https://github.com/rpmsphere/noarch/raw/master/r/rpmsphere-release-32-1.noarch.rpm

# install packages
dnf+install ${_me}.log whois xdg-utils snap cloud-init ttyrec

# dnf+install go
snap install --classic go
mkgopath
go+install go-t

snap install multipass


# add users
useradd git bashenv skippy
