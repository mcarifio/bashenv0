#!/usr/bin/python

# https://gist.github.com/hedning/008462f98da4b8cf584e1f1e94de06f3
# doesn't work

import dbus
import time
bus = dbus.SessionBus()
obj = bus.get_object("org.gnome.Shell", "/org/gnome/Shell/Screencast")

obj.Screencast("Auto %d %t.webm", [],
               dbus_interface="org.gnome.Shell.Screencast")
time.sleep(999999)
