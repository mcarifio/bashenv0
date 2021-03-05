#!/usr/bin/env -S deno --quiet --unstable run 
// Mike Carifio <mike@carif.io>
// Place this script in the deno bin directory, add that directory to path and then use it to assign DENO_INSTALL_ROOT,
//   which will be ${DENO_DIR}/.. (depending on the shell):
// bash:
// export DENO_INSTALL_ROOT=$(deno_install_root.ts)
// export DENO_DIR=$(deno_dir.ts)

// https://stackoverflow.com/questions/61829367/node-js-dirname-filename-equivalent-in-deno
// https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/slice

// Remove trailing slash.
let up1 = new URL('../', import.meta.url).pathname.slice(0,-1);
console.log(up1);



