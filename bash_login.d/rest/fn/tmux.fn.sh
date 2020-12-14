function tmux.fn.__template__ {
    local _self=${FUNCNAME[0]}
    u.value $(tmux.fn.pathname)
}
# don't export __template__

function tmux.fn.defines {
    local _self=${FUNCNAME[0]}
    export -f  2>&1 | grep "declare -fx tmux"
}
export -f tmux.fn.defines

function tmux.fn.pathname {
    local _self=${FUNCNAME[0]}
    u.value $(me.pathname)    
}
export -f tmux.fn.pathname



# usage: using tmux, save a buffer
# at the command line, ask tmux to cp into the system clipboard with `tp -`
function tmux.tp {
    local tmux_buffer=${1:-'-'}
    tmux save-buffer - | xclip -i -sel clipboard
    echo "tmux buffer '${tmux_buffer}' -> clipboard"
}
export -f tmux.tp

