#!/usr/bin/env bash

# https://www.linuxuprising.com/2020/07/how-to-restart-gnome-shell-from-command.html
# busctl --user call org.gnome.Shell
(set -x; busctl --user call org.gnome.Shell /org/gnome/Shell org.gnome.Shell Eval s 'Meta.restart("Restarting…")')

