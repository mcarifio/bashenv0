function go.__template__ {
    local _self=${FUNCNAME[0]}
    echo ${_self} tbs
}
export -f go.__template__

function go.check {
    f.apply file.is.dir $(go env GOPATH)/{src,pkg,bin} || f.err "missing directories in $(go env GOPATH)"
}
export -f go.check
