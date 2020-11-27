#!/bin/bash
here=$(dirname $(readlink -f $0))
source $here/functions.src.sh

check_user root
agi bar $(<$(basename $0 .sh).list)

# configure .nailrc and .mailrc
cat <<EOF > ~/.nailrc
set smtp=smtp.gmail.com:587
set smtp-use-starttls
set smtp-auth=cram-md5
set ssl-no-default-ca
set ssl-ca-file=/etc/ssl/certs/ca-certificates.crt
set ssl-verify=strict

set smtp-auth=login
set smtp-auth-user=carifio@usys.com
set smtp-auth-password=4rebecca
EOF
chmod 600 ~/.nailrc


cat<<EOF > ~/.mailrc
set NAIL_EXTRA_RC=~/.nailrc
EOF
