#!/usr/bin/env bash
me=$(realpath -s ${BASH_SOURCE:-$0})
here=$(dirname ${me})
self=$(basename ${me} .sh)
when=$(date -I)
     
content=${1:-${PWD}}
project=$(basename ${content})
zipfile=${2:-${content}/../${project}-${when}.zip}
ignore=${3} # tbs
zipfile=$(realpath -s ${zipfile})

tmp=/tmp/${self}
working=${tmp}/$$
summary=${working}/summary.sh

[[ -f ${zipfile} ]] && rm -v ${zipfile}

# TODO mikec@crescendocg.com: use .gitignore etc to ignore irrelevant files?
(set -x; cd ${content}/.. ; zip -r ${zipfile} ${project})
mkdir -p ${working}

trap "rm -rf ${tmp}" EXIT
printf "author='${USER}'\nzipfile='${zipfile}'\ngenerator='${me}'\ndate='$(date)'\nproject='${zipname}'" > ${summary}
(cd ${working}; zip ${zipfile} $(basename ${summary}))
unzip -l ${zipfile}
