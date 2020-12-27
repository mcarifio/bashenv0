#!/bin/bash
#
# Mike Carifio <michael.carifio@canonical.com>

project=${1:-$(pes-project.sh)}
if [[ -z "$project" ]] ;
then
  select p in $(echo ~/Projects/*-*-*[!.])
  do
    project=$(basename $p)
    break
  done
fi

ptest $project
