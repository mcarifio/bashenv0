#!/usr/bin/env bash

function chrome {
  local profile=${1?-'expecting a profile'}
  chromium-browser --user-data-dir="${profile}" &
}

declare -A profiles
profiles=(["mike@carif.io"]='Default'
          ["mike@encirca.com"]='Profile 1')
name=${1:-'mike@carif.io'}
profile=${profiles[$name]}
# echo ${profile}
chrome ${profile}

    
