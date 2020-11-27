#!/usr/bin/env bash

# I update enough at the command line to warrent it's own little command.
# I typically place this command in ~root/bin/update.sh

# Note: apt logs in /var/log/apt/{term,history}.log, so you can review past results there.
# Note: ln -s /root/bin/update.sh /etc/cron.daily  # will run this script as a daily root crontask.

# To run this script daily: ln -s /root/bin/update.sh /etc/cron.daily

# Assumes your effective id (euid) is root (or 0).
(( id -u != 0 )) && { echo "You must run `${me}` as root."; exit 1; }

me=$(realpath ${BASH_SOURCE})
here=${me%/*}

function finish {
    local code=$?
    echo "finish ${me} with exit code ${code} at '$(date)'" >> ${me}.log
    exit ${code}
}
trap finish EXIT



apt update
apt full-upgrade -y  # remove old packages as needed

# Deal with any packages "held_back" explicitly. Has to be a more elegant way.
# https://serverfault.com/questions/958003/how-to-disable-warning-apt-does-not-have-a-stable-cli-interface
# held_back is the explicit list of packages currently "held back", the "pipe chain" below is sorta gross.
held_back=$(apt list --upgradable 2>/dev/null|tail -n+2 | cut -d'/' -f1)

# If some packages are held back, try upgrading them explicitly.
[[ -z "${held_back}" ]] || (set -x; apt upgrade "${held_back}" )

# Remove orphaned packages.
apt autoremove -y

# Clean up downloads.
apt autoclean -y

