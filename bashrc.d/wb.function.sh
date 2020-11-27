# source this

# should be a way to do this with gnome-open?
function wb {
    chromium-browser --user-data-dir=~/.config/chromium/${1:-Default} &
}
