# https://direnv.net/docs/hook.html
# direnv is somewhat broken
u.have.command direnv || return 0
source <(direnv hook $(me.shell))

