#!/usr/bin/env bash
# @author: Mike Carifio <mike@carif.io>
# -*- mode: shell-script; eval: (message "tab-width: %d, indent with %s" tab-width (if indent-tabs-mode "tabs (not preferred)" "spaces (preferred)")) -*- 

# Note that emacs can be configured for [editorconfig](https://editorconfig.org/)
#   with [editorconfig-emacs](https://github.com/editorconfig/editorconfig-emacs)

set -euo pipefail
IFS=$'\n\t'

_me=$(realpath ${BASH_SOURCE})
_here=$(dirname ${_me})
_name=$(basename ${_me})

source utils.lib.sh &> /dev/null || true

# run as root?
# if [[ $(id -un) != root ]] ; then
#     exec sudo ${_me} --for=${USERNAME} $@
# fi


_version() {
    local v=${_me}.version.txt
    if [[ -r ${v} ]] ; then
        cat -s ${v}
    else
        echo "0.1.1"
    fi
}

_say_version() {
    echo "${_name} $(_version) # at ${_me}"
    exit 0
}

_help() {
    echo "help ${_name} $(_version) # at ${_me}"
    exit 0
}

_usage() {
    echo "usage: ${_name} [-h|--help] [-v|--version] [-u|--usage] [--start=<function_name>] # at ${_me}"
    exit 1
}

_error() {
    local _status=${2:-1}
    local _message=${1-"${_me} error ${_status}"}
    echo ${_message} > /dev/stderr
    exit 1
}

_on_exit() {
    local _status=$?
    # cleanup here
    exit ${_status}
}

# trap -l to enumerate signals
trap _on_exit EXIT

# Explicit dispatch to an entry point, _start by default.
_dispatch() {
    
    local _entry=_start
    declare -a _args # don't pass --start to "real" function
    local _user=${USERNAME}


    while (( $# )); do
        local _it="${1}"
        case "${_it}" in
            -h|--help) _help ;;
            -v|--version) _say_version ;;
            -u|--usage) _usage ;;
            # new entry point, --start=${USERNAME} dispatches to _start_mcarifio with all arguments
            --start=*) _entry=_start_${_it#--start=} ;;
            # breaks?
            --as=*) _user=${_it#--as=} ;;
            *) _args+=(${_it}) ;;
        esac
        shift
    done

    if [[ "${USERNAME}" != "${_user}" ]] && (( 0 != $(id -uz) )) ; then
        _error "${USERNAME} can't run ${_me}/${_entry} as user '${_user}'. Only root can do that."
    fi
    
    
    ${_entry} ${_args[*]}
}


_config_yaml=${_me}.yaml
_yaml_key=$(basename ${_me} .sh)
_auth_key=$(yq r ${_config_yaml} ${_yaml_key}.auth_key)
_email=$(yq r ${_config_yaml} ${_yaml_key}.email)

# update ${hostname} ${ip_address}
# example: update office.m00nlit.com 24.1.1.1
# update takes a hostname and the current *external* address of your router and updates the name on your cloudflair DNS. Note that this hostname must already exist
# (you have created it manually) and that name is configured not to use the cloudflair CDN for http. If you don't do that, you'll get an error message. This can be fixed,
# but its probably a useful error check.

cfzone() {
    local zone=$1
    yq r -j ${_config_yaml} |jq -r ".\"${_yaml_key}\".zones.\"${zone}\".cfzone"
}


function cfget {
    local sub=$1
    local geo=$2
    local zone=$3
    local cfzone=$(cfzone ${zone})
    
    name=${sub}.${geo}.${zone}

    curl -s -X GET "https://api.cloudflare.com/client/v4/zones/${cfzone}/dns_records?type=A&name=${name}" \
         -H "X-Auth-Email: ${_email}" \
         -H "X-Auth-Key: ${_auth_key}" \
         -H "Content-Type: application/json" 2>/dev/null | jq -r .result[0].content
        
}

function cfput {
    local sub=$1
    local zone=$2
    local ip=$3
    local cfzone=$(cfzone ${zone})
    # name=${sub}.${geo}.${zone}
    name=${sub}.${zone}

    declare -i _auto=1 # constant for auto in methods below
    
    
    id=$(curl -X GET "https://api.cloudflare.com/client/v4/zones/${cfzone}/dns_records?type=A&name=${name}" \
         -H "X-Auth-Email: ${_email}" \
         -H "X-Auth-Key: ${_auth_key}" \
         -H "Content-Type: application/json" | jq -r .result[0].id)

    if [[ -z "${id}" || null = ${id} ]] ; then
        curl -X POST "https://api.cloudflare.com/client/v4/zones/${cfzone}/dns_records" \
             -H "X-Auth-Email: ${_email}" \
             -H "X-Auth-Key: ${_auth_key}" \
             -H "Content-Type: application/json" \
             --data "{\"type\":\"A\",\"name\":\"${name}\",\"content\":\"${ip}\",\"ttl\":${_auto},\"proxied\":false}"   
    else
        curl -X PUT "https://api.cloudflare.com/client/v4/zones/${cfzone}/dns_records/${id}" \
             -H "X-Auth-Email: ${_email}" \
             -H "X-Auth-Key: ${_auth_key}" \
             -H "Content-Type: application/json" \
             --data "{\"type\":\"A\",\"name\":\"${name}\",\"content\":\"${ip}\",\"ttl\":${_auto},proxied\":false}"           
    fi 
    
}


# function update {
#     local sub=${1?:'expecting a subdomain, e.g. www'}
#     local geo=${2?:'expecting a geolocation'}
#     local zone=${3:?'expecting a domain, e.g. google.com'}
#     local ip_address=${3:?'expecting an ip address, e.g. x.y.z.q'}  # the current ip_address assigned by your ISP of your router
#     local name=${sub}.${geo}.${zone}

#     local a_record=$(dig +short ${name})  # get the current (external) IP address of this hostname
#     # Has the IP address changed (is it different from the router address)?
#     if [[ "${a_record}" != "${ip_address}" ]] ; then
#         # hostname IP address is different from router address. Update the A record for the hostname.
#         local id=$( cfget ${sub} ${zone} | jq --raw-output ".result[].id")
#         cfput ${sub} ${zone} ${ip_address} ${id}
#     fi
# }





_start() {
    local -a _args=( $* )
    local -a _positionals

    # hosts=$(yq r ${config_yaml} ${yaml_key}.lan.${1:?'expecting a lan name'})

    # initial (default) values for vars, especially command line switches/flags.
    # local _template_flag=''
    local _external_ip4=$(dig +short myip.opendns.com @resolver1.opendns.com.)
    local _gateway=$(route|tail +3|head -1|awk '{print $2; }')
    _gateway=${_gateway:-gw}
    local _geo=$(curl -s https://ipvigilante.com/${_external_ip4} | jq -M -r .data.city_name)
    _geo=${_geo,,}
    
    while (( $# )); do
        local _it=${1}
        case "${_it}" in
            # --template-flag=*) _template_flag=${_it#--template-flag=};;
            --gateway=*) _gateway=${_it#--gateway=};;
            --) shift; _positionals+=($*); break;;
            -*|--*) _error "$1 unknown flag"; break;;
            *) _positionals+=(${_it});;
        esac
        shift
    done


    # echo "${_positionals[*]} # count: ${#_positionals[*]}"
    # for p in "${_positionals[*]}" ; do
    #     echo ${p}
    # done

    for z in $(yq r -j ${_config_yaml} | jq -r '."update-cf-dns".zones|keys[]') ; do
        if [[ ${_external_ip4} != $(dig +short ${_gateway}.${z}) ]] ; then
            cfput ${_gateway} ${z} ${_external_ip4}
        fi 
    done
    

}

# <script> --start=echo * # @advise:bash:inspect: a useful smoketest
_start_echo() {
    echo "$*"
}

_dispatch $@

