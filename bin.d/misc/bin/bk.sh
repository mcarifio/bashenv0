#!/bin/bash
# emacs tabs tbs
# Mike Carifio <carifio@usys.com>

function usage {
		echo "$0 file..."
		exit 1
}

here=$(readlink -f $(dirname $BASH_SOURCE))
bk_path=${BK_PATH:-/media/backup}


for f in $* ; do
		file=$(readlink -f $f)
		dir=$(dirname $file)
		# TODO mcarifio: is rsync smart enough to create the directory?
		bk_path_dir=$bk_path/$dir
		[[ -d $bk_path_dir ]] || mkdir -p $bk_path_dir
		target=$bk_path/$file
		rsync --backup --xattrs $file $target
		if [[ -f $target ]] ; then
		  ls -l $target
		else
			echo "'$target' wasn't copied." > /dev/stderr
		fi
done