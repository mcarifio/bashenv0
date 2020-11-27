# http://seanbowman.me/blog/fzf-fasd-and-bash-aliases/
jd() {
    local dir
    dir=$(find ${1:-*} -path '*/\.*'\
        -prune -o -type d\
        -print 2> /dev/null | fzf +m)
    [ -d "$dir" ] && pushd "$dir"
}

complete -d jd
