#!/usr/bin/env -S sudo bash
me=$(realpath -s ${BASH_SOURCE})
here=$(dirname ${me})
source ${here}/../apt.fn.sh

apt/install ${me}.log whois xdg-utils
