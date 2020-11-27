#!/bin/bash
here=$(dirname $(readlink -f $0))
source $here/functions.src.sh

check_user root

agi r-recommended python-setuptools # python-setuptools also installed via python.sh
## easy_install rpy2 ## TODO mcarifio: didn't work, why?
agi python-rpy2


