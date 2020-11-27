#!/bin/bash

here=$(dirname $(readlink -f $0))
source $here/functions.src.sh

check_user root

agi qt-sdk qt4-{demos,dev-tools,designer,doc-html,qmake} qtcreator{,-doc} python-qt4{,-dev,-dbg}

