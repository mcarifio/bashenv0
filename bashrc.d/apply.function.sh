# source this in

function apply {
  _f=$1; shift
  for i in $* ; do $_f $i ; done
}

function domain-check {
    local name=${1:?'expecting a name'}
    whois ${name} && gnome-open http://www.${name} &
}
