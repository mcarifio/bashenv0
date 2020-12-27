#!/usr/bin/python3

import gi
gi.require_version('Snapd', '1')
from gi.repository import Snapd

# Can only communicate locally
c = Snapd.Client()
for snap in c.list_sync():
    print(snap.props.name)
