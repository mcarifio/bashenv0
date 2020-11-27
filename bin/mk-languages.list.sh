#!/bin/bash
#set -x
here=$(readlink -f $(dirname $BASH_SOURCE))


#usage: mk-languages.list.sh <directory> [<name>]

directory=${1?-'expecting a directory, none found'}
language_list=${2:-$directory-languages.list}
status=0

for po in $directory/*.po; do echo $(basename $po .po); done > $language_list
echo "Created $language_list"

exit $status

