# snap.mod.sh

[[ "$(snap get system experimental.parallel-instances)" = true ]] || sudo snap set system experimental.parallel-instances=true


function snap.install {
    local _self=${FUNCNAME[0]}
    local _mod_name=${_self%%.*} # snap.mod for mod functions
    local _mod=${_self%.*} # snap

    sudo snap install $* && printf '%s ' ${*} >> $(dirname $(${_mod}.mod.pathname))/${_self}.${HOSTNAME}.list

}

function snap.install.all {
    local _self=${FUNCNAME[0]}
    local _mod_name=${_self%%.*}
    local _mod=${_self%.*}

    snap.install $(cat $(dirname $(${_mod}.mod.pathname))/${_self}*.list 2>/dev/null | uniq | sort)
    # snap.install cacher core core18 core20 direnv doctl emacs-28 gtk-common-themes multipass zoom-client barrier postman
    # snap.install.classic clion code code-insiders datagrip emacs go goland intellij-idea-ultimate kubectl powershell rider
    # snap.install.edge chromium
}

function snap.install.edge {
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
