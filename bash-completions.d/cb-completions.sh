# Mike Carifio <mike@carifio.org>
# usage: source cb-completions.sh
# http://www.gnu.org/software/bash/manual/bash.html#Programmable-Completion

# This is really the best I can find on this topic.
# http://www.debian-administration.org/article/An_introduction_to_bash_completion_part_{1,2}


function _cb {

    # Init Variables
    # --------------

    # 'COMPREPLY' is populated to communicate potential completions to bash.
    # Initial start, haven't found any completions.
    # COMPREPLY=()

    # You can map several "first words" to this function.
    # 'first_word' will tell us which word we're starting with.
    #local first_word=$1

    # 'cur', the current word we're trying to complete.
    # 'prev' is the previous to 'cur' word. In our case, this tells which file we want to source in.
    # Note: these two lines are stylized.
    local cur prev words cword
    _init_completion || return

    # switch completion, add short and long switchs to the end
    short_opts='-h'
    long_opts='--help'
    if [[ $cur == '-*' ]] ; then
        COMPREPLY=( $(compgen -W "$short_opts $long_opts" -- $cur) )
        return 0
    fi

    if [[ $cur == '--*' ]] ; then
        COMPREPLY=( $(compgen -W "$long_opts" -- $cur) )
        return 0
    fi

    if (( cword == 1 )) ; then # first arg
        COMPREPLY=( $(compgen -f ~/.config/chromium*) )
        return 0
    fi
}

complete -F _cb cb.sh
