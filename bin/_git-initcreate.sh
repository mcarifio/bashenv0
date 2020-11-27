#!/usr/bin/env bash

# @see ./git-initclone, that clones the remote repo after creating it. ./git-initpush assumes the local repo already exists.
# ./git-initpush will probably be used more often.

# TODO: reimplement in python3? typescript?

me=$(readlink -e ${BASH_SOURCE})
default_name=$(basename ${PWD})

# TODO mike@carif.io: I can't think of any circumstance where I want the repo name and directory name
# to diverge. For now, take out the argument
# name=${1:-${default_name}}
name=${default_name}


# Populate an empty directory. Eventually use yo or cookiecutter.
populate=$(dirname ${me})/populate-git-files.sh
./${populate} .


# Rely on the commands themselves to output relevant information.
# Not a great assumption, but it's too much work to emit something better.
hub create ${name}
git push

url=$(hub browse --url)
echo "Opening ${url} in preferred browser."
xdg-open ${url}
exit 0

