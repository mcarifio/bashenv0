# verbose=1 source load.mod.sh # verbose test

# "custom loader" for bootstrap/mod/*.mod.sh.
for _s in $(dirname ${BASH_SOURCE[0]})/mod/{mod,f,me,file,u,path}.mod.sh; do
#                                           ^^^^^^^^^^^^^^^^^^^^ order is fixed
    [[ -n "${verbose}" ]] && >&2 printf 'load %s...' ${_s}
    source ${_s}
    [[ -n "${verbose}" ]] && >&2 printf 'done (%s)\n' $?
done
