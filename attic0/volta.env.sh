[[ -d ~/.local/share/volta ]] || return 1
export VOLTA_HOME=$HOME/.local/share/volta
path_if_exists ${VOLTA_HOME}/bin
volta completions ${ISHELL:-$(basename ${SHELL})} | source /dev/stdin

# tabtab source for serverless package
# uninstall by removing these lines or running `tabtab uninstall serverless`
source_if_exists ${VOLTA_HOME}/tools/image/packages/serverless/1.52.2/node_modules/tabtab/.completions/serverless.bash

