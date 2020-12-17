# me.fn.sh reflects on the script it appears in.

function me.__template__ {
    local _self=${FUNCNAME[0]}
    local _fn=${_self%%.*}

    u.value $(${_fn}.fn.pathname)
}

function me.fn.defines {
    local _self=${FUNCNAME[0]}
    local _fn=${_self%%.*}

    export -f  2>&1 | grep "declare -fx ${_fn}."
}
export -f me.fn.defines

function me.fn.pathname {
    local _self=${FUNCNAME[0]}
    local _fn=${_self%%.*}

    u.value $(realpath ${BASH_SOURCE[0]})
}
export -f me.fn.pathname

# Reload this file. Todo: using inotify to reload automatically.
function me.fn.reload {
    local _self=${FUNCNAME[0]}
    local _fn=${_self%%.*}

    verbose=1 u.source $(${_fn}.fn.pathname)
}
export -f me.fn.reload



# full path to shell e.g. /bin/bash
function me.exe {
    local _self=${FUNCNAME[0]}
    local _fn=${_self%%.*}

    realpath /proc/$$/exe
}
export -f me.exe

# name of shell e.g. bash
function me.shell {
    local _self=${FUNCNAME[0]}
    local _fn=${_self%%.*}

    basename $(me.exe)
}
export -f me.shell


# pathname of current script; me.pathname -s resolves symbolic links.
function me.pathname {
    local _self=$(u.first ${FUNCNAME[0]} $0 main)
    local _fn=${_self%%.*}

    local _flag=${1:-''}
    realpath ${_flag} ${BASH_SOURCE[1]}
}
export -f me.pathname

# pathname of script's directory.
function me.here {
    local _self=${FUNCNAME[0]}
    local _fn=${_self%%.*}

    realpath $(dirname ${BASH_SOURCE[1]:-$PWD})/${1}
}
export -f me.here

# Name of the current "module", e.g. 'ssh' for 'ssh.fn.sh' otherwise ''.
function me.name {
    local _self=${FUNCNAME[0]}
    local _fn=${_self%%.*}

    u.value ${FUNCNAME[1]%%.*}
}
export -f me.name

# Name of the "metadata" for the current module, e.g. 'ssh.fn' for file 'ssy.fn.sh' otherwise ''.
function me.fn {
    local _self=${FUNCNAME[0]}
    local _fn=${_self%%.*}

    u.value ${FUNCNAME[1]%.*}
}
export -f me.fn
