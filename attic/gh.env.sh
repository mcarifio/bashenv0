# linux installation: https://github.com/cli/cli/blob/trunk/docs/install_linux.md installs command `gh`.
# post-installation: `gh config set git_protocol ssh` # |> ~/.config/gh/config.yml
# doc: https://cli.github.com/manual/index

# configure only if gh somehow installed and available
have-command gh || return 1

# gh help completion
# ISHELL defined in ~/.bash_aliases 
eval $(gh completion --shell=${ISHELL:-$(basename ${SHELL})})

# gh help environment
# https://github.com/settings/tokens/486892018, `all scopes for gh at mcarifio@shuttle`, value `fa43f0f7259fd3348efe030e61782acdc58e3f63`
# xdg-open https://github.com/settings/tokens for user mcarifio


# usage: gh-token
# usage: gh-token mike@carif.io
# tests:
#   echo $GITHUB_TOKEN # you should have a value
#   gh repo view gh_smoketest # view https://github.com/mcarifio/gh-smoketest/blob/master/README.md ; really depends of the token and its privs.

# given a username->token, you should be able to reconstruct all the rest.
declare -gA gh_username2token=([mcarifio]=fa43f0f7259fd3348efe030e61782acdc58e3f63
                           [m00nlit-mcarifio]='tbs'
                           [ccg-mcarifio]=65f93a9b2ee510be92f71f34c9880365df4c40c4)
declare -gA gh_token2name=()
for k in ${!gh_username2token[*]}; do gh_token2name[${gh_username2token[$k]}]=$k; done
declare -gA gh_email2token=([mike@carif.io]=${gh_username2token[mcarifio]}
                         [mikec@crescendocg.com]=${gh_username2token[ccg-mcarifio]})
declare -gA gh_label2token=([personal]=${gh_username2token[mcarifio]}
                            [m00nlit]=${gh_username2token[m00nlit-mcarifio]}
                            [ccg]=${gh_username2token[ccg-mcarifio]})
declare -gA gh_org2token=([crescendocg-dev]=${gh_username2token[ccg-mcarifio]})
declare -gA gh_ssh2token=([crescendocg-dev]=${gh_username2token[ccg-mcarifio]})



gh-username() {
    local _token=${1:-${GITHUB_TOKEN}}
    echo ${gh_token2name[${_token}]}
}

# elevate these
env_set() { export $1=$2; }
first() { echo $1; }

gh-token0() {
    local _id=${1:-${USER}}
    first ${gh_username2token[${_id}]} \
          ${gh_org2token[${_id}]} \
          ${gh_label2token[${_id}]} \
          ${gh_email2token[${_id}]} \

}

gh-token() {
    local name=${1:-${USER}}
    local hoster=${FUNCNAME[0]%-token}
    git-token ${hoster} ${name}
}


# git tokens stored in git config files
git-token() {
    local hoster=${1:?'expecting a git hosting service, e.g. gh'}
    local name=${2:?'expecting a git name'}
    git config --get credential.${hoster}.${name}.token
}

github-token() {
    local name=${1:-${USER}}    
    export GITHUB_TOKEN=$(gh-token $1) && export GITHUB_NAME=$1
}

github-token

