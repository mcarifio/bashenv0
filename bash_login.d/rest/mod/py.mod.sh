# py.mod.sh

# `python -m pip install --user ${package}` can sometimes install command line binaries 
# TODO mike@carif.io: do several python installs share the same site user-base?
# https://packaging.python.org/tutorials/installing-packages/#id21
# path_if_exists $(python -m site --user-base)/bin
function py.site.bin {
    local _self=${FUNCNAME[0]};
    local _mod_name=${_self%%.*};
    local _mod=${_self%.*};

    local _user_base=$(python3 -m site --user-base) # always returns a directory?
    [[ -n "${_user_base}" ]] && file.is.dir "${_user_base}" && echo ${_user_base}/bin
}

function py.pip+install {
    local _self=${FUNCNAME[0]};
    local _mod_name=${_self%%.*};
    local _mod=${_self%.*};

    if [[ -z "${update_pip}" ]] ; then
        python -m pip install --upgrade pip
        update_pip=$(date -Iseconds)
    fi
    python3 -m pip install --upgrade "$*"
}

function py.pip+install.all {
    local _self=${FUNCNAME[0]}
    pip.install wheel git git-url-parse gitpython dotmap fire rich dotmap maya fabric patchwork invocations poetry 'xonsh[full]' prompt_toolkit xfr
}


function py.env.PYTHONSTARTUP {
    local _self=${FUNCNAME[0]};
    local _mod_name=${_self%%.*};
    local _mod=${_self%.*};

    u.env -r $(py.env.rc)
}

function py.env.rc {
    local _self=${FUNCNAME[0]};
    local _mod_name=${_self%%.*};
    local _mod=${_self%.*};

    local _py_env_rc=$(u.first $(f.apply file.is.readable $1 ${XDG_DATA_DIR:-~/.local/share}/python/rc/python3rc.py))
    [[ -n "${_py_env_rc}" ]] && echo "${_py_env_rc}"
} 

# Make this file a "module".
# Extract mod from pathname.
function pn2mod { local _result=${1##*/}; echo ${_result%%.*}; }
# Augment functions above with "module" conventions.
mod.mkmod $(pn2mod ${1:-${BASH_SOURCE[0]}}) ${2:-$(realpath ${BASH_SOURCE[0]})}

