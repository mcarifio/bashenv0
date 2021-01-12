#!/usr/bin/env bash
# -*- mode: shell-script; -*- # eval: (setq-local indent-tabs-mode nil tab-width 4 indent-line-function 'insert-tab) -*-
#!/usr/bin/env -S sudo -i /usr/bin/env bash # run as root under sudo

# __fw__ framework
source __fw__.sh || { >&2 echo "$0 cannot find __fw__.sh"; exit 1; }
trap '_catch --lineno default-catcher $?' ERR

declare _whitenoise=$(xdg-user-dir MUSIC)/whitenoise/calming-seas-11h.ogg

function --help {
    >&2 echo "${_name} [\$1:-'${_whitenoise}'}] # play whitenoise to improve focus"
    exit 1
}

# Specific work.
function _start {
    declare -Ag _flags
    # --qt-start-minimized doesn't work
    cvlc --quiet ${_whitenoise} &
}

# add specific option parsing
# _start_at --start=_fw_start --forward=_start

# skip specific option parsing
_start_at --start=_start $@

