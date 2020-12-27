let _bottom=$(( ${#BASH_SOURCE[*]} - 1 ))
[[ $0 != ${BASH_SOURCE[${_bottom}]} ]] && (( _bottom-- ))
_me=$(realpath -s ${BASH_SOURCE[${_bottom}]:-$0})
_here=$(dirname ${_me})
_basename=$(basename ${_me})
_name=$(basename ${_me} .sh)


# usage: [BASHENV=''] source USER.sh --echo [--force] [--systemd]

# --force --echo --systemd
if [[ -z "${BASHENV}" ]] ; then
    # load all the bash "modules"
    source ${_here}/../../../../load.mod.sh

    # using the path module, bootstrap PATH
    path.add $(path.bins)
fi

# Graft USER/{.config,.local/share} to ${HOME} via symbolic links.
# There should be a more elegant way, perhaps a union fs?

${_here}/ln.sh $@

# .local/share/*/bin may have been grafted. Add those paths as well.
path.add $(path.bins)

>&2 echo "Try logging in (--login) via ssh or a virtual terminal"
