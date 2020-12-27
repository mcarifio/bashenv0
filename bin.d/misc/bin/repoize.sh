#!/bin/bash
here=$(readlink -f $(dirname $BASH_SOURCE))

function error {
    echo "$1" 1>&2
    exit 1
}

series=$(lsb_release --short --code)
component=wip
repo=${2:-$PWD/dists/$series/$component/binary-$(dpkg-architecture -qDEB_BUILD_ARCH)}
debs=${1:-$PWD}

mkdir --parent $repo
set -x
ln -s $repo $debs/..
dpkg-scanpackages $repo | gzip -c > $repo/Packages.gz
cat<<EOF | tee deb.list
deb http://10.0.1.144:8000 $series $component
EOF
python3 -m http.server
