# -*- mode: shell-script; eval: (setq-local indent-tabs-mode nil tab-with 4 indent-line-function 'insert-tab) -*-
me=$(realpath -s ${BASH_SOURCE:-$0})
here=$(dirname ${me})

function _err {
  local msg=${1:-error}
  declare -i status=${2:-1}
  >&2 echo "${msg}"
  return ${status}
}



# This is a function rather than a script because by default bash function definitions are not inherited
#  by subshells.
function ecc {
    
  # name, the "thing" to edit
    local name=${1}
    [[ -z "${name}" ]] && _err "expecting a name"
    
    # prefix, the directory where to create ${name} if it isn't found.
    local prefix=${2:-${here}}

    # type -t ${name} `alias', `keyword', `function', `builtin', `file'
    local name_type=$(type -t ${name})
    case "${name_type}" in
        alias|keyword|builtin) _err "'${name}' is a '${name_type}'. Stop." ;;
        function) pathname=$(declare -F ${name} | awk '{print $3;}'); [[ -z "${pathname}" ]] && _err "Source for function '${name}' not found. Stop." ;;
        file) pathname=$(type -p ${name}); [[ -z "${pathname}" ]] && _err "Source for script '${name}' not found. Stop." ;;
        *) pathname=${prefix}/${name} ; cp $(__template__.sh) ${pathname} ; chmod a+x ${pathname} ;;
    esac

    ec ${pathname}
}

export -f ecc
  
