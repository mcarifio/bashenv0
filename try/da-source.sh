_lambda() {
    local _fdname=''
    case $1 in
        --fdname=*) _fdname=${1#--fdname=} ; shift ;;
    esac

    local _me=$(realpath ${BASH_SOURCE}) ;
    local _here=$(dirname ${_me})
    declare -i _sourced; (return 0 > /dev/null) && _sourced=1 || _sourced=0
    
    echo ${_sourced}
    echo some more stuff
    echo even more to stderr > /dev/stderr
    if [[ -n "${_fdname}" ]] ; then 
        eval "echo '{result: {sourced: ${_sourced}, pathname: ${_me}}}'>&${!_fdname}"
    fi            
}

_lambda $*
unset _lambda
