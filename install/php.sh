#!/bin/bash
here=$(dirname $(readlink -f $0))
source $here/functions.src.sh

check_user root

agi php5 php5-{dev,memcache,mysql,sqlite,xdebug,curl,pear,mcrypt} zend-framework{,-bin} phpunit 

# configure debug
