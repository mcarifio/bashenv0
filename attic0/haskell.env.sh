# install haskell /usr/local/bin/stack: curl -sSL https://get.haskellstack.org/ | bash
have-command stack || return 1
stack --bash-completion-script stack | source /dev/stdin

# usage: stack ghci



