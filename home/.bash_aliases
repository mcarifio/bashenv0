# Mike Carifio <mike@carif.io>
export ISHELL=$(basename ${SHELL}) # :-$(type -p bash)} # bash, inherited by other execs

# TODO mike@carif.io: move into separate file and source

# https://www.gnu.org/software/bash/manual/html_node/The-Shopt-Builtin.html
shopt -s extdebug # declare -F ${name} => ${name} ${lineno} ${pathname}
# shopt -s nullglob # http://bash.cumulonim.biz/NullGlob.html nullglob
shopt -s globstar
# shopt -s failglob
shopt -s autocd cdable_vars
shopt -s checkhash
shopt -s no_empty_cmd_completion

function _msg {
   # look up the call stack
   local _up=${2:-1}

   # generate a message
   local _msg="$(date +%F) $(caller ${_up}): '${1:?'no message?'}'"

   # print out the message
   printf "%s" ${_msg} > /dev/stderr
}

function _error {
   _msg $1 2
   return 1
}

function _warn {
  _msg $1 2
}

function is-defined {
  local f=${1:?'expecting a function name'}
  type -f ${f} 2>&1 > /dev/null
}

# usage: local var=$(first $var1 $var2 $var3) ## first defined var wins
function first { echo $1; }



# source all *.sh files in a directory.
# TODO mcarifio: source from stdin
function source_d {
  local d=${1:-${PWD}}
  if [[ -d "${d}" ]] ; then  
     for f in ${d}/*.sh ; do
         source_1 ${f}
     done
  fi
  
}


export BELOG=/tmp/bashenv/sourcer/$$
mkdir -p ${BELOG}

function source_1 {
  # local s=$(realpath -s ${1:?'expecting a source file name'})
  local s=$(realpath -s ${1:?'expecting a source file name'})
  # echo ${s}
  local log=${BELOG}/$(basename ${s}).log
  source ${s} &> ${log}  || >&2 echo ${s} status $? log ${log}
}


# usage: have-command gh ; echo $? |> 0 iff gh is an available command
# usage: have-command gh && source_if_exists /some/path
function have-command {
  local _command=${1?:'expecting a command on PATH'}
  type ${_command} &> /dev/null
}

# source a collection of files for each one that exists
function source_if_exists {
  for f in $*; do [[ -f $f ]] && source_1 $f; done
}

function path_if_exists {
  for p in $*; do
    path_if_exists_var PATH ${p}
  done
}

function path_if_exists_var {
  local var=${1:?'expecting a variable name, e.g. PATH'} ; shift
  declare -n val=${var}
  for p in $*; do
    if [[ ! ${var} =~ (^|:)\b*${p}\b*(:|$) ]] ; then
       # TODO mike@carif.io: shouldn't need eval here, but indirect variables aren't working
       if [[ -d "${p}" ]] ; then eval ${var}=${p}:${val}; fi
    fi
  done
}


# eval_if_executable direnv hook bash
function eval_if_executable {
  cmd=$1; shift
  [[ -x $(type -p ${cmd}) || -x ${cmd} ]] && eval "$(${cmd} $*)"
}

# source function definitions into the current environment
export BASHENV=$(realpath -s $(dirname $(realpath ${BASH_SOURCE}))/..)
# source_d ~/bashenv/bashrc.d
source_d ${BASHENV}/bashrc.d
# source completions into the current environment
source_d ${BASHENV}/bash-completions.d

# ssh autocomplete "plugin"
# source_if_exists ~/.ssh/config.d/bin/italian-autocomplete.env.sh
