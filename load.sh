_delegate=$(dirname ${BASH_SOURCE})/bash_login.d/bootstrap/$(basename ${BASH_SOURCE})
[[ -r ${_delegate} ]] && source ${_delegate} || { >&2 echo "${_delegate} not found" ; return 1; }
verbose=1 f.apply u.source.tree $(me.here bash_login.d/rest) $(me.here bash_completion.d)

