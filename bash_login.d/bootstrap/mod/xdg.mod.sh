# source xdg.mod.sh

declare -Ag _xdg_defaults=([XDG_DATA_HOME]=${HOME}/.local/share [XDG_CONFIG_HOME]=${HOME}/.config)
                          
function xdg.dir {
    : 'internal, usage: local _value=$(xdg.value ${name})'
    local _self=${FUNCNAME[0]}
    local _mod_name=${_self%%.*};
    local _mod=${_self%.*};

    declare -Ag _xdg_defaults
    local _xdg_name=$(f.must.have "$1" "xdg name") || return 1

    [[ -n "${!_xdg_name}" ]] && echo "${!_xdg_name}" && return 0
    local _default=${_xdg_defaults[${_xdg_name}]}
    [[ -n "${_default}" ]] && echo "${_default}" && return 0
    return 1    
}



function xdg.XDG_DATA_HOME {
    : 'public, usage: local _xdh=$(xdg.XDG_DATA_HOME)'
    local _self=${FUNCNAME[0]}
    local _mod_name=${_self%%.*};
    local _mod=${_self%.*};

    xdg.dir ${_self##${_mod_name}.}
}

function xdg.DATA_HOME {
    : 'public, usage: local _xdh=$(xdg.DATA_HOME)'
    local _self=${FUNCNAME[0]}
    local _mod_name=${_self%%.*};
    local _mod=${_self%.*};

    xdg.dir XDG_${_self##${_mod_name}.}
}


function xdg.XDG_CONFIG_HOME {
    : 'public, usage: local _xch=$(xdg.XDG_CONFIG_HOME)'
    local _self=${FUNCNAME[0]}
    local _mod_name=${_self%%.*};
    local _mod=${_self%.*};

    # >&2 echo ${_self}, ${_mod_name}, ${_self##${_mod_name}.}
    xdg.dir ${_self##${_mod_name}.}
}

function xdg.CONFIG_HOME {
    : 'public, usage: local _xch=$(xdg.CONFIG_HOME)'
    local _self=${FUNCNAME[0]}
    local _mod_name=${_self%%.*};
    local _mod=${_self%.*};

    # >&2 echo ${_self}, ${_mod_name}, ${_self##${_mod_name}.}
    xdg.dir XDG_${_self##${_mod_name}.}
}


# Make this file a "module".
# Extract mod from pathname.
function pn2mod { local _result=${1##*/}; echo ${_result%%.*}; }
# Augment functions above with "module" conventions.
mod.mkmod $(pn2mod ${1:-${BASH_SOURCE[0]}}) ${2:-$(realpath ${BASH_SOURCE[0]})}
