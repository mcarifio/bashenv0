#!/usr/bin/env bash
# @see ../bashrc.d/hist.env.sh, which sets the HISTFILESIZE=-1 (unlimited size).
# Creates the need for this cronjob.

me=$(realpath ${BASH_SOURCE})
here=${me%/*}

# /usr/sbin not on PATH by default
# crontab entry: @weekly ~/bashenv/cron/history-logrotate.sh
# Note: /usr/sbin is not on path by default.
/usr/sbin/logrotate ${me}.conf

