#!/usr/bin/env bash

# return the set of initially installed packages, sorted as a list
function initially_installed {
    gunzip -c /var/log/installer/initial-status.gz | grep '^Package:' | cut -c10- | sort | uniq
}

# return the set of currently installed packages, sorted as a list
function currently_installed {
    dpkg-query --show --showformat='${binary:Package}\n'| sed 's/:.*$//g' | sort | uniq
}



# XXX: assumes end user didn't purge an initially installed ubuntu package.
# This is a pretty good assumption, but not always true.

comm -13 <(initially_installed) <(currently_installed)
