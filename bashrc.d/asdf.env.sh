[[ -z "${ASDF_BIN}" ]] || return 1
[[ -z "${ASDF_ENV_SH}" ]] || return 0
export ASDF_ENV_SH=$(realpath -s ${BASH_SOURCE})
source_if_exists ~/.asdf/asdf.sh
source_if_exists ~/.asdf/completions/asdf.bash

# too much, but it's a good pattern to know
# PATH=$(find ~/.asdf/installs -type d -name bin -printf "%p:")${PATH}

if pybin=$(asdf which python) 2>&1 1>/dev/null ; then
    path_if_exists ${pybin%/*}
    unset pybin
fi
