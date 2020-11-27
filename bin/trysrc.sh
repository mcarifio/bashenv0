#!/usr/bin/env bash
me=$(realpath ${BASH_SOURCE})
here=${me%/*}



function f {
    echo "$* # ${me}"
}


source /dev/stdin
