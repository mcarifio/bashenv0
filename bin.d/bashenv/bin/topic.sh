#!/usr/bin/env bash
# -*- mode: shell-script; -*- # eval: (setq-local indent-tabs-mode nil tab-width 4 indent-line-function 'insert-tab) -*-
#!/usr/bin/env -S sudo -i /usr/bin/env bash # run as root under sudo

# __fw__ framework
source __fw__.sh || { >&2 echo "$0 cannot find __fw__.sh"; exit 1; }
trap '_catch --lineno default-catcher $?' ERR


# Specific option parsing
function _fw_start {
    local _self=${FUNCNAME[0]}

    declare -Ag _flags+=([--root]=$(xdg-user-dir DOCUMENTS)/edoc, [--area]='' [--topic]='')
    local -a _rest=()
    
    while (( $# )); do
        local _it=${1}
        case "${_it}" in
            --area=*) _flags[--area]=${_it#--area=};; # csharp
            --topic=*) _flags[--topic]=${_it#--topic=};; # asp.net-core
            --) shift; _rest+=($*); break;;
            -*|--*) _catch --exit=1 --print --lineno "${_it} unknown flag" ;;
            *) _rest+=(${_it});;
        esac
        shift
    done

    [[ -v "${_flags[--area]}" ]] || _catch --lineno "--area required" 1
    [[ -v "${_flags[--topic]}" ]] || _catch --lineno "--topic required" 1

    
    # echo the command line with default flags added.
    if (( ${_flags[--verbose]} )) ; then
        printf "${_self} "
        local _k; for _k in ${!_flags[*]}; do printf '%s=%s ' ${_k} ${_flags[${_k}]}; done;
        printf '%s ' ${_rest[*]}
        echo
    fi

    # All options parsed (or defaulted). Do the work.
    ${_flags[--forward]} ${_rest[*]}
}


# Specific work.
function _start {
    local -r _self=${FUNCNAME[0]}

    declare -Ag _flags
    local _d=$(realpath -s ${_flags[--root]}/**/${_flags[--area]}/**/${_flags[--topic]})
    evince ${_d}/*.pdf &
}


# Dispatch to worker _start.
_start_at $@
