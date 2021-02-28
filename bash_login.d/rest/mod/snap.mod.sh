# snap.mod.sh

[[ "$(snap get system experimental.parallel-instances)" = true ]] || sudo snap set system experimental.parallel-instances=true


function snap.install {
    : 'snap.install ${snap}... # install all snaps with strict (default) confinement, @see snap.install.*'
    local _self=${FUNCNAME[0]}
    local _mod_name=${_self%%.*} # snap.mod for mod functions
    local _mod=${_self%.*} # snap

    sudo snap install $* && printf '%s ' ${*} >> $(dirname $(${_mod}.mod.pathname))/${_self}.${HOSTNAME}.list

}

function snap.install.all {
    : 'snap.install.all # install all the snaps I want without remembering the enumeration'
    local _self=${FUNCNAME[0]}
    local _mod_name=${_self%%.*}
    local _mod=${_self%.*}

    snap.install $(cat $(dirname $(${_mod}.mod.pathname))/${_self}*.list 2>/dev/null | uniq | sort)
    # snap.install cacher core core18 core20 direnv doctl emacs-28 gtk-common-themes multipass zoom-client barrier postman
    # snap.install.classic clion code code-insiders datagrip emacs go goland intellij-idea-ultimate kubectl powershell rider
    # snap.install.edge chromium
}

function snap.install.edge {
    : 'snap.install.edge ${snap}... # install a snap from the edge channel (i.e. the latest version) with strict confinement'
    local _self=${FUNCNAME[0]}
    local _mod_name=${_self%%.*}
    local _mod=${_self%.*}

    snap.install $*
    if (set -x; sudo snap set system experimental.parallel-instances=true) ; then
        snap.install --edge $(printf '%s_edge ' $*)
    else
        >&2 echo "can't set experimental.parallel-instances=true, skipping --edge install of $*"
        return 1
    fi
}

function snap.install.classic {
    : 'snap.install.classic ${snap}... # install a snap with classic confinement'
    local _self=${FUNCNAME[0]};
    local _mod_name=${_self%%.*};
    local _mod=${_self%.*};

    snap.install --classic $*

}

function snap.env {
    # https://forum.snapcraft.io/t/snap-which-chromium/17278/6
    : 'snap.env ${command} [${SNAP_something:-SNAP}] # prints out the snap environment variables for a snap'
    local _self=${FUNCNAME[0]}
    local _mod_name=${_self%%.*}
    local _mod=${_self%.*}

    snap run --shell ${1:-$(return 1)} -c "env | grep ${2:-SNAP}"
}

# Make this file a "module".
# Extract mod from pathname.
function pn2mod { local _result=${1##*/}; echo ${_result%%.*}; }
# Augment functions above with "module" conventions.
mod.mkmod $(pn2mod ${1:-${BASH_SOURCE[0]}}) ${2:-$(realpath ${BASH_SOURCE[0]})}
