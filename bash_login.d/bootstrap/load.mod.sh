for _s in $(dirname ${BASH_SOURCE[0]})/mod/{f,me,file,u,path,mod}.mod.sh; do
    source ${_s} && [[ -n "${verbose}" ]] && >&2 echo ${_s} 
done
