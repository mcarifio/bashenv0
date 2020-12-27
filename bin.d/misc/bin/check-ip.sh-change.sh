#!/usr/bin/env bash

me=$(readlink -f ${BASH_SOURCE})
current_public_address=${1:?'expecting the current ip address'}
last_public_address=${2:-'not provided'}

echo ${current_public_address} ${last_public_address}
