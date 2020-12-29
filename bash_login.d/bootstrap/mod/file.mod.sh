# file.mod.sh

function mkcd {
    local _self=${FUNCNAME[0]};
    local _mod_name=${_self%%.*};
    local _mod=${_self%.*};

    local _d=${1:-${HOME}}
    file.mkdir ${_d}
    # pushd ${_d}
    command cd ${_d}
}

function mkpushd {
    local _self=${FUNCNAME[0]};
    local _mod_name=${_self%%.*};
    local _mod=${_self%.*};

    local _d=${1:-${HOME}} ; file.mkdir ${_d} && pushd ${_d} > /dev/null
}


function rcnt {
    local _self=${FUNCNAME[0]};
    local _mod_name=${_self%%.*};
    local _mod=${_self%.*};

    command cd $(dirs | fzf +m)
}


# https://www.gnu.org/software/bash/manual/html_node/Programmable-Completion-Builtins.html
function _rcnt_cmpl {
    local _command=$1
    local _word=$2
    local _prev_word=$3
    COMPREPLY=$(f.apply "[[ $_ = $2* ]]" $(dirs))
}

# complete -F _rcnt_cmpl -I rcnt 



# http://seanbowman.me/blog/fzf-fasd-and-bash-aliases/
function relcd {
    local _self=${FUNCNAME[0]};
    local _mod_name=${_self%%.*};
    local _mod=${_self%.*};

    local _d=$(find ${1:-*} -path '*/\.*'\
        -prune -o -type d\
        -print 2> /dev/null | fzf +m)
    [[ -d "${_d}" ]] && pushd "${_d}"
}
complete -d relcd


function fcd {
    local _self=${FUNCNAME[0]};
    local _mod_name=${_self%%.*};
    local _mod=${_self%.*};

    pushd $(find ${1:-${HOME}} -type d -print 2> /dev/null | fzf +m)
}
complete -d fcd


function file.newest { 
    local _self=${FUNCNAME[0]};
    local _mod_name=${_self%%.*};
    local _mod=${_self%.*};

    stat --printf='%Y\t%n\n' $(find $*)|sort -g -r -k1|head -1|cut -f2
}


function file.is {
    local _self=${FUNCNAME[0]};
    local _mod_name=${_self%%.*};
    local _mod=${_self%.*};

    local _test=$(f.must.have "$1" "test") || return $(f.err "expected a test")
    local _thing=$(f.must.have "$2" "thing") || return $(f.err "expected a thing")

    if test ${_test} ${_thing} ; then
        printf '%s' ${_thing}
        return 0
    fi
    return 1
}


function file.is.dir {
    local _self=${FUNCNAME[0]};
    local _mod_name=${_self%%.*};
    local _mod=${_self%.*};

    local _d=$(f.must.have "$1" "directory") || return $(f.err "expected a directory")
    [[ -d "${_d}" ]] && printf '%s' ${_d} && return 0
    return 1
}

function file.is.file {
    local _self=${FUNCNAME[0]};
    local _mod_name=${_self%%.*};
    local _mod=${_self%.*};

    local _expected='file'
    local _f=$(f.must.have "$1" ${_expected}) || return $(f.err "expected a ${_expected}")
    file.is '-f' ${_f}
}

function file.is.readable {
    local _self=${FUNCNAME[0]};
    local _mod_name=${_self%%.*};
    local _mod=${_self%.*};

    local _self=${FUNCNAME[0]}
    local _f=$(f.must.have "$1" "file") || return $(f.err "expected a file")
    [[ -r ${_f} ]] && printf '%s' ${_f} && return 0
    return 1
}



function file.mkdir {
    : 'public, usage: local _d=$(file.mkdir ${HOME}/some/where)'
    local _self=${FUNCNAME[0]};
    local _mod_name=${_self%%.*};
    local _mod=${_self%.*};

    local _d=$(f.must.have "$1" "directory") || return 1; shift
    [[ -d "${_d}" ]] || install $* --directory ${_d} || return 1
    echo "${_d}"
}


function file.mv {
    : 'public, usage: file.mv here there # backs up there'
    local _self=${FUNCNAME[0]};
    local _mod_name=${_self%%.*};
    local _mod=${_self%.*};

    local _src=$(f.must.have "$1" "directory") || return 1
    local _dest=$(f.must.have "$2" "directory") || return 1
    # TODO mike@carif.io: use install instead?
    mv --backup ${_src} ${_dest} &> /dev/null
}


function file.sudo.install { 
    : 'public, usage: file.sudo.install /from /to [${owner} [${group}]]'
    local _self=${FUNCNAME[0]};
    local _mod_name=${_self%%.*};
    local _mod=${_self%.*};

    local _src=$(f.must.have "$1" "directory") || return 1
    local _dest=$(f.must.have "$2" "directory") || return 1
    local _owner=${3:-${USER}}
    local _group=${4:-${USER}}
    sudo install -o ${_owner} -g ${_group} -D ${_src} ${_dest} 
}


function file.exec {
    : 'public, usage: file.exec ${pathname} $* # exec ${pathname} with $* iff ${pathname} exists'
    local _self=${FUNCNAME[0]};
    local _mod_name=${_self%%.*};
    local _mod=${_self%.*};

    local _cmd=$(u.must.have "$1" "pathname") || return 1; shift
    [[ -x {_cmd} ]] && ${_cmd} "$*"
}


function file.path2 {
    local _self=${FUNCNAME[0]};
    local _mod_name=${_self%%.*};
    local _mod=${_self%.*};

    local _pathname=$(f.must.have "$1" "pathname") || return 1
    local _d=$(dirname ${_d})
    [[ -n "${_d}" ]] && file.mkdir ${_d} && >&2 echo ${_d}
}

function file.xz {
    local _self=${FUNCNAME[0]};
    local _mod_name=${_self%%.*};
    local _mod=${_self%.*};

    local _from=$(f.must.have "$1" "source file") || return 1
    local _to=$(f.must.have "$2" "dest file") || return 1
    local _tmp=$(file.path2 /tmp/${USER}/${_self}/$$/$(basename ${_to}))
    xz -c $_from ${_tmp} && file.mv ${_tmp} $(file.path2 ${_to})
}

# Make this file a "module".
# Extract mod from pathname.
function pn2mod { local _result=${1##*/}; echo ${_result%%.*}; }
# Augment functions above with "module" conventions.
mod.mkmod $(pn2mod ${1:-${BASH_SOURCE[0]}}) ${2:-$(realpath ${BASH_SOURCE[0]})}
