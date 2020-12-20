# be.fn.sh
# functions to hack/modify bashenv.


function be.root {
    local _self=${FUNCNAME[0]};
    local _mod_name=${_self%%.*};
    local _mod=${_self%.*};

    echo ${BASHENV:-${XDG_DATA_DIR:-~/.share/local/bashenv}}
}

function be.root.from {
    local _self=${FUNCNAME[0]};
    local _mod_name=${_self%%.*};
    local _mod=${_self%.*};

    local _be_root=$(${_mod}.root)
    [[ -z "${_be_root}" ]] && f.err "bashenv directory not defined." && return 1

    [[ -n "${BASHENV}" ]] && f.info "bashenv directory defined in BASHENV"
    [[ -n "${XDG_DATA_DIR}" ]] && f.info "bashenv directory found through XDG_DATA_DIR"
    echo ${_be_dir}
}



# Reload all the functions in "bootstrap" order.
function be.reload {
    local _self=${FUNCNAME[0]};
    local _mod_name=${_self%%.*};
    local _mod=${_self%.*};

    verbose=1 source $(${_mod_name}.root)/load.sh
}

# Make this file a "module".
# Extract mod from pathname.
function pn2mod { local _result=${1##*/}; echo ${_result%%.*}; }
# Augment functions above with "module" conventions.
mod.mkmod $(pn2mod ${1:-${BASH_SOURCE[0]}}) ${2:-$(realpath ${BASH_SOURCE[0]})}
