function ssh.__template__ {
    local _self=${FUNCNAME[0]}
    echo ${_self} tbs
}
export -f ssh.__template__


function ssh.tmux {
  ssh $* -t 'tmux a || tmux || /bin/bash'
}
export -f ssh.tmux
