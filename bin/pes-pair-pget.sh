#!/bin/bash

arch=i386
#project=hedley
#project=omsk
#project=${2:-charlotte}
#project=${2:-hedley}
project=${2:-omsk}
for r in {updates,$project}-lucid-$arch ; do pget $r $1; done | grep -e '^Get:3\.*\(diff\)'

