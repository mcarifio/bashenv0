#!/usr/bin/env bash

# [user@server[:port]]
server_host_port=${1:?'need a server'}

if [[ "${server_host_port}" = ^([^@:]*)

# http://www.revsys.com/writings/quicktips/ssh-tunnel.html
ssh -f user@personal-server.com -L 2000:personal-server.com:25 -N

