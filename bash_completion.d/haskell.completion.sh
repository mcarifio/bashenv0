# install haskell /usr/local/bin/stack: curl -sSL https://get.haskellstack.org/ | bash
u.have.command stack || return 1
source <(stack --bash-completion-script stack)



