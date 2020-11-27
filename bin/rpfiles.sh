#!/usr/bin/env bash
me=$(realpath ${BASH_SOURCE:-$0})
here=$(dirname ${me})

find ${1:-$PWD} ! -type d -exec realpath '{}' +
