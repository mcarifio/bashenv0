#!/usr/bin/env bash

# Checks your *single* public IP address. If it changes, run an associated "change script" which will update various
# public services based on your new IP address. Add this to cron for a machine that is usually mostly on.

me=$(readlink -f ${BASH_SOURCE})  # full pathname of this script
me_text=${me}.last_public_address # last public IP address associated with this script
me_history=${me}.history # history of this script's runs

# Get the current public ip address `current_public_address`
current_public_address=$(curl --silent http://api.ipify.org/)

# Read the last available IP address from a previous successful run iff available.
last_public_address=''
[ -r "${me_text}" ] && last_public_address=$(< ${me_text})

# Remember the retrieved address for next time iff you fetched one successfully.
[ -z "${current_public_address}" ] || echo ${current_public_address} > ${me_text}

# Did the address change?
if [[ "${current_public_address}" != "${last_public_address}" ]] ; then
    # Yes, run a hook bash script.
    ${me}-change.sh ${current_public_address} ${last_public_address} | tee ${me_history}   
else
    # No. Record the run.
    echo "$(date): ${current_public_address} no change" >> ${me_history}
fi
