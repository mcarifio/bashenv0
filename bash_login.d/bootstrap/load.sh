for _s in $(dirname ${BASH_SOURCE[0]})/fn/{f,me,file,u,path}.fn.sh; do source ${_s} && >&2 echo "${_s} sourced." ; done
