set -euo pipefail
# If passing an array in a function, modify IFS or comment out.
# IFS=$'\n\t'
IFS=$'\n\t'


let _bottom=$(( ${#BASH_SOURCE[*]} - 1 ))
[[ $0 != ${BASH_SOURCE[${_bottom}]} ]] && (( _bottom-- ))
_me=$(realpath -s ${BASH_SOURCE[${_bottom}]:-$0})
_here=$(dirname ${_me})
_name=$(basename ${_me} .sh)
_ap_shell=$(realpath /proc/$$/exe) # absolute pathname of current shell
_shell=$(basename ${_ap_shell}) # current shell: 'bash' (unless you change the shebang line).
_version="0.0.1"

source utils.lib.sh &> /dev/null || true
source ${_me}.conf &> /dev/null || true


# The framework functions come in pairs. _${f} calls _fw_${f} initially.
# Redefine ${f} to change the implementation.
function _fw_version {
    local -r _self=${FUNCNAME[0]}
    [[ -r ${_me}.version.text ]] && { cat -s ${_me}.version.text ; return 0; }
    [[ -n "${_version}" ]] && { echo "${_version}" ; return 0; }
    echo "0.0.1"
}
function _version {
    local -r _self=${FUNCNAME[0]}
    _fw${_self} $*
}




function _fw--version {
    local -r _self=${FUNCNAME[0]}
    >&2 echo "${_name} $(_version) # at ${_me}"
    exit 1
}
function --version {
    local -r _self=${FUNCNAME[0]}
    _fw${_self} $*
}




function _fw--help {
    >&2 echo "help ${_name} $(_version) # at ${_me}"
    exit 1
}
function --help {
    local -r _self=${FUNCNAME[0]}
    _fw${_self} $*
}



function _fw--usage {
    >&2 echo "usage: ${_name} [-h|--help] [-v|--version] [-u|--usage] [--start=<function_name>] # at ${_me}"
    exit 1
}
function --usage {
    local -r _self=${FUNCNAME[0]}
    _fw${_self} $*
}


function _fw_message {
    local -r _self=${FUNCNAME[0]}
    local -r _lineno=${1:?'expecting required lineno'}
    local -r _status=${3:-0}
    if [[ -z "${_status}" || "${_status}" == "0" ]] ; then
        local -r _message=${2:-warning}
        local -r _status_pair=""
    else
        local -r _message=${2:-error}
        local -r _status_pair=", status: ${_status}" 
    fi
    local -r _funcname=${FUNCNAME[1]}
    echo "{ where: { pathname: \"${_me}\", funcname: \"${_funcname}\", lineno: \"${_lineno}\" }, message: \"${_message}\"${_status_pair} }"
}
function _message {
    local -r _self=${FUNCNAME[0]}
    _fw${_self} $*
}



function _fw_errorln {
    local -r _self=${FUNCNAME[0]}
    _catch --exit --print $(_message ${1:-${LINENO}} ${2:-error} ${3:-1})
}
function _errorln {
    local -r _self=${FUNCNAME[0]}
    _fw${_self} $*
}



function _fw_error {
    local -r _self=${FUNCNAME[0]}
    _catch --exit --print $(_message tbs ${1:-error} ${2:-1})
}
function _error {
    local -r _self=${FUNCNAME[0]}
    _fw${_self} $*
}


function _fw_stacktrace {
    local -r _self=${FUNCNAME[0]}
    _error "not yet implemented"
}
function _stacktrace {
    local -r _self=${FUNCNAME[0]}
    _fw${_self} $*
}



function _fw_caller {
    local -r _self=${FUNCNAME[0]}
    echo ${FUNCNAME[1]}
}
function _caller {
    local -r _self=${FUNCNAME[0]}
    _fw${_self} $*
}





# usage: trap '_catch' EXIT
# usage: trap '_catch --exit=1' EXIT
# usage: trap '_catch --return=10' EXIT
# usage: trap '_catch --print[=/dev/stderr] --return'

function _fw_catch {
    # hack: _catch invoked implicitly via explicit exit command (e.g. `exit 1`)
    # rather than via an explicit _catch call.
    [[ ${FUNCNAME[0]} == ${FUNCNAME[1]} ]] && return

    local -a _args=( $* )
    local -a _rest=()

    declare -A _flags=([--exit]=1 [--print]=1 [--lineno]=1 [--status]=$? [--to]=/dev/stderr)
    
    while (( $# )); do
        local _it=${1}
        case "${_it}" in
            # --template-flag=*) _flags[--template_flag]=${_it#--template-flag=};;
            --return) _flags[--exit]=0 ;;
            --return=*) _flags[--exit]=0; _flags[--status]=${_it#--return=} ;;
            --exit) _flags[--exit]=1 ;;
            --exit=*) _flags[--print]=1; _flags[--status]=${_it#--exit=} ;;
            --lineno) _flags[--lineno]=1 ;;
            --print) _flags[--print]=1 ;;
            --print=*) _flags[--print]=1; _flags[--to]=${_it#--print=} ;;
            --) shift; _rest+=($*); break ;;
            # -*|--*) _message ${LINENO} "$1 unknown flag" ; exit 1 ;;
            # -*|--*) >&2 echo "$(realpath ${BASH_SOURCE[0]}):${LINENO} ${_it} unknown flag" ; exit 1 ;;
            *) _rest+=(${_it}) ;;
        esac
        shift
    done

    #local -ir _the_lineno="${_rest[0]:-${LINENO}}"
    local -ir _the_lineno=${BASH_LINENO[1]}
    local -r _message="${_rest[*]:-${FUNCNAME[0]}}"
    if (( ${_flags[--print]} )) ; then
        _message ${_the_lineno} ${_message} ${_flags[--status]} > ${_flags[--to]}
        # _message ${_the_lineno} ${_message} ${_status} | jq . > ${_to}
    fi
    if (( ${_flags[--exit]} )) ; then
        exit ${_flags[--exit]}
    fi
}
function _catch {
    local _self=${FUNCNAME[0]}
    _fw${_self} $*
}



function _fw_on_exit {
    local _status=$?
    # cleanup here
    exit ${_status}
}
function _on_exit {
    local _self=${FUNCNAME[0]}
    _fw${_self} $*
}


# trap -l to enumerate signals
# trap _on_exit EXIT
# trap '_catch ${LINENO} default-catcher $?' ERR

# allows for: cp $(__template__.sh) /some/path/x.sh
[[ '__framework__' = "${_name}" ]] && >&2 _message ${LINENO} "running framework ${_me} directly"




# Explicit dispatch to an entry point, _start by default.
function _fw_start_at {
    
    declare -Ag _flags=([--start]=_fw_start [--forward]=_start [--as]=${USER} [--verbose]=0)
    local -a _rest=() # don't pass --start to "real" function

    while (( $# )); do
        local _it="${1}"
        case "${_it}" in
            -h|--help) --help ;;
            -V|--version) --version ;;
            -u|--usage) --usage ;;
            -v|--verbose) _flags[--verbose]=1 ;;
            # new entry point, --start=${USERNAME} dispatches to _start_mcarifio with all arguments
            --start=*) _flags[--start]=${_it#--start=} ;;
            --forward=*) _flags[--forward]=${_it#--forward=} ;;
            # breaks?
            --as=*) _flags[--as]=${_it#--as=} ;;
            --) shift; _rest+=($*); break;;
            *) _rest+=(${_it}) ;;
        esac
        shift
    done

    if [[ "${USER}" != "${_flags[--as]}" ]] && (( 0 != $(id -uz) )) ; then
        _errorln ${LINENO} "${USER} can't run ${_me}/${_flags[--start]} as user '${_flags[--as]}'. Only root can do that."
    fi
    
    ${_flags[--start]} ${_rest[*]} 
}
function _start_at {
    local _self=${FUNCNAME[0]}
    _fw${_self} $*
}




# <script> --start=echo * # @advise:bash:inspect: a useful smoketest
_fw_start_echo() {
    echo "$*"
}
function _start_echo {
    local _self=${FUNCNAME[0]}
    _fw${_self} $*
}

