# PATH manipulation

function path.__template__ {
    local _self=${FUNCNAME[0]}
    echo ${_self} tbs
}
export -f path.__template__



# Centralized path hacking. Returns list of directories if they exist.
function path.bins {
    local _self=${FUNCNAME[0]}
    local _py3=$(type -p python3)
    local -a _py3a=()
    if [[ -x ~/.asdf/bin/asdf ]] ; then
        _py3=$(~/.asdf/bin/asdf which python)
        _py3a=($(${_py3} -m site --user-base)/bin $(dirname ${_py3}) ~/.asdf/{bin,shims})
    else
        _py3a=($(${_py} -m site --user-base)/bin $(dirname ${_py3}))
    fi
    f.filter file.is.dir ~/bin ~/.cargo/bin $(go env GOPATH) ~/.local/bin ~/*/bin ${_py3a[*]}  ~/.local/share/*/bin
}
export -f path.bins


# true iff ${directory} on $PATH
function path.on.path {
    local _self=${FUNCNAME[0]}
    local _d=$(f.must.have "$1" "directory")
    [[ "${PATH}" =~ (^|:)${_d}(:|$) ]] && printf '%s' ${_d}
}
export -f path.on.path


# true iff ${directory} not on PATH
function path.noton.path {
    local _self=${FUNCNAME[0]}
    local _d=$(f.must.have "$1" "directory")
    [[ "${PATH}" =~ (^|:)${_d}(:|$) ]] || printf '%s' ${_d}
}
export -f path.noton.path


# Given a list of directories, returns the filtered list of those that exist _and_ are not on PATH.
function path.needed {
    local _self=${FUNCNAME[0]}
    f.filter path.noton.path $(f.filter file.is.dir $*)
}
export -f path.needed

export -a BASHENV_PATHS BASHENV_PATHADDS

# Added needed directories to PATH
function path.add {
    local _self=${FUNCNAME[0]}
    # local -a _left=($(f.filter path.noton.path $(f.filter file.is.dir $*)))
    local -a _needed=($(path.needed $*))
    (( ${#_needed} )) || return 0
    local _prefix=$(printf '%s:' ${_needed[*]})
    BASHENV_PATHS+=$PATH
    BASHENV_PATHADDS+=${_prefix}
    export PATH="${_prefix}${PATH}"
}
export -f path.add

# Report successive adds. Useful for debugging.
function path.added {
    printf '%s\n' ${BASHENV_PATHADDS[*]}
}
export -f path.added

# Report PATH vertically. It's easier to read.
function path.path {
    sed 's/:/\n/g' <<< $PATH
}
export -f path.path

