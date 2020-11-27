#!/usr/bin/env bash

whois $1 && gnome-open http://www.$1
