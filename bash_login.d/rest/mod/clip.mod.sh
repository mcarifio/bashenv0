u.have.command xclip || return $(f.err "missing xclip")
# BASHENV_AUTOINSTALL=1 u.have.command xclip

function clip.in {
    : 'public, usage: cmd | clip.in'
    local _self=${FUNCNAME[0]};
    local _mod_name=${_self%%.*};
    local _mod=${_self%.*};

    xclip -in -rmlastnl -selection clipboard 
}

function clip.out {
    : 'public, usage: clip.out'
    local _self=${FUNCNAME[0]};
    local _mod_name=${_self%%.*};
    local _mod=${_self%.*};

    xclip -out -selection clipboard 
}


# Make this file a "module".
# Extract mod from pathname.
function pn2mod { local _result=${1##*/}; echo ${_result%%.*}; }
# Augment functions above with "module" conventions.
mod.mkmod $(pn2mod ${1:-${BASH_SOURCE[0]}}) ${2:-$(realpath ${BASH_SOURCE[0]})}


       
