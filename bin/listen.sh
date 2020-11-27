#!/bin/bash

# http://icecast.ubuntu.com:8000/status.xsl
# grand-ballroom-a

gst-launch-0.10 playbin2 uri=http://icecast.ubuntu.com:8000/$1.ogg
