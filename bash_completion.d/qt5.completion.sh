u.have.command qtchooser || return 0
source <(qtchooser -print-env)
path.add ${QTTOOLDIR}


