# https://wiki.canonical.com/OEMServices/Engineering/DevelopingWithPbuilder
# https://wiki.canonical.com/OEMServices/Engineering/KnowledgeBase/Bashrc
export MY_FULLNAME=$(getent passwd $USER|cut -f5 -d:|cut -f1 -d,)
export MY_EMAIL="mike@carif.io"
export NAME="$MY_FULLNAME <$MY_EMAIL>"
