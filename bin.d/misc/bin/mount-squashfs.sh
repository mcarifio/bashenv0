#!/usr/bin/env bash


function usage {
cat <<EOF
$0 image.squashfs # mounts image.squashfs at /tmp/squashfs/image.squashfsa
EOF
}

squashfs=${1?:"expecting a squashfs image"}
mnt_pnt=/tmp/squashfs/$squashfs
[[ -d $mnt_pnt ]] || mkdir -p $mnt_pnt
sudo mount -o loop -t squashfs $squashfs $mnt_pnt
mount | grep "$mnt_pnt"
echo -e "\n\nWhen done: sudo umount $mnt_pnt \n\n"