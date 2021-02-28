# PATH manipulation

# Centralized path hacking. Returns list of directories if they exist.
function path.bins {
    local _self=${FUNCNAME[0]};
    local _mod_name=${_self%%.*};
    local _mod=${_self%.*};

    local _xdg_data_home=${XDG_DATA_HOME:~/.local/share}
    local _bashenv=${BASHENV:-${_xdg_data_home}/bashenv}

    # TODO mike@carif.io: mv ~/.asdf -> ~/.local/asdf?
    local _py3=$(type -p python3)
    local -a _py3a=()
    if [[ -x ~/.asdf/bin/asdf ]] ; then
        _py3=$(~/.asdf/bin/asdf which python)
        _py3a=($(${_py3} -m site --user-base)/bin $(dirname ${_py3}) ~/.asdf/{bin,shims})
    else
        _py3a=($(${_py3} -m site --user-base)/bin $(dirname ${_py3}))
    fi
    f.apply file.is.dir ~/bin ~/.cargo/bin $(go env GOPATH)/bin ~/.local/bin ~/*/bin ${_py3a[*]}  ~/.local/share/*/bin ${_xdg_data_home}/*/bin ${_bashenv}/bin.d/*/bin 
}

# true iff ${directory} on $PATH
function path.on.path {
    local _self=${FUNCNAME[0]};
    local _mod_name=${_self%%.*};
    local _mod=${_self%.*};

    local _d=$(f.must.have "$1" "directory")
    [[ "${PATH}" =~ (^|:)${_d}(:|$) ]] && printf '%s' ${_d}
}

# true iff ${directory} not on PATH
function path.noton.path {
    local _self=${FUNCNAME[0]};
    local _mod_name=${_self%%.*};
    local _mod=${_self%.*};

    local _d=$(f.must.have "$1" "directory")
    [[ "${PATH}" =~ (^|:)${_d}(:|$) ]] || printf '%s' ${_d}
}


# Given a list of directories, returns the filtered list of those that exist _and_ are not on PATH.
function path.needed {
    local _self=${FUNCNAME[0]};
    local _mod_name=${_self%%.*};
    local _mod=${_self%.*};

    f.apply path.noton.path $(f.apply file.is.dir $*)
}



export -a BASHENV_PATHS BASHENV_PATHADDS

# Added needed directories to PATH
function path.add {
    local _self=${FUNCNAME[0]};
    local _mod_name=${_self%%.*};
    local _mod=${_self%.*};

    # local -a _left=($(f.apply path.noton.path $(f.apply file.is.dir $*)))
    local -a _needed=($(path.needed $*))
    (( ${#_needed} )) || return 0
    local _prefix=$(printf '%s:' ${_needed[*]})
    BASHENV_PATHS+=($PATH)
    BASHENV_PATHADDS+=(${_prefix})
    export PATH="${_prefix}${PATH}"
}

# Report successive adds. Useful for debugging. Difficult to read.
function path.adds {
    printf '%s\n\n' ${BASHENV_PATHADDS[*]}
}

function path.history {
    printf '%s\n\n' ${BASHENV_PATHS[*]}
}

# Report PATH vertically. It's easier to read.
function path.path {
    sed 's/:/\n/g' <<< $PATH
}

# technically not a path command
function path.from.command {
    local _self=${FUNCNAME[0]};
    local _mod_name=${_self%%.*};
    local _mod=${_self%.*};

    _path=$(type -p $1)
    [[ -z "${_path}" ]] && return 0
    echo ${_path%/bin/*}
}

# Make this file a "module".
# Extract mod from pathname.
function pn2mod { local _result=${1##*/}; echo ${_result%%.*}; }
# Augment functions above with "module" conventions.
mod.mkmod $(pn2mod ${1:-${BASH_SOURCE[0]}}) ${2:-$(realpath ${BASH_SOURCE[0]})}

