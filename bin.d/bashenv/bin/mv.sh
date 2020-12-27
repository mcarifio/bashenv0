#!/usr/bin/env bash
shopt -s nullglob globstar

function mv {
    [[ -z "$*" ]] || command mv "$*" &>/dev/null
}

mv ~/Downloads/*.mp4 /tank/mcarifio/media/Videos/p
mv ~/Pictures/p/* /tank/mcarifio/media/Pictures/p
