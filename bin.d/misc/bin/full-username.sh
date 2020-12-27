#!/usr/bin/env bash

# Returns the "user id info" (e.g. Mike Carifio).
getent passwd $(id -u)|cut -f5 -d':'|cut -f1 -d','


