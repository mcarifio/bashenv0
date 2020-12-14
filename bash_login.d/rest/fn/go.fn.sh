function go.fn.__template__ {
    local _self=${FUNCNAME[0]}
    declare -F ${_self}
}

function go.fn.defines {
    local _self=${FUNCNAME[0]}
    export -f  2>&1 | grep "declare -fx go"
}
export -f go.fn.defines

function go.fn.pathname {
    local _self=${FUNCNAME[0]}
    u.value $(me.pathname)    
}
export -f go.fn.pathname






function go.bootstrap {
    sudo.snap.install --classic go && go.mkgopath    
}
export -f go.bootstrap

function go.mkgopath {
    local _gopath=$(go env GOPATH)
    [[ -z "${_gopath}" ]] && f.err '$(go env GOPATH) failed'
    file.mkdir ${_gopath}/{bin,pkg,src} && go.check
}
export -f go.mkgopath

function go.i1 {
    go install -i $*
}
export -f go.i1

function go.install {
    f.apply go.i1 $*
}
export -f go.install


function go.install.all {
    go.bootstrap
    go.install go-t
}
export -f go.install.all


function go.check {
    f.apply file.is.dir $(go env GOPATH)/{src,pkg,bin} || f.err "missing directories in $(go env GOPATH)"
}
export -f go.check


