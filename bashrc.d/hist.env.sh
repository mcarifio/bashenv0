# Mike Carifio <mike@carif.io>
# Source this file to merge the history of bash commands from multiple windows (for a single user, e.g. `mcarifio`).

# Unlimited sizes, including the bash history file. See ../cron/history-logrotate.sh for method to periodically rename
# the history file based on its size. Note, this makes using this file a little more brittle (since you have to manually create
# the cron job).

# https://unix.stackexchange.com/questions/1288/preserve-bash-history-in-multiple-terminal-windows
# TODO mcarifio 2011-05-05T10:53:08-0400: does this really work?
# shopt -s globstar # ** pattern matchin
# shopt -s nullglob # remove pattern if nothing matches, bashref p 24

# https://www.gnu.org/software/bash/manual/html_node/The-Shopt-Builtin.html
 
# see ./bash.env.sh as well
shopt -s histappend
export HISTCONTROL=${HISTCONTROL}:ignoredups:erasedups:ignoreboth:ignorespace
export HISTFILESIZE=-1
export HISTSIZE=-1


function background {
    local interval=${1:-60s}
    local command=${2:-'historic'}
    # while true ; do sleep ${interval} ; (set -x ; ${command} ) ; done    # verbose version
    while true ; do sleep ${interval} ; ${command} ; done  
}


# TODO mike@carif.io: ssh, tmux and mongodb versions of this
# http://www.linuxjournal.com/content/using-bash-history-more-efficiently-histcontrol

#if [[ -n "${HISTCONTROL}" ]] ; then
#    echo "Reassigning HISTCONTROL from '${HISTCONTROL}' to 'ignoreboth'" >&2
#fi

function historic {
    history -a
    history -n
    # echo "historic ran for $$" >> /tmp/historic.log
}

# jobs will report a clearer function name.
function dump_history_every_minute {
    background &
}

# Run historic in the background
dump_history_every_minute &



