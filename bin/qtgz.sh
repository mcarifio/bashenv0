#!/usr/bin/env bash
# Mike Carifio <michael.carifio@canonical.com>

#set -x

# 'here', the directory where this script lives.
here=$(dirname $BASH_SOURCE)
[[ -f $here/util.fn.sh ]] && source -f $here/util.fn.sh

# Print usage and exit (if needed).
function usage {
    echo "$BASH_SOURCE [path [target]]"
    exit 1
}

path=${1:-$(basename $PWD)}
target=${2:-slicehost}
remote=$(basename $path).tgz

tar zxvf - $path | ssh $target "cat > $remote"
ssh $target ls -l $remote