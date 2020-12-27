#!/usr/bin/env bash
me=$(realpath ${BASH_SOURCE})
here=${me%/*}
log=${me}.log

# Get rustup and cargo on PATH in the sanctioned way.
source ~/.cargo/env

printf "*** ${me} $(date)\n" >> ${log}
rustup update >> ${log}
# https://github.com/nabijaczleweli/cargo-update
# cargo install cargo-update to get the cargo subcommand below `install-update`
cargo install-update -a >> ${log}

