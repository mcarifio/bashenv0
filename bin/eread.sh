#!/usr/bin/env bash

here=$(dirname $(readlink -f $0))
me=$(basename $0)

function error {
		echo "$*" > /dev/stderr
		exit 1
}


# doc, what to read, required argument
doc=$(readlink -f ${1?-"expecting a doc"})
[[ -f $doc ]] || error "Can't find $doc"

# notes, comments on doc, generated if unavailable
notes=${2:-${doc}.notes.txt}

[[ -f $notes ]] || cat <<EOF > $notes
$USERNAME $(date +%d/%m/%Y)
Notes for $doc
---------------------------


EOF

## assumes: sudo apt-get install -y attr to get {get,set}fattr
## TODO mcarifio: use the extended attribute to figure out where notes are kept
##   Could be a website for example.

## TODO mcarifio: handle get/set of extended attributes better in bash
setfattr -n user.notes_on -v $notes $doc
setfattr -n user.notes_for -v $doc $notes


# read the doc and open the associated notes
gnome-open $doc &
emacsclient $notes &


