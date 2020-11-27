# source this file

if [[ -z "$FUNCTIONS_SRC_SH" ]] ; then

function error {
		printf "$1\n" > /dev/stderr
  exit 1
}

function check_user {
  want=${1:-root} ; got=$(id -un)
  if [[ "$got" = "$id" ]] ; then error "Expecting '$want', got '$got'; please run as '$want'" ; fi 
}

function agi {
  apt-get update && apt-get install -y --install-recommends $*
}

fi

FUNCTIONS_SRC_SH=1

