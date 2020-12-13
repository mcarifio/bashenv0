#!/usr/bin/env bash
# -*- mode: shell-script; -*- # eval: (setq-local indent-tabs-mode nil tab-width 4 indent-line-function 'insert-tab) -*-
#!/usr/bin/env -S sudo -i /usr/bin/env bash # run as root under sudo with login

# @author: Mike Carifio <mike@carif.io>
# Note that emacs can be configured for [editorconfig](https://editorconfig.org/)
#   with [editorconfig-emacs](https://github.com/editorconfig/editorconfig-emacs)


# usage: __simple_template__.sh ${script_pathname:-simple.sh} ${editor:-emacsclient}
# note: to create simple.sh without editing: __simple_template__.sh ${script_name} true


set -euo pipefail
# If passing an array in a function, modify IFS or comment out.
# IFS=$'\n\t'
IFS=$'\n\t'


_me=$(realpath -s ${BASH_SOURCE:-$0})
_here=$(dirname ${_me})
_name=$(basename ${_me} .sh)
_shell=$(realpath /proc/$$/exe) # current shell


source utils.lib.sh &> /dev/null || true
source ${_me}.conf &> /dev/null || true


function TAGS {
    local _self=${FUNCNAME[0]}
    local _up=$(realpath ${_here}/..)
    # language Sh
    /usr/bin/ctags -e -f ${_up}/TAGS --language-force=sh -R ${_up}/{bash*,bin,cron,git,home,install,lib,rc,session,test,wm} 
}

${_name} $@





