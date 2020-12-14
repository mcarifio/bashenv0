function go.__template__ {
    local _self=${FUNCNAME[0]}
    echo ${_self} tbs
}
export -f $_

function go.bootstrap {
    sudo.snap.install --classic go && go.mkgopath    
}
export -f $_

function go.mkgopath {
    local _gopath=$(go env GOPATH)
    [[ -z "${_gopath}" ]] && f.err '$(go env GOPATH) failed'
    file.mkdir ${_gopath}/{bin,pkg,src} && go.check
}
export -f $_

function go.i1 {
    go install -i $*
}
export -f $_

function go.install {
    f.apply go.i1 $*
}
export -f $_


function go.install.all {
    go.bootstrap
    go.install go-t
}
export -f $_


function go.check {
    f.apply file.is.dir $(go env GOPATH)/{src,pkg,bin} || f.err "missing directories in $(go env GOPATH)"
}
export -f $_

