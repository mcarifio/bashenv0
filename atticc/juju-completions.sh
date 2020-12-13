# Mike Carifio <mike@carifio.org>
# usage: source juju-completions.sh ; source juju-set-env.sh <juju_environment>
# http://www.gnu.org/software/bash/manual/bash.html#Programmable-Completion

# This is really the best I can find on this topic.
# http://www.debian-administration.org/article/An_introduction_to_bash_completion_part_{1,2}


# function _source indicates how to complete the 'source' command in bash. See the 'complete' command
# below which associates a "completion spec" ('-F _source') with a word ('source').
function _source {

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
    #local cur prev
    #_get_comp_words_by_ref cur prev
    local cur prev words cword
    _init_completion || return


    # Use the usual completion for 'source' if previous_word isn't juju-set-env.sh.
    if [[ $prev = source ]] ; then
        COMPREPLY=( $(compgen -f $cur ) )
        return 0

    # Completion for the first arg to juju-set-env.sh is a juju environment.
    # Let's try to complete the argument name.
    elif [[ $(basename $prev) = "juju-set-env.sh" ]] ; then
        COMPREPLY=( $(compgen -W "$($(readlink -f $(dirname $BASH_SOURCE))/juju-envs.py $cur)" -- $cur) )
        return 0
    # Let bash default machinery kick in.
    # XXX doesn't actually seem to work
    else
        return 124
    fi
}

complete -o bashdefault -F _source source





