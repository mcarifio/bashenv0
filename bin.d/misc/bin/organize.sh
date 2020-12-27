#!/usr/bin/env bash

# useful command to currate ~/Downloads

me=$(realpath ${BASH_SOURCE})
here=${me%/*}
conf=${me}.conf
[[ -s $conf ]] && source ${conf}

src=${1:?'expecting a file name'}
backup=$(realpath ${src})
backup=${backup%/*}/backup
dest=${2:?'expecting a target directory'}
mode=${3:-660}
suffix=$(tr -d '[:blank:]' <<< ${src} | tr '[:upper:]' '[:lower:]' | tr '_' '-')

# install creates intermediate directories as needed, but assumes its copying an
#   executable, hence the mode overwrite.
install -p -m=${mode} -D ${src} ${dest}/${suffix}
if [[ -d ${backup} ]] ; then
    mv ${src} ${backup}
    xz ${backup}/${src}
fi
