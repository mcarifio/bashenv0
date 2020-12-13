# usage: using tmux, save a buffer
# at the command line, ask tmux to cp into the system clipboard with `tp -`
function tmux.tp {
    local tmux_buffer=${1:-'-'}
    tmux save-buffer - | xclip -i -sel clipboard
    echo "tmux buffer '${tmux_buffer}' -> clipboard"
}
export -f tmux.tp

