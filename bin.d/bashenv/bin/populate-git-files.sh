#!/usr/bin/env bash
# TODO: reimplement in python3? typescript?

# There are several ways to populate an initial git repo: yo, cookiecutter, git templates, an initial pull/checkout from some repo.
# All of them seem crufty in some way.

me=$(realpath ${BASH_SOURCE})
here=$(dirname ${me});
git_work_tree=${1:-${PWD}}
name=$(basename ${git_work_tree})

# Check that git_work_tree is empty before you modify it.
contents=""
[[ -d "${git_work_tree}" ]] && contents=$(find ${git_work_tree} -maxdepth 0)
[[ -n "${contents}" ]] && { echo "${git_work_tree} has contents, skipping..."; exit 1; }
# git_work_tree is empty

# Assumes you are in git_work_tree. Brittle assumption.
git init ${git_work_tree}
echo "# ${name}" > ${git_work_tree}/README.md
install -D /dev/stdin ${git_work_tree}/doc/typescript/README.md <<EOF
# bash sessions

Contains bash sessions (commands and output).
*.raw.typescript are the raw output (including mistakes) without annotation.
*.annotated.typescript are the cleaned up versions _with_ annotation (as bash comments).

EOF
tree -F -I .git ${git_work_tree} >> ${git_work_tree}/README.md

git -C ${git_work_tree} add README.md doc
# why is -C and -m mutually exclusive?
( cd ${git_work_tree} ; git commit -m "${me} created initial contents" )
