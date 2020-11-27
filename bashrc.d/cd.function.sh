# Creates directory to cd into iff needed.
# Replaces and extends mkcd.function.sh (now deprecated).
# We'll see how I like this.

function cd {
    local dir=${1:-${HOME}}
    [[ -d $dir ]] || mkdir -vp $dir
    builtin cd $dir
}
