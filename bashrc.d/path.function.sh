# http://lucapette.me/docker/a-couple-of-useful-aliases-for-docker/

function path {
    local add=${1:?'expecting an addition'}
    OLD_PATH=${PATH}
    PATH=${add}:${PATH}
    printf "Added '${add}' to PATH\n"
}


function pathbins {
    local root=${1:-${PWD}}
    path $(find ${root} -type d -name bin -o -name .bin|tr '\n' ':')
}

function pathpop {
    if [[ -z "${OLD_PATH}" ]] ; then
        echo "No path to pop."
    else
        POPPED_PATH=${PATH}
        PATH=${OLD_PATH}
    fi
    echo "Old path value reverted."
}
