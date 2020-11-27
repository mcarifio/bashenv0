#!/usr/bin/env bash
set -x
curl --user 'api:key-0effa90bcfc0e4d2d768048d8e5a1332' \
    https://api.mailgun.net/v3/dmarc.m00nlit.com/messages \
    -F from='mike@m00nlit.com' \
    -F to='dmarc-ruf@dmarc.m00nlit.com' \
    -F subject='Hello' \
    -F text='Testing some Mailgun awesomness!'
