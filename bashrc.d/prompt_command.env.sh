# Source this file.
shopt -s histappend                      # append to history, don't overwrite it

function prompt_command {
    # https://askubuntu.com/questions/67283/is-it-possible-to-make-writing-to-bash-history-immediate
    # seems wasteful
    # note that the scope of this is all interactive bash sessions for a given user, e.g. `mcarifio`
    history -a
    history -c
    history -r
    # doesn't yet work with tmux?
    echo -ne "\033]0;$PWD\007"
}

PROMPT_COMMAND=prompt_command


