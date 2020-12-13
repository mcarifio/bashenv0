# me.fn.sh reflects on the script it appears in.

function me.__template__ {
    local _self=${FUNCNAME[0]}
    echo ${_self} tbs
}
export -f me.__template__


# full path to shell e.g. /bin/bash
function me.exe {
    local _self=${FUNCNAME[0]}
    realpath /proc/$$/exe
}
export -f me.exe

# name of shell e.g. bash
function me.shell {
    basename $(me.exe)
}
export -f me.shell


# pathname of current script; me.pathname -s resolves symbolic links.
function me.pathname {
    local _self=${FUNCNAME[0]}
    local _flag=${1:-''}
    local _source=$(f.must.have "${BASH_SOURCE[1]}" "source name") || return 0
    realpath ${_flag} ${_source}
}
export -f me.pathname

# pathname of script's directory.
function me.here {
    local _self=${FUNCNAME[0]}
    dirname $(me.pathname);
}
export -f me.here

# name of current script (no path, suffix removed).
function me.name {
    local _self=${FUNCNAME[0]}
    local result=$(basename $(me.pathname));
    echo ${result%.*}
}
export -f me.name




