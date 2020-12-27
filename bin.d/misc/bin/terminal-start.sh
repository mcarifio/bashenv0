#!/usr/bin/env bash

gnome-terminal --window -e 'pwd' --tab -e 'pwd' --tab -e 'pwd' --tab -e 'pwd' --tab -e 'pwd' --tab -e 'pwd' --tab -e 'pwd' 
gnome-terminal --window -e 'sudo' --tab -e 'ssh atlantis.local'
exit 0
