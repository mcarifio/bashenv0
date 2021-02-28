#!/usr/bin/env bash

# stackexchange.com/questions/337121/how-to-get-drive-serial-number-from-mountpoint
# exclude loop devices https://ubuntu.forumming.com/question/3943/exclude-loop-snap-devices-from-lsblk-output
sudo lsblk -e7 -o NAME,LABEL,SERIAL,MOUNTPOINT
