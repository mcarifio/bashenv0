# machine.fn.sh
function machine.bootstrap.install+all {
    
    py.pip+install.all
    snap.install.all

    # add users
    uid_start=2000 uid_incr=10 sudo.useradd git skippy bashenv 
    sudo.nopasswd
}
export -f $_
