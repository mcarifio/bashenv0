# linux installation: https://github.com/cli/cli/blob/trunk/docs/install_linux.md installs command `gh`.
# post-installation: `gh config set git_protocol ssh` # |> ~/.config/gh/config.yml
# doc: https://cli.github.com/manual/index

# configure only if gh somehow installed and available
have-command doctl || _error "apt install doctl"

# gh help completion
# ISHELL defined in ~/.bash_aliases 
doctl completion ${ISHELL:-$(basename ${SHELL})} | source /dev/stdin

# gh help environment
# https://github.com/settings/tokens/486892018, `all scopes for gh at mcarifio@shuttle`, value `fa43f0f7259fd3348efe030e61782acdc58e3f63`
# xdg-open https://github.com/settings/tokens for user mcarifio


# usage: gh-token
# usage: gh-token mike@carif.io
# tests:
#   echo $GITHUB_TOKEN # you should have a value
#   gh repo view gh_smoketest # view https://github.com/mcarifio/gh-smoketest/blob/master/README.md ; really depends of the token and its privs.

function do-token {
    # Hack. Don't pollute global scope with mapping.
    # TODO mike@carif.io: use bash mapfile instead.
    declare -A tokens=([mcarifio]='', [mikec]=4c693b183c75b0e7fba9dff042f1e23c4facf84534983139630974d141d90c04, [personal]=c683e5b4c6eefecd57f3f44a6186bcbfc1728dbadcf2c1389e391fd85ea1ffa6)
    declare -A email2token=([mike@carif.io]=${tokens[mcarifio]}, [mikec@crescendocg.com]=${tokens[mikec]}, [carifio@carifio.org]=${tokens[personal]})
    local _id=${1:-${USER}}
    if [[ ${_id} =~ @ ]] ; then
        local _token=${email2token[${_id}]}
        [[ -z ${_token} ]] && _error "No github token for email address '${_id}'"
    else
        local _token=${tokens[${_id}]}
        [[ -z ${_token} ]] && _error "No $(caller) token for user '${_id}'"        
    fi
    if [[ -n "${DIGITALOCEAN_CONTEXT}" ]] ; then
        doctl --context default --access-token ${_token}
        # usage: local _var=${DIGITALOCEAN_ACCESS_TOKEN%%##*}
        export DIGITALOCEAN_ACCESS_TOKEN="## doctl --context default --access-token ${_token}"
    else
        # respected only when --context default
        # @see 'https://github.com/digitalocean/doctl?utm_source=DigitalOceanResources#logging-in-to-multiple-digitalocean-accounts'
        export DIGITALOCEAN_ACCESS_TOKEN=${_token}
    fi
}

do-token mikec


