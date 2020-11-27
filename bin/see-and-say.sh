#!/bin/bash
here=$(readlink -f $(dirname $BASH_SOURCE))

declare -l answer # always lowercase
exe=${1?-"expecting an executable, none found"} ; shift
for f in $@ ; do
  $exe $f
	# TODO fix eol
  read -n 1 -p "$f [y/n]" answer
  [[ "$answer" == "y" ]] && echo $f
done

