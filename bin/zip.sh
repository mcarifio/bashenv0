#!/usr/bin/env bash
me=$(realpath -s ${BASH_SOURCE:-$0})
here=$(dirname ${me})
self=$(basename ${me} .sh)
project=$(basename ${PWD})
     
zipfile=${1:-${PWD}/../${project}.zip}
content=${2:-${PWD}}
ignore=${3} # tbs
zipname=$(basename ${zipfile} .zip)
zipfile=$(realpath -s ${zipfile})

tmp=/tmp/${self}
working=${tmp}/$$
summary=${working}/summary.sh

[[ -f ${zipfile} ]] && rm -v ${zipfile}

# TODO mikec@crescendocg.com: use .gitignore etc to ignore irrelevant files?
(cd ${content}/..; zip -r ${zipfile} ${zipname})
mkdir -p ${working}
trap "rm -rf ${tmp}" EXIT

printf "author='${USER}'\nzipfile='${zipfile}'\ngenerator='${me}'\ndate='$(date)'\nproject='${zipname}'" > ${summary}
(cd ${working}; zip ${zipfile} $(basename ${summary}))
unzip -l ${zipfile}
