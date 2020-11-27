#!/bin/bash
here=$(dirname $(readlink -f $0))
source $here/functions.src.sh

check_user root

agi mysql-{server,admin,query-browser} mysqltuner # mysql-workbench

autostart=/etc/init/mysql.override
echo 'manual' > $autostart
echo "gzip $autostart ## to start mysql server on boot"


# create mysql users
user=${SUDO_USER:-mcarifio}

# create mysql databases
