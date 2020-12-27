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

_flags=""
_usage() {
    
    echo "usage: ${_name} [-h|--help] [-v|--version] [-u|--usage] [--start=<function_name>] ${_flags} # at ${_me}"
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

# TODO mike@carif.io: mv to utils.sh
fmkdir() {
    local _pathname=${1:?'expecting a pathname'}
    # Make a directory at ${_pathname} without messages regardless of what's there (except an existing non-directory file).
    # fmkdir /some/path/here |> /some/path/here
    [[ -f ${_pathname} ]] || return 1

    if [[ -L ${_pathname} ]] ; then
        unlink ${_pathname}
    fi
    [[ -d ${_pathname} ]] || mkdir -p ${_pathname}
    echo ${_pathname}
}

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


_start() {
    local -a _args=( $* )
    local -a _positionals

    # initial (default) values for vars, especially command line switches/flags.
    # local _template_flag=''

    # Install at ${_root}/${_tool}/${_tool}-${_version} with ${_root}/${_tool}/${_current}/bin pointing to "the executable"
    #  and can be added to PATH. Note that the tool name, e.g. `thunderbird` *must* be a part of 
    local _root=/opt
    local _current='current'
    local _tool
    
    while (( $# )); do
        local _it=${1}
        case "${_it}" in
            # --template-flag=*) _template_flag=${_it#--template-flag=};;
            --root=*) _root=${_it#--root=};;
            --current=*) _current=${_it#--current=};;
            --tool=*) _tool=${_it#--tool};;
            --) shift; _positionals+=($*); break;;
            -*|--*) _error "$1 unknown flag"; break;;
            *) _positionals+=(${_it});;
        esac
        shift
    done

    fmkdir ${_root} || true

    ### *** replace below *** ###
    # echo "${_positionals[*]} # count: ${#_positionals[*]}"
    for p in "${_positionals[*]}" ; do
        local rp=$(realpath ${p}) ## better error messages
        if [[ -r ${rp} ]] ; then
            # TODO mike@carif.io: can't make regexp work
            if [[ $(basename ${rp}) =~ ^([^-]+)- ]] ; then
                local _tool=${BASH_REMATCH[1]}
            fi
            [[ -z "${_tool}" ]] && _error "What tool are you installing? --tool=something"
            local _tool_root=${_root}/${_tool}
            fmkdir ${_tool_root} || true
            mv --verbose ${rp} ${_tool_root}
            rp=$(realpath ${_tool_root}/$(basename ${rp}))
            
            if [[ $(basename ${rp}) =~ ^([^\.]+)\.t ]] ; then
                local _subdir=${BASH_REMATCH[1]}
            else
                _error "Expecting a tar file, got `${rp}`"
            fi
            _listing=$(tar -tf ${rp})
            local _untar_flags='-xaf '
            if [[ ${_listing} =~ ^${_subdir}/ ]] ; then
                _untar_flags+='--one-top-level '
                declare -i _ln_sibling=1
            fi
            
            [[ ${_listing} =~ ^${_tool}/ ]] || _current=${_subdir}/${_tool}
            local _bin=''
            [[ ${_listing} =~ ^.+/bin ]] && _bin=${BASH_REMATCH[1]}
            
            tar "${_untar_flags}" ${rp}
            local _trc=${_tool_root}/${_current}
            local _trc_bin=${_trc}/$(dirname ${_bin})
            if $(( _ln_sibling )) ; then
                if [[ -z "$(dirname ${_bin})" ]] ; then
                    ln -srf ${_tool_root}/${_subdir} ${_trc}
                    echo ${_trc}/bin
                else
                    fmkdir ${_trc}
                    ln -srf ${_trc}/bin ${_trc_bin}
                    echo ${_trc}/bin                    
                fi                
            else
                fmkdir ${_trc}                                
            fi            
        fi        
    done

}

# <script> --start=echo * # @advise:bash:inspect: a useful smoketest
_start_echo() {
    echo "$*"
}

_dispatch $@

