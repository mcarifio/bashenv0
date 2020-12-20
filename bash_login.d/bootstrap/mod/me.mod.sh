# me.mod.sh reflects on the script it appears in.

# full path to shell e.g. /bin/bash
function me.exe {
    local _self=${FUNCNAME[0]}
    local _mod_name=${_self%%.*};
    local _mod=${_self%.*};

    realpath /proc/$$/exe
}

# name of shell e.g. bash
function me.shell {
    local _self=${FUNCNAME[0]}
    local _mod_name=${_self%%.*};
    local _mod=${_self%.*};

    basename $(me.exe)
}


# pathname of current script; me.pathname -s resolves symbolic links.
function me.pathname {
    local _self=${FUNCNAME[0]}
    local _mod_name=${_self%%.*};
    local _mod=${_self%.*};

    local _bash_source=${BASH_SOURCE[2]}
    [[ -n "${_bash_source}" ]] && realpath ${_bash_source}
}


# pathname of script's directory.
function me.here {
    local _self=${FUNCNAME[0]}
    local _mod_name=${_self%%.*};
    local _mod=${_self%.*};

    local _suffix=${1:-''}
    local _bash_source=${BASH_SOURCE[2]}
    
    [[ -n "${_bash_source}" ]] && realpath $(dirname $(realpath ${_bash_source}))/${_suffix}
}

# Name of the current "module", e.g. 'ssh' for 'ssh.fn.sh' otherwise ''.
function me.name {
    local _self=${FUNCNAME[0]}
    local _fn=${_self%%.*}
    local _module=${_self%.*}

    u.value ${FUNCNAME[1]%%.*}
}

# Make this file a "module".
# Extract mod from pathname.
function pn2mod { local _result=${1##*/}; echo ${_result%%.*}; }
# Augment functions above with "module" conventions.
mod.mkmod $(pn2mod ${1:-${BASH_SOURCE[0]}}) ${2:-$(realpath ${BASH_SOURCE[0]})}
