u.have.command az || return 0

export AZURE_ACCOUNT=${2:-default}
export AZURE_CONFIG_ROOT=${HOME}/.config/azure
export AZURE_CONFIG_DIR=${AZURE_CONFIG_ROOT}/${AZURE_ACCOUNT}
[[ -d ${AZURE_CONFIG_DIR} ]] || return 0

function az.fn.__template__ {
    local _self=${FUNCNAME[0]}
    declare -F ${_self}
}

function az.fn.defines {
    local _self=${FUNCNAME[0]}
    local _fn=${_self%%.*}

    export -f  2>&1 | grep "declare -fx ${_fn}."
}
export -f az.fn.defines

function az.fn.pathname {
    local _self=${FUNCNAME[0]}
    local _fn=${_self%%.*}

    u.value $(me.pathname)    
}
export -f az.fn.pathname

function az.fn.reload {
    local _self=${FUNCNAME[0]}
    local _fn=${_self%%.*}

    verbose=1 u.source $(${_fn}.fn.pathname)
}
export -f az.fn.reload



function az.account {
    local _self=${FUNCNAME[0]}
    local _fn=${_self%%.*}

    local folder=$1
    if [[ -n "${folder}" ]] ; then
        local proposed=${AZURE_CONFIG_ROOT}/${folder}
        if [[ -d ${proposed} ]]; then
            AZURE_CONFIG_DIR=${proposed}
        fi
    fi
    echo AZURE_CONFIG_DIR=${AZURE_CONFIG_DIR}
    az account list
}
export -f az.account

# https://jmespath.org/tutorial.html

function az.default.id {
    local _self=${FUNCNAME[0]}
    local _fn=${_self%%.*}

    az account list --query="([?isDefault].id)[0]"
}
export -f az.default.id

function az.email2id {
    local _self=${FUNCNAME[0]}
    local _fn=${_self%%.*}

    local email=${1:-${EMAIL}}
    az account list --query="([?user.name=='${email}'].id)[0]"
}
export -f az.email2id

function az.name2id {
    local _self=${FUNCNAME[0]}
    local _fn=${_self%%.*}

    local name=${1:?'expecting an azure name, none given'}
    az account list --query="([?lname=='${name}'].id)[0]"
}
export -f az.name2id


    


