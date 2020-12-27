let _bottom=$(( ${#BASH_SOURCE[*]} - 1 ))
[[ $0 != ${BASH_SOURCE[${_bottom}]} ]] && (( _bottom-- ))
_me=$(realpath -s ${BASH_SOURCE[${_bottom}]:-$0})
_here=$(dirname ${_me})
_basename=$(basename ${_me})
_name=$(basename ${_me} .sh)

# --force --echo --systemd
if [[ -z "${BASHENV}" ]] ; then
    source ${_here}/../../../../load.mod.sh
    path.add $(path.bins)
fi
${_here}/ln.sh $@
