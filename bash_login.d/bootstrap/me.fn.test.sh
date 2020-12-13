#!/usr/bin/env bash
# usage: ./me.fn.test.sh
# in general to test ${name}.fn.sh, create exe ${name}.fn.test.sh similar to below.

# hack to load test support test.fn.test.sh and then ${name}.fn.sh based on this
# script's name.
_here=$(dirname ${BASH_SOURCE[0]})
for _s in ${_here}/{test.fn.test.sh,${BASH_SOURCE[0]/.test/}}; do source ${_s} ; done




# unit tests for bash functions
# [verbose=1] [skip=1] test.expect.[${predicate}] ${computed} ${expected}

test.expect.equal $(me.pathname) $(realpath ${BASH_SOURCE[0]})
verbose=1 test.expect.equal $(me.pathname) $(realpath ${BASH_SOURCE[0]})
skip=1 test.expect.equal $(me.pathname) x
verbose=1 skip=1 test.expect.equal $(me.pathname) x
