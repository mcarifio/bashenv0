#!/bin/bash

function error {
    echo "$*" 2>&1
    exit 1
}



remote=${1:?'Expecting a remote file'} # e.g. 'jetbook.local:/some/path/to/file'

# Separate remote in a host and pathname, e.g. 'jetbook.local' and '/some/path/to/file' 
host=${remote%%:*}
pathname=${remote##*:}

# Local pathname is same as remote unless user overrides it.
local=${2:-$pathname}


# Here: got all the user direction, let's diff local and remote:
diff=${RDIFFER:-meld}

error "$local is wrong, fix later"
$diff <(ssh $host cat $pathname) $local


