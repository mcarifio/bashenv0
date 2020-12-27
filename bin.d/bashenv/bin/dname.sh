#!/usr/bin/env bash

name=${1?:'expecting a domain name'}
output=/tmp/${name}.whois.text
if whois ${name} > ${output} ; then
    url=http://${name}/
    # curl ${url} > /tmp/${name}.html
    gnome-open ${url}
fi

    
