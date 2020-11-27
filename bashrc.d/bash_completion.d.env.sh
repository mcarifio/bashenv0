# Create a private function, call it, undefine it.
function ___f {
    shopt -s nullglob
    local bash_completion_d=${1:?'expecting a directory'}
    for c in ${bash_completion_d}/*.bash-completion ; do
        local cc=$(realpath -s ${c})
        source ${cc} || >&2 echo ${cc} error
    done
}


# from where?
___f ${XDG_CONFIG_HOME:-$HOME/.config}/bash_completion.d
___f ${BASHENV}/bash_completion.d
unset -f ___f
