# https://coderwall.com/p/powgbg

# TODO: get back ~/.ssh/config hostname completion?

function ssht(){
  ssh $* -t 'tmux a || tmux || /bin/bash'
}
