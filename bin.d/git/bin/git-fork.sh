#!/usr/bin/env bash

here=$(readlink -f $(dirname ${BASH_SOURCE}))
me=$(basename $0 .sh)

function error {
    echo "$*" >&2
    return 1
}

function git-fork {
    local token=$(git config --global github.token)
    [[ -z "${token}" ]] && error "git config --global github.token => nothing"
    local owner=${1:?"expecting an organization, e.g 'encirca'"}
    local repo=${2:?"expecting a repo name"}

    # https://developer.github.com/v3/repos/forks/#create-a-fork
    # POST /repos/:owner/:repo/forks
    curl -sS -X POST -H "Authorization: token ${token}" https://api.github.com/repos/${owner}/${repo}/forks
    
}

function git-parent {
    local token=$(git config --global git.token)
    [[ -z "${git_token}" ]] && error "git config --global git.token => nothing"
    # GET /repos/:owner/:repo
    local repo=${1:-'error'}
    local owner=${2:-$(git config github.user)}
    curl -sS -H "Authorization: token ${token}" https://api.github.com/repos/${owner}/${repo} | jq '.parent.git_url'

}

function this-repo {
    git remote get-url origin
}

