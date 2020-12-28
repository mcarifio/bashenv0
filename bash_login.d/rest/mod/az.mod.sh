# source az.mod.sh

u.have.command az || return 0

export AZURE_ACCOUNT=${2:-default}
export AZURE_CONFIG_ROOT=${HOME}/.config/azure
export AZURE_CONFIG_DIR=$(file.mkdir ${AZURE_CONFIG_ROOT}/${AZURE_ACCOUNT})

function az.account.set {
    local _self=${FUNCNAME[0]};
    local _mod_name=${_self%%.*};
    local _mod=${_self%.*};

    local _account=$(f.must.have "$1" "account name")
    export AZURE_CONFIG_DIR=$(file.is.dir ${AZURE_CONFIG_ROOT}/${_account})
    az account list
}


# https://jmespath.org/tutorial.html

function az.default.id {
    local _self=${FUNCNAME[0]};
    local _mod_name=${_self%%.*};
    local _mod=${_self%.*};

    az account list --query="([?isDefault].id)[0]"
}

function az.email2id {
    local _self=${FUNCNAME[0]};
    local _mod_name=${_self%%.*};
    local _mod=${_self%.*};

    local _email=$(f.must.have "$1" "email") || return 1
    az account list --query="([?user.name=='${_email}'].id)[0]"
}

function az.name2id {
    local _self=${FUNCNAME[0]};
    local _mod_name=${_self%%.*};
    local _mod=${_self%.*};

    local _name=$(f.must.have "$1" "azure name") || return 1
    az account list --query="([?lname=='${_name}'].id)[0]"
}


# Make this file a "module".
# Extract mod from pathname.
function pn2mod { local _result=${1##*/}; echo ${_result%%.*}; }
# Augment functions above with "module" conventions.
mod.mkmod $(pn2mod ${1:-${BASH_SOURCE[0]}}) ${2:-$(realpath ${BASH_SOURCE[0]})}
    


