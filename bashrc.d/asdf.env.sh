source_if_exists ~/.asdf/asdf.sh
source_if_exists ~/.asdf/completions/asdf.bash
# too much, but it's a good pattern to know
# PATH=$(find ~/.asdf/installs -type d -name bin -printf "%p:")${PATH}

if pybin=$(asdf which python) 2>&1 1>/dev/null ; then
    path_if_exists ${pybin%/*}
    unset pybin
fi

have-command az || return 1
export AZURE_ACCOUNT=${2:-default}
export AZURE_CONFIG_ROOT=${HOME}/.config/azure
export AZURE_CONFIG_DIR=${AZURE_CONFIG_ROOT}/${AZURE_ACCOUNT}
[[ -d ${AZURE_CONFIG_DIR} ]] || return 1

az-account() {
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

# https://jmespath.org/tutorial.html

az-default-id() {
    az account list --query="([?isDefault].id)[0]"
}

az-email2id() {
    local email=${1:-${EMAIL}}
    az account list --query="([?user.name=='${email}'].id)[0]"
}

az-name2id() {
    local name=${1:?'expecting an azure name, none given'}
    az account list --query="([?lname=='${name}'].id)[0]"
}


    


