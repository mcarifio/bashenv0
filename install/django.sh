#!/bin/bash
here=$(dirname $(readlink -f $0))
source $here/functions.src.sh

check_user root

# https://wiki.ubuntu.com/Django
# TODO mcarifio: write a juju charm to do this
# TODO: would dependencies install python first?

agi libapache2-mod-python python-django python-django-doc ## eventually do mod_wsgi




