#!/usr/bin/env bash
me=$(realpath ${BASH_SOURCE})
here=${me%/*}

pathname=$(realpath ${1:?'expecting a pathname'})
filetype=$(file -b ${pathname})

# https://support.ssl.com/Knowledgebase/Article/View/19/0/der-vs-crt-vs-cer-vs-pem-certificates-and-how-to-convert-them

# https://www.tldp.org/LDP/Bash-Beginners-Guide/html/sect_07_03.html
case ${filetype} in
    'PEM certificate') ( set -x; openssl x509 -text -noout -in ${pathname} )
                       exit 0
                       ;;
esac

cat ${pathname}

