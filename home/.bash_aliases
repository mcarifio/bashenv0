# Mike Carifio <mike@carif.io>
export ISHELL=$(basename ${SHELL}) # :-$(type -p bash)} # bash, inherited by other execs
_bash_aliases=$(realpath -s ${BASH_SOURCE})
export BASHENV=$(realpath $(dirname ${_bash_aliases})/..)
_bashenv=$(basename ${BASHENV})
BASHENV_LOGROOT=/tmp/${USER}/${_bashenv}/source_1/$(date -Iseconds)
mkdir -p ${BASHENV_LOGROOT}

# TODO mike@carif.io: move into separate file and source

# https://www.gnu.org/software/bash/manual/html_node/The-Shopt-Builtin.html
shopt -s extdebug # declare -F ${name} => ${name} ${lineno} ${pathname}
# shopt -s nullglob # http://bash.cumulonim.biz/NullGlob.html nullglob
shopt -s globstar
# shopt -s failglob
shopt -s autocd cdable_vars
shopt -s checkhash
shopt -s no_empty_cmd_completion


function _m {
   # look up the call stack
   local _caller=${FUNCNAME[2]}:${LINENO[2]}
   (( $? )) && _text=${1:-"error"} || _text=${1:-"warning"} 
   local _msg="$(date +%F) ${_caller}| ${_text}"
   printf "%s" "${_msg}" > /dev/stderr
   return 0
}

# usage: local _v=$(_must "$1" "expecting 1")
function _must {
  local _caller=${FUNCNAME[1]}:${LINENO[1]}
  [[ -z "${1}" ]] &&  _e "${_caller} ${2:-'expecting an argument, none found'}"
  echo "${1}"
}

function _e {
   local _status=${2:-1}
   _m $1 ${_status}
   return ${_status}
}

function _w {
  _m $1
}

function is-defined {
  local _f=$(_must "${1}" "expecting a function name, none provided.")
  type -f ${_f} &> /dev/null
}

# usage: local var=$(first $var1 $var2 $var3) ## first defined var wins
function first { echo $1; }



# source all *.sh files in a directory.
# TODO mcarifio: source from stdin
function source_d {
  local d=${1:-${PWD}}
  declare -i _announce=0
  if [[ -d "${d}" ]] ; then
     shopt -u nullglob
     for f in ${d}/*.sh ; do
         source_1 ${f}
         (( _announce ||= $? ))
     done
  fi
  # _show_logs ${BASHENV_LOGROOT}/*.log
  (( _announce )) && echo ${BASHENV_LOGROOT}
}

function _show_logs {
  shopt -u nullglob
  for l in "$*"; do cat ${l} ; done
}

function source_1 {
  local _self=${FUNCNAME[0]}@${LINENO[0]}
  local _s=$(realpath -s $(_must "${1}" "expecting a pathname, none provided"))
  [[ -f ${_s} ]] || return ${2:-1}
  local _there=$(dirname ${_s})
  local _name=$(basename ${_s})
  # echo ${_s} ${_name}
  local _log=${BASHENV_LOGROOT}/${_name}.txt
  if source ${_s} &> ${_log} ; then
      local _log_status=${_log}.0.log
      mv ${_log} ${_log_status}
      xz ${_log_status}
  else
      local _status=$?
      local _log_status=${log}.${_status}.log
      mv ${_log} ${_log_status}
      local _backpointer=$(realpath --relative-to ${_there} ${_s})
      ln -sr ${_s} ${_backpointer}
      _w "${_s} status ${_status} log ${_log}.${_status}.log backpointer ${_backpointer}"
  fi
}


# usage: have-command gh ; echo $? |> 0 iff gh is an available command
# usage: have-command gh && source_if_exists /some/path
function have-command {
  local _command=$(_must "$1" "expecting a command on PATH")
  type ${_command} &> /dev/null
}

# source a collection of files for each one that exists

function source_if_exists {
  shopt -u nullglob
  for f in "$*"; do source_1 $f 0; done
}

function source_a {
  shopt -u nullglob
  for f in "$*"; do source_1 $f; done
}

function path_if_exists {
  shopt -u nullglob
  for p in "$*"; do
    path_if_exists_var PATH ${p}
  done
}

function path_if_exists_var {
  local var=${1:?'expecting a variable name, e.g. PATH'} ; shift
  declare -n val=${var}
  for p in "$*"; do
    if [[ ! ${var} =~ (^|:)\b*${p}\b*(:|$) ]] ; then
       # TODO mike@carif.io: shouldn't need eval here, but indirect variables aren't working
       if [[ -d "${p}" ]] ; then
         # (set -x; eval ${var}=${p}:${val})
         eval ${var}=${p}:${val}         
       fi
    fi
  done
}


# eval_if_executable direnv hook bash
function eval_if_executable {
  local _cmd="$1"; shift
  [[ -x $(type -p ${_cmd}) || -x ${_cmd} ]] && ${_cmd} "$*"
}

# source function definitions into the current environment

if [[ "${PWD}" == "${HOME}" ]] ; then
  # source function definitions into the current environment
  source_d ${BASHENV}/bashrc.d
  # source completions into the current environment
  source_d ${BASHENV}/bash-completions.d

  # ssh autocomplete "plugin"
  # source_if_exists ~/.ssh/config.d/bin/italian-autocomplete.env.sh
else
  >&2 echo "Loading functions only. To simulate a login: cd ~;source .bash_aliases"
fi