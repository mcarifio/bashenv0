# https://wiki.canonical.com/OEMServices/Engineering/DevelopingWithPbuilder
# https://wiki.canonical.com/OEMServices/Engineering/KnowledgeBase/Bashrc
export MY_FULLNAME=$(getent passwd $USER|cut -f5 -d:|cut -f1 -d,)
export MY_EMAIL="michael.carifio@canonical.com"
export DEBFULLNAME="$MY_FULLNAME"
export NAME="$MY_FULLNAME <$MY_EMAIL>"
export DEBEMAIL="$MY_EMAIL"
# TODO mcarifio: fetch this from gpg with $DEBEMAIL: gpg --list-secret-keys --fingerprint $DEBEMAIL
export GPGKEY=A48B2FE0 # from https://launchpad.net/~carifio

# http://wiki.debian.org/UsingQuilt
export QUILT_REFRESH_ARGS="-p ab --no-timestamps --no-index"
export QUILT_PATCHES=debian/patches

export PBUILDER_SRCDIR_FORMAT=pkg
