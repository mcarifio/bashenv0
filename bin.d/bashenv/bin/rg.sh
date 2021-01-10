#!/usr/bin/env bash
export DISPLAY=:0.0
# do a nohup bash style according to:
# http://seejeffrun.blogspot.com/2008/05/bash-nohups-background-jobs.html
{ `gnome-shell --replace &> /dev/null`; } < /dev/stdin &
