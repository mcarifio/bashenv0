if [[ -n "${GNOME_SHELL_SESSION_MODE}" && ! -d ~/.local/share/gnome-shell/extensions/switcher@landau.fi ]] ; then
    >&2 echo "gnome switcher not installed at ~/.local/share/gnome-shell/extensions/switcher@landau.fi? See https://github.com/daniellandau/switcher to install."
fi
