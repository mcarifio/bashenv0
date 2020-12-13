# linux installation: https://github.com/cli/cli/blob/trunk/docs/install_linux.md installs command `gh`.
# post-installation: `gh config set git_protocol ssh` # |> ~/.config/gh/config.yml
# TODO mike@carif.io: ssh breaks api use with multiple users?
# doc: https://cli.github.com/manual/index

# configure only if gh somehow installed and available
u.have.command gh || return 0

# gh help completion
# ISHELL defined in ~/.bash_aliases 
source <(gh completion --shell=$(me.shell))

# TODO redo functions below


# gh help environment
# https://github.com/settings/tokens/486892018, `all scopes for gh at mcarifio@shuttle`, value `fa43f0f7259fd3348efe030e61782acdc58e3f63`
# xdg-open https://github.com/settings/tokens for user mcarifio
# xdg-open https://github.com/settings/tokens for user m00nlit-mcarifio
# xdg-open https://github.com/settings/tokens for user ccg-mcarifio

# Note that the credentials are stored in ~/.config/git/git.config.d/git.config.d/credential.config.

# usage: github-token mcarifio  # in git tree will set GITHUB_TOKEN in bash session and write ${GITROOT}/config with user, token config values
# tests:
#   echo $GITHUB_TOKEN # you should have a value
#   gh repo view gh_smoketest # view https://github.com/mcarifio/gh-smoketest/blob/master/README.md ; really depends of the token and its privs.



# git tokens stored in git config files under credentials.${hoster}.${account}.**
# hosters are github.com gh, gitlabs.com gl, bitbucket.com bb, gitea.com ea.
# account information is stored under account.${hoster}.${account}.**.


# Return the token at ${hoster} for ${account}
function git-token {
    local hoster=${1:?'expecting a git hosting service, e.g. gh'}
    local account=${2:?'expecting a git account'}
    git config --get credential.${hoster}.${account}.token
}
export -f git-token


# Given a token return the associated account in ${hoster}.${account} format.
function git-token2account {
    local token=${1:-${GIT_TOKEN:?'No GIT_TOKEN defined'}}
    git config --get-regexp '^credential\..*\.token' |
        grep ${token} |
        awk 'BEGIN { FS = "." } ; { printf "account.%s.%s", $2, $3 ; }'
}
export -f git-token2account


function git-accounts {
    local hoster=${1:-'.*'}
    git config --get-regexp "^credential\.${hoster}\..*\.token" |
        awk 'BEGIN { FS = "." } ; { printf "account.%s.%s\n", $2, $3 ; }'
}
export -f git-accounts

function fullname {
    local user=${1:-${USER}}
    getent passwd ${user} | awk 'BEGIN { FS=":" } { print $5; }' | tr -d ','
}
export -f fullname

# Given label, e.g. name and a token, retrieve the value of account.${hoster}.${account}.${label}.
# If the label isn't defined, return $3, the fallback value.
# Utility function for later functions.
function git-token2label {
    local suffix=${1?'expecting an account suffix'}
    local token=${2?'expecting a token'}
    local label=$(git-token2account ${token}).${suffix}
    result=$(git config --get ${label})
    [[ -n "${result}" ]] && echo ${result} || echo $3
    
}
export -f git-token2label

# Get the account name for this token.
function git-token2name {
    local token=${1:-${GIT_TOKEN:?'No token. GIT_TOKEN also undefined'}}
    git-token2label name ${token} $(fullname)
}
export -f git-token2name

# Get the account email for this token.
function git-token2email {
    local token=${1:-${GIT_TOKEN:?'No token. GIT_TOKEN also undefined'}}
    git-token2label email ${token} ${EMAIL}
}
export -f git-token2email



# Given a token, generate .git/config with useful settings for that token.
# Simplifies command-line git operations.
function git-config {
    local token=${1:-${GIT_TOKEN:?'No token. GIT_TOKEN also undefined'}}
    local fqan=$(git-token2account ${token})
    local account=$(awk 'BEGIN{FS="."}{print $3}' <<< ${fqan})
    local name=$(git-token2name ${token})
    local email=$(git-token2email ${token})
    local git_config=$(git rev-parse --show-toplevel)/.git/config  # fooled with --git-dir=somewhere
    cat <<EOF > ${git_config}
# created with ${FUNCNAME[0]} on $(date)
[user]
name = ${name}
email = ${email}

[token]
fqan = ${fqan}
account=${account}
# export GITHUB_TOKEN=\$(git config --local --get token.token)
#  or github-token-repo
token=${token}

#eof
EOF
    
}
export -f git-config


#-------- github -------------

# Given an account name, fetch it's token. Don't set anything.
function gh-token {
    local name=${1:-${USER}}
    local hoster=${FUNCNAME[0]%-token}
    git-token ${hoster} ${name}
}
export -f gh-token

# Given a token, find it's associate account name, e.g. 'mcarifio'
function gh-account {
    local token=${1:-${GITHUB_TOKEN:?'No token. GITHUB_TOKEN also undefined'}}
    git-token2account ${token} | awk 'BEGIN { FS = "." } ; { print $3; }'
}
export -f gh-account

# Given a token, find it's associate account name, e.g. 'mcarifio'
function gh-accounts {
    git-accounts gh 
}
export -f gh-accounts

# set GITHUB_TOKEN from local repo config.
function github-token-repo {
    local token=$(gh-config2token)
    if [[ -z "${token}" ]] ; then
        >2& echo "Token '${token}' not found in local config."
    else
        export GITHUB_TOKEN=${token}
    fi
}
export -f github-token-repo

# Fetch token from local repo if there.
function gh-config2token {
    git config --local --get token.token
}
export -f gh-config2token

function gh-config2account {
    git config --local --get token.account
}
export -f gh-config2account


# Generate a git local configuration from a given token.
function gh-config {
    local token=${1:-${GITHUB_TOKEN:?'No token. GITHUB_TOKEN also undefined'}}
    git-config ${token}
}
export -f gh-config

# Set environment variable GITHUB_TOKEN from an account username
function GITHUB_TOKEN {
    local name=${1:-${USER}}
    export ${FUNCNAME[0]}=$(gh-token ${name})    
}
export -f GITHUB_TOKEN

# Set env GITHUB_TOKEN from account name and generate a local config.
function set-github-token {
    local account=${1}
    [[ -z "${account}" ]] && account="$(gh-config2account)"
    [[ -z "${account}" ]] && account=${USER}

    GITHUB_TOKEN $(gh-token ${account})    
    git-config ${GITHUB_TOKEN}
    gh auth status
}
export -f set-github-token


# All to get here. Set GITHUB_TOKEN for the default account $USER.
[[ -z "${GITHUB_TOKEN}" ]] && GITHUB_TOKEN

