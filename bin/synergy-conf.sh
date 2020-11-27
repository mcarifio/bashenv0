#!/bin/bash
# -*- tab-indent: 2 -*-
# Mike Carifio <carifio@usys.com>
# usage: synergy-conf.sh (left|right) jetbook client0 client1 client2 | synergys -f /dev/stdin


direction=$1; shift

echo "section: screens"
for c in $* ; do echo "  $c:" ; done
echo "end"

server=$1 ; shift
current=$server
echo "section: links"
for c in $* 
do 
  printf "  $current:\n    $direction = $c\n"
  current=$c
done     
echo "end"