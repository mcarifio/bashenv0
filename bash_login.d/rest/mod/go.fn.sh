# go.fn.sh

function go.fn.__template__ {
    local _self=${FUNCNAME[0]}
    local _fn=${_self%%.*}

    u.value $(ssh.fn.pathname)
}

function go.fn.defines {
    local _self=${FUNCNAME[0]}
    local _fn=${_self%%.*}

    export -f  2>&1 | grep "declare -fx ${_fn}."
}
export -f go.fn.defines

function go.fn.pathname {
    local _self=${FUNCNAME[0]}
    local _fn=${_self%%.*}

    u.value $(me.pathname)    
}
export -f go.fn.pathname

function go.fn.reload {
    local _self=${FUNCNAME[0]}
    local _fn=${_self%%.*}

    verbose=1 u.source $(${_fn}.fn.pathname)
}
export -f go.fn.reload






function go.bootstrap {
    local _self=${FUNCNAME[0]}
    local _fn=${_self%%.*}

    sudo.snap.install --classic go && go.mkgopath    
}
export -f go.bootstrap

function go.mkgopath {
    local _self=${FUNCNAME[0]}
    local _fn=${_self%%.*}

    local _gopath=$(go env GOPATH)
    [[ -z "${_gopath}" ]] && f.err '$(go env GOPATH) failed'
    file.mkdir ${_gopath}/{bin,pkg,src} && go.check
}
export -f go.mkgopath

function go.i1 {
    local _self=${FUNCNAME[0]}
    local _fn=${_self%%.*}

    go install -i $*
}
export -f go.i1

function go.install {
    local _self=${FUNCNAME[0]}
    local _fn=${_self%%.*}

    f.apply go.i1 $*
}
export -f go.install


function go.install.all {
    local _self=${FUNCNAME[0]}
    local _fn=${_self%%.*}

    go.bootstrap
    go.install go-t
}
export -f go.install.all


function go.check {
    local _self=${FUNCNAME[0]}
    local _fn=${_self%%.*}

    f.apply file.is.dir $(go env GOPATH)/{src,pkg,bin} || f.err "missing directories in $(go env GOPATH)"
}
export -f go.check


