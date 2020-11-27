#!/bin/bash
#
# Mike Carifio <michael.carifio@canonical.com>

re=
[[ $PWD =~ $HOME/Projects/([^/]*)/? ]]
echo ${BASH_REMATCH[1]}

