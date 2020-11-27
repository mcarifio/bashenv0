# https://direnv.net/docs/hook.html
# direnv is somewhat broken
if direnv --version 2>&1 > /dev/null ; then
    eval "$(direnv hook $(basename ${SHELL}))" 
fi

