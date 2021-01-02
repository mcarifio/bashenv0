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



function history.background {
    local _interval=${1:-60s}
    local _command=${2:-'history.historic'}
    # while true ; do sleep ${interval} ; (set -x ; ${command} ) ; done    # verbose version
    while true ; do sleep ${_interval} ; ${_command} ; done  
}

# TODO mike@carif.io: ssh, tmux and mongodb versions of this
# http://www.linuxjournal.com/content/using-bash-history-more-efficiently-histcontrol

#if [[ -n "${HISTCONTROL}" ]] ; then
#    echo "Reassigning HISTCONTROL from '${HISTCONTROL}' to 'ignoreboth'" >&2
#fi

function history.historic {
    history -a
    history -n
    # echo "historic ran for $$" >> /tmp/historic.log
}

# jobs will report a clearer function name.
function history.dump_history_every_minute {
    history.background &
}

export PROMPT_COMMAND='history.dump_history_every_minute;'${PROMPT_COMMAND}

# Make this file a "module".
# Extract mod from pathname.
function pn2mod { local _result=${1##*/}; echo ${_result%%.*}; }
# Augment functions above with "module" conventions.
mod.mkmod $(pn2mod ${1:-${BASH_SOURCE[0]}}) ${2:-$(realpath ${BASH_SOURCE[0]})}





