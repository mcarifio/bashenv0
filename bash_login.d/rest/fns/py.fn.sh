# `python -m pip install --user ${package}` can sometimes install command line binaries 
# TODO mike@carif.io: do several python installs share the same site user-base?
# https://packaging.python.org/tutorials/installing-packages/#id21
# path_if_exists $(python -m site --user-base)/bin

function py.__template__ {
    local _self=${FUNCNAME[0]}
    echo ${_self} tbs
}
export -f py.__template__


function py.env.PYTHONSTARTUP {
    local _self=${FUNCNAME[0]}
    u.env -r ${1:-${BASHENV}/rc/python3rc.py}
}
export -f py.env.PYTHONSTARTUP

# less typing
function py.pip+install {
    local _self=${FUNCNAME[0]}    
    if [[ -z "${update_pip}" ]] ; then
        python -m pip install --upgrade pip
        export update_pip=$(date -Iseconds)
    fi
    python -m pip install --upgrade "$*"
}
export -f py.pip+install 
