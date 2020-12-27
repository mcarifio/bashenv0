#!/usr/bin/env bash

# Run terminator remotely iff you can ssh to the machine first.

me=$(realpath -s ${BASH_SOURCE:-$0})
here=$(dirname ${me})

_ssh_terminator() {
    local host=${1:?'host required'}
    
    if ssh ${host} id &>/dev/null ; then
        (set -x; autossh -X -Y ${host} terminator) &
    else   
           if ping -c 1 ${host} &>/dev/null ; then
               >&2 echo "Can't ssh to ${host}"
           else
               sudo etherwake -i bond0 ${host}
               >&2 echo "Trying to boot ${host} now. Try again in a few minutes."
           fi    
    fi
}

# killall autossh to stop autossh jobs
# TODO mike@carif.io: find all *.local hosts at the command line? With a pattern?
# ssh-terminator.sh {zenterprise,atlantis}.local

for h in $*; do _ssh_terminator ${h} ; done




