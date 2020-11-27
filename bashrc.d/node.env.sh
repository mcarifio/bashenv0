# Mike Carifio <mike@carif.io>
# https://nodejs.org/api/repl.html

export NODE_REPL_HISTORY_SIZE=10000

# export NODE_PATH=/usr/lib/node_modules
# alias node='\node -r esm'
# alias node='\node --experimental-modules'

# https://nodejs.org/api/vm.html
NODE_OPTIONS='--require esm --experimental-modules --experimental-repl-await --experimental-json-modules --experimental-wasm-modules --experimental-vm-modules --trace-uncaught --input-type=module'


# is nvm used? if so, then functions are loaded in the current environment. Try calling them.
# if nvm_version_path $(nvm_ls_current) 2 > /dev/null ; then
#     node_path=$(nvm_version_path $(nvm_ls_current))/bin
#     if [[ -d "${node_path}" ]] ; then
#         # here: you have a path based on the nvm default (or current). use it.
#         export PATH=${PATH}:${node_path}
#     fi
# fi
