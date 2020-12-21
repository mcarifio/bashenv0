source $(dirname ${BASH_SOURCE[0]})/bash_login.d/bootstrap/$(basename ${BASH_SOURCE[0]}) 

# u.source.tree $(me.here bash_login.d/rest) $(me.here bash_completion.d)
for __ in $(find $(dirname ${BASH_SOURCE[0]})/bash_login.d/rest/mod -name \*.sh -perm /222) ; do source ${__}; done


