# snap.mod.sh

[[ "$(snap get system experimental.parallel-instances)" = true ]] || sudo snap set system experimental.parallel-instances=true


function snap.install {
    local _self=${FUNCNAME[0]};
    local _mod_name=${_self%%.*};
    local _mod=${_self%.*};

    sudo snap install $*
}

function snap.install.all {
    local _self=${FUNCNAME[0]};
    local _mod_name=${_self%%.*};
    local _mod=${_self%.*};

    snap.install cacher core core18 core20 direnv doctl emacs-28 gtk-common-themes multipass zoom-client barrier
    snap.install.classic clion code code-insiders datagrip emacs go goland intellij-idea-ultimate kubectl powershell rider
    snap.install.edge chromium
}

function snap.install.edge {
    local _self=${FUNCNAME[0]};
    local _mod_name=${_self%%.*};
    local _mod=${_self%.*};

    local _snap=$(f.must.have "$1" "pkg")
    snap.install ${_snap}
    snap.install --edge ${_snap}_edge
}

function snap.install.classic {
    local _self=${FUNCNAME[0]};
    local _mod_name=${_self%%.*};
    local _mod=${_self%.*};

    snap.install --classic $*

}

# Make this file a "module".
# Extract mod from pathname.
function pn2mod { local _result=${1##*/}; echo ${_result%%.*}; }
# Augment functions above with "module" conventions.
mod.mkmod $(pn2mod ${1:-${BASH_SOURCE[0]}}) ${2:-$(realpath ${BASH_SOURCE[0]})}
