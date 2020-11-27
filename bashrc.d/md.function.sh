function md {
    dir=${1:?'Expecting a directory, got none.'}
    [[ -d $dir ]] || mkdir -p $dir
    cd $dir
}