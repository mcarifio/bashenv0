#!/bin/bash
#
# Mike Carifio <michael.carifio@canonical.com>

# return the newest file satisfying a glob (file pattern)
function newest { 
    stat --printf='%Y\t%n\n' $(find $@)|sort -g -r -k1|head -1|cut -f2
}

function bzr_branch_exists {
  ! bzr check --repo $1 2>&1 | grep --quiet "No repository found at specified location."
}

# get the source.changes file (or pass it in)
source_changes=${1:-$(newest ../*_source.changes)}


# Using bash regular expressions, pull out the project name and component
[[ $source_changes =~ [0-9]+([a-zA-Z]+)[0-9]+_source\.changes$ ]] ## bind BASH_REMATCH
project=${BASH_REMATCH[1]}
[[ $source_changes =~ ^([^_]*)_ ]]
component=$(basename ${BASH_REMATCH[1]})


# Show the user the dput command
read -n 1 -p "dput ppa:oem-archive/${project} $source_changes (y/n): "
echo

if [[ "$REPLY" = y ]]
then
	# dput the source file
  dput ppa:oem-archive/${project} $source_changes

  # look in the expected places for an associated bzr branch
  branches=("lp:~oem-solutions-group/$project/$component" "lp:~${project}-team/$project/$component")
  for branch in $branches; do
    echo -n "Trying '$branch'... "
    if bzr_branch_exists $branch ; then
			# found a branch, tell the user, should only find one, but check them all
      echo ">>> FOUND <<<"
    else
      echo "not found."
    fi
  done
else
  echo "Did NOT dput '$source_changes'"
fi
