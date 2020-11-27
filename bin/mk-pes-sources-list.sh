#!/bin/bash
# https://wiki.canonical.com/OEMServices/Engineering/Training/PbuilderChroot

project=${1?-"expecting a project name"}
series=${2:-$(lsb_release --short --codename)}
# https://wiki.canonical.com/PES/Infrastructure/Repository/CustomerMirrors
password=${3:-zUPu76Br}

list=~/Projects/${project}.list
cat <<EOF > $list
# Created with '$0 $*'
deb https://warthogs:${password}@cesg.canonical.com/canonical/ ${project}-${series}-devel public private
deb-src https://warthogs:${password}@cesg.canonical.com/canonical/ ${project}-${series}-devel public private
EOF
echo "Created '$list'"

