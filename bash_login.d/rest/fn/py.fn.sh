function py.__template__ {
    local _self=${FUNCNAME[0]}
    echo ${_self} tbs
}
export -f $_


function py.bootstrap {
    local _self=${FUNCNAME[0]}
    apt.install python3
}
export -f $_


# `python -m pip install --user ${package}` can sometimes install command line binaries 
# TODO mike@carif.io: do several python installs share the same site user-base?
# https://packaging.python.org/tutorials/installing-packages/#id21
# path_if_exists $(python -m site --user-base)/bin
function py.site.bin {
    local _self=${FUNCNAME[0]}
    local _user_base=$(python3 -m site --user-base) # always returns a directory?
    [[ -n "${_user_base}" ]] && file.is.dir "${_user_base}" && echo ${_user_base}/bin
}
export -f $_



function py.pip+install {
    local _self=${FUNCNAME[0]}
    if [[ -z "${update_pip}" ]] ; then
        python -m pip install --upgrade pip
        update_pip=$(date -Iseconds)
    fi
    python3 -m pip install --upgrade "$*"
}
export -f $_

function py.pip+install.start {
    local _self=${FUNCNAME[0]}
    pip.install wheel git git-url-parse gitpython dotmap fire rich dotmap maya fabric patchwork invocations poetry 'xonsh[full]' prompt_toolkit xfr
}
export -f $_


function py.env.PYTHONSTARTUP {
    local _self=${FUNCNAME[0]}
    u.env -r $(py.env.rc)
}
export -f $_

function py.env.rc {
    local _py_env_rc=$(f.first (f.filter file.is.read $1 ${BASHENV:-${XDG_DATA_DIR:-~/.local/share}/bashenv}/rc/python/python3rc.py))
    [[ -n "${_py_env_rc}" ]] && echo "${_py_env_rc}"
} 
export -f $_
