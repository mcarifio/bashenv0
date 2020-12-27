#!/usr/bin/env bash

# apti.sh, apt install $* with some logging and preparation
me=$(realpath ${BASH_SOURCE})
log=${me}.log
here=${me%/*}

sudo update
sudo upgrade -y
sudo autoremove -y
sudo apt install "$*" | (printf "\n\n\n--- ${me} install $* ---\n" >> ${log}; tee -a ${log})
