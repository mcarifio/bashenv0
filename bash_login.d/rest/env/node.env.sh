# Mike Carifio <mike@carif.io>
# https://nodejs.org/api/repl.html

export NODE_REPL_HISTORY_SIZE=10000

# export NODE_PATH=/usr/lib/node_modules
# alias node='\node -r esm'
# alias node='\node --experimental-modules'

# https://nodejs.org/api/vm.html
NODE_OPTIONS='--require esm --experimental-modules --experimental-repl-await --experimental-json-modules --experimental-wasm-modules --experimental-vm-modules --trace-uncaught --input-type=module'

