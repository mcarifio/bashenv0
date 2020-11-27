# usage: pyvenva [${directory}]
# create python virtual env in ${directory} iff it doesn't exist. Then pip install the modules requirements.txt.
# Default venv location to git root iff in a git directory. Otherwise use ${PWD}/venv.


function pyvenva {
  # Figure out where to put venv iff the user doesn't say where.
  # If this is a git project, default to the top of the tree.
  local project_root=$(git rev-parse --show-toplevel)
  # Else default to present working directory.
  [[ -z "${project_root}" ]] && project_root=${PWD}

  # Else the user tells us the project root. It's a concept.
  local directory=$(readlink -f ${1:-${project_root}/venv})

  # Are we doing this again with an existing venv?
  local re=''
  [[ -d ${directory} ]] && re='re'
  
  # If we're in a venv, deactivate it and and activate the new one.
  if [[ "${directory}" != "${VIRUAL_ENV}" ]] ; then
     if [[ ! -z "${VIRTUAL_ENV}" ]] ; then
        echo "deactivate '${VIRTUAL_ENV}'"
        deactivate
     fi
     echo "${re}activate '${directory}'"
     pyvenv ${directory}
     source ${directory}/bin/activate
  fi

  # Is there a requirements.txt in the project root?
  export PROJECT_ROOT=$(readlink -f ${directory}/..)
  local requirements=${PROJECT_ROOT}/requirements.txt
  if [[ -r ${requirements} ]] ; then
    echo "${re}load ${requirements}"
    pip install -U --pre -r ${requirements}
  else
    # TODO mcarifio: might be broken?
    pip install -U --pre -e .
  fi

  epilog=${PROJECT_ROOT}/epilog.sh
  if [[ -r ${eplilog} ]] ; then
     echo "sourcing '${epilog}'"
     source ${epilog}
  fi  
}
