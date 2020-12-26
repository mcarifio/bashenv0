#!/usr/bin/env bash

# https://major.io/2015/07/06/allow-new-windows-to-steal-focus-in-gnome-3/
# TODO mike@carif.io 02/2020: I must have set this indirectly somehow since I was getting "strict" behavior (or so I thought).
# This setting makes it explicit.
gsettings set org.gnome.desktop.wm.preferences focus-new-windows 'strict'
