#!/usr/bin/env python3
'''
juju-envs.py will print the list of potential environments from ~/.juju/environments.yaml.
This is used by the completion command in juju-set-env.sh.
'''



import yaml, os, sys

# Slurp in the yaml file and pull out the keys
envs = list(yaml.safe_load(open(os.environ['HOME'] + '/.juju/environments.yaml'))['environments'].keys())
# Sort the keys
envs.sort()

if len(sys.argv) > 1:
    prefix = sys.argv[1]
else:
    prefix = ''

# Print each environment name to stdout.
for k in envs: 
    if k.startswith(prefix):
        print(k, end = ' ') 


# for emacs:
# Local Variables:
# mode: python
# tab-width: 4
# End:
