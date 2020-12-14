_delegate=$(dirname ${BASH_SOURCE})/bash_login.d/bootstrap/$(basename ${BASH_SOURCE})
[[ -r ${_delegate} ]] && source ${_delegate} || { >&2 echo "${_delegate} not found" ; return 1; }
verbose=1 u.source.all $(me.here bash_login.d/rest)/**/*.sh $(me.here bash_completion.d)/**/*.sh
