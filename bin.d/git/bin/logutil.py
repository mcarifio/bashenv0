'''
import logging module and set the default level from various inputs.

@usage: from logutil import l
'''

import semver
__self__ = dict(author='Mike Carifio', email='mike@carif.io',version=semver.VersionInfo.parse('0.1.1'))

import os
import logging as lg
default_level:str = 'WARN'
lg.basicConfig(level=getattr(lg, os.environ.get('LOGLEVEL', 'WARN').upper(), None))
rl = lg.getLogger()
rl.debug(f"{__file__} now logging at level '{rl.getEffectiveLevel()}'")

