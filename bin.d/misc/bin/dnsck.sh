#!/usr/bin/env bash

# Ubuntu: apt install whois xdg-utils
# Fedora: dnf install whois xdg-utils

name=${1:?'expecting a name'}

function surf {
    local url=$1
    curl -IL --max-time 10 ${url} && xdg-open ${url}
}

if ( set -x ; whois ${name} ) ; then
    surf http://www.${name}
fi
