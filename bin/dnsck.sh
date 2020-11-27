#!/usr/bin/env bash

name=${1:?'expecting a name'}

function surf {
    local url=$1
    curl -IL --max-time 10 ${url} && gnome-open ${url}
}

if ( set -x ; whois ${name} ) ; then
    surf https://www.${name} || surf http://www.${name}
fi
