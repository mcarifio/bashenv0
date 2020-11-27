#!/bin/bash

here=$(dirname $(readlink -f $0))
source $here/functions.src.sh

check_user root

agi ruby ruby1.9 ruby-gems
gem update
gem install rake rails 

cat <<'EOF' > /etc/profile.d/gem.sh
# Add gem directory to path
export PATH=$(gem environment gemdir)/bin:$PATH
EOF
