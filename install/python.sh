#!/bin/bash

here=$(dirname $(readlink -f $0))
source $here/functions.src.sh

check_user root

agi python3{,-all} python-{setuptools,xattr,pip} ipython

# pip stuff here


