# shared functions across all distros
source ${BASHENV:-~/.local/share/bashenv}/load.sh


# sudo.fn.sh
function sudo.nopasswd {
    local _nopasswd=/etc/sudoers.d/nopasswd
    printf "# fc\n%%%s ALL = (ALL) NOPASSWD: ALL\n" sudo wheel > ${_nopasswd}
    printf "# debian et al\n%%%s ALL = (ALL) NOPASSWD: ALL\n" sudo sudo >> ${_nopasswd}
    chmod 0600 ${_nopasswd}
}
export -f $_

function sudo.useradd {
    local _self=${FUNCNAME[0]}
    local _conf=${_self}.conf
    if ! source ${_conf} &> /dev/null ; then
        [[ -z "${_groups}" ]] && declare -a _groups=(wheel sudo admin plugdev ssh lxd)
    fi

    for u in "$*"; do
        command useradd ${u}
        command usermod --append ${u} --groups ${g} || true
    done    
}
export -f $_

# more as needed







function go.bootstrap {
    sudo.snap.install --classic go && go.mkgopath    
}
export -f $_

function go.mkgopath {
    local _gopath=$(go env GOPATH)
    [[ -z "${_gopath}" ]] && u.err '$(go env GOPATH) failed'
    mkdir -p ${_gopath}/{bin,pkg,src}
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








# py.fn.sh
function py.pip+install {
    if [[ -z "${update_pip}" ]] ; then
        python -m pip install --upgrade pip
        update_pip=$(date -Iseconds)
    fi
    python -m pip install --upgrade "$*"
}
export -f $_

function py.pip+install.start {
    pip.install wheel git git-url-parse gitpython dotmap fire rich dotmap maya fabric patchwork invocations poetry 'xonsh[full]' prompt_toolkit xfr
}
export -f $_






# snap.fn.sh
function snap.i1 {
    sudo snap install $*
}
export -f $_

function snap.install {
    f.apply snap.i1 $*
}
export -f $_


function snap.install.all {
    snap.install install multipass

}
export -f $_









# site.fn.sh
function site.bootstrap.install+all {

    py.pip+install.all
    snap.install.all

    # add users
    sudo.luseradd git bashenv skippy
    sudo.nopasswd
}
export -f $_
