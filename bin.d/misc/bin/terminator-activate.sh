#!/usr/bin/env bash

# This script is meant to be invoked by a symlinked script that provides an (implied) argument via $0, e.g. `atlantis`.
# ssh-terminator.sh sets this up if there's not a symlink already.
# This is a convenience since terminator doesn't present the window title when selecting a new app via alt-tab.
# This scripts relies on a number of conventions, such as window size and window title, that are not really very explicit.
# As a result, the script is brittle. But useful.

# Using naming conventions, map the script name into a hostname, e.g. `~/bashenv/bin/atlantis` -> `atlantis`.
script=${0##*/}
name=${script%%.*}


# title, the window title to search for
title="${USER}@${name}"
# TODO: find the center of screen 0
center=''

# right, the number of pixels to move the current window right. Default is 2000. These numbers are arbitrary and brittle.
# Alternative approach: put the current terminator window and the new terminator window side-by-side on screen 0. I don't currently know how.
right=${1:-2000}


# Get the position of the current terminator window as env variables X and Y.
eval $(xdotool getactivewindow getwindowgeometry --shell)

# Move the current window left and out of the way
xdotool getactivewindow windowmove --relative ${right} y

# Place the new terminator window where the old one was. Uses the first --name match.
xdotool search --name ${title} windowactivate windowmove ${X} ${Y}
