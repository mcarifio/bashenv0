
export MY_FULLNAME=$(getent passwd ${USER}|cut -f5 -d:|cut -f1 -d,)
# git uses EMAIL also, https://git-scm.com/book/en/v2/Git-Internals-Environment-Variables
export EMAIL="mike@carif.io"
export NAME="${MY_FULLNAME} <${EMAIL}>"
