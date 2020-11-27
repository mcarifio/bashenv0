#!/bin/bash

here=$(dirname $(readlink -f $0))
source $here/functions.src.sh

check_user root

agi juju puppet chef


