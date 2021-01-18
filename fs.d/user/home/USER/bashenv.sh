# @debug: bashdb -s 'source ~/bashenv.sh'

shopt -s extglob
export BASHENV=$(realpath -s $(dirname $(realpath ${BASH_SOURCE[0]}))/../../../..)
if source $BASHENV/load.mod.sh ; then
    u.init.shopt
    path.add $(path.bins)
else
    >&2 echo "source $BASHENV/load.sh => $?"
fi





