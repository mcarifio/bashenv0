# Sets status to 0 iff $1 is installed
# usage: is-pkg-installed foo || sudo apt-get install -y --install-recommends foo

function is-pkg-installed {
    pkg=${1:?'Expecting a package name, received nothing.'}
    # redirection order matters; do stdout first, then redirect stderr
    dpkg -s $pkg >/dev/null 2>&1
}