#!/usr/bin/env bash

# Mike Carifio <michael.carifio@canonical.com>
# Install needed packages only if not already installed.
# Then you don't have to think about them, you just install them.

#set -x

# 'here', the directory where this script lives.
here=$(dirname $BASH_SOURCE)

# Print usage and exit (if needed).
function usage {
    echo "$BASH_SOURCE pkg-names..."
    exit 1
}



# Check for command line arguments. Notify user if nothing is found.
[[ -z $@ ]] && usage

declare -a todo # pkgs to be installed

# Step through command line args...
for p in $@
do
     # ... adding only pkgs not yet installed to the "todo list"
    if dpkg -s $p > /dev/null 2>&1 
    then 
				echo "$p is already installed. Skipping it."
    else
				todo[${#todo[*]}]=$p
    fi
done
# Here: bash array 'todo' contains all packages to be installed

# Do we still have any packages to be installed?
if ((${#todo[@]} > 0))
then
  # Yes. Update the apt cache and install them.
  sudo apt-get update
  sudo apt-get install -y --install-recommends ${todo[@]}
fi

# remember what got installed for the next ubuntu installation
echo ${todo[@]} >> $here/../install/misc.list
