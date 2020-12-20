# mod.fn.sh
# usage: at end of file mod.mkmod

function mod.mkmod {
    local _self=${FUNCNAME[0]}
    local _mod_name=${_self%%.*};
    local _mod=${_self%.*};

    local _that_mod=$(f.must.have "$1" "mod") || return 1
    local _pathname=$(f.must.have "$2" "pathname") || return 1
    shift 2
    
    # No comments in evaled code. All code ends up on a simple line so always need semi-colons.
    local _eval=$(cat<<EOF
function ${_that_mod}.${_mod_name}.exists { return 0; };

function ${_that_mod}.${_mod_name}.self {
    local _self=\${FUNCNAME[0]};
    local _mod_name=\${_self%%.*};
    local _mod=\${_self%.*};

    u.value \${_mod_name}; 
    u.value \${_mod};
    u.value \${_self};
    u.value \$(\${_mod}.pathname);
} ;

function ${_that_mod}.${_mod_name}.uses {
    local _self=\${FUNCNAME[0]};
    local _mod_name=\${_self%%.*};
    local _mod=\${_self%.*};

    local _uses="$*";
    [[ -n "\${_uses}" ]] && echo \${_uses};
} ;


function ${_that_mod}.${_mod_name}.__template__ {
    local _self=\${FUNCNAME[0]};
    local _mod_name=\${_self%%.*};
    local _mod=\${_self%.*};

    local _fname=\$(f.must.have "\$1" "function name") || return 1;

    printf 'function ${_that_mod}.%s {
    local _self=\${FUNCNAME[0]};
    local _mod_name=\${_self%%%%.*};
    local _mod=\${_self%%.*};

    u.value \${_mod_name}; 
    u.value \${_mod};
    u.value \${_self};
    u.value ${_pathname};
} ;' \${_fname}; };

function ${_that_mod}.${_mod_name}.exported {
    local _self=\${FUNCNAME[0]};
    local _mod_name=\${_self%%.*};
    local _mod=\${_self%.*};

    export -f  2>&1 | grep "^declare -fx \${_mod_name}\." | cut -d' ' -f3 ; 
} ;

function ${_that_mod}.${_mod_name}.export {
    local _self=\${FUNCNAME[0]};
    local _mod_name=\${_self%%.*};
    local _mod=\${_self%.*};

    export -f \$(declare -f | grep "^\${_mod_name}\..* ()"|cut -d' ' -f1);
} ; 

function ${_that_mod}.${_mod_name}.pathname {
    local _self=\${FUNCNAME[0]};
    local _mod_name=\${_self%%.*};
    local _mod=\${_self%.*};

    u.value ${_pathname};
}; 

function ${_that_mod}.${_mod_name}.reload {
    local _self=\${FUNCNAME[0]};
    local _mod_name=\${_self%%.*};
    local _mod=\${_self%.*};

    for _f in \$(declare -f | grep "^\${_mod_name}\..* ()"|cut -d' ' -f1); do [[ \${_f} != \${_self} ]] && unset -f \${_f}; done || true;
    source ${_pathname} \${_mod_name} ${_pathname} && >&2 echo "${_pathname} => $?"; 
};
${_that_mod}.${_mod}.reload;
EOF
          )
    # echo ${_eval}
    eval ${_eval}

    
}


# local -A _flags; local -a _args; file.cd $* -> file.parse _flags _args $* -> mod.parse _flags _args # and return
# ... then _flags contains all the flags and (perhaps default) values, _args has all the arguments.
function mod.parse {
    local _self=${FUNCNAME[0]}
    local _mod_name=${_self%%.*};
    local _mod=${_self%.*};

    # usage: local -A _flags; local -a _args; mod.dispatch _flags _args # side effect _flags and _args respectively
    local _flags=$(f.must.have "$1" "dictionary") || return 1
    local _args=$(f.must.have "$2" "array") || return 1 ; shift 2
    # local _user=${USERNAME}

    while (( $# )); do
        local _it="${1}"
        case "${_it}" in
            --help) ${!_flags[${_it%--}]}=1;;
            --version) ${!_flags[${_it%--}]}=1;;
            --usage) ${!_flags[${_it%--}]}=1;;
            --verbose) ${!_flags[${_it%--}]}=1;;
            --as=*)  local _key=$(u.re+extract ${_it} '^--([^=]+)=')
                     local _value=$(u.re+extract ${_it} '^--[^=]+=(.*)$')
                     ${!_flags[${_key}]}=${_value};;
            *) ${!_args}+=${_it};;
        esac
        shift
    done
}

# usage: mod.mkmod ${1:-${BASH_SOURCE[0]%%.*}} ${2:-$(realpath ${BASH_SOURCE[0]})}
export -f mod.mkmod mod.parse
