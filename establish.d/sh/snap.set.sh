#!/usr/bin/env -S sudo bash

# where do you put "one-time" settings scripts?
snap set system experimental.parallel-instances=true
snap get system experimental
