#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

_me=$(realpath ${BASH_SOURCE})
_here=$(dirname ${_me})
_name=$(basename ${_me})

_version() {
    local v=${me}.version.txt
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
    echo "${_name} $(_version) [--profile=\${known_profile}] [--log] # at ${_me}"
    echo "note: ${_name} --log | tee /tmp/a.log # useful"
    echo "note:  ${_name} --log &> /tmp/a.log && tail -f a.log # useful"
    exit 0
}

_usage() {
    echo "usage: ${_name} [-h|--help] [-v|--version] [-u|--usage] ${chromium args} # at ${_me}"
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

_profiles() {
    local _d=${1:?'expecting a configuration root'}
    echo '${_d}/Default'
    # My chromium profiles are symbolic links to 'Profile *' that are themselves directories
    #  containing a `README` file.
    for d in $(find ${_d} -mindepth 1 -maxdepth 1 -lname '*Profile *' -xtype d) ; do
        [[ -f ${d}/README ]] && echo ${d}
    done
    exit 0
}


# trap -l to enumerate signals
trap _on_exit EXIT


# Explicit dispatch to an entry point, _start by default.
_dispatch() {
    
    local _entry=_start
    declare -a _args=() # filter out arguments before calling real entry point

    while (( ${#*} )); do
        local _i=${1}
        case "${_i}" in
            -h|--help) _help;;
            -v|--version) _say_version;;
            -u|--usage) _usage;;
            # new entry point, --start=${USERNAME} dispatches to _start_mcarifio with all arguments
            --start=*) _entry=_start_${_i#--start=} ; shift ;;
            *) _args+=(${_i}) ; shift ;;
        esac
    done

    ${_entry} ${_args[*]}
}


_start() {
    local _args=( $* )
    local -a _positionals

    # initial (default) values for variables, including switches.
    # http://www.chromium.org/for-testers/enable-logging
    # local _logging="--enable-logging=stderr --v=1"
    local _logging=''
    local _profile=Default
    local _to=''

    # This was a lot harder than it needed to be.
    local _snap_user_data=$(snap run --shell chromium -c 'echo $SNAP_USER_DATA')
    local _snap_user_data=${HOME}/snap/chromium/common/chromium
    local _data_dir=${_snap_user_data}
    local _entry=${default_starter:-_start}

    while (( ${#*} )); do
        local _i=${1}
        case "${_i}" in
            -h|--help) _help; break;;
            -v|--version) _say_version; break;;
            -u|--usage) _usage; break;;
            --profiles) _profiles ${_data_dir} ; break;;
            --profile=*) _profile=${_i#--profile=}; shift;;
            --log=*) _logging="--enable-logging=stderr --v=1"; _to=${_i#--log=}; shift ;;
            --log) _logging="--enable-logging=stderr --v=1" ; shift ;;
            --) shift; _positionals+=($*); break;;
            *) _positionals+=(${_i}); shift;;
        esac
    done

    # echo "${_positionals[*]} # count: ${#_positionals[*]}"
                           

    
    # Note: I assume `ln -sr ${_data_dir} ${_profile}` previously out-of-band
    # This gives several better "local names" for profiles, e.g. `personal` as well as `Default`.
    local _profile_dir=${_data_dir}/${_profile}
    
    if [[ -d ${_profile_dir} ]] ; then
        if [[ -z "${_to}" ]] ; then
            # Have to explicitly state --user-data-dir to get a profile at the command line even though it's default value
            #  is the same. Confusing.
            (set -x ; chromium ${_logging} --user-data-dir="${_data_dir}" --profile-directory="${_profile}" ${_positionals[*]} ) &
        else
            (set -x ; chromium ${_logging} --user-data-dir="${_data_dir}" --profile-directory="${_profile}" ${_positionals[*]} &> ${_to} ) &
            echo "tail -f ${_to} # @advise:bash:next:debug"
        fi
    else
        _error "Expecting profile '${_profile}' at '${_profile_dir}' for chromium '$(chromium --version)'. Not found."
    fi
}



# cb.sh --start=${USERNAME} # @advise:human:note: starts three profiles: iceman, work and Default
_start_mcarifio() {
     # first one started in the "default" when clicking urls in email?
    _start $*
    # work missing on startup?
    _start $* --profile=work
    _start $* --profile=iceman
    _start $* --profile=webmonkey
}

# default for --start=. If unstated, you dispatch to this function.
default_starter=_start_${USER}

_dispatch $@

