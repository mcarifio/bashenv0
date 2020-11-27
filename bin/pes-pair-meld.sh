#!/bin/bash

function newest_dir { 
    stat --printf='%Y\t%n\n' $* |sort -g -r -k1|head -1|cut -f2
}

pkg=$(basename $(readlink -f ..))
#project=omsk
#project=${1:-hedley}
project=${1:-omsk}
tool=${2:-meld}
dir=$(newest_dir $(echo ~/Projects/${project}-lucid-i386/$pkg/$pkg-*[!~]))
#$tool  ~/Projects/${project}-lucid-i386/$pkg/$pkg-*[!~] .
$tool  $dir .

