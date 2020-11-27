#!/usr/bin/env bash
# set -x

me=$(realpath ${BASH_SOURCE})
here=${me%/*}
suffix=$(basename ${me} .sh)
dir=$(realpath ${1:-${PWD}})
[[ -d ${dir} ]] || { echo "${dir} not a directory" > /dev/stderr ; exit 1; }
name=$(basename ${dir} .sh)
tar=${name}.${suffix}.txz
tar cJf ${tar} -C ${dir}/..  ${name}
[[ -f ${tar} ]] && echo "Created $(realpath ${tar})"
