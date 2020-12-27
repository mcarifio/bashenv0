#!/usr/bin/env bash

set -e
me=$(readlink -e ${BASH_SOURCE})
here=$(dirname ${me})  # directory this script sits in
conf=${me}.conf
[[ -r ${conf} ]] && source ${conf}  # source the conf file if it exists


# alias yaml=/opt/yaml/current/bin/yaml

config_yaml=${me}.yaml
yaml_key=$(basename ${me} .sh)
auth_key=$(yaml r ${config_yaml} ${yaml_key}.auth_key)
email=$(yaml r ${config_yaml} ${yaml_key}.email)
# hosts=$(yaml r ${config_yaml} ${yaml_key}.lan.${1:?'expecting a lan name'})



# update ${hostname} ${ip_address}
# example: update office.m00nlit.com 24.1.1.1
# update takes a hostname and the current *external* address of your router and updates the name on your cloudflair DNS. Note that this hostname must already exist
# (you have created it manually) and that name is configured not to use the cloudflair CDN for http. If you don't do that, you'll get an error message. This can be fixed,
# but its probably a useful error check.

function cfget {
    local sub=$1
    local zone=$2
    local cfzone=$(yaml r ${config_yaml} ${yaml_key}.zones.${zone}.cfzone)
    name=${sub}.${zone}
    
    curl -X GET "https://api.cloudflare.com/client/v4/zones/${cfzone}/dns_records?type=A&name=${name}" \
         -H "X-Auth-Email: ${email}" \
         -H "X-Auth-Key: ${auth_key}" \
         -H "Content-Type: application/json"
    
}

function cfput {
    local sub=$1
    local zone=$2
    local ip=$3
    local id=$4
    local cfzone=$(yaml r ${config_yaml} ${yaml_key}.zones.${zone}.cfzone)
    name=${sub}.${zone}
    
    curl -X PUT "https://api.cloudflare.com/client/v4/zones/${cfzone}/dns_records/${id}" \
         -H "X-Auth-Email: ${email}" \
         -H "X-Auth-Key: ${auth_key}" \
         -H "Content-Type: application/json" \
         --data "{\"type\":\"A\",\"name\":\"${name}\",\"content\":\"${ip}\",\"ttl\":600,\"proxied\":false}"
    
}


function update {
    local sub=${1?:'expecting a subdomain, e.g. www'}
    local zone=${2:?'expecting a domain, e.g. google.com'}
    local ip_address=${3:?'expecting an ip address, e.g. x.y.z.q'}  # the current ip_address assigned by your ISP of your router
    local name=${sub}.${zone}

    local a_record=$(dig +short ${hostname})  # get the current (external) IP address of this hostname
    # Has the IP address changed (is it different from the router address)?
    if [[ "${a_record}" == "${ip_address}" ]] ; then
        # No change, do nothing.
        echo "No change for '${hostname}'"
    else
        # hostname IP address is different from router address. Update the A record for the hostname.
        local id=$( cfget ${sub} ${zone} | jq --raw-output ".result[].id")
        cfput ${sub} ${zone} ${ip_address} ${id}
    fi
}





# Using dig, get the IP address of your router. This is a hack.
router=$(dig +short myip.opendns.com @resolver1.opendns.com)


# usage: update-dns.sh x0.y0.z0 x0.y0.z0 x0.y0.z0 x0.y0.z0  # will update each x0.y0.z0 to the external router address. Each x0.y0.z0 should already exist at cloudflare.
for h in "$@"; do
    if [[ ${h} =~ ^(.+)\.(.+\..+)$ ]] ; then
      sub=${BASH_REMATCH[1]}
      zone=${BASH_REMATCH[2]}
      update ${sub} ${zone} ${router}
    fi    
done

